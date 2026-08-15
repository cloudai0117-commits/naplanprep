BEGIN;

-- ================================================================
-- V55 — Year 3 Numeracy ADVANCED Exam 01
-- Task ID: Y3_NUM_ADVANCED_EXAM01
-- 8-node adaptive pool | 12 questions per testlet | 96 total
-- Student path: 3 testlets (36 questions)
-- ================================================================

INSERT INTO exams (id, title, description, domain, year_level, package_type, time_limit_seconds, status)
VALUES (
    'a0000055-0000-4000-a000-000000000001',
    'Year 3 Numeracy Advanced — Exam 1',
    'Adaptive numeracy practice exam for Year 3. Covers Number and Algebra, Measurement and Geometry, and Statistics and Probability with ADVANCED content coverage.',
    'NUMERACY', 3, 'ADVANCED', 2700, 'PUBLISHED'
);

INSERT INTO exam_sections (id, exam_id, title, section_order, calculator_allowed, navigation_locked, domain, instructions)
VALUES (
    'a0000055-0001-4000-a000-000000000001',
    'a0000055-0000-4000-a000-000000000001',
    'Numeracy',
    1, FALSE, FALSE, 'NUMERACY',
    'Read each question carefully. Choose the best answer. You may use working-out space. No calculator is allowed.'
);

