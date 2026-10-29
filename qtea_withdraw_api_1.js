
// QTEA LIVE - Withdraw API (WD Feature)
// File: qtea_withdraw_api.js - Tambahkan ke qtea_jackpot_api.js

const express = require('express');
const router = express.Router();

// 1. Host cek saldo beans & rate
router.get('/api/host/:hostId/balance', async (req, res) => {
  const { hostId } = req.params;
  const [rows] = await db.execute('SELECT beans, total_earned_beans, total_withdrawn_beans FROM users WHERE id = ?', [hostId]);
  if (!rows.length) return res.status(404).json({error: 'Host not found'});
  
  const beans = rows[0].beans;
  const rate = 1.111; // 1 bean = Rp 1.111 dari config
  const rp = Math.floor(beans * rate);
  
  res.json({
    beans,
    rp_estimate: rp,
    rate: `1 bean = Rp ${rate}`,
    min_wd_beans: 9000,
    min_wd_rp: 10000,
    can_withdraw: beans >= 9000
  });
});

// 2. Host request WD
router.post('/api/withdraw/request', async (req, res) => {
  const { hostId, beans, ewallet, ewallet_number, bank_name, bank_account, account_name } = req.body;
  
  // Validasi min 9000
  if (beans < 9000) return res.status(400).json({error: 'Min WD 9000 beans = Rp 10.000'});
  
  const [userRows] = await db.execute('SELECT beans FROM users WHERE id = ? FOR UPDATE', [hostId]);
  if (!userRows.length || userRows[0].beans < beans) {
    return res.status(400).json({error: 'Beans tidak cukup'});
  }
  
  const rate = 1.111;
  const rp = Math.floor(beans * rate);
  const fee = 0; // gratis di awal
  
  const conn = await db.getConnection();
  try {
    await conn.beginTransaction();
    // Potong beans host langsung (tahan)
    await conn.execute('UPDATE users SET beans = beans - ?, total_withdrawn_beans = total_withdrawn_beans + ? WHERE id = ?', [beans, beans, hostId]);
    // Buat request
    const [result] = await conn.execute(
      'INSERT INTO qtea_withdrawals (host_id, beans_requested, rp_amount, fee_beans, e_wallet, ewallet_number, bank_name, bank_account, account_name, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [hostId, beans, rp, fee, ewallet, ewallet_number, bank_name, bank_account, account_name, 'PENDING']
    );
    await conn.commit();
    res.json({success: true, withdrawal_id: result.insertId, beans, rp_amount: rp, status: 'PENDING', message: `Request WD ${beans} beans = Rp ${rp.toLocaleString()} berhasil, tunggu approve admin`});
  } catch(e){
    await conn.rollback();
    res.status(500).json({error: e.message});
  } finally {
    conn.release();
  }
});

// 3. Admin - List WD pending
router.get('/api/admin/withdrawals', async (req, res) => {
  const { status } = req.query; // PENDING, APPROVED, etc
  let query = 'SELECT w.*, u.username FROM qtea_withdrawals w JOIN users u ON w.host_id = u.id';
  if (status) query += ` WHERE w.status = '${status}'`;
  query += ' ORDER BY w.created_at DESC';
  const [rows] = await db.execute(query);
  res.json(rows);
});

// 4. Admin - Approve / Reject WD
router.post('/api/admin/withdraw/:id/:action', async (req, res) => {
  const { id, action } = req.params; // approve, reject, success
  const { admin_note } = req.body;
  
  const valid = {approve: 'APPROVED', reject: 'REJECTED', success: 'SUCCESS', processing: 'PROCESSING'};
  if (!valid[action]) return res.status(400).json({error: 'Action invalid'});
  
  const newStatus = valid[action];
  
  if (action === 'reject') {
    // Balikin beans ke host kalau reject
    const conn = await db.getConnection();
    try {
      await conn.beginTransaction();
      const [wdRows] = await conn.execute('SELECT host_id, beans_requested FROM qtea_withdrawals WHERE id = ?', [id]);
      if (!wdRows.length) throw new Error('Not found');
      await conn.execute('UPDATE users SET beans = beans + ?, total_withdrawn_beans = total_withdrawn_beans - ? WHERE id = ?', [wdRows[0].beans_requested, wdRows[0].beans_requested, wdRows[0].host_id]);
      await conn.execute('UPDATE qtea_withdrawals SET status = ?, admin_note = ?, processed_at = NOW() WHERE id = ?', [newStatus, admin_note, id]);
      await conn.commit();
      res.json({success: true, status: newStatus});
    } catch(e){ await conn.rollback(); res.status(500).json({error: e.message}); } finally { conn.release(); }
  } else {
    await db.execute('UPDATE qtea_withdrawals SET status = ?, admin_note = ?, processed_at = NOW() WHERE id = ?', [newStatus, admin_note, id]);
    res.json({success: true, status: newStatus});
  }
});

module.exports = router;
