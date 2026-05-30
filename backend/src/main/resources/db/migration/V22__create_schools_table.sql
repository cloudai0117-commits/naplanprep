CREATE TABLE IF NOT EXISTS schools (
    id          UUID        PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(200) NOT NULL,
    state       VARCHAR(10),
    created_at  TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Seed a handful of common schools so the dropdown isn't empty on first deploy
INSERT INTO schools (id, name, state) VALUES
    (uuid_generate_v4(), 'Sydney Grammar School', 'NSW'),
    (uuid_generate_v4(), 'Melbourne Grammar School', 'VIC'),
    (uuid_generate_v4(), 'Brisbane State High School', 'QLD'),
    (uuid_generate_v4(), 'Perth Modern School', 'WA'),
    (uuid_generate_v4(), 'Adelaide High School', 'SA')
ON CONFLICT DO NOTHING;
