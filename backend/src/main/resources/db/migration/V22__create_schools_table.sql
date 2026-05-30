CREATE TABLE IF NOT EXISTS schools (
    id          UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
    name        VARCHAR(200) NOT NULL,
    state       VARCHAR(10),
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Seed a handful of common schools so the dropdown isn't empty on first deploy
INSERT INTO schools (name, state) VALUES
    ('Sydney Grammar School', 'NSW'),
    ('Melbourne Grammar School', 'VIC'),
    ('Brisbane State High School', 'QLD'),
    ('Perth Modern School', 'WA'),
    ('Adelaide High School', 'SA')
ON CONFLICT DO NOTHING;
