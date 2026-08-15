BEGIN;

-- ================================================================
-- V56 — Year 3 Numeracy ADVANCED Exam 02
-- Task ID: Y3_NUM_ADVANCED_EXAM02
-- 8-node adaptive pool | 12 questions per testlet | 96 total
-- ================================================================

INSERT INTO exams (id, title, description, domain, year_level, package_type, time_limit_seconds, status)
VALUES (
    'a0000056-0000-4000-a000-000000000001',
    'Year 3 Numeracy Advanced — Exam 2',
    'Second adaptive numeracy practice exam for Year 3. Covers Number and Algebra, Measurement and Geometry, and Statistics and Probability.',
    'NUMERACY', 3, 'ADVANCED', 2700, 'PUBLISHED'
);

INSERT INTO exam_sections (id, exam_id, title, section_order, calculator_allowed, navigation_locked, domain, instructions)
VALUES (
    'a0000056-0001-4000-a000-000000000001',
    'a0000056-0000-4000-a000-000000000001',
    'Numeracy', 1, FALSE, FALSE, 'NUMERACY',
    'Read each question carefully. Choose the best answer. No calculator is allowed.'
);

INSERT INTO testlets (id, section_id, title, testlet_order, is_branching_node, navigation_locked, calculator_allowed, instructions)
VALUES
    ('a0000056-0002-4000-a000-000000000001', 'a0000056-0001-4000-a000-000000000001', 'Node A — Starting Testlet',   1, TRUE,  FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000002', 'a0000056-0001-4000-a000-000000000001', 'Node B — Higher Path',        2, TRUE,  FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000003', 'a0000056-0001-4000-a000-000000000001', 'Node B Late — Support Path',  3, TRUE,  FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000004', 'a0000056-0001-4000-a000-000000000001', 'Node C — Challenge Path',     4, FALSE, FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000005', 'a0000056-0001-4000-a000-000000000001', 'Node C Early — Bridge Path',  5, FALSE, FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000006', 'a0000056-0001-4000-a000-000000000001', 'Node D — Standard Path',      6, TRUE,  FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000007', 'a0000056-0001-4000-a000-000000000001', 'Node E — Mid Path',           7, FALSE, FALSE, FALSE, NULL),
    ('a0000056-0002-4000-a000-000000000008', 'a0000056-0001-4000-a000-000000000001', 'Node F — Foundation Path',    8, FALSE, FALSE, FALSE, NULL);

