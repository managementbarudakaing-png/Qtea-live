-- QTEA LIVE Topup Packages
-- Harga: Rp 10000 = 9000 Coin (base rate 1 coin = Rp 1.111)

DROP TABLE IF EXISTS qtea_topup_packages;
CREATE TABLE qtea_topup_packages (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  price_rp INT NOT NULL,
  coins INT NOT NULL COMMENT 'Coin base tanpa bonus',
  bonus_coins INT DEFAULT 0,
  total_coins INT NOT NULL COMMENT 'Total yang diterima user',
  tag VARCHAR(50),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO qtea_topup_packages (id, name, price_rp, coins, bonus_coins, total_coins, tag) VALUES
(1, 'Paket Cilok', 10000, 9000, 0, 9000, ''),
(2, 'Paket Bakso', 20000, 18000, 1000, 19000, 'Hot'),
(3, 'Paket Seblak', 50000, 45000, 5000, 50000, 'Best Seller'),
(4, 'Paket Sate', 100000, 90000, 15000, 105000, 'Bonus 16%'),
(5, 'Paket Nasi Liwet', 200000, 180000, 40000, 220000, 'Bonus 22%'),
(6, 'Paket Keraton', 500000, 450000, 150000, 600000, 'Bonus 33%'),
(7, 'Paket Naga Dewa', 1000000, 900000, 400000, 1300000, 'SULTAN +44%');

-- Tabel transaksi topup
DROP TABLE IF EXISTS qtea_topup_transactions;
CREATE TABLE qtea_topup_transactions (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  package_id INT,
  price_rp INT,
  coins_received INT,
  payment_method VARCHAR(50) DEFAULT 'MIDTRANS',
  payment_status ENUM('PENDING','SUCCESS','FAILED') DEFAULT 'PENDING',
  midtrans_order_id VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (package_id) REFERENCES qtea_topup_packages(id)
);

-- Config withdraw host: 1 bean = Rp 1.111 (sama dengan coin rate) agar 60% fair
-- Misal host punya 9000 beans = 9000 * 1.111 = Rp 10.000 bisa withdraw
DROP TABLE IF EXISTS qtea_config;
CREATE TABLE qtea_config (
  config_key VARCHAR(50) PRIMARY KEY,
  config_value VARCHAR(100),
  description TEXT
);

INSERT INTO qtea_config (config_key, config_value, description) VALUES
('coin_to_rp', '1.111', '1 coin = Rp 1.111 (9000 coin = Rp 10000)'),
('bean_to_rp', '1.111', '1 bean host = Rp 1.111, host dapat 60% dari gift'),
('host_percent', '60', 'Host dapat 60%'),
('jp_pool_percent', '40', '40% dari Gift JP masuk Global Jackpot Pool'),
('min_withdraw_beans', '9000', 'Min withdraw 9000 beans = Rp 10000'),
('min_withdraw_rp', '10000', 'Min withdraw Rp 10.000');
