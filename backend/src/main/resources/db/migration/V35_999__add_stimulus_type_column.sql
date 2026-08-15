-- Adds stimulus_type to questions BEFORE V36a/b/c/d seed inserts run.
-- Those inserts reference this column; without this migration every fresh
-- deployment fails at V36a with "column stimulus_type does not exist".
-- IF NOT EXISTS makes this safe on databases that already have the column.
ALTER TABLE questions ADD COLUMN IF NOT EXISTS stimulus_type VARCHAR(20);