-- ----------------------------------------------------------------
-- NODE A  (bands 3–5)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4001-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 6 × 7?',
    '[{"label":"A","text":"42"},{"label":"B","text":"43"},{"label":"C","text":"47"},{"label":"D","text":"49"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '6 × 7 = 42. Count by 6s: 6, 12, 18, 24, 30, 36, 42.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What does the 4 represent in the number 549?',
    '[{"label":"A","text":"4"},{"label":"B","text":"40"},{"label":"C","text":"400"},{"label":"D","text":"4 000"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'In 549: 5 is hundreds, 4 is tens, 9 is ones. The 4 represents 4 tens = 40.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is half of 22?',
    '[{"label":"A","text":"10"},{"label":"B","text":"11"},{"label":"C","text":"12"},{"label":"D","text":"13"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Half of 22: 22 ÷ 2 = 11.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 67 + 28?',
    '[{"label":"A","text":"85"},{"label":"B","text":"90"},{"label":"C","text":"95"},{"label":"D","text":"105"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '67 + 28: ones 7+8=15 (write 5 carry 1). Tens: 6+2+1=9. Answer: 95.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the missing number: 36, 30, 24, ___, 12?',
    '[{"label":"A","text":"16"},{"label":"B","text":"18"},{"label":"C","text":"20"},{"label":"D","text":"22"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern subtracts 6 each time. 24 − 6 = 18. Check: 18 − 6 = 12. ✓',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A caterpillar crawls 45 centimetres and then crawls 38 centimetres more. How far has it travelled altogether?',
    '[{"label":"A","text":"73 cm"},{"label":"B","text":"83 cm"},{"label":"C","text":"85 cm"},{"label":"D","text":"93 cm"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '45 cm + 38 cm: 45 + 40 = 85, minus 2 = 83 cm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4001-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 36 ÷ 4?',
    '[{"label":"A","text":"7"},{"label":"B","text":"8"},{"label":"C","text":"9"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '36 ÷ 4: 4 × 9 = 36. The answer is 9.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A sandwich costs $4.60 and a drink costs $2.35. How much do they cost together?',
    '[{"label":"A","text":"$6.05"},{"label":"B","text":"$6.85"},{"label":"C","text":"$6.95"},{"label":"D","text":"$7.05"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '$4.60 + $2.35: dollars 4+2=6, cents 60+35=95. Total = $6.95.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4001-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Students were asked to name their favourite season: Summer 15, Autumn 9, Winter 6, Spring 10. How many students were asked altogether?',
    '[{"label":"A","text":"30"},{"label":"B","text":"36"},{"label":"C","text":"40"},{"label":"D","text":"46"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '15 + 9 + 6 + 10 = 40 students.',
    'APPLICATION', 'Statistics and Probability'
),
(
    'a0000056-0003-4001-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many days are in the month of June?',
    '[{"label":"A","text":"28"},{"label":"B","text":"29"},{"label":"C","text":"30"},{"label":"D","text":"31"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'June has 30 days. (Months with 30 days: April, June, September, November.)',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000056-0003-4001-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A shape has 8 equal sides and 8 equal angles. What is the shape called?',
    '[{"label":"A","text":"Hexagon"},{"label":"B","text":"Heptagon"},{"label":"C","text":"Octagon"},{"label":"D","text":"Nonagon"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A shape with 8 sides is called an octagon. (Octo = eight.)',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000056-0003-4001-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 84 − 47?',
    '[{"label":"A","text":"37"},{"label":"B","text":"43"},{"label":"C","text":"47"},{"label":"D","text":"57"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '84 − 47: 84 − 50 = 34, then add back 3 = 37.',
    'RECALL', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- NODE B  (bands 5–7)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4002-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 5 × 6?',
    '[{"label":"A","text":"24"},{"label":"B","text":"25"},{"label":"C","text":"30"},{"label":"D","text":"36"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 × 6 = 30. Count by 5s six times: 5, 10, 15, 20, 25, 30.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 463 + 278?',
    '[{"label":"A","text":"631"},{"label":"B","text":"641"},{"label":"C","text":"731"},{"label":"D","text":"741"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '463 + 278: ones 3+8=11 (write 1 carry 1). Tens: 6+7+1=14 (write 4 carry 1). Hundreds: 4+2+1=7. Answer: 741.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A swimming pool has 40 laps. Zoe has swum 3/4 of them. How many laps has Zoe swum?',
    '[{"label":"A","text":"10"},{"label":"B","text":"20"},{"label":"C","text":"25"},{"label":"D","text":"30"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '3/4 of 40: 1/4 = 10, then 3 × 10 = 30 laps.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A rectangular room is 6 metres long and 5 metres wide. What is the area of the floor?',
    '[{"label":"A","text":"11 square metres"},{"label":"B","text":"22 square metres"},{"label":"C","text":"30 square metres"},{"label":"D","text":"35 square metres"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Area = length × width = 6 × 5 = 30 square metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4002-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 72 ÷ 8?',
    '[{"label":"A","text":"7"},{"label":"B","text":"8"},{"label":"C","text":"9"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '72 ÷ 8: 8 × 9 = 72. The answer is 9.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What are the next two terms: 2, 6, 18, 54, ___?',
    '[{"label":"A","text":"108"},{"label":"B","text":"112"},{"label":"C","text":"162"},{"label":"D","text":"216"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Each term is multiplied by 3: 2×3=6, 6×3=18, 18×3=54, 54×3=162.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 603 − 357?',
    '[{"label":"A","text":"244"},{"label":"B","text":"246"},{"label":"C","text":"254"},{"label":"D","text":"256"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '603 − 357: 603 − 360 = 243, then add back 3 = 246. Check: 357 + 246 = 603. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A rectangular paddock has a length of 14 m and a perimeter of 44 m. What is the width?',
    '[{"label":"A","text":"6 m"},{"label":"B","text":"8 m"},{"label":"C","text":"10 m"},{"label":"D","text":"15 m"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Perimeter = 2 × (length + width). 44 = 2 × (14 + width). 22 = 14 + width. Width = 8 m.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4002-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A jar has 12 lollies: 5 are red, 4 are green and 3 are yellow. If you pick one without looking, which colour is LEAST likely?',
    '[{"label":"A","text":"Red"},{"label":"B","text":"Green"},{"label":"C","text":"Yellow"},{"label":"D","text":"They are equally likely"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Yellow has the fewest lollies (3 out of 12), so it is least likely to be picked.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000056-0003-4002-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A tray holds 24 cupcakes. A baker makes 5 trays. How many cupcakes in total?',
    '[{"label":"A","text":"100"},{"label":"B","text":"110"},{"label":"C","text":"120"},{"label":"D","text":"130"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 × 24: (5 × 20) + (5 × 4) = 100 + 20 = 120 cupcakes.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4002-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A sports match starts at 1:45 pm and finishes at 3:20 pm. How long does the match last?',
    '[{"label":"A","text":"1 hour 25 minutes"},{"label":"B","text":"1 hour 35 minutes"},{"label":"C","text":"1 hour 45 minutes"},{"label":"D","text":"2 hours 25 minutes"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1:45 pm to 3:20 pm: 1:45 to 3:45 = 2 hours, but 3:45 − 3:20 = 25 min too many. 2h − 25min = 1h 35min.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4002-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 1/2 + 1/4?',
    '[{"label":"A","text":"2/6"},{"label":"B","text":"2/8"},{"label":"C","text":"3/4"},{"label":"D","text":"1/8"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1/2 = 2/4. So 2/4 + 1/4 = 3/4.',
    'COMPREHENSION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- NODE B_LATE  (bands 2–4)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4003-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What number is 10 less than 53?',
    '[{"label":"A","text":"33"},{"label":"B","text":"43"},{"label":"C","text":"63"},{"label":"D","text":"73"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '10 less than 53: 53 − 10 = 43.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 16 + 23?',
    '[{"label":"A","text":"29"},{"label":"B","text":"37"},{"label":"C","text":"39"},{"label":"D","text":"49"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '16 + 23: ones 6+3=9, tens 10+20=30. Total = 39.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 5 × 4?',
    '[{"label":"A","text":"9"},{"label":"B","text":"16"},{"label":"C","text":"20"},{"label":"D","text":"25"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 × 4 = 4 + 4 + 4 + 4 + 4 = 20.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What number is the same as 7 tens and 3 ones?',
    '[{"label":"A","text":"37"},{"label":"B","text":"73"},{"label":"C","text":"703"},{"label":"D","text":"730"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '7 tens = 70 and 3 ones = 3. 70 + 3 = 73.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 35 − 17?',
    '[{"label":"A","text":"8"},{"label":"B","text":"18"},{"label":"C","text":"22"},{"label":"D","text":"28"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '35 − 17: 35 − 20 = 15, then add back 3 = 18.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which picture shows 3/4 shaded?',
    '[{"label":"A","text":"A shape with 1 of 4 parts shaded"},{"label":"B","text":"A shape with 2 of 4 parts shaded"},{"label":"C","text":"A shape with 3 of 4 parts shaded"},{"label":"D","text":"A shape with 4 of 4 parts shaded"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3/4 means 3 out of 4 equal parts are shaded.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What time is shown when the big hand points to 12 and the small hand points to 8?',
    '[{"label":"A","text":"12:08"},{"label":"B","text":"8:12"},{"label":"C","text":"8:00"},{"label":"D","text":"12:00"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'When the big hand (minute hand) points to 12, it is on the hour. The small hand (hour hand) points to 8. The time is 8:00.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4003-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Amir has 3 coins worth 10 cents each. How much money does he have?',
    '[{"label":"A","text":"13 cents"},{"label":"B","text":"30 cents"},{"label":"C","text":"33 cents"},{"label":"D","text":"$1.00"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 × 10 cents = 30 cents.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'In a tally chart: Stars ||||| |||| (9 marks), Hearts ||||| (5 marks). How many more stars than hearts are there?',
    '[{"label":"A","text":"3"},{"label":"B","text":"4"},{"label":"C","text":"5"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '9 stars − 5 hearts = 4 more stars than hearts.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000056-0003-4003-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which shape always has all four sides the same length AND all four angles equal?',
    '[{"label":"A","text":"Rectangle"},{"label":"B","text":"Square"},{"label":"C","text":"Parallelogram"},{"label":"D","text":"Rhombus"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A square has all 4 sides equal AND all 4 right angles (90°). A rhombus has equal sides but not necessarily right angles.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4003-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What comes next in the pattern: 3, 6, 9, 12, ___?',
    '[{"label":"A","text":"14"},{"label":"B","text":"15"},{"label":"C","text":"16"},{"label":"D","text":"18"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern counts by 3s. 12 + 3 = 15.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4003-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A worm is 14 centimetres long. Another worm is 9 centimetres long. How much longer is the first worm?',
    '[{"label":"A","text":"4 cm"},{"label":"B","text":"5 cm"},{"label":"C","text":"6 cm"},{"label":"D","text":"23 cm"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '14 cm − 9 cm = 5 cm. The first worm is 5 cm longer.',
    'APPLICATION', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- NODE C  (bands 7–9)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4004-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 8 × 9?',
    '[{"label":"A","text":"63"},{"label":"B","text":"70"},{"label":"C","text":"72"},{"label":"D","text":"81"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 × 9 = 72. Count by 8s: 8, 16, 24, 32, 40, 48, 56, 64, 72.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A class of 32 students planted seeds. Three eighths of them grew sunflowers. How many students grew sunflowers?',
    '[{"label":"A","text":"8"},{"label":"B","text":"12"},{"label":"C","text":"16"},{"label":"D","text":"24"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3/8 of 32: 1/8 = 32 ÷ 8 = 4. Then 3 × 4 = 12 students.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 1 000 − 457?',
    '[{"label":"A","text":"453"},{"label":"B","text":"543"},{"label":"C","text":"553"},{"label":"D","text":"643"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 000 − 457: complement method — 457 + ___ = 1 000. 457 + 543 = 1 000. Answer: 543.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — volume', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'How many millilitres are in 3 and a half litres?',
    '[{"label":"A","text":"3 050 mL"},{"label":"B","text":"3 500 mL"},{"label":"C","text":"3 550 mL"},{"label":"D","text":"4 000 mL"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 L = 3 000 mL. Half a litre = 500 mL. Total = 3 000 + 500 = 3 500 mL.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4004-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    '96 cupcakes are packed into boxes of 8. How many boxes are needed?',
    '[{"label":"A","text":"10"},{"label":"B","text":"11"},{"label":"C","text":"12"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '96 ÷ 8: 8 × 12 = 96. 12 boxes are needed.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A market stall sells oranges at $2.40 for a bag of 6. What is the cost of one orange?',
    '[{"label":"A","text":"30 cents"},{"label":"B","text":"35 cents"},{"label":"C","text":"40 cents"},{"label":"D","text":"48 cents"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '$2.40 ÷ 6 = $0.40 = 40 cents per orange.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'The mean (average) of 4 numbers is 9. Three of the numbers are 6, 11 and 8. What is the fourth number?',
    '[{"label":"A","text":"9"},{"label":"B","text":"10"},{"label":"C","text":"11"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Mean = sum ÷ count. Sum = 9 × 4 = 36. Known sum = 6 + 11 + 8 = 25. Fourth number = 36 − 25 = 11.',
    'ANALYSIS', 'Statistics and Probability'
),
(
    'a0000056-0003-4004-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 8, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'The rule is "double and add 1". Starting at 1, what is the 5th term?',
    '[{"label":"A","text":"15"},{"label":"B","text":"31"},{"label":"C","text":"33"},{"label":"D","text":"63"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Term 1: 1. Term 2: 1×2+1=3. Term 3: 3×2+1=7. Term 4: 7×2+1=15. Term 5: 15×2+1=31.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A sports hall has 18 rows of seats with 23 seats in each row. How many seats are there?',
    '[{"label":"A","text":"374"},{"label":"B","text":"394"},{"label":"C","text":"404"},{"label":"D","text":"414"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '18 × 23: (18 × 20) + (18 × 3) = 360 + 54 = 414 seats.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Which fraction is closest in value to 1?',
    '[{"label":"A","text":"1/2"},{"label":"B","text":"2/3"},{"label":"C","text":"5/6"},{"label":"D","text":"3/5"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5/6 ≈ 0.833, which is the closest to 1. 2/3 ≈ 0.667, 1/2 = 0.5, 3/5 = 0.6.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4004-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Mum drove for 2 hours 30 minutes in the morning and 1 hour 45 minutes in the afternoon. How long did she drive in total?',
    '[{"label":"A","text":"3 hours 15 minutes"},{"label":"B","text":"3 hours 45 minutes"},{"label":"C","text":"4 hours 15 minutes"},{"label":"D","text":"4 hours 30 minutes"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '2h 30min + 1h 45min: hours 2+1=3, minutes 30+45=75=1h 15min. Total: 3h + 1h 15min = 4h 15min.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4004-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 9, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A bag has 15 balls. 6 are blue. What fraction of the balls are NOT blue?',
    '[{"label":"A","text":"6/15"},{"label":"B","text":"9/15"},{"label":"C","text":"10/15"},{"label":"D","text":"3/5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Not blue = 15 − 6 = 9 balls. Fraction = 9/15.',
    'COMPREHENSION', 'Statistics and Probability'
);

