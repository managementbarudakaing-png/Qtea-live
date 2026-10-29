
-- QTEA LIVE V3 - Pisah Bean Topup vs Coin WD
-- ATURAN BARU: Bean Topup TIDAK bisa WD, hanya Coin hasil gift yang bisa WD

-- Drop & recreate users dengan 2 dompet terpisah
DROP TABLE IF EXISTS users_v3;
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50),
  -- Dompet 1: Topup (TIDAK bisa WD)
  topup_beans INT DEFAULT 0 COMMENT 'Bean hasil topup Rp 10k=9000 bean - TIDAK BISA WD',
  topup_beans_used INT DEFAULT 0 COMMENT 'Bean topup yang sudah dipakai buat gift',
  
  -- Dompet 2: Hasil Nge-host (BISA WD)
  earned_coins INT DEFAULT 0 COMMENT 'Coin hasil gift dari viewer - BISA WD',
  earned_coins_withdrawn INT DEFAULT 0 COMMENT 'Coin yang sudah di WD',
  
  -- Total untuk display
  total_earned_beans BIGINT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Update gifts: sekarang pakai topup_beans untuk bayar, hasil masuk earned_coins host
DROP TABLE IF EXISTS qtea_gifts_v3;
CREATE TABLE qtea_gifts (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  price_beans INT COMMENT 'Harga pakai topup_beans',
  type ENUM('JP','MURNI'),
  category VARCHAR(50),
  is_jackpot BOOLEAN,
  winrate DECIMAL(5,2),
  mult_min INT,
  mult_max INT,
  host_earn_coins INT COMMENT 'Host dapat dalam bentuk earned_coins yang BISA WD',
  platform_profit_beans INT,
  jackpot_pool_beans INT,
  animation_type VARCHAR(20)
);

-- Withdraw hanya dari earned_coins
DROP TABLE IF EXISTS qtea_withdrawals_v3;
CREATE TABLE qtea_withdrawals (
  id INT PRIMARY KEY AUTO_INCREMENT,
  host_id INT NOT NULL,
  earned_coins_requested INT NOT NULL COMMENT 'Ambil dari earned_coins - BISA WD',
  rp_amount INT NOT NULL,
  status ENUM('PENDING','APPROVED','REJECTED','SUCCESS') DEFAULT 'PENDING',
  ewallet VARCHAR(50),
  ewallet_number VARCHAR(20),
  bank_name VARCHAR(50),
  bank_account VARCHAR(50),
  account_name VARCHAR(100),
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  processed_at TIMESTAMP NULL,
  FOREIGN KEY (host_id) REFERENCES users(id)
);

-- Config baru
DROP TABLE IF EXISTS qtea_config_v3;
CREATE TABLE qtea_config (
  config_key VARCHAR(50) PRIMARY KEY,
  config_value VARCHAR(100),
  description TEXT
);

INSERT INTO qtea_config (config_key, config_value, description) VALUES
('topup_rate', '9000', 'Rp 10000 = 9000 topup_beans - TIDAK BISA WD'),
('topup_bean_to_rp', '1.111', '1 topup_bean = Rp 1.111 tapi tidak bisa WD'),
('earned_coin_to_rp', '1.111', '1 earned_coin = Rp 1.111 - BISA WD'),
('host_percent', '60', 'Host dapat 60% dalam bentuk earned_coins yang BISA WD'),
('min_wd_coins', '9000', 'Min WD 9000 earned_coins = Rp 10000 - hanya dari hasil gift'),
('rule', 'TOPUP_BEAN_TIDAK_BISA_WD', 'Bean topup hanya untuk gift, tidak bisa dicairkan. Hanya earned_coins dari gift yang bisa WD');
