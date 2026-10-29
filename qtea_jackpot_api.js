
// QTEA LIVE - Jackpot Engine API
// Node.js + Express + Socket.io + MySQL
// Aturan: Host 60% - Jackpot HANYA dari Gift JP - Gift Murni tidak masuk Pool

const express = require('express');
const mysql = require('mysql2/promise');
const { Server } = require('socket.io');

const app = express();
app.use(express.json());

// DB Pool
const db = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'qtea_live',
  waitForConnections: true
});

// In-memory cache untuk gifts (load sekali dari qtea_gifts_92.json)
const gifts = require('./qtea_gifts_92.json');
const giftMap = new Map(gifts.map(g => [g.id, g]));

/*
 * CORE FUNCTION: Roll Jackpot
 * Dipanggil setiap user kirim Gift JP
 */
async function processGiftJP({ userId, hostId, giftId, roomId, io }) {
  const gift = giftMap.get(giftId);
  if (!gift || gift.type !== 'JP') throw new Error('Bukan Gift JP');

  const conn = await db.getConnection();
  await conn.beginTransaction();

  try {
    // 1. Potong koin user (asumsi sudah ada cek saldo di middleware)
    await conn.execute('UPDATE users SET coins = coins - ? WHERE id = ?', [gift.price, userId]);

    // 2. Host dapat 60% langsung
    const hostBeans = gift.host_beans;
    await conn.execute('UPDATE users SET beans = beans + ? WHERE id = ?', [hostBeans, hostId]);

    // 3. 40% masuk Global Jackpot Pool
    const poolAdd = gift.price - hostBeans;
    await conn.execute('UPDATE qtea_jackpot_pool SET current_pool = current_pool + ?, total_in = total_in + ?, updated_at = NOW() WHERE id = 1', [poolAdd, poolAdd]);

    // 4. Roll Winrate
    const roll = Math.random() * 100;
    const isWin = roll < gift.winrate;
    
    let winAmount = 0;
    let multiplier = 0;

    if (isWin) {
      // Random kelipatan antara mult_min dan mult_max
      multiplier = Math.floor(Math.random() * (gift.mult_max - gift.mult_min + 1)) + gift.mult_min;
      winAmount = gift.price * multiplier;

      // Cek apakah pool cukup, kalau tidak cukup kasih max pool
      const [poolRows] = await conn.execute('SELECT current_pool FROM qtea_jackpot_pool WHERE id = 1 FOR UPDATE');
      const currentPool = poolRows[0].current_pool;

      if (winAmount > currentPool) {
        winAmount = currentPool; // All-in pool
        multiplier = Math.floor(winAmount / gift.price);
      }

      // Kurangi pool, tambah koin ke pemenang
      await conn.execute('UPDATE qtea_jackpot_pool SET current_pool = current_pool - ?, total_out = total_out + ?, last_winner_id = ?, last_win_amount = ? WHERE id = 1', [winAmount, winAmount, userId, winAmount]);
      await conn.execute('UPDATE users SET coins = coins + ? WHERE id = ?', [winAmount, userId]);

      // Log kemenangan
      await conn.execute('INSERT INTO qtea_jackpot_logs (user_id, gift_id, gift_name, price_paid, win_amount, multiplier) VALUES (?, ?, ?, ?, ?, ?)', [userId, gift.id, gift.name, gift.price, winAmount, multiplier]);

      await conn.commit();

      // 5. BROADCAST ke SEMUA ROOM kalau win besar
      if (winAmount >= 1000 || gift.price >= 25) {
        io.emit('jackpot_win', {
          type: 'GLOBAL_JACKPOT',
          userId,
          giftName: gift.name,
          winAmount,
          multiplier,
          message: `🔥 USER ${userId} MENANG ${winAmount.toLocaleString()} KOIN DI ${gift.name.toUpperCase()} x${multiplier}!`,
          animation: gift.price >= 50 ? 'legendary' : 'grand'
        });
      }

      // Broadcast ke room spesifik juga
      io.to(`room_${roomId}`).emit('gift_result', {
        giftId, giftName: gift.name, userId, hostId,
        result: 'WIN', winAmount, multiplier,
        hostBeans
      });

      return { status: 'WIN', winAmount, multiplier, hostBeans, poolAdd };

    } else {
      // KALAH - tidak dapat apa-apa selain host sudah dapat 60%
      await conn.commit();
      io.to(`room_${roomId}`).emit('gift_result', {
        giftId, giftName: gift.name, userId, hostId,
        result: 'LOSE', winAmount: 0,
        hostBeans
      });
      return { status: 'LOSE', winAmount: 0, hostBeans, poolAdd };
    }

  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}

// API untuk Gift Murni - Simple, tidak ada jackpot
async function processGiftMurni({ userId, hostId, giftId, roomId, io }) {
  const gift = giftMap.get(giftId);
  if (!gift || gift.type !== 'MURNI') throw new Error('Bukan Gift Murni');

  const conn = await db.getConnection();
  await conn.beginTransaction();
  try {
    await conn.execute('UPDATE users SET coins = coins - ? WHERE id = ?', [gift.price, userId]);
    await conn.execute('UPDATE users SET beans = beans + ? WHERE id = ?', [gift.host_beans, hostId]);
    // platform_beans dicatat sebagai profit lu di tabel lain kalau mau
    await conn.commit();

    io.to(`room_${roomId}`).emit('gift_result', {
      giftId, giftName: gift.name, userId, hostId,
      result: 'MURNI', hostBeans: gift.host_beans, platformBeans: gift.platform_beans
    });

    return { status: 'MURNI_OK', hostBeans: gift.host_beans };
  } catch (e) {
    await conn.rollback();
    throw e;
  } finally {
    conn.release();
  }
}

// --- EXPRESS ROUTES ---
app.post('/api/gift/send', async (req, res) => {
  const { userId, hostId, giftId, roomId } = req.body;
  const io = req.app.get('io');
  try {
    const gift = giftMap.get(Number(giftId));
    if (!gift) return res.status(404).json({ error: 'Gift not found' });

    let result;
    if (gift.type === 'JP') {
      result = await processGiftJP({ userId, hostId, giftId: Number(giftId), roomId, io });
    } else {
      result = await processGiftMurni({ userId, hostId, giftId: Number(giftId), roomId, io });
    }
    res.json({ success: true, gift, result });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

app.get('/api/gifts', (req, res) => {
  res.json(gifts);
});

app.get('/api/jackpot/pool', async (req, res) => {
  const [rows] = await db.execute('SELECT * FROM qtea_jackpot_pool WHERE id = 1');
  res.json(rows[0]);
});

app.get('/api/jackpot/logs', async (req, res) => {
  const [rows] = await db.execute('SELECT * FROM qtea_jackpot_logs ORDER BY created_at DESC LIMIT 20');
  res.json(rows);
});

const server = app.listen(3000, () => console.log('QTEA LIVE API running on :3000'));
const io = new Server(server, { cors: { origin: '*' } });
app.set('io', io);

io.on('connection', (socket) => {
  socket.on('join_room', (roomId) => {
    socket.join(`room_${roomId}`);
  });
});

module.exports = { processGiftJP, processGiftMurni };