-- ----------------------------------------------------------------
-- NODE C_EARLY  (bands 3–6)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4005-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 72 + 19?',
    '[{"label":"A","text":"81"},{"label":"B","text":"89"},{"label":"C","text":"91"},{"label":"D","text":"101"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '72 + 19: 72 + 20 = 92, then subtract 1 = 91.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 8 × 3?',
    '[{"label":"A","text":"11"},{"label":"B","text":"18"},{"label":"C","text":"24"},{"label":"D","text":"27"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 × 3 = 3 + 3 + 3 + 3 + 3 + 3 + 3 + 3 = 24.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 20 ÷ 4?',
    '[{"label":"A","text":"4"},{"label":"B","text":"5"},{"label":"C","text":"6"},{"label":"D","text":"8"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '20 ÷ 4: 4 × 5 = 20. The answer is 5.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'Which fraction is less than 1/2?',
    '[{"label":"A","text":"3/5"},{"label":"B","text":"2/3"},{"label":"C","text":"3/4"},{"label":"D","text":"2/5"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    '2/5 = 0.4, which is less than 1/2 = 0.5. The others (3/5=0.6, 2/3≈0.67, 3/4=0.75) are all greater.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'Kai buys 4 stickers at 35 cents each. How much does he pay?',
    '[{"label":"A","text":"$1.05"},{"label":"B","text":"$1.20"},{"label":"C","text":"$1.40"},{"label":"D","text":"$1.60"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '4 × 35 cents: (4 × 30) + (4 × 5) = 120 + 20 = 140 cents = $1.40.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — mass', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A puppy weighs 3.5 kilograms. Its mother weighs 18 kilograms. How much heavier is the mother?',
    '[{"label":"A","text":"14.5 kg"},{"label":"B","text":"15 kg"},{"label":"C","text":"15.5 kg"},{"label":"D","text":"21.5 kg"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '18 − 3.5 = 14.5 kg. The mother is 14.5 kg heavier.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4005-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A bus departs at 8:50 am and arrives at 9:35 am. How long is the journey?',
    '[{"label":"A","text":"35 minutes"},{"label":"B","text":"40 minutes"},{"label":"C","text":"45 minutes"},{"label":"D","text":"50 minutes"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8:50 to 9:35: 8:50 + 10min = 9:00, then 9:00 + 35min = 9:35. Total = 10 + 35 = 45 minutes.',
    'COMPREHENSION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4005-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 318 + 494?',
    '[{"label":"A","text":"802"},{"label":"B","text":"810"},{"label":"C","text":"812"},{"label":"D","text":"912"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '318 + 494: ones 8+4=12 (write 2 carry 1). Tens: 1+9+1=11 (write 1 carry 1). Hundreds: 3+4+1=8. Answer: 812.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A square has sides of 7 metres. What is its area?',
    '[{"label":"A","text":"14 square metres"},{"label":"B","text":"28 square metres"},{"label":"C","text":"49 square metres"},{"label":"D","text":"56 square metres"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Area of a square = side × side = 7 × 7 = 49 square metres.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4005-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is the missing number: 120, 110, ___, 90, 80?',
    '[{"label":"A","text":"95"},{"label":"B","text":"100"},{"label":"C","text":"105"},{"label":"D","text":"115"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern subtracts 10. 110 − 10 = 100.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4005-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'Six students measured their heights in cm: 118, 125, 112, 130, 119 and 108. What is the range of heights?',
    '[{"label":"A","text":"18 cm"},{"label":"B","text":"20 cm"},{"label":"C","text":"22 cm"},{"label":"D","text":"25 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Range = tallest − shortest = 130 − 108 = 22 cm.',
    'ANALYSIS', 'Statistics and Probability'
),
(
    'a0000056-0003-4005-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'Round 4 836 to the nearest hundred.',
    '[{"label":"A","text":"4 800"},{"label":"B","text":"4 850"},{"label":"C","text":"4 900"},{"label":"D","text":"5 000"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    'The tens digit of 4 836 is 3 (less than 5), so we round down. 4 836 rounded to the nearest hundred = 4 800.',
    'COMPREHENSION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- NODE D  (bands 3–5)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4006-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 46 + 37?',
    '[{"label":"A","text":"73"},{"label":"B","text":"83"},{"label":"C","text":"84"},{"label":"D","text":"93"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '46 + 37: ones 6+7=13 (write 3 carry 1). Tens: 4+3+1=8. Answer: 83.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 10 × 6?',
    '[{"label":"A","text":"56"},{"label":"B","text":"60"},{"label":"C","text":"66"},{"label":"D","text":"70"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '10 × 6 = 60. Multiplying by 10 moves the digit one place left: 6 becomes 60.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 1/3 of 24?',
    '[{"label":"A","text":"6"},{"label":"B","text":"8"},{"label":"C","text":"9"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1/3 of 24: 24 ÷ 3 = 8.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — capacity', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A carton holds 1 litre of milk. How many millilitres is that?',
    '[{"label":"A","text":"10 mL"},{"label":"B","text":"100 mL"},{"label":"C","text":"1 000 mL"},{"label":"D","text":"10 000 mL"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 litre = 1 000 millilitres.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000056-0003-4006-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Data and graphs', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A spinner has 4 equal sections coloured red, blue, green and yellow. You spin it 20 times. About how many times would you expect it to land on blue?',
    '[{"label":"A","text":"2"},{"label":"B","text":"4"},{"label":"C","text":"5"},{"label":"D","text":"10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '1 out of 4 sections is blue. Expected = 1/4 × 20 = 5 times.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000056-0003-4006-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the next number: 8, 16, 24, 32, ___?',
    '[{"label":"A","text":"36"},{"label":"B","text":"38"},{"label":"C","text":"40"},{"label":"D","text":"42"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'The pattern adds 8. 32 + 8 = 40.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 120 − 65?',
    '[{"label":"A","text":"45"},{"label":"B","text":"55"},{"label":"C","text":"65"},{"label":"D","text":"75"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '120 − 65: 120 − 70 = 50, then add back 5 = 55.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Pita saves $5 every week for 8 weeks. How much has he saved?',
    '[{"label":"A","text":"$13"},{"label":"B","text":"$35"},{"label":"C","text":"$40"},{"label":"D","text":"$45"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '8 weeks × $5 per week = 8 × 5 = $40.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A shelf is 2 metres long. Books each take up 8 centimetres. How many books fit on the shelf?',
    '[{"label":"A","text":"20"},{"label":"B","text":"25"},{"label":"C","text":"30"},{"label":"D","text":"40"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '2 metres = 200 cm. 200 ÷ 8 = 25 books.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4006-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 9 × 4?',
    '[{"label":"A","text":"27"},{"label":"B","text":"32"},{"label":"C","text":"36"},{"label":"D","text":"40"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '9 × 4 = 36. Count by 9s: 9, 18, 27, 36.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4006-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'A TV show starts at 7:30 pm and is 90 minutes long. What time does it finish?',
    '[{"label":"A","text":"8:30 pm"},{"label":"B","text":"9:00 pm"},{"label":"C","text":"9:30 pm"},{"label":"D","text":"10:00 pm"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '7:30 pm + 90 minutes: 90 min = 1 h 30 min. 7:30 + 1:30 = 9:00 pm.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4006-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 857 − 429?',
    '[{"label":"A","text":"418"},{"label":"B","text":"428"},{"label":"C","text":"432"},{"label":"D","text":"438"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '857 − 429: 857 − 430 = 427, then add back 1 = 428.',
    'RECALL', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- NODE E  (bands 5–7)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4007-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Division', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 49 ÷ 7?',
    '[{"label":"A","text":"6"},{"label":"B","text":"7"},{"label":"C","text":"8"},{"label":"D","text":"9"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '49 ÷ 7: 7 × 7 = 49. The answer is 7.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 5, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 5 × 8?',
    '[{"label":"A","text":"35"},{"label":"B","text":"38"},{"label":"C","text":"40"},{"label":"D","text":"45"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '5 × 8 = 40. Count by 5s eight times: 5, 10, 15, 20, 25, 30, 35, 40.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 3/5 of 25?',
    '[{"label":"A","text":"10"},{"label":"B","text":"12"},{"label":"C","text":"15"},{"label":"D","text":"20"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '3/5 of 25: 1/5 = 25 ÷ 5 = 5. 3/5 = 3 × 5 = 15.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — area', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'How many 1-centimetre squares fit inside a rectangle that is 11 cm long and 5 cm wide?',
    '[{"label":"A","text":"32"},{"label":"B","text":"44"},{"label":"C","text":"55"},{"label":"D","text":"60"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Area = 11 × 5 = 55 square centimetres = 55 unit squares.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4007-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What is 916 − 488?',
    '[{"label":"A","text":"418"},{"label":"B","text":"428"},{"label":"C","text":"438"},{"label":"D","text":"468"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '916 − 488: 916 − 500 = 416, then add back 12 = 428. Check: 488 + 428 = 916. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 6, 'MEDIUM', 1, 'ADVANCED', 'PUBLISHED',
    'What are the next two numbers: 1, 1, 2, 3, 5, 8, ___?',
    '[{"label":"A","text":"10 and 18"},{"label":"B","text":"11 and 16"},{"label":"C","text":"13 and 21"},{"label":"D","text":"16 and 24"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Fibonacci-like pattern — each number is the sum of the two before: 5+8=13, 8+13=21.',
    'ANALYSIS', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A restaurant serves 48 tables. Each table can seat 4 people. What is the maximum number of customers?',
    '[{"label":"A","text":"148"},{"label":"B","text":"168"},{"label":"C","text":"192"},{"label":"D","text":"204"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '48 × 4: (40 × 4) + (8 × 4) = 160 + 32 = 192 customers.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 1 − 3/8?',
    '[{"label":"A","text":"3/8"},{"label":"B","text":"5/8"},{"label":"C","text":"4/8"},{"label":"D","text":"7/8"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 = 8/8. 8/8 − 3/8 = 5/8.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — perimeter', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A regular hexagon has a perimeter of 48 cm. How long is each side?',
    '[{"label":"A","text":"6 cm"},{"label":"B","text":"7 cm"},{"label":"C","text":"8 cm"},{"label":"D","text":"12 cm"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'A hexagon has 6 equal sides. 48 ÷ 6 = 8 cm per side.',
    'APPLICATION', 'Measurement and Geometry'
),
(
    'a0000056-0003-4007-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Chance and probability', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'A box contains 5 red, 3 blue and 2 yellow pencils. What is the probability of picking a red or blue pencil?',
    '[{"label":"A","text":"5/10"},{"label":"B","text":"7/10"},{"label":"C","text":"8/10"},{"label":"D","text":"3/10"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Red + blue = 5 + 3 = 8 pencils out of 10 total (5+3+2=10). Probability = 8/10.',
    'COMPREHENSION', 'Statistics and Probability'
),
(
    'a0000056-0003-4007-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'What is 6 thousands + 4 hundreds + 0 tens + 9 ones written as a number?',
    '[{"label":"A","text":"6 049"},{"label":"B","text":"6 409"},{"label":"C","text":"6 490"},{"label":"D","text":"6 940"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '6 thousands = 6 000, 4 hundreds = 400, 0 tens = 0, 9 ones = 9. Total = 6 409.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4007-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Money', 7, 'HARD', 1, 'ADVANCED', 'PUBLISHED',
    'Six children each brought $4.50 to buy craft supplies. They spent $24.30 altogether. How much money is left over?',
    '[{"label":"A","text":"$2.70"},{"label":"B","text":"$3.00"},{"label":"C","text":"$3.20"},{"label":"D","text":"$3.70"}]'::jsonb,
    '{"value":"A"}'::jsonb,
    '6 × $4.50 = $27.00. $27.00 − $24.30 = $2.70 left over.',
    'APPLICATION', 'Number and Algebra'
);

