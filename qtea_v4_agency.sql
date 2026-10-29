
-- QTEA LIVE V4 - AGENCY / PARTNER SYSTEM
-- Agency dapat keuntungan dari host yang mereka daftarkan

DROP TABLE IF EXISTS qtea_agencies;
CREATE TABLE qtea_agencies (
  id INT PRIMARY KEY AUTO_INCREMENT,
  agency_code VARCHAR(20) UNIQUE COMMENT 'Kode unik buat daftar host cth: AGENCYQTEA1',
  agency_name VARCHAR(100) NOT NULL,
  owner_id INT NOT NULL COMMENT 'User yang jadi agency owner',
  owner_name VARCHAR(100),
  level ENUM('BRONZE','SILVER','GOLD','PLATINUM','DIAMOND') DEFAULT 'BRONZE',
  total_hosts INT DEFAULT 0,
  active_hosts INT DEFAULT 0,
  total_host_earnings BIGINT DEFAULT 0 COMMENT 'Total earned_coins yang dihasilkan semua host agency',
  total_agency_earnings BIGINT DEFAULT 0 COMMENT 'Total komisi agency',
  commission_rate DECIMAL(5,2) DEFAULT 10.00 COMMENT 'Default 10% dari earned_coins host',
  balance_earned_coins INT DEFAULT 0 COMMENT 'Komisi agency yang BISA WD',
  balance_withdrawn INT DEFAULT 0,
  status ENUM('PENDING','ACTIVE','SUSPENDED','BANNED') DEFAULT 'PENDING',
  referral_link VARCHAR(255) COMMENT 'Link daftar host via agency',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS qtea_agency_hosts;
CREATE TABLE qtea_agency_hosts (
  id INT PRIMARY KEY AUTO_INCREMENT,
  agency_id INT NOT NULL,
  host_id INT NOT NULL UNIQUE COMMENT 'Satu host hanya bisa 1 agency',
  host_username VARCHAR(50),
  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_gifts_received INT DEFAULT 0 COMMENT 'Jumlah gift yang diterima host',
  total_earned_coins BIGINT DEFAULT 0 COMMENT 'Total earned_coins yang dihasilkan host',
  agency_commission_generated BIGINT DEFAULT 0 COMMENT 'Total komisi yang dihasilkan host untuk agency',
  status ENUM('ACTIVE','INACTIVE','LEFT','BANNED') DEFAULT 'ACTIVE',
  FOREIGN KEY (agency_id) REFERENCES qtea_agencies(id),
  FOREIGN KEY (host_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS qtea_agency_earnings;
CREATE TABLE qtea_agency_earnings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  agency_id INT NOT NULL,
  host_id INT NOT NULL,
  gift_id INT,
  gift_price INT COMMENT 'Harga gift dalam topup_beans',
  host_earned_coins INT COMMENT 'Host dapat 50% earned_coins',
  agency_commission_coins INT COMMENT 'Agency dapat 10% earned_coins',
  platform_profit_coins INT COMMENT 'Platform dapat 40%',
  transaction_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (agency_id) REFERENCES qtea_agencies(id),
  FOREIGN KEY (host_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS qtea_agency_withdrawals;
CREATE TABLE qtea_agency_withdrawals (
  id INT PRIMARY KEY AUTO_INCREMENT,
  agency_id INT NOT NULL,
  owner_id INT NOT NULL,
  commission_coins_requested INT NOT NULL,
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
  FOREIGN KEY (agency_id) REFERENCES qtea_agencies(id)
);

-- Config agency
INSERT INTO qtea_config (config_key, config_value, description) VALUES
('agency_enabled', '1', 'Fitur agency aktif'),
('agency_commission_rate', '10', 'Default agency dapat 10% dari earned_coins host'),
('agency_host_percent', '50', 'Host yang punya agency dapat 50% (bukan 60%), 10% ke agency'),
('agency_no_agency_host_percent', '60', 'Host tanpa agency dapat 60% full'),
('agency_min_hosts_bronze', '1', 'Min 1 host untuk Bronze'),
('agency_min_hosts_silver', '5', 'Min 5 host untuk Silver - komisi 12%'),
('agency_min_hosts_gold', '15', 'Min 15 host untuk Gold - komisi 15%'),
('agency_min_hosts_platinum', '30', 'Min 30 host untuk Platinum - komisi 18%'),
('agency_min_hosts_diamond', '50', 'Min 50 host untuk Diamond - komisi 20%'),
('agency_level_commission', 'BRONZE:10,SILVER:12,GOLD:15,PLATINUM:18,DIAMOND:20', 'Komisi naik per level'),
('agency_min_wd', '9000', 'Min WD agency sama kayak host 9000 coins = Rp 10k')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value);

-- Update users: tambah agency_id
ALTER TABLE users ADD COLUMN IF NOT EXISTS agency_id INT NULL COMMENT 'Host terdaftar di agency mana';
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_agency_owner BOOLEAN DEFAULT FALSE;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_host BOOLEAN DEFAULT TRUE;

-- Contoh data agency
-- INSERT INTO qtea_agencies (agency_code, agency_name, owner_id, owner_name, level, commission_rate) VALUES ('QTEABDG01', 'Barudak Aing Agency', 1, 'Deri Cahill', 'BRONZE', 10.00);
