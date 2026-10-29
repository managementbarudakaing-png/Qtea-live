
// QTEA LIVE V3 - Dual Wallet System
// ATURAN: Topup Bean TIDAK BISA WD, hanya Earned Coin hasil gift yang BISA WD

// 1. TOPUP - Masuk ke topup_beans (TIDAK BISA WD)
async function handleTopup(userId, packageId) {
  const pkg = topupPackages.find(p => p.id === packageId); // Rp 10k = 9000 bean
  await db.execute('UPDATE users SET topup_beans = topup_beans + ? WHERE id = ?', [pkg.total_coins, userId]);
  await db.execute('INSERT INTO qtea_topup_transactions (user_id, package_id, price_rp, coins_received) VALUES (?, ?, ?, ?)', [userId, packageId, pkg.price_rp, pkg.total_coins]);
  return { message: `Topup ${pkg.total_coins} topup_beans (TIDAK BISA WD) berhasil` };
}

// 2. KIRIM GIFT - Pakai topup_beans, host dapat earned_coins (BISA WD)
async function processGiftV3({ userId, hostId, giftId, roomId, io }) {
  const gift = giftMap.get(giftId);
  const conn = await db.getConnection();
  await conn.beginTransaction();
  try {
    // Cek saldo topup_beans user (yang TIDAK BISA WD ini)
    const [userRows] = await conn.execute('SELECT topup_beans FROM users WHERE id = ? FOR UPDATE', [userId]);
    if (userRows[0].topup_beans < gift.price) throw new Error('Topup beans tidak cukup, topup dulu Rp 10k=9000 bean');

    // Potong topup_beans user
    await conn.execute('UPDATE users SET topup_beans = topup_beans - ?, topup_beans_used = topup_beans_used + ? WHERE id = ?', [gift.price, gift.price, userId]);

    // Host dapat earned_coins (BISA WD) = 60% dari harga
    const hostEarn = Math.floor(gift.price * 0.6); // misal gift 100 beans, host dapat 60 earned_coins yang BISA WD
    await conn.execute('UPDATE users SET earned_coins = earned_coins + ?, total_earned_beans = total_earned_beans + ? WHERE id = ?', [hostEarn, hostEarn, hostId]);

    // Jika MURNI: 40% profit platform (hangus, tidak masuk pool)
    // Jika JP: 40% masuk jackpot pool
    if (gift.type === 'JP') {
      const poolAdd = gift.price - hostEarn;
      await conn.execute('UPDATE qtea_jackpot_pool SET current_pool = current_pool + ? WHERE id = 1', [poolAdd]);
      
      // Roll jackpot
      const isWin = Math.random()*100 < gift.winrate;
      if (isWin) {
        const mult = Math.floor(Math.random()*(gift.mult_max - gift.mult_min +1)) + gift.mult_min;
        let winAmount = gift.price * mult; // Menang dalam topup_beans? Tidak, menang dalam bentuk yang BISA dipakai lagi tapi tetap TIDAK BISA WD? Aturan: Menang jackpot masuk ke topup_beans juga (agar tidak bisa WD langsung, harus di-gift lagi biar host dapat)
        // Atau sesuai request: jackpot win masuk ke topup_beans (tidak bisa WD) atau earned_coins? Kita set: Jackpot win masuk ke topup_beans (agar harus diputar lagi)
        // Tapi biar adil: kita masukkan ke topup_beans (tidak bisa WD) supaya tidak abuse
        await conn.execute('UPDATE users SET topup_beans = topup_beans + ? WHERE id = ?', [winAmount, userId]);
        await conn.execute('UPDATE qtea_jackpot_pool SET current_pool = current_pool - ? WHERE id = 1', [winAmount]);
        io.emit('jackpot_win', { userId, giftName: gift.name, winAmount, message: `MENANG ${winAmount} beans (topup, tidak bisa WD langsung)` });
        await conn.commit();
        return { status: 'WIN_JP', winAmount, note: 'Menang masuk topup_beans (tidak bisa WD, harus gift lagi)' };
      }
    }

    await conn.commit();
    io.to(`room_${roomId}`).emit('gift_result', { giftId, hostEarnCoins: hostEarn, note: 'Host dapat earned_coins BISA WD, user pakai topup_beans TIDAK BISA WD' });
    return { status: 'OK', hostEarnCoins: hostEarn };

  } catch(e){ await conn.rollback(); throw e; } finally { conn.release(); }
}

// 3. WITHDRAW - Hanya bisa dari earned_coins (hasil gift), TIDAK bisa dari topup_beans
async function requestWithdrawV3({ hostId, earnedCoins, ewallet, ewallet_number }) {
  if (earnedCoins < 9000) throw new Error('Min WD 9000 earned_coins (hasil gift) = Rp 10.000. Topup beans tidak bisa WD!');
  
  const [rows] = await db.execute('SELECT earned_coins FROM users WHERE id = ? FOR UPDATE', [hostId]);
  if (rows[0].earned_coins < earnedCoins) throw new Error('Earned coins tidak cukup. Ini hanya coin hasil gift, bukan topup');

  const rp = Math.floor(earnedCoins * 1.111);
  await db.execute('UPDATE users SET earned_coins = earned_coins - ?, earned_coins_withdrawn = earned_coins_withdrawn + ? WHERE id = ?', [earnedCoins, earnedCoins, hostId]);
  const [result] = await db.execute('INSERT INTO qtea_withdrawals (host_id, earned_coins_requested, rp_amount, ewallet, ewallet_number) VALUES (?, ?, ?, ?, ?)', [hostId, earnedCoins, rp, ewallet, ewallet_number]);
  return { withdrawal_id: result.insertId, earnedCoins, rp, message: `WD ${earnedCoins} earned_coins (hasil gift) = Rp ${rp} - topup_beans tidak bisa WD` };
}

// Contoh response balance host
async function getHostBalanceV3(hostId) {
  const [rows] = await db.execute('SELECT topup_beans, earned_coins FROM users WHERE id = ?', [hostId]);
  return {
    topup_beans: rows[0].topup_beans, // TIDAK BISA WD
    earned_coins: rows[0].earned_coins, // BISA WD
    note: 'topup_beans = hasil topup Rp10k=9000, TIDAK BISA WD. earned_coins = hasil gift dari viewer, BISA WD 60%',
    can_withdraw: rows[0].earned_coins,
    cannot_withdraw: rows[0].topup_beans
  };
}
