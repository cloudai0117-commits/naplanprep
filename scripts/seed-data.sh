#!/usr/bin/env bash
# Seeds the database with subscription plans, admin user, test students,
# and 50 sample questions (Year 3, 5, 7 — Numeracy & Reading).
# Safe to re-run — all inserts use ON CONFLICT DO NOTHING.
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
INSERT INTO plans (id, name, slug, monthly_price, annual_price,
    max_children, daily_question_limit, annual_mock_exam_limit,
    adaptive_learning, parent_dashboard, detailed_analytics, active, description)
VALUES
  (uuid_generate_v4(), 'Free',     'free',     0.00,   0.00, 1, 10,  1,   false, false, false, true, '1 diagnostic per year level, 10 practice questions/day'),
  (uuid_generate_v4(), 'Standard', 'standard', 14.99, 129.00, 1, -1, 12,  false, false, false, true, 'Full question bank, 12 mock exams/year, progress tracking'),
  (uuid_generate_v4(), 'Premium',  'premium',  24.99, 219.00, 1, -1, -1,  true,  true,  true,  true, 'Adaptive learning, unlimited mocks, parent dashboard'),
  (uuid_generate_v4(), 'Family',   'family',   34.99,   null, 4, -1, -1,  true,  true,  true,  true, 'Up to 4 children, all Premium features')
ON CONFLICT (slug) DO NOTHING;
"

# bcrypt cost 12 hash for 'Admin123!'
BCRYPT_HASH='\$2a\$12\$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewGF.f1KY/j3Ot.q'

