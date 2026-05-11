#!/usr/bin/env bash
# Seeds the database with subscription plans, admin user, test students,
# and 30 sample questions (Year 3 & 5, Numeracy & Reading).
set -euo pipefail

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-naplanprep_dev}"
DB_USER="${DB_USER:-postgres}"
export PGPASSWORD="${DB_PASSWORD:-postgres}"

psql_exec() {
  psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -c "$1"
}

echo "=== Seeding NAPLANPrep Database ==="

echo "Inserting subscription plans..."
psql_exec "
INSERT INTO subscription_plan (name, price_monthly, price_annual, max_children, daily_question_limit, mock_exams_per_year, adaptive_learning, parent_dashboard, created_at)
VALUES
  ('FREE',     0.00,    0.00, 1, 10,  1,   false, false, NOW()),
  ('STANDARD', 14.99, 129.00, 1, 999, 12,  false, false, NOW()),
  ('PREMIUM',  24.99, 219.00, 1, 999, 999, true,  true,  NOW()),
  ('FAMILY',   34.99,   0.00, 4, 999, 999, true,  true,  NOW())
ON CONFLICT (name) DO NOTHING;
"

# Password hash for 'Admin123!' using bcrypt cost 12
BCRYPT_HASH='\$2a\$12\$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewGF.f1KY/j3Ot.q'

echo "Inserting admin user..."
psql_exec "
INSERT INTO app_user (email, password_hash, role, first_name, last_name, active, created_at)
VALUES ('admin@naplanprep.com.au', '$BCRYPT_HASH', 'ADMIN', 'Admin', 'User', true, NOW())
ON CONFLICT (email) DO NOTHING;
"

echo "Inserting test student accounts..."
psql_exec "
INSERT INTO app_user (email, password_hash, role, first_name, last_name, active, year_level, created_at)
VALUES
  ('student1@test.com', '$BCRYPT_HASH', 'STUDENT', 'Test', 'Student1', true, 3, NOW()),
  ('student2@test.com', '$BCRYPT_HASH', 'STUDENT', 'Test', 'Student2', true, 5, NOW())
ON CONFLICT (email) DO NOTHING;
"