-- ----------------------------------------------------------------
-- NODE F  (bands 1–4)
-- ----------------------------------------------------------------
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, difficulty, marks, package_type, status, question_text, options, correct_answer, explanation, cognitive_skill, curriculum_strand)
VALUES
(
    'a0000056-0003-4008-a000-000000000001', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Counting', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What number comes just after 99?',
    '[{"label":"A","text":"98"},{"label":"B","text":"100"},{"label":"C","text":"109"},{"label":"D","text":"199"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'Counting forward from 99, the next number is 100.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000002', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 6 + 8?',
    '[{"label":"A","text":"12"},{"label":"B","text":"13"},{"label":"C","text":"14"},{"label":"D","text":"15"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '6 + 8 = 14.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000003', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 1, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is 18 − 7?',
    '[{"label":"A","text":"9"},{"label":"B","text":"10"},{"label":"C","text":"11"},{"label":"D","text":"12"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '18 − 7 = 11. Check: 11 + 7 = 18. ✓',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000004', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Place value', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Which number has 4 in the tens place?',
    '[{"label":"A","text":"204"},{"label":"B","text":"402"},{"label":"C","text":"420"},{"label":"D","text":"40"}]'::jsonb,
    '{"value":"D"}'::jsonb,
    'In 40: the digit 4 is in the tens place (4 tens = 40) and 0 is in the ones place. In 204, 402 and 420 the digit 4 is in a hundreds or other place.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000005', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    '2D shapes', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many sides does a triangle have?',
    '[{"label":"A","text":"2"},{"label":"B","text":"3"},{"label":"C","text":"4"},{"label":"D","text":"5"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'A triangle has exactly 3 sides.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000056-0003-4008-a000-000000000006', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A fisherman caught 11 fish in the morning and 9 fish in the afternoon. How many fish did he catch in total?',
    '[{"label":"A","text":"2"},{"label":"B","text":"18"},{"label":"C","text":"20"},{"label":"D","text":"21"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    '11 + 9 = 20 fish in total.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000007', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Number patterns', 2, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'What is the missing number: 4, 8, ___, 16, 20?',
    '[{"label":"A","text":"10"},{"label":"B","text":"12"},{"label":"C","text":"13"},{"label":"D","text":"14"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    'The pattern adds 4: 4, 8, 12, 16, 20.',
    'RECALL', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000008', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Multiplication', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many legs do 3 cats have altogether?',
    '[{"label":"A","text":"8"},{"label":"B","text":"10"},{"label":"C","text":"12"},{"label":"D","text":"16"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'Each cat has 4 legs. 3 × 4 = 12 legs.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000009', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Measurement — length', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many centimetres are in 1 metre?',
    '[{"label":"A","text":"10"},{"label":"B","text":"100"},{"label":"C","text":"1 000"},{"label":"D","text":"10 000"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '1 metre = 100 centimetres.',
    'RECALL', 'Measurement and Geometry'
),
(
    'a0000056-0003-4008-a000-000000000010', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Fractions', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'A pizza is cut into 3 equal slices. You eat 1 slice. What fraction of the pizza is left?',
    '[{"label":"A","text":"1/3"},{"label":"B","text":"2/3"},{"label":"C","text":"3/3"},{"label":"D","text":"1/2"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '3 slices total − 1 eaten = 2 slices left. 2 out of 3 = 2/3.',
    'COMPREHENSION', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000011', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Addition and subtraction', 3, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'Ella had 25 stickers. She gave some away and has 16 left. How many did she give away?',
    '[{"label":"A","text":"7"},{"label":"B","text":"9"},{"label":"C","text":"11"},{"label":"D","text":"41"}]'::jsonb,
    '{"value":"B"}'::jsonb,
    '25 − 16 = 9. Ella gave away 9 stickers.',
    'APPLICATION', 'Number and Algebra'
),
(
    'a0000056-0003-4008-a000-000000000012', 'MULTIPLE_CHOICE', 3, 'NUMERACY',
    'Time', 4, 'EASY', 1, 'ADVANCED', 'PUBLISHED',
    'How many seconds are in 1 minute?',
    '[{"label":"A","text":"24"},{"label":"B","text":"30"},{"label":"C","text":"60"},{"label":"D","text":"100"}]'::jsonb,
    '{"value":"C"}'::jsonb,
    'There are 60 seconds in 1 minute.',
    'RECALL', 'Measurement and Geometry'
);

