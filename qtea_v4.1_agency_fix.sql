
-- QTEA LIVE V4.1 - UPDATE AGENCY SPLIT FINAL
-- Host dengan agency: Host 60% + Agency 15% + Platform 25% = 100%
-- Host tanpa agency: Host 60% + Platform 40% = 100%

UPDATE qtea_config SET config_value = '60' WHERE config_key = 'agency_host_percent';
UPDATE qtea_config SET config_value = '15' WHERE config_key = 'agency_commission_rate';
UPDATE qtea_config SET config_value = '25' WHERE config_key = 'agency_platform_percent';

-- Insert if not exists
INSERT INTO qtea_config (config_key, config_value, description) VALUES
('agency_platform_percent', '25', 'Platform dapat 25% kalau host punya agency (host 60% + agency 15%)'),
('no_agency_host_percent', '60', 'Host tanpa agency dapat 60%'),
('no_agency_platform_percent', '40', 'Platform dapat 40% kalau host tanpa agency')
ON DUPLICATE KEY UPDATE config_value=VALUES(config_value), description=VALUES(description);

-- Update level commission tetap 15% base tapi platform yang berkurang
-- BRONZE 15%, SILVER 15%, GOLD 15%, PLATINUM 18%, DIAMOND 20% (naik bonus dari platform)
