BEGIN;

-- ================================================================
-- V54 — Year 3 Numeracy FREE Exam 01
-- Task ID: Y3_NUM_FREE_EXAM01
-- 8-node adaptive pool | 12 questions per testlet | 96 total
-- Student path: 3 testlets (36 questions)
-- Nodes: A → (B | D | B_late) → (C | E | C_early | F)
-- ================================================================

INSERT INTO exams (id, title, description, domain, year_level, package_type, time_limit_seconds, status)
VALUES (
    'a0000054-0000-4000-a000-000000000001',
    'Year 3 Numeracy Practice — Exam 1',
    'Adaptive numeracy practice exam for Year 3. Covers Number and Algebra, Measurement and Geometry, and Statistics and Probability. Three testlets are delivered per student based on performance.',
    'NUMERACY', 3, 'FREE', 2700, 'PUBLISHED'
);

-- ----------------------------------------------------------------
-- SECTION
-- ----------------------------------------------------------------
INSERT INTO exam_sections (id, exam_id, title, section_order, calculator_allowed, navigation_locked, domain, instructions)
VALUES (
    'a0000054-0001-4000-a000-000000000001',
    'a0000054-0000-4000-a000-000000000001',
    'Numeracy',
    1, FALSE, FALSE, 'NUMERACY',
    'Read each question carefully. Choose the best answer. You may use working-out space on your paper. No calculator is allowed.'
);

