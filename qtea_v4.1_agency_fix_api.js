
// QTEA LIVE V4.1 - FIX SPLIT FINAL
// Host dengan agency: Host 60% + Agency 15% + Platform 25% = 100%

function calculateSplitV41(giftPrice, hasAgency, agencyLevel) {
  const COMMISSION_LEVEL = {
    BRONZE: 15,
    SILVER: 15,
    GOLD: 15,
    PLATINUM: 18,
    DIAMOND: 20
  };

  if (!hasAgency) {
    // Host tanpa agency: Host 60%, Platform 40%
    return {
      hostEarn: Math.floor(giftPrice * 0.60),
      agencyEarn: 0,
      platformProfit: Math.floor(giftPrice * 0.40)
    };
  } else {
    // Host DENGAN agency sesuai request: Host 60% + Agency 15% + Platform 25%
    const rate = COMMISSION_LEVEL[agencyLevel] || 15;
    const agencyEarn = Math.floor(giftPrice * rate / 100);
    const hostEarn = Math.floor(giftPrice * 0.60);
    const platformProfit = giftPrice - hostEarn - agencyEarn; // 25% kalau rate 15%

    return { hostEarn, agencyEarn, platformProfit, rate };
  }
}

// Contoh implementasi di processGiftV4
async function processGiftV41({ userId, hostId, giftId }) {
  const giftPrice = 100; // contoh gift 100 topup_beans
  const hasAgency = true;
  const agencyLevel = 'BRONZE';

  const split = calculateSplitV41(giftPrice, hasAgency, agencyLevel);

  console.log(`Gift ${giftPrice} beans:`);
  console.log(`- Host dapat: ${split.hostEarn} earned_coins (60% BISA WD)`);
  console.log(`- Agency dapat: ${split.agencyEarn} commission_coins (15% BISA WD)`);
  console.log(`- Platform dapat: ${split.platformProfit} (25%)`);

  // Contoh: Gift 100
  // Host = 60, Agency = 15, Platform = 25

  // Gift 5000 (Garuda Wisnu)
  // Host = 3000 coins = Rp 3333 BISA WD
  // Agency = 750 coins = Rp 833 BISA WD
  // Platform = 1250 coins

  // Gift 50000 (Naga Dewa Grand)
  // Host = 30000 coins = Rp 33.330 BISA WD
  // Agency = 7500 coins = Rp 8.332 BISA WD
  // Platform = 12500
}

module.exports = { calculateSplitV41 };
