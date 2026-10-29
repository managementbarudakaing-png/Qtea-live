
-- QTEA LIVE V4.2 - AdMob Tracking untuk penghasilan tambahan
CREATE TABLE qtea_ad_earnings (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  ad_type ENUM('APP_OPEN','INTERSTITIAL','REWARDED','BANNER') NOT NULL,
  reward_beans INT DEFAULT 0 COMMENT 'Beans gratis yang diberikan ke user (TIDAK BISA WD)',
  admob_revenue_usd DECIMAL(10,4) DEFAULT 0 COMMENT 'Estimasi revenue dari AdMob',
  admob_revenue_rp INT DEFAULT 0 COMMENT 'Revenue dalam Rupiah (USD*16000)',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE qtea_ad_config (
  config_key VARCHAR(50) PRIMARY KEY,
  config_value VARCHAR(100),
  description TEXT
);

INSERT INTO qtea_ad_config (config_key, config_value, description) VALUES
('ad_enabled', '1', 'Iklan aktif'),
('ad_app_open_enabled', '1', 'App Open Ad pas buka app - cuan gede'),
('ad_interstitial_enabled', '1', 'Interstitial pas keluar live room'),
('ad_rewarded_enabled', '1', 'Rewarded untuk free beans 100 beans'),
('ad_rewarded_beans', '100', 'Reward 100 topup_beans (TIDAK BISA WD) per iklan'),
('ad_rewarded_limit_per_day', '10', 'Max 10x nonton iklan per hari = 1000 beans gratis'),
('ad_banner_enabled', '0', 'Banner dimatikan dulu biar UI bersih kayak Momo'),
('admob_app_id', 'ca-app-pub-xxxxxxxx~xxxxxxxx', 'Ganti dengan App ID AdMob lu'),
('admob_estimated_ecpm_id', '0.50', 'Estimasi eCPM Indonesia $0.50 per 1000 impression')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value);