INSERT INTO testlets (id, section_id, title, testlet_order, is_branching_node, navigation_locked, calculator_allowed, instructions)
VALUES
    ('a0000055-0002-4000-a000-000000000001', 'a0000055-0001-4000-a000-000000000001', 'Node A — Starting Testlet',   1, TRUE,  FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000002', 'a0000055-0001-4000-a000-000000000001', 'Node B — Higher Path',        2, TRUE,  FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000003', 'a0000055-0001-4000-a000-000000000001', 'Node B Late — Support Path',  3, TRUE,  FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000004', 'a0000055-0001-4000-a000-000000000001', 'Node C — Challenge Path',     4, FALSE, FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000005', 'a0000055-0001-4000-a000-000000000001', 'Node C Early — Bridge Path',  5, FALSE, FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000006', 'a0000055-0001-4000-a000-000000000001', 'Node D — Standard Path',      6, TRUE,  FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000007', 'a0000055-0001-4000-a000-000000000001', 'Node E — Mid Path',           7, FALSE, FALSE, FALSE, NULL),
    ('a0000055-0002-4000-a000-000000000008', 'a0000055-0001-4000-a000-000000000001', 'Node F — Foundation Path',    8, FALSE, FALSE, FALSE, NULL);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE A  (12 questions, bands 3–5)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4001-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 132 + 245?',
    '[{"label":"A","text":"367"},{"label":"B","text":"377"},{"label":"C","text":"387"},{"label":"D","text":"477"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '132 + 245: ones 2+5=7, tens 3+4=7, hundreds 1+2=3. Answer: 377.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 3 × 6?',
    '[{"label":"A","text":"9"},{"label":"B","text":"15"},{"label":"C","text":"18"},{"label":"D","text":"21"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3 × 6 = 6 + 6 + 6 = 18.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is half of 14?',
    '[{"label":"A","text":"5"},{"label":"B","text":"6"},{"label":"C","text":"7"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Half of 14 means dividing by 2: 14 ÷ 2 = 7.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'In the number 473, which digit is in the ones place?',
    '[{"label":"A","text":"4"},{"label":"B","text":"7"},{"label":"C","text":"3"},{"label":"D","text":"47"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'In 473: 4 is hundreds, 7 is tens, 3 is ones.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the next number in the pattern: 55, 50, 45, 40, ___?',
    '[{"label":"A","text":"30"},{"label":"B","text":"35"},{"label":"C","text":"38"},{"label":"D","text":"42"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern subtracts 5 each time. 40 − 5 = 35.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'It is 9:30 am. School assembly lasts 30 minutes. What time does assembly finish?',
    '[{"label":"A","text":"9:00 am"},{"label":"B","text":"9:30 am"},{"label":"C","text":"10:00 am"},{"label":"D","text":"10:30 am"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '9:30 am + 30 minutes = 10:00 am.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4001-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many sides does a pentagon have?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A pentagon has 5 sides. (Penta means five.)',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000055-0003-4001-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Bella has one $5 note, one $2 coin and one 20 cent coin. How much money does she have?',
    '[{"label":"A","text":"$7.00"},{"label":"B","text":"$7.20"},{"label":"C","text":"$7.25"},{"label":"D","text":"$7.50"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '$5.00 + $2.00 + $0.20 = $7.20.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 15 ÷ 3?',
    '[{"label":"A","text":"3"},{"label":"B","text":"4"},{"label":"C","text":"5"},{"label":"D","text":"6"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '15 ÷ 3: think "3 times what equals 15?" 3 × 5 = 15. The answer is 5.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4001-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — mass', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A watermelon weighs 4 kilograms and a bunch of bananas weighs 2 kilograms. What is the total mass?',
    '[{"label":"A","text":"2 kg"},{"label":"B","text":"4 kg"},{"label":"C","text":"6 kg"},{"label":"D","text":"8 kg"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 kg + 2 kg = 6 kg total.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4001-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A bar graph shows how many sandwiches were sold each day: Mon 8, Tue 12, Wed 6, Thu 10, Fri 14. On which day were the most sandwiches sold?',
    '[{"label":"A","text":"Tuesday"},{"label":"B","text":"Thursday"},{"label":"C","text":"Friday"},{"label":"D","text":"Monday"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Friday had the highest bar at 14 sandwiches — the most of any day.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000055-0003-4001-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 93 − 56?',
    '[{"label":"A","text":"27"},{"label":"B","text":"37"},{"label":"C","text":"43"},{"label":"D","text":"47"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '93 − 56: 93 − 60 = 33, then add back 4 (because 60 − 56 = 4). 33 + 4 = 37.',
    'RECALL', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE B  (12 questions, bands 5–7)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4002-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 6 × 9?',
    '[{"label":"A","text":"45"},{"label":"B","text":"54"},{"label":"C","text":"56"},{"label":"D","text":"63"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '6 × 9 = 54. Count by 6s nine times: 6, 12, 18, 24, 30, 36, 42, 48, 54.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 508 + 374?',
    '[{"label":"A","text":"872"},{"label":"B","text":"878"},{"label":"C","text":"882"},{"label":"D","text":"892"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '508 + 374: ones 8+4=12, write 2 carry 1. Tens: 0+7+1=8. Hundreds: 5+3=8. Answer: 882.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'There are 18 flowers. One third are daisies. How many daisies are there?',
    '[{"label":"A","text":"3"},{"label":"B","text":"6"},{"label":"C","text":"9"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1/3 of 18: 18 ÷ 3 = 6 daisies.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A rectangular swimming pool is 8 metres long and 4 metres wide. What is its area?',
    '[{"label":"A","text":"12 square metres"},{"label":"B","text":"24 square metres"},{"label":"C","text":"32 square metres"},{"label":"D","text":"48 square metres"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Area = length × width = 8 × 4 = 32 square metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4002-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 63 ÷ 7?',
    '[{"label":"A","text":"7"},{"label":"B","text":"8"},{"label":"C","text":"9"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '63 ÷ 7: think "7 times what equals 63?" 7 × 9 = 63. The answer is 9.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A cake goes into the oven at 2:15 pm and needs to bake for 45 minutes. What time should it come out?',
    '[{"label":"A","text":"2:45 pm"},{"label":"B","text":"3:00 pm"},{"label":"C","text":"3:05 pm"},{"label":"D","text":"3:15 pm"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '2:15 pm + 45 minutes: 2:15 + 45 = 3:00 pm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4002-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is the missing number in the pattern: 100, 91, 82, 73, ___?',
    '[{"label":"A","text":"60"},{"label":"B","text":"63"},{"label":"C","text":"64"},{"label":"D","text":"66"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The pattern subtracts 9 each time. 73 − 9 = 64.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 701 − 248?',
    '[{"label":"A","text":"443"},{"label":"B","text":"453"},{"label":"C","text":"463"},{"label":"D","text":"473"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '701 − 248: 701 − 250 = 451, then add back 2 = 453. Check: 248 + 453 = 701. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A square paddock has a perimeter of 28 metres. How long is each side?',
    '[{"label":"A","text":"4 metres"},{"label":"B","text":"7 metres"},{"label":"C","text":"9 metres"},{"label":"D","text":"14 metres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A square has 4 equal sides. Perimeter = 4 × side. 28 ÷ 4 = 7 metres per side.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4002-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A bag contains 10 balls: 4 are white, 3 are black and 3 are striped. What is the probability of picking a black ball?',
    '[{"label":"A","text":"1/10"},{"label":"B","text":"3/10"},{"label":"C","text":"4/10"},{"label":"D","text":"7/10"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 black balls out of 10 total. Probability = 3/10.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000055-0003-4002-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A packet of cards has 52 cards. A teacher buys 3 packets. How many cards are there altogether?',
    '[{"label":"A","text":"126"},{"label":"B","text":"146"},{"label":"C","text":"152"},{"label":"D","text":"156"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '3 × 52: (3 × 50) + (3 × 2) = 150 + 6 = 156 cards.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4002-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Which fraction is between 1/4 and 3/4 on a number line?',
    '[{"label":"A","text":"1/8"},{"label":"B","text":"3/8"},{"label":"C","text":"1/2"},{"label":"D","text":"7/8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1/2 = 0.5, which is between 1/4 (0.25) and 3/4 (0.75). Both 3/8 (0.375) and 1/2 are between them, but 1/2 is more commonly placed between these fractions as the midpoint.',
    'COMPREHENSION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE B_LATE  (12 questions, bands 2–4)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4003-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What number is 10 more than 36?',
    '[{"label":"A","text":"26"},{"label":"B","text":"37"},{"label":"C","text":"46"},{"label":"D","text":"136"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '10 more than 36: 36 + 10 = 46.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 24 + 31?',
    '[{"label":"A","text":"45"},{"label":"B","text":"53"},{"label":"C","text":"55"},{"label":"D","text":"65"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '24 + 31: ones 4+1=5, tens 20+30=50. Total = 55.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 2 × 6?',
    '[{"label":"A","text":"8"},{"label":"B","text":"10"},{"label":"C","text":"12"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2 × 6 = 6 + 6 = 12.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the value of the digit 6 in the number 62?',
    '[{"label":"A","text":"6"},{"label":"B","text":"60"},{"label":"C","text":"62"},{"label":"D","text":"600"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'In 62, the digit 6 is in the tens place. 6 tens = 60.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which is longer: 75 centimetres or 1 metre?',
    '[{"label":"A","text":"75 centimetres, because 75 is bigger than 1"},{"label":"B","text":"They are the same length"},{"label":"C","text":"1 metre, because 1 metre = 100 centimetres"},{"label":"D","text":"It depends what you measure"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 metre = 100 centimetres. 100 cm > 75 cm, so 1 metre is longer.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4003-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many months are in one year?',
    '[{"label":"A","text":"7"},{"label":"B","text":"10"},{"label":"C","text":"12"},{"label":"D","text":"52"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'There are 12 months in one year.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000055-0003-4003-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A chocolate bar is broken into 8 equal pieces. What fraction is 2 pieces?',
    '[{"label":"A","text":"2/4"},{"label":"B","text":"2/8"},{"label":"C","text":"8/2"},{"label":"D","text":"1/4"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '2 pieces out of 8 total pieces is written as 2/8 (two eighths).',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 47 − 19?',
    '[{"label":"A","text":"28"},{"label":"B","text":"32"},{"label":"C","text":"38"},{"label":"D","text":"66"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '47 − 19: 47 − 20 = 27, then add back 1 = 28.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A picture graph shows apples eaten by students. Each picture = 2 apples. Zara has 3 pictures. How many apples did Zara eat?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"5"},{"label":"D","text":"6"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '3 pictures × 2 apples each = 6 apples.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000055-0003-4003-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '3D shapes', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which 3D shape looks like a can of soup?',
    '[{"label":"A","text":"Cone"},{"label":"B","text":"Sphere"},{"label":"C","text":"Cylinder"},{"label":"D","text":"Pyramid"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A cylinder has two circular faces and a curved surface — just like a soup can.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000055-0003-4003-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What comes next in the pattern: 70, 60, 50, 40, ___?',
    '[{"label":"A","text":"30"},{"label":"B","text":"35"},{"label":"C","text":"41"},{"label":"D","text":"50"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    'The pattern counts down by 10. 40 − 10 = 30.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4003-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Ordering numbers', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which number is the greatest: 189, 198, 918 or 891?',
    '[{"label":"A","text":"189"},{"label":"B","text":"198"},{"label":"C","text":"891"},{"label":"D","text":"918"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '918 has a 9 in the hundreds place, which is greater than 8 (in 891). 918 is the greatest.',
    'COMPREHENSION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE C  (12 questions, bands 7–9)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4004-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 7 × 8?',
    '[{"label":"A","text":"48"},{"label":"B","text":"54"},{"label":"C","text":"56"},{"label":"D","text":"64"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '7 × 8 = 56. Count by 7s eight times: 7, 14, 21, 28, 35, 42, 49, 56.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 2/3 of 30?',
    '[{"label":"A","text":"10"},{"label":"B","text":"15"},{"label":"C","text":"20"},{"label":"D","text":"25"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2/3 of 30: first find 1/3 (30 ÷ 3 = 10), then multiply by 2 (10 × 2 = 20).',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 84 ÷ 7?',
    '[{"label":"A","text":"10"},{"label":"B","text":"11"},{"label":"C","text":"12"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '84 ÷ 7: 7 × 12 = 84. The answer is 12.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — volume', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A fish tank holds 60 litres. Rosa fills it using a 4-litre bucket. How many full buckets does she need?',
    '[{"label":"A","text":"12"},{"label":"B","text":"14"},{"label":"C","text":"15"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '60 ÷ 4 = 15 full buckets.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4004-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What are the next two numbers in the pattern: 1, 4, 9, 16, 25, ___, ___?',
    '[{"label":"A","text":"30 and 35"},{"label":"B","text":"34 and 43"},{"label":"C","text":"36 and 49"},{"label":"D","text":"40 and 55"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Square numbers: 1²=1, 2²=4, 3²=9, 4²=16, 5²=25, 6²=36, 7²=49.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Four friends each contributed $6.75 to buy a gift. How much money did they collect altogether?',
    '[{"label":"A","text":"$24.00"},{"label":"B","text":"$26.00"},{"label":"C","text":"$27.00"},{"label":"D","text":"$28.75"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × $6.75: (4 × $6) + (4 × $0.75) = $24.00 + $3.00 = $27.00.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A class tracked steps walked each day: Mon 4 250, Tue 3 800, Wed 5 100, Thu 4 600, Fri 3 950. What is the total number of steps for the week?',
    '[{"label":"A","text":"21 600"},{"label":"B","text":"21 700"},{"label":"C","text":"21 800"},{"label":"D","text":"22 000"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '4250 + 3800 = 8050; 8050 + 5100 = 13150; 13150 + 4600 = 17750; 17750 + 3950 = 21700.',
    'APPLICATION', 'Statistics and Probability'
),
(
    'a0000055-0003-4004-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A bookcase has 8 shelves. Each shelf holds 35 books. How many books can the bookcase hold in total?',
    '[{"label":"A","text":"240"},{"label":"B","text":"270"},{"label":"C","text":"280"},{"label":"D","text":"315"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 × 35: (8 × 30) + (8 × 5) = 240 + 40 = 280 books.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Which list shows fractions in order from smallest to largest?',
    '[{"label":"A","text":"3/4, 1/2, 1/4"},{"label":"B","text":"1/4, 1/2, 3/4"},{"label":"C","text":"1/2, 1/4, 3/4"},{"label":"D","text":"3/4, 1/4, 1/2"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1/4 = 0.25, 1/2 = 0.5, 3/4 = 0.75. Smallest to largest: 1/4, 1/2, 3/4.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A flight leaves at 7:40 am and arrives at 10:05 am. How long is the flight?',
    '[{"label":"A","text":"2 hours 15 minutes"},{"label":"B","text":"2 hours 25 minutes"},{"label":"C","text":"2 hours 35 minutes"},{"label":"D","text":"3 hours 5 minutes"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '7:40 to 10:05: from 7:40 to 10:40 = 3 hours, then subtract 35 minutes (10:40 − 35 min = 10:05). So 3h − 35min = 2h 25min.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4004-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is the value of the digit 7 in 7 392?',
    '[{"label":"A","text":"7"},{"label":"B","text":"700"},{"label":"C","text":"7 000"},{"label":"D","text":"70 000"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'In 7 392: 7 is in the thousands place. Its value is 7 × 1 000 = 7 000.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4004-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A deck of 20 cards is numbered 1–20. One card is picked at random. What is the probability of picking a multiple of 4?',
    '[{"label":"A","text":"1/20"},{"label":"B","text":"4/20"},{"label":"C","text":"5/20"},{"label":"D","text":"6/20"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Multiples of 4 between 1 and 20: 4, 8, 12, 16, 20 — that is 5 numbers. Probability = 5/20.',
    'ANALYSIS', 'Statistics and Probability'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE C_EARLY  (12 questions, bands 3–6)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4005-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 56 + 38?',
    '[{"label":"A","text":"84"},{"label":"B","text":"90"},{"label":"C","text":"94"},{"label":"D","text":"104"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '56 + 38: ones 6+8=14 (write 4 carry 1). Tens: 5+3+1=9. Answer: 94.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 4 × 7?',
    '[{"label":"A","text":"21"},{"label":"B","text":"24"},{"label":"C","text":"28"},{"label":"D","text":"32"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × 7 = 7 + 7 + 7 + 7 = 28.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 32 ÷ 8?',
    '[{"label":"A","text":"3"},{"label":"B","text":"4"},{"label":"C","text":"5"},{"label":"D","text":"6"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '32 ÷ 8: 8 × 4 = 32. The answer is 4.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What fraction of the alphabet are the letters A, E, I, O and U if the alphabet has 26 letters?',
    '[{"label":"A","text":"5/21"},{"label":"B","text":"5/26"},{"label":"C","text":"1/5"},{"label":"D","text":"26/5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '5 vowels out of 26 letters total = 5/26.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A toy costs $12.90. Lena pays with a $20 note. How much change does she get?',
    '[{"label":"A","text":"$6.90"},{"label":"B","text":"$7.00"},{"label":"C","text":"$7.10"},{"label":"D","text":"$8.00"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '$20.00 − $12.90 = $7.10 change.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'How many hours are in 2 days?',
    '[{"label":"A","text":"12"},{"label":"B","text":"24"},{"label":"C","text":"36"},{"label":"D","text":"48"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '1 day = 24 hours. 2 days = 2 × 24 = 48 hours.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4005-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A square tile has sides of 9 centimetres. What is the perimeter of the tile?',
    '[{"label":"A","text":"18 cm"},{"label":"B","text":"27 cm"},{"label":"C","text":"36 cm"},{"label":"D","text":"81 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Perimeter of a square = 4 × side = 4 × 9 = 36 cm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4005-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 273 + 459?',
    '[{"label":"A","text":"622"},{"label":"B","text":"632"},{"label":"C","text":"722"},{"label":"D","text":"732"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '273 + 459: ones 3+9=12 (write 2 carry 1). Tens: 7+5+1=13 (write 3 carry 1). Hundreds: 2+4+1=7. Answer: 732.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is the rule for the pattern 5, 10, 20, 40, 80?',
    '[{"label":"A","text":"Add 5"},{"label":"B","text":"Add 10"},{"label":"C","text":"Multiply by 2"},{"label":"D","text":"Multiply by 5"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 × 2 = 10, 10 × 2 = 20, 20 × 2 = 40, 40 × 2 = 80. The rule is multiply by 2.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 7 × 9?',
    '[{"label":"A","text":"54"},{"label":"B","text":"56"},{"label":"C","text":"63"},{"label":"D","text":"72"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '7 × 9 = 63. Count by 7s nine times: 7, 14, 21, 28, 35, 42, 49, 56, 63.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4005-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'Five students each did a standing long jump: 95 cm, 110 cm, 88 cm, 102 cm and 115 cm. What is the difference between the longest and shortest jump?',
    '[{"label":"A","text":"17 cm"},{"label":"B","text":"20 cm"},{"label":"C","text":"27 cm"},{"label":"D","text":"30 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Longest: 115 cm. Shortest: 88 cm. Difference = 115 − 88 = 27 cm.',
    'ANALYSIS', 'Statistics and Probability'
),
(
    'a0000055-0003-4005-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A rectangular table is 3 metres long and 2 metres wide. What is its area?',
    '[{"label":"A","text":"5 square metres"},{"label":"B","text":"6 square metres"},{"label":"C","text":"10 square metres"},{"label":"D","text":"12 square metres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Area = length × width = 3 × 2 = 6 square metres.',
    'APPLICATION', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE D  (12 questions, bands 3–5)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4006-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 59 + 34?',
    '[{"label":"A","text":"83"},{"label":"B","text":"93"},{"label":"C","text":"95"},{"label":"D","text":"103"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '59 + 34: ones 9+4=13 (write 3 carry 1). Tens: 5+3+1=9. Answer: 93.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 3 × 9?',
    '[{"label":"A","text":"21"},{"label":"B","text":"24"},{"label":"C","text":"27"},{"label":"D","text":"30"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3 × 9 = 9 + 9 + 9 = 27.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 1/4 of 28?',
    '[{"label":"A","text":"4"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1/4 of 28: 28 ÷ 4 = 7.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A garden path is made of 6 tiles, each 30 centimetres long. How long is the path in total?',
    '[{"label":"A","text":"36 cm"},{"label":"B","text":"150 cm"},{"label":"C","text":"180 cm"},{"label":"D","text":"210 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '6 tiles × 30 cm each = 6 × 30 = 180 cm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4006-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the next number in the pattern: 7, 14, 21, 28, ___?',
    '[{"label":"A","text":"33"},{"label":"B","text":"35"},{"label":"C","text":"36"},{"label":"D","text":"42"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern adds 7 each time (7 times tables). 28 + 7 = 35.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Emi has 4 coins worth $1 each and 2 coins worth 20 cents each. How much does she have?',
    '[{"label":"A","text":"$4.02"},{"label":"B","text":"$4.20"},{"label":"C","text":"$4.40"},{"label":"D","text":"$4.80"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × $1 = $4.00. 2 × $0.20 = $0.40. Total = $4.00 + $0.40 = $4.40.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — mass', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A bag of apples weighs 3 kilograms. How many grams is that?',
    '[{"label":"A","text":"300 g"},{"label":"B","text":"1 000 g"},{"label":"C","text":"3 000 g"},{"label":"D","text":"30 000 g"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 kg = 1 000 g. 3 kg = 3 × 1 000 = 3 000 g.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4006-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A class counted how many pets each student has: 0 pets: 8 students, 1 pet: 10 students, 2 pets: 5 students, 3 pets: 2 students. How many students are in the class?',
    '[{"label":"A","text":"20"},{"label":"B","text":"23"},{"label":"C","text":"25"},{"label":"D","text":"27"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 + 10 + 5 + 2 = 25 students in the class.',
    'APPLICATION', 'Statistics and Probability'
),
(
    'a0000055-0003-4006-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 145 − 78?',
    '[{"label":"A","text":"57"},{"label":"B","text":"67"},{"label":"C","text":"77"},{"label":"D","text":"87"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '145 − 78: 145 − 80 = 65, then add back 2 = 67.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — capacity', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A water pitcher holds 2 litres. How many 250 mL cups can you fill from a full pitcher?',
    '[{"label":"A","text":"4"},{"label":"B","text":"6"},{"label":"C","text":"8"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2 litres = 2 000 mL. 2 000 ÷ 250 = 8 cups.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4006-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 6 × 4?',
    '[{"label":"A","text":"18"},{"label":"B","text":"20"},{"label":"C","text":"24"},{"label":"D","text":"28"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '6 × 4 = 4 + 4 + 4 + 4 + 4 + 4 = 24.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4006-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A movie is 1 hour and 55 minutes long. It starts at 6:10 pm. What time does it end?',
    '[{"label":"A","text":"7:05 pm"},{"label":"B","text":"7:55 pm"},{"label":"C","text":"8:05 pm"},{"label":"D","text":"8:15 pm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '6:10 pm + 1 hour = 7:10 pm. 7:10 pm + 55 minutes = 8:05 pm.',
    'APPLICATION', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE E  (12 questions, bands 5–7)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4007-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 54 ÷ 9?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"7"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '54 ÷ 9: 9 × 6 = 54. The answer is 6.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 8 × 6?',
    '[{"label":"A","text":"42"},{"label":"B","text":"48"},{"label":"C","text":"54"},{"label":"D","text":"56"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '8 × 6 = 6 + 6 + 6 + 6 + 6 + 6 + 6 + 6 = 48.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is the simplest form of 4/8?',
    '[{"label":"A","text":"2/4"},{"label":"B","text":"1/2"},{"label":"C","text":"4/4"},{"label":"D","text":"8/4"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '4/8: divide both numerator and denominator by 4. 4÷4=1, 8÷4=2. Simplest form = 1/2.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A tiled floor has 7 rows of tiles with 9 tiles in each row. How many tiles are on the floor?',
    '[{"label":"A","text":"16"},{"label":"B","text":"54"},{"label":"C","text":"63"},{"label":"D","text":"72"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '7 rows × 9 tiles = 7 × 9 = 63 tiles.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4007-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 532 − 279?',
    '[{"label":"A","text":"243"},{"label":"B","text":"253"},{"label":"C","text":"263"},{"label":"D","text":"273"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '532 − 279: 532 − 280 = 252, then add back 1 = 253. Check: 279 + 253 = 532. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'You roll a standard 6-sided die. What is the probability of rolling a number greater than 4?',
    '[{"label":"A","text":"1/6"},{"label":"B","text":"2/6"},{"label":"C","text":"3/6"},{"label":"D","text":"4/6"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Numbers greater than 4 on a die: 5 and 6 — that is 2 faces. Probability = 2/6.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000055-0003-4007-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'The pattern is: 3, 9, 27, 81, ___. What is the next number?',
    '[{"label":"A","text":"162"},{"label":"B","text":"189"},{"label":"C","text":"243"},{"label":"D","text":"324"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Each number is multiplied by 3: 3×3=9, 9×3=27, 27×3=81, 81×3=243.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A triangle has sides of 12 cm, 15 cm and 18 cm. What is its perimeter?',
    '[{"label":"A","text":"40 cm"},{"label":"B","text":"43 cm"},{"label":"C","text":"45 cm"},{"label":"D","text":"50 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Perimeter of triangle = sum of all sides = 12 + 15 + 18 = 45 cm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000055-0003-4007-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A swimming carnival has 12 teams with 8 swimmers in each team. How many swimmers are competing?',
    '[{"label":"A","text":"80"},{"label":"B","text":"88"},{"label":"C","text":"96"},{"label":"D","text":"104"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '12 teams × 8 swimmers = 12 × 8 = 96 swimmers.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A baker made 40 muffins. She sold 3/4 of them. How many muffins were sold?',
    '[{"label":"A","text":"10"},{"label":"B","text":"20"},{"label":"C","text":"30"},{"label":"D","text":"35"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3/4 of 40: 1/4 = 40 ÷ 4 = 10. 3/4 = 3 × 10 = 30 muffins sold.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 3 hundreds + 7 tens + 4 ones written as a number?',
    '[{"label":"A","text":"347"},{"label":"B","text":"374"},{"label":"C","text":"437"},{"label":"D","text":"473"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 hundreds = 300, 7 tens = 70, 4 ones = 4. 300 + 70 + 4 = 374.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4007-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Sam saved $3.50 each week for 6 weeks. How much money has Sam saved?',
    '[{"label":"A","text":"$18.00"},{"label":"B","text":"$20.00"},{"label":"C","text":"$21.00"},{"label":"D","text":"$22.50"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '6 × $3.50: (6 × $3) + (6 × $0.50) = $18.00 + $3.00 = $21.00.',
    'APPLICATION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE F  (12 questions, bands 1–4)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000055-0003-4008-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What number is 1 more than 29?',
    '[{"label":"A","text":"28"},{"label":"B","text":"30"},{"label":"C","text":"31"},{"label":"D","text":"39"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 more than 29 is 30.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 9 + 6?',
    '[{"label":"A","text":"13"},{"label":"B","text":"14"},{"label":"C","text":"15"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '9 + 6 = 15. Count on 6 from 9: 10, 11, 12, 13, 14, 15.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 17 − 9?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"9"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '17 − 9 = 8. Check: 8 + 9 = 17. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 3 tens and 4 ones?',
    '[{"label":"A","text":"7"},{"label":"B","text":"34"},{"label":"C","text":"43"},{"label":"D","text":"304"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 tens = 30, 4 ones = 4. 30 + 4 = 34.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many corners does a square have?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"5"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A square has 4 corners (also called vertices).',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000055-0003-4008-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What are the missing numbers: 5, 10, 15, ___, 25, ___?',
    '[{"label":"A","text":"18 and 28"},{"label":"B","text":"20 and 30"},{"label":"C","text":"22 and 32"},{"label":"D","text":"20 and 35"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern counts by 5s. After 15: 20. After 25: 30.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'There are 8 birds on a fence and 7 more fly in. How many birds are there now?',
    '[{"label":"A","text":"1"},{"label":"B","text":"14"},{"label":"C","text":"15"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 birds + 7 birds = 15 birds on the fence.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'An orange is cut into 4 equal pieces. How many pieces make 1 whole orange?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 equal pieces make 1 whole orange. You need all 4 pieces.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'There are 30 students in a class. 14 are girls. How many are boys?',
    '[{"label":"A","text":"14"},{"label":"B","text":"16"},{"label":"C","text":"17"},{"label":"D","text":"44"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '30 − 14 = 16 boys in the class.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '3D shapes', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which shape has no flat faces at all?',
    '[{"label":"A","text":"Cube"},{"label":"B","text":"Pyramid"},{"label":"C","text":"Sphere"},{"label":"D","text":"Prism"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A sphere is completely round — it has no flat faces, no edges and no corners.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000055-0003-4008-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many legs do 4 dogs have altogether?',
    '[{"label":"A","text":"8"},{"label":"B","text":"12"},{"label":"C","text":"16"},{"label":"D","text":"20"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Each dog has 4 legs. 4 dogs × 4 legs = 16 legs.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000055-0003-4008-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many minutes are in half an hour?',
    '[{"label":"A","text":"15"},{"label":"B","text":"30"},{"label":"C","text":"45"},{"label":"D","text":"60"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'One hour = 60 minutes. Half of 60 = 30. There are 30 minutes in half an hour.',
    'RECALL', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- EXAM_QUESTIONS  (96 links)
-- ----------------------------------------------------------------
INSERT INTO exam_questions (exam_id, question_id, question_order, section_id, testlet_id) VALUES
-- Node A
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4001-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000001'),
-- Node B
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4002-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000002'),
-- Node B_late
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4003-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000003'),
-- Node C
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4004-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000004'),
-- Node C_early
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4005-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000005'),
-- Node D
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4006-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000006'),
-- Node E
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4007-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000007'),
-- Node F
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000001', 1,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000002', 2,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000003', 3,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000004', 4,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000005', 5,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000006', 6,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000007', 7,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000008', 8,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000009', 9,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000010',10,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000011',11,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008'),
('a0000055-0000-4000-a000-000000000001','a0000055-0003-4008-a000-000000000012',12,'a0000055-0001-4000-a000-000000000001','a0000055-0002-4000-a000-000000000008');

