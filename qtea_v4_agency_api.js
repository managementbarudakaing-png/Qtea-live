
// QTEA LIVE V4 - AGENCY / PARTNER SYSTEM API
// File: qtea_agency_api.js

const express = require('express');
const router = express.Router();

// COMMISSION TABLE
const COMMISSION_RATES = {
  BRONZE: 10,
  SILVER: 12,
  GOLD: 15,
  PLATINUM: 18,
  DIAMOND: 20
};

// LEVEL UPGRADE RULES
const LEVEL_RULES = [
  { level: 'DIAMOND', minHosts: 50 },
  { level: 'PLATINUM', minHosts: 30 },
  { level: 'GOLD', minHosts: 15 },
  { level: 'SILVER', minHosts: 5 },
  { level: 'BRONZE', minHosts: 1 },
];

// 1. CREATE AGENCY - User daftar jadi agency owner
router.post('/api/agency/create', async (req, res) => {
  const { ownerId, agencyName } = req.body;
  if (!ownerId || !agencyName) return res.status(400).json({error: 'ownerId & agencyName required'});
  
  const agencyCode = 'QTEA' + Math.random().toString(36).substring(2, 8).toUpperCase();
  const referralLink = `https://qtea.live/join?agency=${agencyCode}`;
  
  try {
    const [result] = await db.execute(
      'INSERT INTO qtea_agencies (agency_code, agency_name, owner_id, commission_rate, referral_link, status) VALUES (?, ?, ?, ?, ?, ?)',
      [agencyCode, agencyName, ownerId, 10, referralLink, 'ACTIVE']
    );
    await db.execute('UPDATE users SET is_agency_owner = TRUE, agency_id = ? WHERE id = ?', [result.insertId, ownerId]);
    
    res.json({ success: true, agency_id: result.insertId, agency_code: agencyCode, referral_link: referralLink, message: `Agency ${agencyName} berhasil dibuat! Kode: ${agencyCode}` });
  } catch(e){ res.status(500).json({error: e.message}); }
});

// 2. HOST JOIN AGENCY via kode referral
router.post('/api/agency/join', async (req, res) => {
  const { hostId, agencyCode } = req.body;
  
  const [agencyRows] = await db.execute('SELECT * FROM qtea_agencies WHERE agency_code = ? AND status = "ACTIVE"', [agencyCode]);
  if (!agencyRows.length) return res.status(404).json({error: 'Kode agency tidak valid'});
  
  const agency = agencyRows[0];
  
  const [existing] = await db.execute('SELECT * FROM qtea_agency_hosts WHERE host_id = ?', [hostId]);
  if (existing.length) return res.status(400).json({error: 'Host sudah punya agency'});
  
  const [userRows] = await db.execute('SELECT username FROM users WHERE id = ?', [hostId]);
  
  await db.execute('INSERT INTO qtea_agency_hosts (agency_id, host_id, host_username) VALUES (?, ?, ?)', [agency.id, hostId, userRows[0]?.username || `host_${hostId}`]);
  await db.execute('UPDATE users SET agency_id = ? WHERE id = ?', [agency.id, hostId]);
  await db.execute('UPDATE qtea_agencies SET total_hosts = total_hosts + 1, active_hosts = active_hosts + 1 WHERE id = ?', [agency.id]);
  
  // Auto upgrade level
  await checkAndUpgradeLevel(agency.id);
  
  res.json({ success: true, agency_name: agency.agency_name, message: `Berhasil join agency ${agency.agency_name}. Komisi agency ${agency.commission_rate}% dari gift kamu` });
});

