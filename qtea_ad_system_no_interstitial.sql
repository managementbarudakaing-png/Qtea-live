
-- QTEA LIVE V4.2 FINAL - Hanya 2 Iklan (Tanpa Interstitial)
-- Sesuai request: Jangan gunakan No 3 Interstitial

CREATE TABLE qtea_ad_earnings_v2 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  ad_type ENUM('APP_OPEN','REWARDED') NOT NULL COMMENT 'Hanya 2 tipe, tanpa INTERSTITIAL',
  reward_beans INT DEFAULT 0 COMMENT '100 beans gratis TIDAK BISA WD',
  admob_revenue_usd DECIMAL(10,4) DEFAULT 0,
  admob_revenue_rp INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO qtea_config (config_key, config_value, description) VALUES
('ad_enabled', '1', 'Iklan aktif - hanya App Open & Rewarded'),
('ad_app_open_enabled', '1', 'App Open Ad pas buka app - TIDAK ganggu live'),
('ad_rewarded_enabled', '1', 'Rewarded untuk free beans 100 beans - user sukarela'),
('ad_interstitial_enabled', '0', 'Interstitial DIMATIKAN sesuai request - tidak ganggu keluar live room'),
('ad_rewarded_beans', '100', 'Reward 100 topup_beans TIDAK BISA WD'),
('ad_rewarded_limit_per_day', '10', 'Max 10x per hari = 1000 beans gratis')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value), description=VALUES(description);
