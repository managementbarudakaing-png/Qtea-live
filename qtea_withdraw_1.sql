
-- QTEA LIVE - Fitur Withdraw (WD) Host
-- Rate: 1 bean = Rp 1.111 | Min WD 9000 beans = Rp 10.000

DROP TABLE IF EXISTS qtea_withdrawals;
CREATE TABLE qtea_withdrawals (
  id INT PRIMARY KEY AUTO_INCREMENT,
  host_id INT NOT NULL,
  beans_requested INT NOT NULL COMMENT 'Beans yang mau dicairkan',
  rp_amount INT NOT NULL COMMENT 'Rupiah yang diterima host',
  fee_beans INT DEFAULT 0 COMMENT 'Biaya admin jika ada',
  status ENUM('PENDING','APPROVED','REJECTED','PROCESSING','SUCCESS') DEFAULT 'PENDING',
  bank_name VARCHAR(50),
  bank_account VARCHAR(50),
  account_name VARCHAR(100),
  e_wallet VARCHAR(50) COMMENT 'DANA, OVO, GOPAY',
  ewallet_number VARCHAR(20),
  admin_note TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  processed_at TIMESTAMP NULL,
  FOREIGN KEY (host_id) REFERENCES users(id)
);

-- Tabel users tambahan kolom
ALTER TABLE users ADD COLUMN IF NOT EXISTS beans INT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_earned_beans BIGINT DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS total_withdrawn_beans BIGINT DEFAULT 0;

-- Insert contoh config WD
INSERT INTO qtea_config (config_key, config_value, description) VALUES
('wd_enabled', '1', 'Fitur WD aktif'),
('wd_min_beans', '9000', 'Min 9000 beans = Rp 10000'),
('wd_max_beans_per_day', '4500000', 'Max WD per hari 4.5jt beans = Rp 5jt'),
('wd_fee_percent', '0', 'Fee WD 0% di awal biar host betah'),
('wd_auto_approve', '0', '0=manual approve admin, 1=auto'),
('wd_bank_options', 'DANA,OVO,GOPAY,BCA,BRI,MANDIRI', 'Opsi pencairan')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value);