// 3. PROCESS GIFT V4 - Dengan pembagian Agency (HOST 50%, AGENCY 10%, PLATFORM 40%)
async function processGiftV4({ userId, hostId, giftId, roomId, io }) {
  const gift = giftMap.get(giftId); // price 100 topup_beans contoh
  const conn = await db.getConnection();
  await conn.beginTransaction();
  try {
    // Cek saldo topup_beans user
    const [userRows] = await conn.execute('SELECT topup_beans FROM users WHERE id = ? FOR UPDATE', [userId]);
    if (userRows[0].topup_beans < gift.price) throw new Error('Topup beans tidak cukup');
    await conn.execute('UPDATE users SET topup_beans = topup_beans - ? WHERE id = ?', [gift.price, userId]);
    
    // Cek apakah host punya agency
    const [hostRows] = await conn.execute('SELECT agency_id FROM users WHERE id = ? FOR UPDATE', [hostId]);
    const [agencyHostRows] = hostRows[0].agency_id ? await conn.execute('SELECT a.*, ah.id as membership_id FROM qtea_agencies a JOIN qtea_agency_hosts ah ON a.id = ah.agency_id WHERE ah.host_id = ? AND ah.status = "ACTIVE"', [hostId]) : [[]];
    
    let hostEarn, agencyEarn, platformProfit;
    
    if (agencyHostRows.length) {
      // Host punya agency: Host 50%, Agency 10%, Platform 40%
      const agency = agencyHostRows[0];
      const commissionRate = COMMISSION_RATES[agency.level] || 10;
      agencyEarn = Math.floor(gift.price * commissionRate / 100);
      hostEarn = Math.floor(gift.price * 50 / 100);
      platformProfit = gift.price - hostEarn - agencyEarn;
      
      // Host dapat earned_coins (BISA WD)
      await conn.execute('UPDATE users SET earned_coins = earned_coins + ? WHERE id = ?', [hostEarn, hostId]);
      
      // Agency dapat komisi earned_coins (BISA WD juga)
      await conn.execute('UPDATE qtea_agencies SET balance_earned_coins = balance_earned_coins + ?, total_host_earnings = total_host_earnings + ?, total_agency_earnings = total_agency_earnings + ? WHERE id = ?', [agencyEarn, hostEarn, agencyEarn, agency.id]);
      await conn.execute('UPDATE qtea_agency_hosts SET total_earned_coins = total_earned_coins + ?, agency_commission_generated = agency_commission_generated + ?, total_gifts_received = total_gifts_received + 1 WHERE host_id = ?', [hostEarn, agencyEarn, hostId]);
      
      // Log
      await conn.execute('INSERT INTO qtea_agency_earnings (agency_id, host_id, gift_id, gift_price, host_earned_coins, agency_commission_coins, platform_profit_coins) VALUES (?, ?, ?, ?, ?, ?, ?)', [agency.id, hostId, giftId, gift.price, hostEarn, agencyEarn, platformProfit]);
      
      io.to(`room_${roomId}`).emit('gift_result_v4', { giftId, hostEarn, agencyEarn, platformProfit, message: `Host dapat ${hostEarn} (50%), Agency ${agency.agency_name} dapat ${agencyEarn} (${commissionRate}%), Platform ${platformProfit}` });
    } else {
      // Host tanpa agency: Host 60% full, Platform 40%
      hostEarn = Math.floor(gift.price * 60 / 100);
      platformProfit = gift.price - hostEarn;
      agencyEarn = 0;
      await conn.execute('UPDATE users SET earned_coins = earned_coins + ? WHERE id = ?', [hostEarn, hostId]);
      io.to(`room_${roomId}`).emit('gift_result', { giftId, hostEarn, message: `Host tanpa agency dapat ${hostEarn} (60%)` });
    }
    
    // Jackpot pool (hanya dari gift JP)
    if (gift.type === 'JP') {
      await conn.execute('UPDATE qtea_jackpot_pool SET current_pool = current_pool + ? WHERE id = 1', [platformProfit]);
    }
    
    await conn.commit();
    return { hostEarn, agencyEarn, platformProfit, hasAgency: agencyHostRows.length > 0 };
  } catch(e){ await conn.rollback(); throw e; } finally { conn.release(); }
}