-- ----------------------------------------------------------------
-- EXAM_QUESTIONS  (96 links)
-- ----------------------------------------------------------------
INSERT INTO exam_questions (exam_id, question_id, question_order, section_id, testlet_id) VALUES
-- Node A (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4001-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001'),
-- Node B (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4002-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002'),
-- Node B_late (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4003-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003'),
-- Node C (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4004-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000004'),
-- Node C_early (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4005-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000005'),
-- Node D (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4006-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006'),
-- Node E (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4007-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000007'),
-- Node F (12)
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000001', 1,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000002', 2,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000003', 3,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000004', 4,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000005', 5,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000006', 6,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000007', 7,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000008', 8,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000009', 9,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000010',10,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000011',11,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008'),
('a0000056-0000-4000-a000-000000000001','a0000056-0003-4008-a000-000000000012',12,'a0000056-0001-4000-a000-000000000001','a0000056-0002-4000-a000-000000000008');

-- ----------------------------------------------------------------
-- TESTLET TRANSITIONS  (9 rules)
-- ----------------------------------------------------------------
INSERT INTO testlet_transitions (id, exam_id, source_testlet, target_testlet, condition_type, condition_value, priority)
VALUES
('a0000056-0004-4000-a000-000000000001','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002','SCORE_ABOVE','{"threshold":0.75}'::jsonb,20),
('a0000056-0004-4000-a000-000000000002','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006','SCORE_ABOVE','{"threshold":0.40}'::jsonb,10),
('a0000056-0004-4000-a000-000000000003','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003','ALWAYS',NULL,0),
('a0000056-0004-4000-a000-000000000004','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002','a0000056-0002-4000-a000-000000000004','SCORE_ABOVE','{"threshold":0.67}'::jsonb,10),
('a0000056-0004-4000-a000-000000000005','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000002','a0000056-0002-4000-a000-000000000007','ALWAYS',NULL,0),
('a0000056-0004-4000-a000-000000000006','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003','a0000056-0002-4000-a000-000000000005','SCORE_ABOVE','{"threshold":0.50}'::jsonb,10),
('a0000056-0004-4000-a000-000000000007','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000003','a0000056-0002-4000-a000-000000000008','ALWAYS',NULL,0),
('a0000056-0004-4000-a000-000000000008','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006','a0000056-0002-4000-a000-000000000007','SCORE_ABOVE','{"threshold":0.67}'::jsonb,10),
('a0000056-0004-4000-a000-000000000009','a0000056-0000-4000-a000-000000000001','a0000056-0002-4000-a000-000000000006','a0000056-0002-4000-a000-000000000008','ALWAYS',NULL,0);

COMMIT;