echo "Inserting sample questions (Year 3 & 5, Numeracy & Reading)..."
psql_exec "
INSERT INTO question (year_level, strand, question_text, option_a, option_b, option_c, option_d, correct_answer, explanation, difficulty, active, created_at)
VALUES
  (3,'NUMERACY','What is 25 + 37?','52','62','72','53','B','25 + 37 = 62','EASY',true,NOW()),
  (3,'NUMERACY','Which is the largest number?','145','154','415','451','D','451 is the largest','EASY',true,NOW()),
  (3,'NUMERACY','How many sides does a hexagon have?','4','5','6','7','C','A hexagon has 6 sides','EASY',true,NOW()),
  (3,'NUMERACY','What is 8 × 7?','54','56','63','64','B','8 × 7 = 56','MEDIUM',true,NOW()),
  (3,'NUMERACY','If 3 of 8 equal parts are shaded, what fraction is shaded?','1/3','3/8','5/8','3/5','B','3 out of 8 parts = 3/8','MEDIUM',true,NOW()),
  (3,'NUMERACY','What is the perimeter of a square with side 5 cm?','10 cm','15 cm','20 cm','25 cm','C','4 × 5 = 20 cm','MEDIUM',true,NOW()),
  (3,'NUMERACY','Round 347 to the nearest hundred.','300','340','350','400','A','347 is closer to 300 than 400','MEDIUM',true,NOW()),
  (3,'NUMERACY','What is 5/10 as a decimal?','0.05','0.5','5.0','50.0','B','5 ÷ 10 = 0.5','MEDIUM',true,NOW()),
  (3,'NUMERACY','A bag has 3 red and 5 blue balls. P(red) = ?','3/5','5/8','3/8','1/3','C','3 red out of 8 total = 3/8','HARD',true,NOW()),
  (3,'NUMERACY','What is the value of the 4 in 3,421?','4','40','400','4000','C','The 4 is in the hundreds place','HARD',true,NOW()),
  (3,'READING','What does ''enormous'' mean?','Very small','Very large','Very fast','Very slow','B','Enormous means very large','EASY',true,NOW()),
  (3,'READING','Which word is a noun?','Run','Happy','Quickly','Dog','D','Dog is a person, place, or thing','EASY',true,NOW()),
  (3,'READING','Which sentence uses correct punctuation?','the dog ran.','The dog ran','The dog ran.','the Dog ran.','C','Sentences start with a capital and end with punctuation','EASY',true,NOW()),
  (3,'READING','What is the opposite of ''ancient''?','Old','Modern','Large','Tiny','B','Modern is the antonym of ancient','MEDIUM',true,NOW()),
  (3,'READING','She __ to school every day.','walking','walk','walks','walked','C','Third person singular uses walks','MEDIUM',true,NOW()),
  (5,'NUMERACY','What is 15% of 200?','20','25','30','35','C','15 ÷ 100 × 200 = 30','EASY',true,NOW()),
  (5,'NUMERACY','Solve: 3x + 7 = 22','x=3','x=4','x=5','x=6','C','3x = 15 → x = 5','MEDIUM',true,NOW()),
  (5,'NUMERACY','Area of a rectangle 8 m × 6 m?','28 m²','48 m²','56 m²','64 m²','B','8 × 6 = 48 m²','EASY',true,NOW()),
  (5,'NUMERACY','What is 2³?','6','8','9','16','B','2 × 2 × 2 = 8','MEDIUM',true,NOW()),
  (5,'NUMERACY','Prime factorisation of 36?','2² × 3²','2 × 3³','4 × 9','6²','A','36 = 4 × 9 = 2² × 3²','HARD',true,NOW()),
  (5,'NUMERACY','A train travels 240 km in 3 hours. Speed?','60 km/h','70 km/h','80 km/h','90 km/h','C','240 ÷ 3 = 80 km/h','MEDIUM',true,NOW()),
  (5,'NUMERACY','What is 7/8 − 3/8?','1/2','4/8','3/8','Both A and B','D','7/8 − 3/8 = 4/8 = 1/2','EASY',true,NOW()),
  (5,'NUMERACY','Convert 2.75 to a mixed number.','2 3/4','2 7/5','27/5','2 7/10','A','0.75 = 3/4 so 2.75 = 2 3/4','MEDIUM',true,NOW()),
  (5,'NUMERACY','LCM of 4 and 6?','6','8','12','24','C','Multiples of 4: 4,8,12 — Multiples of 6: 6,12 — LCM=12','HARD',true,NOW()),
  (5,'NUMERACY','Rolling a die: P(even) = ?','1/6','1/3','1/2','2/3','C','Even: 2,4,6 → 3/6 = 1/2','MEDIUM',true,NOW()),
  (5,'READING','What does ''persevere'' mean?','Give up','Continue despite difficulty','Work quickly','Start again','B','Persevere means keep going despite difficulty','MEDIUM',true,NOW()),
  (5,'READING','Identify the figure: ''The classroom was a zoo.''','Simile','Metaphor','Personification','Alliteration','B','A metaphor compares without like/as','MEDIUM',true,NOW()),
  (5,'READING','Which is alliteration?','The sun rose slowly','Peter Piper picked peppers','She sells seashells','Both B and C','D','Alliteration repeats initial consonant sounds','MEDIUM',true,NOW()),
  (5,'READING','What is the purpose of an essay conclusion?','Introduce the topic','Provide evidence','Summarise and restate the main argument','Add new ideas','C','A conclusion wraps up and restates the argument','MEDIUM',true,NOW()),
  (5,'READING','Which is passive voice?','The cat chased the mouse','The mouse was chased by the cat','The cat runs fast','Cats are fast','B','Passive: subject receives the action','HARD',true,NOW())
ON CONFLICT DO NOTHING;
"

echo ""
echo "=== Seed Complete ==="
echo "  Subscription plans : FREE, STANDARD, PREMIUM, FAMILY"
echo "  Admin              : admin@naplanprep.com.au / Admin123!"
echo "  Test student 1     : student1@test.com / Admin123!"
echo "  Test student 2     : student2@test.com / Admin123!"
echo "  Questions          : 30 (Year 3 & 5, Numeracy & Reading)"
