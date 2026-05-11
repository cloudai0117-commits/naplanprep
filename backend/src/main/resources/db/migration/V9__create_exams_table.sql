CREATE TYPE exam_status AS ENUM ('DRAFT', 'PUBLISHED', 'ARCHIVED');
CREATE TYPE package_tier AS ENUM ('FREE', 'STANDARD', 'PREMIUM', 'FAMILY');

CREATE TABLE exams (
    id              UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title           VARCHAR(200) NOT NULL,
    description     TEXT,
    year_level      SMALLINT NOT NULL CHECK (year_level IN (3, 5, 7, 9)),
    domain          domain_type NOT NULL,
    package_tier    package_tier NOT NULL DEFAULT 'FREE',
    time_limit_seconds INTEGER NOT NULL CHECK (time_limit_seconds > 0),
    available_from  TIMESTAMPTZ,
    available_until TIMESTAMPTZ,
    status          exam_status NOT NULL DEFAULT 'DRAFT',
    created_by      UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exams_status       ON exams(status);
CREATE INDEX idx_exams_year_level   ON exams(year_level);
CREATE INDEX idx_exams_domain       ON exams(domain);
CREATE INDEX idx_exams_package_tier ON exams(package_tier);
CREATE INDEX idx_exams_window       ON exams(available_from, available_until);
