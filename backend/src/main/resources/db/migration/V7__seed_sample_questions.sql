-- Year 3 Numeracy Questions
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Addition', 2,
     'What is 15 + 27?',
     '{"options": ["40", "42", "41", "43"]}',
     '{"value": "42"}',
     '15 + 27 = 42. Add the ones: 5+7=12, write 2, carry 1. Add the tens: 1+2+1=4.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Subtraction', 2,
     'What is 50 - 18?',
     '{"options": ["32", "28", "38", "42"]}',
     '{"value": "32"}',
     '50 - 18 = 32. Borrow from the tens: 10-8=2, 4-1=3.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Multiplication', 3,
     'What is 6 × 7?',
     '{"options": ["42", "48", "36", "54"]}',
     '{"value": "42"}',
     '6 × 7 = 42. This is a multiplication fact to memorise.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Place Value', 2,
     'What is the value of the digit 4 in the number 247?',
     '{"options": ["4", "40", "400", "4000"]}',
     '{"value": "40"}',
     'In 247, the digit 4 is in the tens place, so its value is 40.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Fractions', 3,
     'Which fraction is equivalent to 1/2?',
     '{"options": ["2/4", "1/4", "3/4", "2/3"]}',
     '{"value": "2/4"}',
     '2/4 = 1/2 because both the numerator and denominator are multiplied by 2.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Geometry', 3,
     'How many sides does a hexagon have?',
     '{"options": ["6", "5", "7", "8"]}',
     '{"value": "6"}',
     'A hexagon has 6 sides. Hex means 6 in Greek.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Time', 2,
     'How many minutes are in 2 hours?',
     '{"options": ["120", "60", "100", "200"]}',
     '{"value": "120"}',
     'There are 60 minutes in 1 hour, so 2 hours = 2 × 60 = 120 minutes.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'NUMERACY', 'Money', 3,
     'Sarah has $5.50. She buys a book for $2.75. How much change does she get?',
     '{"options": ["$2.75", "$3.25", "$2.25", "$3.75"]}',
     '{"value": "$2.75"}',
     '$5.50 - $2.75 = $2.75. Line up the decimals and subtract.', 'PUBLISHED');

-- Year 3 Reading Questions
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, stimulus_text, question_text, options, correct_answer, explanation, status)
VALUES
    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Comprehension', 2,
     'The dog wagged its tail when it saw the ball. It ran across the yard and picked it up in its mouth.',
     'What was the dog carrying in its mouth?',
     '{"options": ["A stick", "A ball", "A bone", "A toy"]}',
     '{"value": "A ball"}',
     'The text says the dog "picked it up in its mouth" referring to the ball.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 3, 'READING', 'Vocabulary', 3,
     'The ancient ruins were discovered by archaeologists who had been searching for years.',
     'What does "ancient" most likely mean?',
     '{"options": ["Very old", "Very new", "Very large", "Very small"]}',
     '{"value": "Very old"}',
     '"Ancient" means very old, often thousands of years old.', 'PUBLISHED');

-- Year 5 Numeracy Questions
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Fractions and Decimals', 4,
     'What is 3/4 as a decimal?',
     '{"options": ["0.75", "0.34", "0.25", "0.50"]}',
     '{"value": "0.75"}',
     '3/4 = 3 ÷ 4 = 0.75. Divide the numerator by the denominator.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Percentages', 5,
     'What is 25% of 200?',
     '{"options": ["50", "25", "75", "100"]}',
     '{"value": "50"}',
     '25% = 25/100 = 1/4. So 1/4 of 200 = 50.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Algebra', 5,
     'If x + 7 = 15, what is x?',
     '{"options": ["8", "7", "22", "9"]}',
     '{"value": "8"}',
     'x + 7 = 15, so x = 15 - 7 = 8.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Area and Perimeter', 4,
     'A rectangle has a length of 8 cm and a width of 5 cm. What is its area?',
     '{"options": ["40 cm²", "26 cm²", "13 cm²", "30 cm²"]}',
     '{"value": "40 cm²"}',
     'Area = length × width = 8 × 5 = 40 cm².', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Statistics', 5,
     'The temperatures for 5 days were: 22, 25, 19, 28, 21. What is the mean temperature?',
     '{"options": ["23", "22", "25", "20"]}',
     '{"value": "23"}',
     'Mean = (22+25+19+28+21) ÷ 5 = 115 ÷ 5 = 23.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'NUMERACY', 'Division', 4,
     'What is 144 ÷ 12?',
     '{"options": ["12", "14", "11", "13"]}',
     '{"value": "12"}',
     '144 ÷ 12 = 12. This is related to 12 × 12 = 144.', 'PUBLISHED');

-- Year 5 Reading Questions
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, stimulus_text, question_text, options, correct_answer, explanation, status)
VALUES
    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Inference', 5,
     'Maria had not eaten since breakfast. As she walked past the bakery, she paused and pressed her nose against the glass window.',
     'What can you infer about Maria?',
     '{"options": ["She is hungry", "She wants to buy bread", "She is lost", "She likes windows"]}',
     '{"value": "She is hungry"}',
     'The fact that she had not eaten and paused at a bakery strongly suggests she is hungry.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 5, 'READING', 'Text Structure', 5,
     'There are several reasons why exercise is important. First, it keeps our hearts healthy. Second, it helps maintain a healthy weight. Finally, exercise improves our mood.',
     'What text structure is used in this passage?',
     '{"options": ["Problem and solution", "Cause and effect", "List/sequence", "Compare and contrast"]}',
     '{"value": "List/sequence"}',
     'The words "First", "Second", and "Finally" signal a list structure.', 'PUBLISHED');

-- Year 7 Numeracy Questions
INSERT INTO questions (id, question_type, year_level, domain, topic, difficulty_band, question_text, options, correct_answer, explanation, status)
VALUES
    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Algebra', 6,
     'Solve for x: 3x - 5 = 16',
     '{"options": ["7", "3", "11", "4"]}',
     '{"value": "7"}',
     '3x - 5 = 16, 3x = 21, x = 7.', 'PUBLISHED'),

    (uuid_generate_v4(), 'MULTIPLE_CHOICE', 7, 'NUMERACY', 'Geometry', 6,
     'What is the sum of angles in a triangle?',
     '{"options": ["180°", "360°", "90°", "270°"]}',
     '{"value": "180°"}',
     'The sum of all interior angles in any triangle is always 180°.', 'PUBLISHED');