async function checkAndUpgradeLevel(agencyId) {
  const [rows] = await db.execute('SELECT active_hosts FROM qtea_agencies WHERE id = ?', [agencyId]);
  if (!rows.length) return;
  const activeHosts = rows[0].active_hosts;
  
  let newLevel = 'BRONZE';
  for (const rule of LEVEL_RULES) {
    if (activeHosts >= rule.minHosts) { newLevel = rule.level; break; }
  }
  
  const newRate = COMMISSION_RATES[newLevel];
  await db.execute('UPDATE qtea_agencies SET level = ?, commission_rate = ? WHERE id = ?', [newLevel, newRate, agencyId]);
  return newLevel;
}

// 4. AGENCY DASHBOARD - Lihat host & komisi
router.get('/api/agency/:agencyId/dashboard', async (req, res) => {
  const { agencyId } = req.params;
  const [agency] = await db.execute('SELECT * FROM qtea_agencies WHERE id = ?', [agencyId]);
  if (!agency.length) return res.status(404).json({error: 'Agency not found'});
  
  const [hosts] = await db.execute('SELECT * FROM qtea_agency_hosts WHERE agency_id = ? ORDER BY total_earned_coins DESC', [agencyId]);
  const [recentEarnings] = await db.execute('SELECT * FROM qtea_agency_earnings WHERE agency_id = ? ORDER BY created_at DESC LIMIT 20', [agencyId]);
  
  const nextLevel = LEVEL_RULES.find(r => r.minHosts > agency[0].active_hosts);
  
  res.json({
    agency: agency[0],
    hosts,
    recent_earnings: recentEarnings,
    stats: {
      total_hosts: agency[0].total_hosts,
      active_hosts: agency[0].active_hosts,
      total_host_earnings: agency[0].total_host_earnings,
      total_agency_earnings: agency[0].total_agency_earnings,
      balance_can_wd: agency[0].balance_earned_coins,
      commission_rate: agency[0].commission_rate,
      next_level: nextLevel ? `${nextLevel.level} butuh ${nextLevel.minHosts} host` : 'MAX LEVEL DIAMOND'
    }
  });
});

// 5. AGENCY WITHDRAW - Agency owner WD komisi
router.post('/api/agency/withdraw', async (req, res) => {
  const { agencyId, ownerId, commissionCoins, ewallet, ewallet_number } = req.body;
  if (commissionCoins < 9000) return res.status(400).json({error: 'Min WD agency 9000 coins = Rp 10.000'});
  
  const [rows] = await db.execute('SELECT balance_earned_coins FROM qtea_agencies WHERE id = ? AND owner_id = ? FOR UPDATE', [agencyId, ownerId]);
  if (!rows.length || rows[0].balance_earned_coins < commissionCoins) return res.status(400).json({error: 'Saldo komisi tidak cukup'});
  
  const rp = Math.floor(commissionCoins * 1.111);
  await db.execute('UPDATE qtea_agencies SET balance_earned_coins = balance_earned_coins - ?, balance_withdrawn = balance_withdrawn + ? WHERE id = ?', [commissionCoins, commissionCoins, agencyId]);
  const [result] = await db.execute('INSERT INTO qtea_agency_withdrawals (agency_id, owner_id, commission_coins_requested, rp_amount, ewallet, ewallet_number) VALUES (?, ?, ?, ?, ?, ?)', [agencyId, ownerId, commissionCoins, rp, ewallet, ewallet_number]);
  
  res.json({ success: true, withdrawal_id: result.insertId, coins: commissionCoins, rp, message: `WD Agency ${commissionCoins} coins = Rp ${rp} berhasil, tunggu approve admin` });
});

// 6. TOP AGENCIES - Leaderboard
router.get('/api/agencies/top', async (req, res) => {
  const [rows] = await db.execute('SELECT * FROM qtea_agencies WHERE status = "ACTIVE" ORDER BY total_agency_earnings DESC LIMIT 20');
  res.json(rows);
});

module.exports = { router, processGiftV4, checkAndUpgradeLevel };
