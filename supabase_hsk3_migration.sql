-- ==============================================================================
-- MIGRATION SCRIPT: CẬP NHẬT PHÂN TÁCH PHIÊN BẢN HSK 2.0 VÀ HSK 3.0
-- Chạy đoạn mã này trong SQL Editor trên Supabase Dashboard (https://supabase.com)
-- ==============================================================================

-- 1. Thêm cột 'version' cho bảng sessions (mặc định các buổi học hiện tại là '2.0')
ALTER TABLE sessions ADD COLUMN IF NOT EXISTS version TEXT DEFAULT '2.0';
UPDATE sessions SET version = '2.0' WHERE version IS NULL;

-- 2. Thêm cột 'version' cho bảng grammar (ngữ pháp)
ALTER TABLE grammar ADD COLUMN IF NOT EXISTS version TEXT DEFAULT '2.0';
UPDATE grammar SET version = '2.0' WHERE version IS NULL;

-- 3. Thêm cột 'version' cho bảng classifiers (lượng từ)
ALTER TABLE classifiers ADD COLUMN IF NOT EXISTS version TEXT DEFAULT '2.0';
UPDATE classifiers SET version = '2.0' WHERE version IS NULL;

-- 4. Tạo chỉ mục (Index) để tối ưu tốc độ lọc theo phiên bản
CREATE INDEX IF NOT EXISTS idx_sessions_version ON sessions(version);
CREATE INDEX IF NOT EXISTS idx_grammar_version ON grammar(version);
CREATE INDEX IF NOT EXISTS idx_classifiers_version ON classifiers(version);

-- (Tùy chọn) Kiểm tra kết quả
SELECT 'sessions' AS tbl, version, count(*) FROM sessions GROUP BY version
UNION ALL
SELECT 'grammar' AS tbl, version, count(*) FROM grammar GROUP BY version
UNION ALL
SELECT 'classifiers' AS tbl, version, count(*) FROM classifiers GROUP BY version;
