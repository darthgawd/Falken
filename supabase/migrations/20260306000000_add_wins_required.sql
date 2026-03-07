-- Add wins_required column for V3 contracts
ALTER TABLE matches ADD COLUMN IF NOT EXISTS wins_required INTEGER DEFAULT 3;

-- Update existing matches to have default value
UPDATE matches SET wins_required = 3 WHERE wins_required IS NULL;