-- ----------------------------------------------------------------
-- TESTLET TRANSITIONS  (9 rules, same branching structure as V54)
-- ----------------------------------------------------------------
INSERT INTO testlet_transitions (id, exam_id, source_testlet, target_testlet, condition_type, condition_value, priority)
VALUES
(
    'a0000055-0004-4000-a000-000000000001',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000002',
    'SCORE_ABOVE', '{"threshold":0.75}'::jsonb, 20
),
(
    'a0000055-0004-4000-a000-000000000002',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000006',
    'SCORE_ABOVE', '{"threshold":0.40}'::jsonb, 10
),
(
    'a0000055-0004-4000-a000-000000000003',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000003',
    'ALWAYS', NULL, 0
),
(
    'a0000055-0004-4000-a000-000000000004',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000002',
    'a0000055-0002-4000-a000-000000000004',
    'SCORE_ABOVE', '{"threshold":0.67}'::jsonb, 10
),
(
    'a0000055-0004-4000-a000-000000000005',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000002',
    'a0000055-0002-4000-a000-000000000007',
    'ALWAYS', NULL, 0
),
(
    'a0000055-0004-4000-a000-000000000006',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000003',
    'a0000055-0002-4000-a000-000000000005',
    'SCORE_ABOVE', '{"threshold":0.50}'::jsonb, 10
),
(
    'a0000055-0004-4000-a000-000000000007',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000003',
    'a0000055-0002-4000-a000-000000000008',
    'ALWAYS', NULL, 0
),
(
    'a0000055-0004-4000-a000-000000000008',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000006',
    'a0000055-0002-4000-a000-000000000007',
    'SCORE_ABOVE', '{"threshold":0.67}'::jsonb, 10
),
(
    'a0000055-0004-4000-a000-000000000009',
    'a0000055-0000-4000-a000-000000000001',
    'a0000055-0002-4000-a000-000000000006',
    'a0000055-0002-4000-a000-000000000008',
    'ALWAYS', NULL, 0
);

COMMIT;