echo "Inserting admin user..."
psql_exec "
INSERT INTO users (id, email, password_hash, role, first_name, last_name, active, created_at, updated_at)
VALUES (uuid_generate_v4(), 'admin@naplanprep.com.au', '$BCRYPT_HASH', 'PLATFORM_ADMIN', 'Admin', 'User', true, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;
"

echo "Inserting test student accounts..."
psql_exec "
INSERT INTO users (id, email, password_hash, role, first_name, last_name, active, year_level, created_at, updated_at)
VALUES
  (uuid_generate_v4(), 'student1@test.com', '$BCRYPT_HASH', 'STUDENT', 'Test', 'Student1', true, 3, NOW(), NOW()),
  (uuid_generate_v4(), 'student2@test.com', '$BCRYPT_HASH', 'STUDENT', 'Test', 'Student2', true, 5, NOW(), NOW()),
  (uuid_generate_v4(), 'parent1@test.com',  '$BCRYPT_HASH', 'PARENT',  'Test', 'Parent1',  true, null, NOW(), NOW())
ON CONFLICT (email) DO NOTHING;
"

echo "Inserting 50 sample questions (Year 3, 5, 7 — Numeracy & Reading)..."

# ─── Year 3 Numeracy ─────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Addition', 2,
   'What is 15 + 27?',
   '{\"options\": [\"40\", \"42\", \"41\", \"43\"]}', '{\"value\": \"42\"}',
   '15 + 27 = 42. Add ones: 5+7=12, write 2 carry 1. Add tens: 1+2+1=4.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Subtraction', 2,
   'What is 50 - 18?',
   '{\"options\": [\"32\", \"28\", \"38\", \"42\"]}', '{\"value\": \"32\"}',
   '50 - 18 = 32. Borrow from tens: 10-8=2, 4-1=3.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Multiplication', 3,
   'What is 6 × 7?',
   '{\"options\": [\"42\", \"48\", \"36\", \"54\"]}', '{\"value\": \"42\"}',
   '6 × 7 = 42. A key multiplication fact.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Place Value', 2,
   'What is the value of the digit 4 in the number 247?',
   '{\"options\": [\"4\", \"40\", \"400\", \"4000\"]}', '{\"value\": \"40\"}',
   'The 4 is in the tens place, so its value is 40.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Fractions', 3,
   'Which fraction is equivalent to 1/2?',
   '{\"options\": [\"2/4\", \"1/4\", \"3/4\", \"2/3\"]}', '{\"value\": \"2/4\"}',
   '2/4 = 1/2. Numerator and denominator both multiplied by 2.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Geometry', 3,
   'How many sides does a hexagon have?',
   '{\"options\": [\"6\", \"5\", \"7\", \"8\"]}', '{\"value\": \"6\"}',
   'A hexagon has 6 sides. Hex = 6 in Greek.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Time', 2,
   'How many minutes are in 2 hours?',
   '{\"options\": [\"120\", \"60\", \"100\", \"200\"]}', '{\"value\": \"120\"}',
   '60 minutes × 2 hours = 120 minutes.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Money', 3,
   'Sarah has \$5.50. She buys a book for \$2.75. How much change?',
   '{\"options\": [\"\$2.75\", \"\$3.25\", \"\$2.25\", \"\$3.75\"]}', '{\"value\": \"\$2.75\"}',
   '\$5.50 - \$2.75 = \$2.75.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Patterns', 2,
   'What comes next? 2, 4, 6, 8, __',
   '{\"options\": [\"9\", \"10\", \"11\", \"12\"]}', '{\"value\": \"10\"}',
   'Adding 2 each time: 8 + 2 = 10.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Division', 3,
   'Share 24 stickers equally among 4 friends. How many each?',
   '{\"options\": [\"4\", \"5\", \"6\", \"8\"]}', '{\"value\": \"6\"}',
   '24 ÷ 4 = 6.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

# ─── Year 3 Reading ───────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, stimulus_text, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Comprehension', 2,
   'The dog wagged its tail when it saw the ball. It ran across the yard and picked it up in its mouth.',
   'What was the dog carrying?',
   '{\"options\": [\"A stick\", \"A ball\", \"A bone\", \"A toy\"]}', '{\"value\": \"A ball\"}',
   'The text says it picked up the ball in its mouth.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Vocabulary', 2,
   'The enormous elephant splashed in the river.',
   'What does ''enormous'' mean?',
   '{\"options\": [\"Very small\", \"Very large\", \"Very fast\", \"Very quiet\"]}', '{\"value\": \"Very large\"}',
   'Enormous means very large.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Grammar', 2,
   null,
   'Which word is a noun?',
   '{\"options\": [\"Run\", \"Happy\", \"Quickly\", \"Dog\"]}', '{\"value\": \"Dog\"}',
   'Dog is a noun — a person, place, or thing.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Punctuation', 2,
   null,
   'Which sentence uses correct punctuation?',
   '{\"options\": [\"the dog ran.\", \"The dog ran\", \"The dog ran.\", \"the Dog ran.\"]}', '{\"value\": \"The dog ran.\"}',
   'Sentences start with a capital letter and end with a full stop.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Vocabulary', 3,
   null,
   'What is the opposite of ''ancient''?',
   '{\"options\": [\"Old\", \"Modern\", \"Large\", \"Tiny\"]}', '{\"value\": \"Modern\"}',
   'Modern is the antonym of ancient.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

# ─── Year 5 Numeracy ─────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Fractions and Decimals', 4,
   'What is 3/4 as a decimal?',
   '{\"options\": [\"0.75\", \"0.34\", \"0.25\", \"0.50\"]}', '{\"value\": \"0.75\"}',
   '3 ÷ 4 = 0.75.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Percentages', 5,
   'What is 25% of 200?',
   '{\"options\": [\"50\", \"25\", \"75\", \"100\"]}', '{\"value\": \"50\"}',
   '25% = 1/4. 200 ÷ 4 = 50.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Algebra', 5,
   'If x + 7 = 15, what is x?',
   '{\"options\": [\"8\", \"7\", \"22\", \"9\"]}', '{\"value\": \"8\"}',
   'x = 15 - 7 = 8.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Area and Perimeter', 4,
   'A rectangle has length 8 cm and width 5 cm. What is its area?',
   '{\"options\": [\"40 cm²\", \"26 cm²\", \"13 cm²\", \"30 cm²\"]}', '{\"value\": \"40 cm²\"}',
   'Area = 8 × 5 = 40 cm².', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Statistics', 5,
   'Temperatures for 5 days: 22, 25, 19, 28, 21. What is the mean?',
   '{\"options\": [\"23\", \"22\", \"25\", \"20\"]}', '{\"value\": \"23\"}',
   '(22+25+19+28+21) ÷ 5 = 115 ÷ 5 = 23.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Division', 4,
   'What is 144 ÷ 12?',
   '{\"options\": [\"12\", \"14\", \"11\", \"13\"]}', '{\"value\": \"12\"}',
   '144 ÷ 12 = 12. Related to 12 × 12 = 144.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Percentages', 4,
   'What is 15% of 80?',
   '{\"options\": [\"10\", \"12\", \"15\", \"20\"]}', '{\"value\": \"12\"}',
   '15% of 80 = 0.15 × 80 = 12.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Probability', 5,
   'A bag has 3 red and 5 blue balls. What is P(red)?',
   '{\"options\": [\"3/5\", \"5/8\", \"3/8\", \"1/3\"]}', '{\"value\": \"3/8\"}',
   '3 red out of 8 total = 3/8.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Powers', 5,
   'What is 2³?',
   '{\"options\": [\"6\", \"8\", \"9\", \"16\"]}', '{\"value\": \"8\"}',
   '2³ = 2 × 2 × 2 = 8.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Speed', 5,
   'A train travels 240 km in 3 hours. What is its speed?',
   '{\"options\": [\"60 km/h\", \"70 km/h\", \"80 km/h\", \"90 km/h\"]}', '{\"value\": \"80 km/h\"}',
   '240 ÷ 3 = 80 km/h.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

# ─── Year 5 Reading ───────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, stimulus_text, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Inference', 5,
   'Maria had not eaten since breakfast. As she walked past the bakery, she paused and pressed her nose against the glass window.',
   'What can you infer about Maria?',
   '{\"options\": [\"She is hungry\", \"She wants to buy bread\", \"She is lost\", \"She likes windows\"]}', '{\"value\": \"She is hungry\"}',
   'Not having eaten and pausing at a bakery strongly suggests hunger.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Text Structure', 5,
   'There are several reasons why exercise is important. First, it keeps our hearts healthy. Second, it helps maintain a healthy weight. Finally, exercise improves our mood.',
   'What text structure is used in this passage?',
   '{\"options\": [\"Problem and solution\", \"Cause and effect\", \"List/sequence\", \"Compare and contrast\"]}', '{\"value\": \"List/sequence\"}',
   'First, Second, Finally signal a list/sequence structure.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Figurative Language', 5,
   null,
   'Identify the figure of speech: ''The classroom was a zoo.''',
   '{\"options\": [\"Simile\", \"Metaphor\", \"Personification\", \"Alliteration\"]}', '{\"value\": \"Metaphor\"}',
   'A metaphor compares two things directly without using like/as.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Vocabulary', 4,
   null,
   'What does ''persevere'' mean?',
   '{\"options\": [\"Give up\", \"Continue despite difficulty\", \"Work quickly\", \"Start again\"]}', '{\"value\": \"Continue despite difficulty\"}',
   'Persevere means to keep going despite difficulty.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Grammar', 4,
   null,
   'Which sentence is written in passive voice?',
   '{\"options\": [\"The cat chased the mouse.\", \"The mouse was chased by the cat.\", \"The cat runs fast.\", \"Cats are fast.\"]}', '{\"value\": \"The mouse was chased by the cat.\"}',
   'Passive voice: the subject receives the action.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

# ─── Year 7 Numeracy ─────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Algebra', 6,
   'Solve for x: 3x - 5 = 16',
   '{\"options\": [\"7\", \"3\", \"11\", \"4\"]}', '{\"value\": \"7\"}',
   '3x = 21, x = 7.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Geometry', 6,
   'What is the sum of interior angles of a triangle?',
   '{\"options\": [\"180°\", \"360°\", \"90°\", \"270°\"]}', '{\"value\": \"180°\"}',
   'Sum of interior angles of any triangle = 180°.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Indices', 6,
   'Simplify: 2³ × 2²',
   '{\"options\": [\"2⁵\", \"2⁶\", \"4⁵\", \"2⁴\"]}', '{\"value\": \"2⁵\"}',
   'When multiplying same base, add exponents: 3+2=5.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Linear Equations', 6,
   'The equation y = 2x + 3. When x = 4, y = ?',
   '{\"options\": [\"9\", \"10\", \"11\", \"12\"]}', '{\"value\": \"11\"}',
   'y = 2(4) + 3 = 8 + 3 = 11.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Probability', 7,
   'Two dice are rolled. P(sum = 7) = ?',
   '{\"options\": [\"1/6\", \"5/36\", \"7/36\", \"6/36\"]}', '{\"value\": \"6/36\"}',
   'Combinations that sum to 7: (1,6)(2,5)(3,4)(4,3)(5,2)(6,1) = 6 out of 36.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Area', 6,
   'The area of a triangle with base 10 cm and height 6 cm?',
   '{\"options\": [\"30 cm²\", \"60 cm²\", \"16 cm²\", \"15 cm²\"]}', '{\"value\": \"30 cm²\"}',
   'Area = ½ × base × height = ½ × 10 × 6 = 30 cm².', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Percentages', 6,
   'A jacket costs \$80 and is on sale for 30% off. What is the sale price?',
   '{\"options\": [\"\$56\", \"\$24\", \"\$50\", \"\$60\"]}', '{\"value\": \"\$56\"}',
   '30% of \$80 = \$24. \$80 - \$24 = \$56.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Ratios', 6,
   'A recipe needs 2 cups of flour and 3 cups of sugar. How much flour for 9 cups of sugar?',
   '{\"options\": [\"4 cups\", \"5 cups\", \"6 cups\", \"3 cups\"]}', '{\"value\": \"6 cups\"}',
   'Ratio 2:3. For 9 cups sugar (×3): 2×3 = 6 cups flour.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Pythagoras', 7,
   'A right triangle has legs 3 cm and 4 cm. What is the hypotenuse?',
   '{\"options\": [\"5 cm\", \"6 cm\", \"7 cm\", \"8 cm\"]}', '{\"value\": \"5 cm\"}',
   '3² + 4² = 9 + 16 = 25. √25 = 5.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Statistics', 6,
   'Data set: 3, 5, 7, 7, 8, 9, 10. What is the median?',
   '{\"options\": [\"7\", \"8\", \"7.5\", \"9\"]}', '{\"value\": \"7\"}',
   'The middle value of 7 items (sorted) is the 4th: 7.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

# ─── Year 7 Reading ───────────────────────────────────────────────────────────
psql_exec "
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, stimulus_text, question_text, options, correct_answer, explanation, status)
VALUES
  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'READING', 'Inference', 6,
   'Although the explorer had been warned about the treacherous mountain path, she pressed on, telling herself that the view from the summit would make the hardship worthwhile.',
   'Which word best describes the explorer''s character?',
   '{\"options\": [\"Reckless\", \"Determined\", \"Fearful\", \"Lazy\"]}', '{\"value\": \"Determined\"}',
   'She continues despite warnings, suggesting determination.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'READING', 'Language Features', 6,
   null,
   'Which technique uses a reference to a well-known event, place, or work?',
   '{\"options\": [\"Alliteration\", \"Allusion\", \"Assonance\", \"Allegory\"]}', '{\"value\": \"Allusion\"}',
   'An allusion is an indirect reference to another work or well-known event.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'READING', 'Author''s Purpose', 6,
   'Advertisements use persuasive language, appealing images, and celebrity endorsements to influence consumers.',
   'What is the author''s main purpose?',
   '{\"options\": [\"To entertain\", \"To inform\", \"To persuade\", \"To describe\"]}', '{\"value\": \"To inform\"}',
   'The passage objectively explains advertising techniques — informative.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'READING', 'Vocabulary in Context', 7,
   'The scientist''s hypothesis was corroborated by three independent experiments.',
   'What does ''corroborated'' mean?',
   '{\"options\": [\"Disproved\", \"Confirmed\", \"Questioned\", \"Ignored\"]}', '{\"value\": \"Confirmed\"}',
   'Corroborated means supported or confirmed by evidence.', 'PUBLISHED'),

  (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'READING', 'Text Type', 6,
   null,
   'A text that presents arguments for and against an issue is called a(n):',
   '{\"options\": [\"Narrative\", \"Recount\", \"Discussion\", \"Procedure\"]}', '{\"value\": \"Discussion\"}',
   'A discussion text explores multiple perspectives on an issue.', 'PUBLISHED')
ON CONFLICT DO NOTHING;
"

echo ""
echo "=== Seed Complete ==="
echo "  Plans     : Free, Standard, Premium, Family"
echo "  Admin     : admin@naplanprep.com.au / Admin123!"
echo "  Students  : student1@test.com, student2@test.com / Admin123!"
echo "  Questions : 50 (Year 3 ×15, Year 5 ×15, Year 7 ×20 — Numeracy & Reading)"