-- ----------------------------------------------------------------
-- TESTLETS  (8 nodes)
-- testlet_order reflects branching evaluation sequence, not delivery order
-- ----------------------------------------------------------------
INSERT INTO testlets (id, section_id, title, testlet_order, is_branching_node, navigation_locked, calculator_allowed, instructions)
VALUES
    ('a0000054-0002-4000-a000-000000000001', 'a0000054-0001-4000-a000-000000000001', 'Node A — Starting Testlet',   1, TRUE,  FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000002', 'a0000054-0001-4000-a000-000000000001', 'Node B — Higher Path',        2, TRUE,  FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000003', 'a0000054-0001-4000-a000-000000000001', 'Node B Late — Support Path',  3, TRUE,  FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000004', 'a0000054-0001-4000-a000-000000000001', 'Node C — Challenge Path',     4, FALSE, FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000005', 'a0000054-0001-4000-a000-000000000001', 'Node C Early — Bridge Path',  5, FALSE, FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000006', 'a0000054-0001-4000-a000-000000000001', 'Node D — Standard Path',      6, TRUE,  FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000007', 'a0000054-0001-4000-a000-000000000001', 'Node E — Mid Path',           7, FALSE, FALSE, FALSE, NULL),
    ('a0000054-0002-4000-a000-000000000008', 'a0000054-0001-4000-a000-000000000001', 'Node F — Foundation Path',    8, FALSE, FALSE, FALSE, NULL);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE A  (12 questions, bands 3–5, entry level)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4001-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 45 + 23?',
    '[{"label":"A","text":"62"},{"label":"B","text":"68"},{"label":"C","text":"72"},{"label":"D","text":"78"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '45 + 23: add the ones first (5 + 3 = 8), then the tens (40 + 20 = 60). Total = 68.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'In the number 256, which digit is in the tens place?',
    '[{"label":"A","text":"2"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"25"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'In 256: 2 is in the hundreds place, 5 is in the tens place, and 6 is in the ones place. The answer is 5.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is the next number in the pattern: 10, 20, 30, 40, ___?',
    '[{"label":"A","text":"45"},{"label":"B","text":"50"},{"label":"C","text":"60"},{"label":"D","text":"100"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern increases by 10 each time. After 40, the next number is 40 + 10 = 50.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 2 × 8?',
    '[{"label":"A","text":"10"},{"label":"B","text":"12"},{"label":"C","text":"16"},{"label":"D","text":"18"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2 × 8 means 2 groups of 8, or 8 + 8 = 16.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Sam has 12 biscuits and shares them equally between 2 friends. How many biscuits does each friend get?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Sharing 12 equally between 2 means dividing by 2: 12 ÷ 2 = 6. Each friend gets 6 biscuits.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Lucy''s swimming lesson starts at 4 o''clock and lasts 1 hour. What time does her lesson finish?',
    '[{"label":"A","text":"3 o''clock"},{"label":"B","text":"4 o''clock"},{"label":"C","text":"5 o''clock"},{"label":"D","text":"6 o''clock"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The lesson starts at 4 o''clock and lasts 1 hour. 4 o''clock + 1 hour = 5 o''clock.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4001-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which shape has exactly 4 equal sides and 4 equal angles?',
    '[{"label":"A","text":"Rectangle"},{"label":"B","text":"Triangle"},{"label":"C","text":"Square"},{"label":"D","text":"Pentagon"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A square has 4 equal sides and 4 right angles (90° each). A rectangle has 4 right angles but its sides are not all equal.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4001-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'A book costs $1.50 and a pen costs $0.75. How much do they cost altogether?',
    '[{"label":"A","text":"$1.75"},{"label":"B","text":"$2.00"},{"label":"C","text":"$2.25"},{"label":"D","text":"$2.75"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '$1.50 + $0.75: add the dollars (1 + 0 = $1) then the cents (50 + 75 = 125 cents = $1.25). Total = $1 + $1.25 = $2.25.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 80 − 37?',
    '[{"label":"A","text":"43"},{"label":"B","text":"47"},{"label":"C","text":"53"},{"label":"D","text":"57"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '80 − 37: 80 − 30 = 50, then 50 − 7 = 43.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'A class voted for their favourite sport. Football: 9 votes, Swimming: 6 votes, Cricket: 4 votes. How many more students voted for football than cricket?',
    '[{"label":"A","text":"3"},{"label":"B","text":"4"},{"label":"C","text":"5"},{"label":"D","text":"13"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Football: 9 votes, Cricket: 4 votes. Difference = 9 − 4 = 5. Five more students voted for football.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4001-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 5 × 7?',
    '[{"label":"A","text":"30"},{"label":"B","text":"35"},{"label":"C","text":"40"},{"label":"D","text":"45"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '5 × 7 means 5 groups of 7, or 7 + 7 + 7 + 7 + 7 = 35. You can also count by 5s seven times: 5, 10, 15, 20, 25, 30, 35.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4001-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A ribbon is 1 metre long. Jake cuts off 35 centimetres. How many centimetres of ribbon are left?',
    '[{"label":"A","text":"55 cm"},{"label":"B","text":"60 cm"},{"label":"C","text":"65 cm"},{"label":"D","text":"75 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 metre = 100 centimetres. 100 − 35 = 65. There are 65 centimetres of ribbon left.',
    'APPLICATION', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE B  (12 questions, bands 5–7, higher path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4002-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 347 + 285?',
    '[{"label":"A","text":"522"},{"label":"B","text":"532"},{"label":"C","text":"622"},{"label":"D","text":"632"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '347 + 285: ones: 7 + 5 = 12, write 2 carry 1. Tens: 4 + 8 + 1 = 13, write 3 carry 1. Hundreds: 3 + 2 + 1 = 6. Answer: 632.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'There are 8 bags of oranges with 3 oranges in each bag. How many oranges are there altogether?',
    '[{"label":"A","text":"11"},{"label":"B","text":"16"},{"label":"C","text":"24"},{"label":"D","text":"32"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 bags × 3 oranges = 8 × 3 = 24 oranges altogether.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is one quarter of 20?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"8"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'One quarter means dividing by 4. 20 ÷ 4 = 5. One quarter of 20 is 5.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 48 ÷ 6?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"9"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '48 ÷ 6: think "6 times what equals 48?" 6 × 8 = 48. The answer is 8.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A garden bed is 5 metres long and 3 metres wide. What is its area?',
    '[{"label":"A","text":"8 square metres"},{"label":"B","text":"15 square metres"},{"label":"C","text":"16 square metres"},{"label":"D","text":"20 square metres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Area of a rectangle = length × width = 5 × 3 = 15 square metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4002-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'It is 10:45 am. A movie starts in 25 minutes. What time does the movie start?',
    '[{"label":"A","text":"10:55 am"},{"label":"B","text":"11:00 am"},{"label":"C","text":"11:05 am"},{"label":"D","text":"11:10 am"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '10:45 + 25 minutes: 10:45 + 15 minutes = 11:00, then + 10 more minutes = 11:10 am.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4002-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '3D shapes', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'Which 3D shape has exactly 6 flat faces, all of them rectangles?',
    '[{"label":"A","text":"Pyramid"},{"label":"B","text":"Sphere"},{"label":"C","text":"Cylinder"},{"label":"D","text":"Rectangular prism"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    'A rectangular prism (also called a cuboid) has 6 rectangular faces. A pyramid has triangular faces. A sphere and cylinder have curved surfaces.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4002-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is the missing number in this pattern: 96, 88, 80, ___, 64?',
    '[{"label":"A","text":"70"},{"label":"B","text":"72"},{"label":"C","text":"74"},{"label":"D","text":"76"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern decreases by 8 each time. 80 − 8 = 72. Check: 72 − 8 = 64. ✓',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 405 − 178?',
    '[{"label":"A","text":"227"},{"label":"B","text":"237"},{"label":"C","text":"267"},{"label":"D","text":"277"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '405 − 178: ones: cannot take 8 from 5, borrow from tens (tens becomes 9, ones becomes 15). 15 − 8 = 7. Tens: 9 − 7 = 2. Hundreds: 4 − 1 = 3... wait recalculate: 405 − 178 = 227. Check: 178 + 227 = 405. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A bag has 3 red marbles, 2 blue marbles and 1 yellow marble. If you pick one without looking, which colour are you MOST LIKELY to pick?',
    '[{"label":"A","text":"Blue"},{"label":"B","text":"Red"},{"label":"C","text":"Yellow"},{"label":"D","text":"They are all equally likely"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'There are 6 marbles in total: 3 red, 2 blue, 1 yellow. Red has the most marbles, so it is most likely to be picked.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4002-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'Each box holds 10 crayons. Mr Park bought 14 boxes. How many crayons in total?',
    '[{"label":"A","text":"24"},{"label":"B","text":"104"},{"label":"C","text":"140"},{"label":"D","text":"1 400"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '14 boxes × 10 crayons = 14 × 10 = 140 crayons. Multiplying by 10 adds a zero to the end.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4002-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'What fraction is exactly halfway between 0 and 1/2 on a number line?',
    '[{"label":"A","text":"1/8"},{"label":"B","text":"1/4"},{"label":"C","text":"1/3"},{"label":"D","text":"2/3"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Halfway between 0 and 1/2: divide 1/2 by 2 = 1/4. On a number line, 1/4 sits exactly in the middle between 0 and 1/2.',
    'COMPREHENSION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE B_LATE  (12 questions, bands 2–4, support path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4003-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What number comes just after 49?',
    '[{"label":"A","text":"48"},{"label":"B","text":"50"},{"label":"C","text":"51"},{"label":"D","text":"59"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Counting up from 49, the very next number is 50.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 12 + 13?',
    '[{"label":"A","text":"23"},{"label":"B","text":"25"},{"label":"C","text":"27"},{"label":"D","text":"35"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '12 + 13: add the ones (2 + 3 = 5) then the tens (10 + 10 = 20). Total = 25.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many corners does a triangle have?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A triangle has 3 sides and 3 corners (vertices).',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4003-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 20 − 8?',
    '[{"label":"A","text":"10"},{"label":"B","text":"12"},{"label":"C","text":"14"},{"label":"D","text":"28"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '20 − 8 = 12. Check: 12 + 8 = 20. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Jake has 50 cents. He buys a sticker for 20 cents. How much money does he have left?',
    '[{"label":"A","text":"20 cents"},{"label":"B","text":"25 cents"},{"label":"C","text":"30 cents"},{"label":"D","text":"70 cents"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '50 cents − 20 cents = 30 cents left.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many minutes are in one hour?',
    '[{"label":"A","text":"30"},{"label":"B","text":"50"},{"label":"C","text":"60"},{"label":"D","text":"100"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'There are 60 minutes in one hour.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4003-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'A pizza is cut into 4 equal pieces. What fraction is one piece?',
    '[{"label":"A","text":"1/2"},{"label":"B","text":"1/3"},{"label":"C","text":"1/4"},{"label":"D","text":"1/8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The pizza is cut into 4 equal pieces. One piece out of 4 is written as 1/4 (one quarter).',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 2 × 5?',
    '[{"label":"A","text":"7"},{"label":"B","text":"8"},{"label":"C","text":"10"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2 × 5 = 5 + 5 = 10.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'A tally chart shows: Cats |||| Dogs ||| Birds |. How many dogs were counted?',
    '[{"label":"A","text":"1"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Dogs shows ||| which is 3 tally marks. Three dogs were counted.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4003-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which is the longest: 80 centimetres, 1 metre, 70 centimetres or 50 centimetres?',
    '[{"label":"A","text":"80 centimetres"},{"label":"B","text":"1 metre"},{"label":"C","text":"70 centimetres"},{"label":"D","text":"50 centimetres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 metre = 100 centimetres, which is longer than 80 cm, 70 cm or 50 cm. The answer is 1 metre.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4003-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'In the number 85, how many tens are there?',
    '[{"label":"A","text":"5"},{"label":"B","text":"8"},{"label":"C","text":"15"},{"label":"D","text":"85"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'In 85, the digit 8 is in the tens place. There are 8 tens.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4003-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is the next number in the pattern: 2, 4, 6, 8, ___?',
    '[{"label":"A","text":"9"},{"label":"B","text":"10"},{"label":"C","text":"12"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern counts by 2s. After 8, the next even number is 10.',
    'RECALL', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE C  (12 questions, bands 7–9, challenge path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4004-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'What is 26 × 4?',
    '[{"label":"A","text":"84"},{"label":"B","text":"100"},{"label":"C","text":"104"},{"label":"D","text":"108"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '26 × 4: split into (20 × 4) + (6 × 4) = 80 + 24 = 104.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'Which fraction is the largest: 1/2, 3/4, 1/3 or 2/5?',
    '[{"label":"A","text":"1/2"},{"label":"B","text":"3/4"},{"label":"C","text":"1/3"},{"label":"D","text":"2/5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Convert to common denominators or compare with 1: 3/4 = 0.75, 1/2 = 0.5, 2/5 = 0.4, 1/3 ≈ 0.33. The largest is 3/4.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'What is 55 ÷ 5?',
    '[{"label":"A","text":"10"},{"label":"B","text":"11"},{"label":"C","text":"12"},{"label":"D","text":"13"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '55 ÷ 5: count by 5s to 55 — that takes 11 steps: 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55. The answer is 11.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A rectangle has a perimeter of 24 metres. Its length is 8 metres. What is its width?',
    '[{"label":"A","text":"3 metres"},{"label":"B","text":"4 metres"},{"label":"C","text":"6 metres"},{"label":"D","text":"16 metres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Perimeter = 2 × (length + width). 24 = 2 × (8 + width). 12 = 8 + width. Width = 4 metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4004-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'The pattern is: 3, 6, 12, 24, ___. What is the rule for this pattern?',
    '[{"label":"A","text":"Add 3"},{"label":"B","text":"Add 6"},{"label":"C","text":"Multiply by 2"},{"label":"D","text":"Multiply by 3"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3 × 2 = 6, 6 × 2 = 12, 12 × 2 = 24. Each term is multiplied by 2. The next number would be 48.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'Mrs Lin buys 3 notebooks at $4.25 each and pays with a $20 note. How much change does she receive?',
    '[{"label":"A","text":"$5.75"},{"label":"B","text":"$7.25"},{"label":"C","text":"$7.75"},{"label":"D","text":"$8.25"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 × $4.25 = $12.75. Change = $20.00 − $12.75 = $7.25.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'Five students measured the length of their pencils: 14 cm, 18 cm, 12 cm, 20 cm and 16 cm. What is the range of the measurements?',
    '[{"label":"A","text":"6 cm"},{"label":"B","text":"8 cm"},{"label":"C","text":"16 cm"},{"label":"D","text":"20 cm"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Range = largest value − smallest value = 20 − 12 = 8 cm.',
    'ANALYSIS', 'Statistics and Probability'
),
(
    'a0000054-0003-4004-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 9, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A school library has 15 shelves. Each shelf holds 24 books. How many books can the library hold altogether?',
    '[{"label":"A","text":"300"},{"label":"B","text":"320"},{"label":"C","text":"360"},{"label":"D","text":"380"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '15 × 24: split as (10 × 24) + (5 × 24) = 240 + 120 = 360 books.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'There are 36 marbles in a jar. Three quarters of them are blue. How many marbles are blue?',
    '[{"label":"A","text":"9"},{"label":"B","text":"18"},{"label":"C","text":"24"},{"label":"D","text":"27"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '3/4 of 36: first find 1/4 (36 ÷ 4 = 9), then multiply by 3 (9 × 3 = 27). So 27 marbles are blue.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A train journey takes 2 hours and 45 minutes. The train arrives at 4:20 pm. What time did the journey start?',
    '[{"label":"A","text":"1:35 pm"},{"label":"B","text":"1:45 pm"},{"label":"C","text":"2:05 pm"},{"label":"D","text":"2:35 pm"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '4:20 pm − 2 hours = 2:20 pm. Then 2:20 pm − 45 minutes = 1:35 pm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4004-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 9, 'HARD', 1, 'FREE', 'PUBLISHED',
    'In the number 4 782, which digit is in the hundreds place?',
    '[{"label":"A","text":"4"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"2"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'In 4 782: 4 = thousands, 7 = hundreds, 8 = tens, 2 = ones. The hundreds digit is 7.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4004-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 8, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A spinner has 8 equal sections: 3 green, 2 red, 2 blue and 1 yellow. What is the probability of spinning green?',
    '[{"label":"A","text":"1/8"},{"label":"B","text":"1/4"},{"label":"C","text":"3/8"},{"label":"D","text":"1/2"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3 green sections out of 8 total sections = 3/8.',
    'COMPREHENSION', 'Statistics and Probability'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE C_EARLY  (12 questions, bands 3–6, bridge path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4005-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 31 + 47?',
    '[{"label":"A","text":"68"},{"label":"B","text":"74"},{"label":"C","text":"78"},{"label":"D","text":"88"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '31 + 47: ones: 1 + 7 = 8. Tens: 30 + 40 = 70. Total = 78.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 64 − 29?',
    '[{"label":"A","text":"25"},{"label":"B","text":"35"},{"label":"C","text":"45"},{"label":"D","text":"55"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '64 − 29: 64 − 30 = 34, then add 1 back (because we subtracted one too many) = 35.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 5 × 9?',
    '[{"label":"A","text":"40"},{"label":"B","text":"45"},{"label":"C","text":"50"},{"label":"D","text":"54"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '5 × 9 = 45. Count by 5s nine times: 5, 10, 15, 20, 25, 30, 35, 40, 45.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which is a bigger piece: 1/2 or 1/4 of the same pizza?',
    '[{"label":"A","text":"1/4, because the number 4 is bigger"},{"label":"B","text":"They are the same size"},{"label":"C","text":"1/2, because each piece is larger"},{"label":"D","text":"It depends on the size of the pizza"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'When cutting the same pizza, 1/2 means cutting into 2 pieces. 1/4 means cutting into 4 pieces. Fewer cuts = bigger pieces. 1/2 is bigger than 1/4.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Theo has 2 coins worth $2 each and 3 coins worth 50 cents each. How much money does he have?',
    '[{"label":"A","text":"$5.00"},{"label":"B","text":"$5.50"},{"label":"C","text":"$6.00"},{"label":"D","text":"$7.50"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '2 × $2 = $4.00. 3 × $0.50 = $1.50. Total = $4.00 + $1.50 = $5.50.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'School ends at 3:15 pm. Kai walks home and arrives at 3:45 pm. How long did the walk take?',
    '[{"label":"A","text":"15 minutes"},{"label":"B","text":"30 minutes"},{"label":"C","text":"45 minutes"},{"label":"D","text":"1 hour"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'From 3:15 pm to 3:45 pm is 30 minutes.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4005-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which shape has 6 sides and 6 angles?',
    '[{"label":"A","text":"Pentagon"},{"label":"B","text":"Hexagon"},{"label":"C","text":"Octagon"},{"label":"D","text":"Heptagon"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A hexagon has 6 sides and 6 angles. (Penta = 5, Hexa = 6, Hepta = 7, Octa = 8.)',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4005-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 10 × 12?',
    '[{"label":"A","text":"110"},{"label":"B","text":"112"},{"label":"C","text":"120"},{"label":"D","text":"122"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '10 × 12 = 120. Multiplying by 10 adds a zero: 12 becomes 120.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'In a picture graph, each picture represents 5 students. If there are 7 pictures in the Reading row, how many students chose reading?',
    '[{"label":"A","text":"7"},{"label":"B","text":"12"},{"label":"C","text":"35"},{"label":"D","text":"50"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '7 pictures × 5 students each = 7 × 5 = 35 students chose reading.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4005-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is the value of the 3 in 3 521?',
    '[{"label":"A","text":"3"},{"label":"B","text":"30"},{"label":"C","text":"300"},{"label":"D","text":"3 000"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    'In 3 521: 3 is in the thousands place. Its value is 3 × 1 000 = 3 000.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4005-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A fence needs 4 pieces of wood. Each piece is 65 centimetres long. What is the total length of wood needed?',
    '[{"label":"A","text":"200 cm"},{"label":"B","text":"240 cm"},{"label":"C","text":"260 cm"},{"label":"D","text":"270 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × 65 cm: split as (4 × 60) + (4 × 5) = 240 + 20 = 260 cm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4005-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — capacity', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A bottle holds 750 mL of juice. Priya drinks 285 mL. How much juice is left in the bottle?',
    '[{"label":"A","text":"365 mL"},{"label":"B","text":"415 mL"},{"label":"C","text":"465 mL"},{"label":"D","text":"515 mL"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '750 − 285: 750 − 300 = 450, then add back 15 (because 300 − 285 = 15). 450 + 15 = 465 mL.',
    'APPLICATION', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE D  (12 questions, bands 3–5, standard mid path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4006-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is the next number in the pattern: 15, 18, 21, ___?',
    '[{"label":"A","text":"22"},{"label":"B","text":"23"},{"label":"C","text":"24"},{"label":"D","text":"25"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The pattern adds 3 each time. 21 + 3 = 24.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 38 + 54?',
    '[{"label":"A","text":"82"},{"label":"B","text":"88"},{"label":"C","text":"92"},{"label":"D","text":"98"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '38 + 54: ones: 8 + 4 = 12, write 2 carry 1. Tens: 3 + 5 + 1 = 9. Answer: 92.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 2 × 9?',
    '[{"label":"A","text":"11"},{"label":"B","text":"16"},{"label":"C","text":"18"},{"label":"D","text":"22"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2 × 9 = 9 + 9 = 18.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 1/4 of 16?',
    '[{"label":"A","text":"2"},{"label":"B","text":"4"},{"label":"C","text":"8"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1/4 of 16 means dividing by 4: 16 ÷ 4 = 4.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — mass', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which is heavier: 1 kilogram or 850 grams?',
    '[{"label":"A","text":"850 grams, because the number is bigger"},{"label":"B","text":"They weigh the same"},{"label":"C","text":"1 kilogram, because 1 kg = 1 000 g"},{"label":"D","text":"It depends on what you are weighing"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 kilogram = 1 000 grams. 1 000 g > 850 g, so 1 kilogram is heavier.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4006-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'The rule is "multiply by 3". If the first term is 2, what is the third term?',
    '[{"label":"A","text":"6"},{"label":"B","text":"8"},{"label":"C","text":"9"},{"label":"D","text":"18"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    'First term: 2. Second term: 2 × 3 = 6. Third term: 6 × 3 = 18.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '3D shapes', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many flat faces does a cube have?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A cube has 6 square faces — top, bottom, front, back, left and right.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4006-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'A column graph shows books read last month: Ana 7, Ben 4, Cleo 9, Dan 6. How many books did Ana and Dan read together?',
    '[{"label":"A","text":"11"},{"label":"B","text":"13"},{"label":"C","text":"15"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Ana read 7 books and Dan read 6 books. 7 + 6 = 13 books together.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4006-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 72 − 28?',
    '[{"label":"A","text":"34"},{"label":"B","text":"44"},{"label":"C","text":"46"},{"label":"D","text":"54"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '72 − 28: 72 − 30 = 42, then add back 2 = 44.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many days are in 3 weeks?',
    '[{"label":"A","text":"18"},{"label":"B","text":"21"},{"label":"C","text":"24"},{"label":"D","text":"30"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 week = 7 days. 3 weeks = 3 × 7 = 21 days.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4006-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 3 × 7?',
    '[{"label":"A","text":"18"},{"label":"B","text":"21"},{"label":"C","text":"24"},{"label":"D","text":"27"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 × 7 = 7 + 7 + 7 = 21.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4006-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'Nadia wants to buy a book for $8.50 and a pencil case for $4.75. She has $15.00. How much change will she get?',
    '[{"label":"A","text":"$1.25"},{"label":"B","text":"$1.50"},{"label":"C","text":"$1.75"},{"label":"D","text":"$2.25"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Total cost: $8.50 + $4.75 = $13.25. Change: $15.00 − $13.25 = $1.75.',
    'APPLICATION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE E  (12 questions, bands 5–7, mid path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4007-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 42 ÷ 6?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"9"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '42 ÷ 6: think "6 times what equals 42?" 6 × 7 = 42. The answer is 7.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 4 × 8?',
    '[{"label":"A","text":"24"},{"label":"B","text":"28"},{"label":"C","text":"32"},{"label":"D","text":"36"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × 8 = 8 + 8 + 8 + 8 = 32.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'Which fraction is equivalent to 1/2 when the whole is divided into 8 equal parts?',
    '[{"label":"A","text":"2/8"},{"label":"B","text":"3/8"},{"label":"C","text":"4/8"},{"label":"D","text":"6/8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1/2 = 4/8 because 1 × 4 = 4 and 2 × 4 = 8. Both fractions name the same amount.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A rectangular playground is 20 metres long and 12 metres wide. What is its perimeter?',
    '[{"label":"A","text":"44 metres"},{"label":"B","text":"64 metres"},{"label":"C","text":"80 metres"},{"label":"D","text":"240 metres"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Perimeter = 2 × (length + width) = 2 × (20 + 12) = 2 × 32 = 64 metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4007-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'What is 624 − 358?',
    '[{"label":"A","text":"244"},{"label":"B","text":"256"},{"label":"C","text":"266"},{"label":"D","text":"276"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '624 − 358: ones: 14 − 8 = 6 (borrow). Tens: 11 − 5 = 6 (borrow). Hundreds: 5 − 3 = 2. Answer: 266. Check: 358 + 266 = 624. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — mass', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A bag of flour weighs 2 kilograms. How many grams is that?',
    '[{"label":"A","text":"200 grams"},{"label":"B","text":"1 000 grams"},{"label":"C","text":"2 000 grams"},{"label":"D","text":"20 000 grams"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 kilogram = 1 000 grams. 2 kilograms = 2 × 1 000 = 2 000 grams.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000054-0003-4007-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'Five cards are numbered 1, 2, 3, 4 and 5. One card is chosen at random. What is the probability of choosing a number greater than 3?',
    '[{"label":"A","text":"1/5"},{"label":"B","text":"2/5"},{"label":"C","text":"3/5"},{"label":"D","text":"4/5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Numbers greater than 3 are: 4 and 5 — that is 2 cards out of 5 total. Probability = 2/5.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000054-0003-4007-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'A jar has 300 jelly beans. 60 are red, 80 are green and the rest are yellow. How many jelly beans are yellow?',
    '[{"label":"A","text":"140"},{"label":"B","text":"150"},{"label":"C","text":"160"},{"label":"D","text":"170"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Red + green = 60 + 80 = 140. Yellow = 300 − 140 = 160.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 6, 'MEDIUM', 1, 'FREE', 'PUBLISHED',
    'Tom reads for 20 minutes each day from Monday to Friday. How many minutes does he read in total each week?',
    '[{"label":"A","text":"60 minutes"},{"label":"B","text":"80 minutes"},{"label":"C","text":"100 minutes"},{"label":"D","text":"120 minutes"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 days × 20 minutes = 100 minutes per week.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'A farmer plants 9 rows of corn with 11 corn plants in each row. How many corn plants are there altogether?',
    '[{"label":"A","text":"90"},{"label":"B","text":"99"},{"label":"C","text":"108"},{"label":"D","text":"110"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '9 × 11 = 9 × 10 + 9 × 1 = 90 + 9 = 99 corn plants.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'There are 24 coloured pencils. One third of them are red. How many are red?',
    '[{"label":"A","text":"3"},{"label":"B","text":"6"},{"label":"C","text":"8"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1/3 of 24: 24 ÷ 3 = 8. Eight pencils are red.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4007-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 7, 'HARD', 1, 'FREE', 'PUBLISHED',
    'What is the missing value in this pattern: 4, 9, 16, 25, ___?',
    '[{"label":"A","text":"30"},{"label":"B","text":"34"},{"label":"C","text":"36"},{"label":"D","text":"49"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The pattern is square numbers: 2²=4, 3²=9, 4²=16, 5²=25, 6²=36. The next term is 36.',
    'ANALYSIS', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- QUESTIONS — NODE F  (12 questions, bands 1–4, foundation path)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000054-0003-4008-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 1, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What number comes just before 17?',
    '[{"label":"A","text":"15"},{"label":"B","text":"16"},{"label":"C","text":"18"},{"label":"D","text":"19"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Counting backwards from 17: the number just before 17 is 16.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 7 + 8?',
    '[{"label":"A","text":"13"},{"label":"B","text":"14"},{"label":"C","text":"15"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '7 + 8 = 15. You can count on from 8: 9, 10, 11, 12, 13, 14, 15 (7 counts).',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What is 14 − 6?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"9"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '14 − 6 = 8. Check: 8 + 6 = 14. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which shape is completely round with no corners?',
    '[{"label":"A","text":"Square"},{"label":"B","text":"Triangle"},{"label":"C","text":"Rectangle"},{"label":"D","text":"Circle"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    'A circle is a completely round shape with no corners or straight sides.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4008-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Ordering numbers', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Which number is the smallest: 42, 24, 14 or 41?',
    '[{"label":"A","text":"42"},{"label":"B","text":"41"},{"label":"C","text":"24"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '14 is the smallest. Its tens digit (1) is less than the tens digits of 24, 41 and 42.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'What are the missing numbers: 2, 4, 6, ___, 10, ___?',
    '[{"label":"A","text":"7 and 11"},{"label":"B","text":"8 and 12"},{"label":"C","text":"8 and 11"},{"label":"D","text":"9 and 13"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern counts by 2s: 2, 4, 6, 8, 10, 12. The missing numbers are 8 and 12.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'FREE', 'PUBLISHED',
    'There are 5 red apples and 4 green apples in a bowl. How many apples are there altogether?',
    '[{"label":"A","text":"1"},{"label":"B","text":"5"},{"label":"C","text":"9"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 red apples + 4 green apples = 5 + 4 = 9 apples altogether.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many days are in one week?',
    '[{"label":"A","text":"5"},{"label":"B","text":"6"},{"label":"C","text":"7"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'There are 7 days in one week: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday and Sunday.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4008-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'How many sides does a rectangle have?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"5"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A rectangle has 4 sides.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000054-0003-4008-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Mia has 12 stickers. She gives 4 to her sister. How many stickers does Mia have left?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '12 − 4 = 8. Mia has 8 stickers left.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'FREE', 'PUBLISHED',
    'If there are 3 groups of 4 birds, how many birds are there altogether?',
    '[{"label":"A","text":"7"},{"label":"B","text":"10"},{"label":"C","text":"12"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3 groups of 4 = 3 × 4 = 12 birds.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000054-0003-4008-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'FREE', 'PUBLISHED',
    'Oscar has one $2 coin and two 50 cent coins. How much money does he have?',
    '[{"label":"A","text":"$2.50"},{"label":"B","text":"$3.00"},{"label":"C","text":"$3.50"},{"label":"D","text":"$4.00"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '$2.00 + $0.50 + $0.50 = $2.00 + $1.00 = $3.00.',
    'APPLICATION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- EXAM_QUESTIONS  (96 links — all 8 nodes × 12 questions)
-- ----------------------------------------------------------------
INSERT INTO exam_questions (exam_id, question_id, question_order, section_id, testlet_id) VALUES
-- Node A
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4001-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000001'),
-- Node B
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4002-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000002'),
-- Node B_late
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4003-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000003'),
-- Node C
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4004-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000004'),
-- Node C_early
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4005-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000005'),
-- Node D
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4006-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000006'),
-- Node E
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4007-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000007'),
-- Node F
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000001', 1,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000002', 2,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000003', 3,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000004', 4,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000005', 5,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000006', 6,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000007', 7,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000008', 8,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000009', 9,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000010',10,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000011',11,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008'),
('a0000054-0000-4000-a000-000000000001','a0000054-0003-4008-a000-000000000012',12,'a0000054-0001-4000-a000-000000000001','a0000054-0002-4000-a000-000000000008');

-- ----------------------------------------------------------------
-- TESTLET TRANSITIONS  (9 branching rules)
-- ----------------------------------------------------------------
-- A → B: high performers (>75%)
-- A → D: mid performers (40–75%)
-- A → B_late: low performers (<40%, ALWAYS fallback)
-- B → C: high performers on B (>67%)
-- B → E: others on B (ALWAYS fallback)
-- B_late → C_early: better B_late performers (>50%)
-- B_late → F: struggling (ALWAYS fallback)
-- D → E: high D performers (>67%)
-- D → F: others on D (ALWAYS fallback)
INSERT INTO testlet_transitions (id, exam_id, source_testlet, target_testlet, condition_type, condition_value, priority)
VALUES
(
    'a0000054-0004-4000-a000-000000000001',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000002',
    'SCORE_ABOVE', '{"threshold":0.75}'::jsonb, 20
),
(
    'a0000054-0004-4000-a000-000000000002',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000006',
    'SCORE_ABOVE', '{"threshold":0.40}'::jsonb, 10
),
(
    'a0000054-0004-4000-a000-000000000003',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000003',
    'ALWAYS', NULL, 0
),
(
    'a0000054-0004-4000-a000-000000000004',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000002',
    'a0000054-0002-4000-a000-000000000004',
    'SCORE_ABOVE', '{"threshold":0.67}'::jsonb, 10
),
(
    'a0000054-0004-4000-a000-000000000005',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000002',
    'a0000054-0002-4000-a000-000000000007',
    'ALWAYS', NULL, 0
),
(
    'a0000054-0004-4000-a000-000000000006',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000003',
    'a0000054-0002-4000-a000-000000000005',
    'SCORE_ABOVE', '{"threshold":0.50}'::jsonb, 10
),
(
    'a0000054-0004-4000-a000-000000000007',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000003',
    'a0000054-0002-4000-a000-000000000008',
    'ALWAYS', NULL, 0
),
(
    'a0000054-0004-4000-a000-000000000008',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000006',
    'a0000054-0002-4000-a000-000000000007',
    'SCORE_ABOVE', '{"threshold":0.67}'::jsonb, 10
),
(
    'a0000054-0004-4000-a000-000000000009',
    'a0000054-0000-4000-a000-000000000001',
    'a0000054-0002-4000-a000-000000000006',
    'a0000054-0002-4000-a000-000000000008',
    'ALWAYS', NULL, 0
);

COMMIT;
