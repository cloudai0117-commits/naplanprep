-- V13: NAPLAN questions — Year 3, 5, 7, 9 × Numeracy, Reading, Grammar & Punctuation
-- 10 questions per category = 120 total

-- ============================================================
-- YEAR 3 — NUMERACY
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Place Value',2,
 'What is the value of the digit 4 in 342?',
 '{"options":["4","40","400","4000"]}','{"value":"40"}',
 'The 4 is in the tens position, so its value is 40.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Addition',2,
 'What is 47 + 38?',
 '{"options":["75","85","95","76"]}','{"value":"85"}',
 '47 + 38: ones 7+8=15 (write 5 carry 1), tens 4+3+1=8. Answer 85.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Subtraction',2,
 'What is 83 − 27?',
 '{"options":["46","54","56","66"]}','{"value":"56"}',
 'Borrow from tens: 13−7=6, 7−2=5. Answer 56.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Multiplication',3,
 'What is 4 × 7?',
 '{"options":["24","28","32","21"]}','{"value":"28"}',
 '4 × 7 = 28.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Division',3,
 '20 apples are shared equally among 4 baskets. How many in each basket?',
 '{"options":["4","5","6","8"]}','{"value":"5"}',
 '20 ÷ 4 = 5.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Fractions',2,
 'Which fraction is equal to one half?',
 '{"options":["1/4","2/4","3/4","4/4"]}','{"value":"2/4"}',
 '2/4 = 1/2 because both numerator and denominator are multiplied by 2.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Measurement',2,
 'Which unit is best to measure the length of a pencil?',
 '{"options":["kilometres","metres","centimetres","tonnes"]}','{"value":"centimetres"}',
 'A pencil is about 15–20 cm long, so centimetres is best.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Time',2,
 'How many minutes are in 2 hours and 30 minutes?',
 '{"options":["120","130","150","160"]}','{"value":"150"}',
 '2 hours = 120 min. 120 + 30 = 150 minutes.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Patterns',2,
 'What is the next number? 3, 6, 9, 12, ___',
 '{"options":["13","14","15","16"]}','{"value":"15"}',
 'Pattern adds 3 each time: 12 + 3 = 15.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'NUMERACY','Geometry',3,
 'How many sides does a hexagon have?',
 '{"options":["5","6","7","8"]}','{"value":"6"}',
 'A hexagon has 6 sides. Hex = 6 in Greek.','PUBLISHED');

-- ============================================================
-- YEAR 3 — READING
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,stimulus_text,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Comprehension',2,
 'Mia loved feeding the ducks at the park. Every Saturday she brought a bag of bread and tossed pieces into the pond. The ducks always swam over quickly.',
 'Why did the ducks swim towards Mia?',
 '{"options":["They were scared","She was feeding them bread","They wanted to play","They liked the pond"]}','{"value":"She was feeding them bread"}',
 'The passage says Mia brought bread to feed the ducks.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Vocabulary',2,
 'The puppy was so tiny it could fit in the palm of your hand.',
 'What does "tiny" mean?',
 '{"options":["very big","very loud","very small","very fast"]}','{"value":"very small"}',
 'Tiny means very small.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Inference',3,
 'Jake put on his raincoat and grabbed his umbrella before heading outside.',
 'What was the weather probably like?',
 '{"options":["sunny","snowy","rainy","windy"]}','{"value":"rainy"}',
 'A raincoat and umbrella suggest it was raining.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Comprehension',2,
 'Butterflies start life as eggs. The eggs hatch into caterpillars. Caterpillars eat leaves and grow. Then they form a chrysalis. Finally a butterfly emerges.',
 'What comes after the caterpillar stage?',
 '{"options":["egg","butterfly","chrysalis","leaf"]}','{"value":"chrysalis"}',
 'The text says caterpillars form a chrysalis after growing.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Vocabulary',2,
 'The athlete sprinted across the finish line.',
 'What does "sprinted" mean?',
 '{"options":["walked slowly","ran very fast","jumped high","crawled"]}','{"value":"ran very fast"}',
 'Sprint means to run at full speed.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Purpose',2,
 null,
 'A recipe tells you how to make food. What is the main purpose of a recipe?',
 '{"options":["To entertain the reader","To persuade people to cook","To give instructions for making food","To tell a story about food"]}','{"value":"To give instructions for making food"}',
 'Recipes are instructional texts — they tell you how to make something.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Comprehension',2,
 'Tom and his dad went fishing early in the morning. They sat quietly by the river for two hours but did not catch anything. Tom was disappointed but his dad said they would try again next weekend.',
 'How did Tom feel at the end?',
 '{"options":["happy","excited","disappointed","angry"]}','{"value":"disappointed"}',
 'The text directly says Tom was disappointed.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Vocabulary',2,
 'The kitten was frightened by the loud thunder.',
 'What does "frightened" mean?',
 '{"options":["tired","hungry","scared","excited"]}','{"value":"scared"}',
 'Frightened means afraid or scared.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Text Features',2,
 null,
 'In a book, what helps you find which page a chapter is on?',
 '{"options":["The index","The glossary","The contents page","The introduction"]}','{"value":"The contents page"}',
 'The contents page lists chapters and their page numbers.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'READING','Text Type',2,
 null,
 'Which text would most likely tell you about the life of a famous person?',
 '{"options":["A recipe","A biography","A poem","A weather report"]}','{"value":"A biography"}',
 'A biography tells the story of a real person''s life.','PUBLISHED');

-- ============================================================
-- YEAR 3 — GRAMMAR & PUNCTUATION
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Nouns',2,
 'Which word is a noun in: "The dog chased the red ball."?',
 '{"options":["chased","red","dog","quickly"]}','{"value":"dog"}',
 'A noun is a person, place, or thing. "Dog" is a noun.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Verbs',2,
 'Which word is the verb in: "The children played in the park."?',
 '{"options":["children","park","the","played"]}','{"value":"played"}',
 'A verb is an action word. "Played" is the action here.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Punctuation',2,
 'Which sentence uses correct punctuation?',
 '{"options":["the cat sat on the mat.","The cat sat on the mat","The cat sat on the mat.","the Cat sat on the mat."]}','{"value":"The cat sat on the mat."}',
 'Sentences start with a capital letter and end with a full stop.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Spelling',2,
 'Which word is spelled correctly?',
 '{"options":["frend","freind","friend","freiend"]}','{"value":"friend"}',
 'The correct spelling is "friend."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Adjectives',2,
 'Which word is an adjective in: "She has a beautiful garden."?',
 '{"options":["has","garden","she","beautiful"]}','{"value":"beautiful"}',
 'An adjective describes a noun. "Beautiful" describes the garden.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Spelling',2,
 'Choose the correctly spelled word:',
 '{"options":["becuase","becasue","beacuse","because"]}','{"value":"because"}',
 'The correct spelling is "because."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Apostrophes',3,
 'Which sentence uses an apostrophe correctly?',
 '{"options":["The dogs bone was buried.","The dog''s bone was buried.","The dogs'' bone was buried.","The dog is bone was buried."]}','{"value":"The dog''s bone was buried."}',
 'Apostrophe + s shows possession — the bone belongs to the dog.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Sentences',2,
 'Which of these is a complete sentence?',
 '{"options":["Running fast in the park.","The bird.","The bird sang a sweet song.","Because it was cold."]}','{"value":"The bird sang a sweet song."}',
 'A complete sentence has a subject and a verb.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Spelling',2,
 'Which word is spelled correctly?',
 '{"options":["libary","liberry","library","librery"]}','{"value":"library"}',
 'The correct spelling is "library."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',3,'GRAMMAR_PUNCTUATION','Punctuation',3,
 'Which sentence uses a question mark correctly?',
 '{"options":["Where are you going.","Where are you going?","Where are you going!","Where are you going,"]}','{"value":"Where are you going?"}',
 'Questions end with a question mark (?).','PUBLISHED');

-- ============================================================
-- YEAR 5 — NUMERACY
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Fractions & Decimals',4,
 'What is 3/5 written as a decimal?',
 '{"options":["0.35","0.53","0.60","0.06"]}','{"value":"0.60"}',
 '3 ÷ 5 = 0.6.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Percentages',4,
 'What is 20% of 150?',
 '{"options":["20","25","30","35"]}','{"value":"30"}',
 '20% = 1/5. 150 ÷ 5 = 30.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Algebra',5,
 'If n + 9 = 21, what is n?',
 '{"options":["10","11","12","13"]}','{"value":"12"}',
 'n = 21 − 9 = 12.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Area',4,
 'A rectangle has length 9 cm and width 4 cm. What is its area?',
 '{"options":["26 cm²","36 cm²","40 cm²","13 cm²"]}','{"value":"36 cm²"}',
 'Area = 9 × 4 = 36 cm².','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Statistics',5,
 'The scores of five students are: 14, 16, 18, 20, 22. What is the mean?',
 '{"options":["16","17","18","19"]}','{"value":"18"}',
 '(14+16+18+20+22) ÷ 5 = 90 ÷ 5 = 18.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Place Value',4,
 'What is the value of the 7 in 4.72?',
 '{"options":["7","0.7","0.07","70"]}','{"value":"0.7"}',
 '7 is in the tenths place, so its value is 0.7.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Probability',5,
 'A bag has 4 red and 6 blue marbles. What is the probability of picking a red marble?',
 '{"options":["4/10","6/10","4/6","1/4"]}','{"value":"4/10"}',
 '4 red out of 10 total = 4/10 (or 2/5).','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Multiplication',4,
 'What is 24 × 15?',
 '{"options":["240","310","360","380"]}','{"value":"360"}',
 '24 × 15 = 24 × 10 + 24 × 5 = 240 + 120 = 360.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Negative Numbers',5,
 'The temperature was −3°C at night and rose 8 degrees by morning. What was the morning temperature?',
 '{"options":["4°C","5°C","6°C","11°C"]}','{"value":"5°C"}',
 '−3 + 8 = 5°C.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'NUMERACY','Perimeter',4,
 'What is the perimeter of a square with side length 7 cm?',
 '{"options":["14 cm","21 cm","28 cm","49 cm"]}','{"value":"28 cm"}',
 'Perimeter = 4 × 7 = 28 cm.','PUBLISHED');

-- ============================================================
-- YEAR 5 — READING
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,stimulus_text,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Inference',5,
 'Maria had not eaten since breakfast. As she walked past the bakery she paused and pressed her nose against the glass window.',
 'What can you infer about Maria?',
 '{"options":["She is hungry","She wants to buy bread","She is lost","She likes windows"]}','{"value":"She is hungry"}',
 'Not eating since breakfast and pausing at a bakery strongly suggests hunger.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Text Structure',5,
 'There are several reasons why exercise is important. First it keeps our hearts healthy. Second it helps maintain a healthy weight. Finally exercise improves our mood.',
 'What text structure is used in this passage?',
 '{"options":["Problem and solution","Cause and effect","List / sequence","Compare and contrast"]}','{"value":"List / sequence"}',
 '"First, Second, Finally" signal a list/sequence structure.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Figurative Language',5,
 null,
 'Identify the figure of speech: "The classroom was a zoo."',
 '{"options":["Simile","Metaphor","Personification","Alliteration"]}','{"value":"Metaphor"}',
 'A metaphor compares two things directly without using like or as.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Vocabulary',4,
 null,
 'What does "persevere" mean?',
 '{"options":["Give up","Continue despite difficulty","Work quickly","Start again"]}','{"value":"Continue despite difficulty"}',
 'Persevere means to keep going despite obstacles.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Comprehension',4,
 'The Great Barrier Reef is the world''s largest coral reef system. It stretches over 2,300 km along the north-east coast of Australia and is home to thousands of species of marine life. Climate change and pollution threaten the reef today.',
 'What is the main threat to the Great Barrier Reef today?',
 '{"options":["Fishing","Tourism","Climate change and pollution","Ocean currents"]}','{"value":"Climate change and pollution"}',
 'The final sentence states climate change and pollution are the threats.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Grammar',4,
 null,
 'Which sentence is written in passive voice?',
 '{"options":["The cat chased the mouse.","The mouse was chased by the cat.","The cat runs fast.","Cats are fast."]}','{"value":"The mouse was chased by the cat."}',
 'Passive voice: the subject receives the action.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Vocabulary',5,
 'The ancient ruins were discovered beneath a dense jungle.',
 'What does "ancient" mean?',
 '{"options":["very new","very large","very old","very hidden"]}','{"value":"very old"}',
 'Ancient means very old, from a long time ago.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Author Purpose',4,
 'Did you know that recycling one aluminium can saves enough energy to run a television for three hours? Recycling is easy and helps our planet. Start recycling today!',
 'What is the author''s main purpose?',
 '{"options":["To inform about aluminium","To entertain readers","To persuade people to recycle","To explain how television works"]}','{"value":"To persuade people to recycle"}',
 'The exclamation and call to action "Start recycling today!" show persuasive intent.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Comprehension',5,
 'Although the plan seemed risky Luke decided to go ahead. He gathered his tools packed his bag and set off before dawn. By midday he had climbed to the summit and planted the flag.',
 'Which word best describes Luke?',
 '{"options":["Cautious","Determined","Reckless","Lazy"]}','{"value":"Determined"}',
 'Luke proceeds despite risk and completes his goal — showing determination.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'READING','Vocabulary in Context',5,
 'The explorer navigated through the treacherous mountain pass.',
 'What does "treacherous" mean?',
 '{"options":["scenic","dangerous","narrow","frozen"]}','{"value":"dangerous"}',
 'Treacherous means full of danger or hazards.','PUBLISHED');

-- ============================================================
-- YEAR 5 — GRAMMAR & PUNCTUATION
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Commas',4,
 'Which sentence uses commas correctly?',
 '{"options":["I bought apples, oranges and bananas.","I bought, apples oranges and, bananas.","I, bought apples oranges and bananas.","I bought apples oranges, and, bananas."]}','{"value":"I bought apples, oranges and bananas."}',
 'Commas separate items in a list. The comma after "apples" and "oranges" is correct.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Tense',4,
 'Which sentence is written in past tense?',
 '{"options":["She runs to the park every day.","She will run to the park tomorrow.","She ran to the park yesterday.","She is running to the park."]}','{"value":"She ran to the park yesterday."}',
 '"Ran" is the past tense of "run."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Spelling',4,
 'Which word is spelled correctly?',
 '{"options":["necesary","necessery","necessary","neccesary"]}','{"value":"necessary"}',
 'The correct spelling is "necessary" — one c, two s.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Subject-Verb Agreement',4,
 'Choose the sentence with correct subject-verb agreement:',
 '{"options":["The students was tired.","The students were tired.","The students is tired.","The students are tired very."]}','{"value":"The students were tired."}',
 '"Students" is plural, so it takes "were" not "was."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Conjunctions',4,
 'Choose the correct conjunction: "I wanted to go to the beach ___ it was raining."',
 '{"options":["so","because","but","and"]}','{"value":"but"}',
 '"But" shows contrast between wanting to go and it raining.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Spelling',5,
 'Which word is spelled correctly?',
 '{"options":["beleive","beleve","believe","beleeve"]}','{"value":"believe"}',
 'The correct spelling is "believe" — i before e except after c (with exceptions).','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Pronouns',4,
 'Choose the correct pronoun: "The teacher gave ___ students extra time."',
 '{"options":["her","his","their","them"]}','{"value":"their"}',
 '"Their" is the possessive pronoun referring to the students.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Adverbs',4,
 'Which word is an adverb in: "She spoke quietly to avoid waking the baby."?',
 '{"options":["spoke","quietly","avoid","baby"]}','{"value":"quietly"}',
 'Adverbs modify verbs. "Quietly" modifies "spoke."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Colons',5,
 'Which sentence uses a colon correctly?',
 '{"options":["She needed: three things for the trip.","She needed three things for the trip:","She needed three things: a tent, a map, and food.","She needed three things a tent: a map and food."]}','{"value":"She needed three things: a tent, a map, and food."}',
 'A colon introduces a list after a complete clause.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',5,'GRAMMAR_PUNCTUATION','Spelling',4,
 'Which word is spelled correctly?',
 '{"options":["enviroment","enviornment","environment","enviorment"]}','{"value":"environment"}',
 'The correct spelling is "environment."','PUBLISHED');

-- ============================================================
-- YEAR 7 — NUMERACY
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Algebra',6,
 'Solve for x: 3x − 5 = 16',
 '{"options":["5","6","7","8"]}','{"value":"7"}',
 '3x = 21, x = 7.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Geometry',6,
 'The sum of interior angles of a triangle is:',
 '{"options":["90°","180°","270°","360°"]}','{"value":"180°"}',
 'The angles of any triangle always add to 180°.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Indices',6,
 'Simplify: 2³ × 2²',
 '{"options":["2⁵","2⁶","4⁵","2⁴"]}','{"value":"2⁵"}',
 'When multiplying same base, add exponents: 3 + 2 = 5.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Linear Equations',6,
 'If y = 2x + 3, what is y when x = 5?',
 '{"options":["11","12","13","14"]}','{"value":"13"}',
 'y = 2(5) + 3 = 10 + 3 = 13.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Percentages',6,
 'A jacket costs $80 and is 25% off. What is the sale price?',
 '{"options":["$55","$60","$65","$70"]}','{"value":"$60"}',
 '25% of $80 = $20. $80 − $20 = $60.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Area',6,
 'The area of a triangle with base 10 cm and height 6 cm is:',
 '{"options":["30 cm²","60 cm²","16 cm²","15 cm²"]}','{"value":"30 cm²"}',
 'Area = ½ × 10 × 6 = 30 cm².','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Probability',7,
 'Two dice are rolled. What is the probability the sum equals 7?',
 '{"options":["1/6","5/36","6/36","7/36"]}','{"value":"6/36"}',
 'Combinations summing to 7: (1,6)(2,5)(3,4)(4,3)(5,2)(6,1) = 6 out of 36.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Ratios',6,
 'A recipe uses 2 cups of flour for every 3 cups of sugar. How many cups of flour are needed for 9 cups of sugar?',
 '{"options":["4","5","6","7"]}','{"value":"6"}',
 'Ratio 2:3. For 9 cups sugar (×3): 2 × 3 = 6 cups flour.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Pythagoras',7,
 'A right triangle has legs 5 cm and 12 cm. What is the hypotenuse?',
 '{"options":["11 cm","13 cm","15 cm","17 cm"]}','{"value":"13 cm"}',
 '5² + 12² = 25 + 144 = 169. √169 = 13.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'NUMERACY','Statistics',6,
 'Data set: 4, 6, 7, 7, 8, 9, 10. What is the median?',
 '{"options":["6","7","8","9"]}','{"value":"7"}',
 'The middle value (4th of 7) in sorted data is 7.','PUBLISHED');

-- ============================================================
-- YEAR 7 — READING
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,stimulus_text,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Inference',6,
 'Although the explorer had been warned about the treacherous mountain path she pressed on telling herself that the view from the summit would make the hardship worthwhile.',
 'Which word best describes the explorer''s character?',
 '{"options":["Reckless","Determined","Fearful","Lazy"]}','{"value":"Determined"}',
 'She continues despite warnings, showing determination.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Language Features',6,
 null,
 'Which technique involves a reference to a well-known event, place, or work?',
 '{"options":["Alliteration","Allusion","Assonance","Allegory"]}','{"value":"Allusion"}',
 'An allusion is an indirect reference to another text or well-known event.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Author Purpose',6,
 'Advertisements use persuasive language, appealing images, and celebrity endorsements to influence consumers.',
 'What is the author''s main purpose in this passage?',
 '{"options":["To entertain","To inform","To persuade","To describe"]}','{"value":"To inform"}',
 'The passage objectively explains advertising techniques — this is informative writing.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Vocabulary in Context',7,
 'The scientist''s hypothesis was corroborated by three independent experiments.',
 'What does "corroborated" mean?',
 '{"options":["disproved","confirmed","questioned","ignored"]}','{"value":"confirmed"}',
 'Corroborated means supported or confirmed by evidence.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Text Type',6,
 null,
 'A text that presents arguments for and against an issue is called a:',
 '{"options":["Narrative","Recount","Discussion","Procedure"]}','{"value":"Discussion"}',
 'A discussion text explores multiple perspectives on an issue.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Comprehension',6,
 'The ocean covers about 71% of the Earth''s surface. Despite this vast coverage less than 20% of the ocean has been explored. Scientists believe millions of species remain undiscovered in its depths.',
 'What can be inferred from this passage?',
 '{"options":["The ocean is mostly explored","Most ocean species are known","There is much still unknown about the ocean","The ocean is shallow in most areas"]}','{"value":"There is much still unknown about the ocean"}',
 'Less than 20% explored + millions undiscovered species = much still unknown.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Figurative Language',6,
 null,
 'What figure of speech is used in: "The wind whispered through the trees"?',
 '{"options":["Simile","Metaphor","Personification","Hyperbole"]}','{"value":"Personification"}',
 'Personification gives human qualities (whispering) to a non-human thing (wind).','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Vocabulary',6,
 'The council''s decision was controversial among local residents.',
 'What does "controversial" mean?',
 '{"options":["popular","expensive","causing disagreement","unexpected"]}','{"value":"causing disagreement"}',
 'Controversial means causing strong disagreement or debate.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Comprehension',7,
 'The invention of the printing press in the 15th century revolutionised communication. Before Gutenberg''s press books had to be copied by hand — a process that took months or years. The press allowed books to be produced quickly and cheaply enabling knowledge to spread widely.',
 'What was the most significant effect of the printing press?',
 '{"options":["It made books more beautiful","It allowed knowledge to spread widely","It replaced hand-copied books only in Europe","It made writers wealthier"]}','{"value":"It allowed knowledge to spread widely"}',
 'The passage directly states the press enabled knowledge to spread widely.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'READING','Point of View',7,
 null,
 'In first-person narration, which pronoun is typically used?',
 '{"options":["He","She","They","I"]}','{"value":"I"}',
 'First-person narration uses "I" and "we."','PUBLISHED');

-- ============================================================
-- YEAR 7 — GRAMMAR & PUNCTUATION
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Semicolons',6,
 'Which sentence uses a semicolon correctly?',
 '{"options":["The storm was fierce; it flooded the streets.","The storm; was fierce it flooded the streets.","The storm was; fierce it flooded the streets.","The storm was fierce it; flooded the streets."]}','{"value":"The storm was fierce; it flooded the streets."}',
 'A semicolon links two related independent clauses.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Relative Clauses',6,
 'Choose the sentence that contains a relative clause:',
 '{"options":["She went to the market.","She went to the market quickly.","She went to the market that was near the school.","She and her friend went to the market."]}','{"value":"She went to the market that was near the school."}',
 '"That was near the school" is a relative clause modifying "market."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Spelling',6,
 'Which word is spelled correctly?',
 '{"options":["accomodation","acommodation","accommodation","accomadation"]}','{"value":"accommodation"}',
 'The correct spelling is "accommodation" — two c''s and two m''s.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Passive Voice',6,
 'Which sentence is in passive voice?',
 '{"options":["The chef cooked the meal.","The meal was cooked by the chef.","The chef is cooking the meal.","The chef had cooked the meal."]}','{"value":"The meal was cooked by the chef."}',
 'Passive voice: the subject (meal) receives the action.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Vocabulary',7,
 'Choose the word that means "to make something worse":',
 '{"options":["alleviate","exacerbate","mitigate","ameliorate"]}','{"value":"exacerbate"}',
 'Exacerbate means to make a problem or situation worse.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Apostrophes',6,
 'Which sentence uses apostrophes correctly?',
 '{"options":["The two girl''s bags were missing.","The two girls'' bags were missing.","The two girls bags'' were missing.","The two girl bags were missing."]}','{"value":"The two girls'' bags were missing."}',
 'Plural possessive: girls'' (apostrophe after the s for a plural noun).','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Spelling',6,
 'Which word is spelled correctly?',
 '{"options":["definately","definetly","definitely","definitly"]}','{"value":"definitely"}',
 'The correct spelling is "definitely." Remember: finite is inside the word.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Conjunctions',6,
 'Which type of conjunction is used in: "She studied hard so that she would pass the exam"?',
 '{"options":["Coordinating","Correlative","Subordinating","Correlating"]}','{"value":"Subordinating"}',
 '"So that" is a subordinating conjunction linking a dependent clause to the main clause.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Punctuation',7,
 'Which sentence uses a dash correctly?',
 '{"options":["The result — was — surprising to everyone.","The result was surprising — to everyone.","The result was surprising — no one expected it.","The result — was surprising to everyone"]}','{"value":"The result was surprising — no one expected it."}',
 'A dash can introduce additional information or a dramatic pause.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',7,'GRAMMAR_PUNCTUATION','Spelling',7,
 'Which word is spelled correctly?',
 '{"options":["occurance","occurence","occurrence","occurrance"]}','{"value":"occurrence"}',
 'The correct spelling is "occurrence" — double c, double r.','PUBLISHED');

-- ============================================================
-- YEAR 9 — NUMERACY
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Quadratics',8,
 'Solve x² − 5x + 6 = 0. What are the solutions?',
 '{"options":["x = 1 and x = 6","x = 2 and x = 3","x = −2 and x = −3","x = 2 and x = −3"]}','{"value":"x = 2 and x = 3"}',
 'Factor: (x−2)(x−3) = 0. Solutions x = 2 and x = 3.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Trigonometry',8,
 'In a right triangle with hypotenuse 10 and opposite side 6, what is sin θ?',
 '{"options":["0.4","0.5","0.6","0.8"]}','{"value":"0.6"}',
 'sin θ = opposite/hypotenuse = 6/10 = 0.6.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Linear Simultaneous',8,
 'Solve: x + y = 10 and x − y = 4. What is x?',
 '{"options":["5","6","7","8"]}','{"value":"7"}',
 'Add equations: 2x = 14, x = 7.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Surds',8,
 'Simplify: √50',
 '{"options":["5√2","10√5","5√10","25√2"]}','{"value":"5√2"}',
 '√50 = √(25×2) = 5√2.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Statistics',7,
 'A data set has mean 20 and median 18. The distribution is most likely:',
 '{"options":["Symmetric","Negatively skewed","Positively skewed","Uniform"]}','{"value":"Positively skewed"}',
 'Mean > median indicates a positive (right) skew.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Compound Interest',8,
 '$5000 is invested at 4% per annum compound interest for 2 years. What is the final amount?',
 '{"options":["$5400","$5408","$5416","$5500"]}','{"value":"$5408"}',
 'A = 5000 × (1.04)² = 5000 × 1.0816 = $5408.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Circle Geometry',8,
 'The circumference of a circle with radius 7 cm is closest to:',
 '{"options":["22 cm","44 cm","154 cm","49 cm"]}','{"value":"44 cm"}',
 'C = 2πr = 2 × 3.14 × 7 ≈ 43.96 ≈ 44 cm.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Probability',8,
 'A card is drawn from a standard 52-card deck. What is the probability of drawing a king or a heart?',
 '{"options":["4/52","17/52","16/52","13/52"]}','{"value":"16/52"}',
 'P(king ∪ heart) = 4/52 + 13/52 − 1/52 = 16/52. (1 king is also a heart, subtract overlap.)','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Indices',7,
 'Simplify: (2³)² ÷ 2⁴',
 '{"options":["2²","2³","2⁴","2⁵"]}','{"value":"2²"}',
 '(2³)² = 2⁶. 2⁶ ÷ 2⁴ = 2².','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'NUMERACY','Geometry',8,
 'A cylinder has radius 3 cm and height 10 cm. Its volume is closest to:',
 '{"options":["90 cm³","188 cm³","283 cm³","314 cm³"]}','{"value":"283 cm³"}',
 'V = πr²h = 3.14 × 9 × 10 ≈ 282.6 ≈ 283 cm³.','PUBLISHED');

-- ============================================================
-- YEAR 9 — READING
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,stimulus_text,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Critical Analysis',8,
 'The government''s proposal to ban single-use plastics has been met with both praise and criticism. Environmentalists argue it is a necessary step to reduce ocean pollution. However business groups warn of significant costs for manufacturers and consumers. Critics also question whether the ban will be enforced effectively.',
 'What is the author''s approach in this passage?',
 '{"options":["Strongly supporting the ban","Strongly opposing the ban","Presenting multiple perspectives","Focusing only on environmental benefits"]}','{"value":"Presenting multiple perspectives"}',
 'The passage presents arguments both for and against the ban — a balanced, informative approach.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Vocabulary in Context',8,
 'The politician''s rhetoric was designed to galvanise voters ahead of the election.',
 'What does "galvanise" mean in this context?',
 '{"options":["confuse","discourage","motivate into action","mislead"]}','{"value":"motivate into action"}',
 'Galvanise means to stimulate or energise someone into action.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Inference',8,
 'Despite her outward composure Isabella''s hands trembled slightly as she accepted the award. She had rehearsed this moment hundreds of times but nothing had prepared her for the reality of standing in front of so many people.',
 'How was Isabella most likely feeling?',
 '{"options":["Completely calm","Angry","Nervous despite appearing calm","Overwhelmed with sadness"]}','{"value":"Nervous despite appearing calm"}',
 'Trembling hands despite composure = nervous under the surface.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Language Techniques',8,
 'The factory belched toxic smoke day and night poisoning the air the children breathed.',
 'What technique is used with "belched"?',
 '{"options":["Simile","Personification","Alliteration","Onomatopoeia"]}','{"value":"Personification"}',
 '"Belched" gives the factory a human action, which is personification.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Comprehension',8,
 'Artificial intelligence is reshaping the labour market at an unprecedented rate. While AI creates new industries and roles it simultaneously renders certain jobs obsolete. Economists debate whether this disruption will ultimately benefit or harm workers in the long term.',
 'What is the central tension described in this passage?',
 '{"options":["AI is only beneficial","AI creates jobs while also eliminating them","Economists support AI fully","AI has had no impact on jobs so far"]}','{"value":"AI creates jobs while also eliminating them"}',
 'The passage describes AI creating new roles while rendering others obsolete — a central tension.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Authorial Intent',7,
 null,
 'An author who uses irony most likely wants to:',
 '{"options":["say exactly what they mean","create a straightforward description","highlight a contradiction between expectation and reality","provide factual information"]}','{"value":"highlight a contradiction between expectation and reality"}',
 'Irony highlights the gap between what is said/expected and what is actually true.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Vocabulary',7,
 null,
 'What does "ubiquitous" mean?',
 '{"options":["rare and unusual","present everywhere","extremely large","deeply important"]}','{"value":"present everywhere"}',
 'Ubiquitous means present, appearing, or found everywhere.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Argument Structure',8,
 'We must act on climate change now. The evidence is clear: global temperatures have risen 1.1°C since pre-industrial times. Extreme weather events are increasing in frequency and severity. Every year we delay action compounds the damage.',
 'What type of argument structure does this passage use?',
 '{"options":["Anecdote followed by conclusion","Evidence-based argument for immediate action","Comparison of two opposing views","Historical narrative"]}','{"value":"Evidence-based argument for immediate action"}',
 'The passage uses data and evidence to build a case for immediate action.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Comprehension',8,
 'The concept of a "digital divide" refers to the gap between those who have access to modern technology and those who do not. This divide exists along socioeconomic demographic and geographic lines and has significant implications for education employment and civic participation.',
 'What does the "digital divide" primarily describe?',
 '{"options":["The difference between digital and analogue technology","The unequal access to technology across different groups","The speed difference between internet providers","The gap between social media users and non-users"]}','{"value":"The unequal access to technology across different groups"}',
 'The passage defines it as a gap in access to technology along socioeconomic/geographic lines.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'READING','Tone',8,
 'After decades of inaction the committee finally — finally! — approved the long-overdue reforms.',
 'What tone does the repetition of "finally" suggest?',
 '{"options":["Neutral and objective","Frustrated relief","Formal and authoritative","Uncertain and hesitant"]}','{"value":"Frustrated relief"}',
 'Repeating "finally" with emphasis suggests the writer is relieved but frustrated by how long it took.','PUBLISHED');

-- ============================================================
-- YEAR 9 — GRAMMAR & PUNCTUATION
-- ============================================================
INSERT INTO questions (id,question_type,year_level,domain,topic,difficulty_band,question_text,options,correct_answer,explanation,status) VALUES
(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Vocabulary',8,
 'Which word means "to make something unclear or less understandable"?',
 '{"options":["elucidate","obfuscate","clarify","illuminate"]}','{"value":"obfuscate"}',
 'Obfuscate means to make confusing or unclear.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Complex Sentences',8,
 'Identify the subordinate clause: "Although the evidence was compelling, the jury remained undecided."',
 '{"options":["the jury remained undecided","Although the evidence was compelling","the evidence was compelling","remained undecided"]}','{"value":"Although the evidence was compelling"}',
 '"Although the evidence was compelling" is a subordinate clause — it cannot stand alone as a sentence.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Spelling',8,
 'Which word is spelled correctly?',
 '{"options":["conscientious","consciencious","conciencious","consciencous"]}','{"value":"conscientious"}',
 'The correct spelling is "conscientious."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Punctuation',8,
 'Which sentence correctly uses parentheses?',
 '{"options":["The report (which was released last week, showed promising results.","The report (which was released last week) showed promising results.","The report which (was released last week) showed promising results.","The (report which was released last week) showed promising results."]}','{"value":"The report (which was released last week) showed promising results."}',
 'Parentheses enclose supplementary information as a complete aside within the sentence.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Vocabulary',7,
 'What does "pragmatic" mean?',
 '{"options":["idealistic","practical and realistic","traditional","creative"]}','{"value":"practical and realistic"}',
 'Pragmatic means dealing with things sensibly and realistically.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Modifiers',8,
 'Identify the dangling modifier: "Running down the street, the bus drove away."',
 '{"options":["the bus drove away","Running down the street","down the street","drove away"]}','{"value":"Running down the street"}',
 '"Running down the street" dangles — it implies the bus was running, not a person.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Spelling',8,
 'Which word is spelled correctly?',
 '{"options":["seperate","seprate","separate","seperrate"]}','{"value":"separate"}',
 'The correct spelling is "separate." Remember: there is "a rat" in separate.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Grammar',8,
 'Choose the sentence with correct grammar:',
 '{"options":["Between you and I, this is wrong.","Between you and me, this is wrong.","Between you and myself, this is wrong.","Between I and you, this is wrong."]}','{"value":"Between you and me, this is wrong."}',
 '"Between" is a preposition requiring an object pronoun: "me," not "I."','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Vocabulary',8,
 'What does "sycophantic" mean?',
 '{"options":["overly critical","excessively flattering to gain favour","completely honest","deeply thoughtful"]}','{"value":"excessively flattering to gain favour"}',
 'Sycophantic means acting in an obsequious, flattering way to gain favour.','PUBLISHED'),

(uuid_generate_v4(),'MULTIPLE_CHOICE',9,'GRAMMAR_PUNCTUATION','Punctuation',8,
 'Which sentence correctly uses an em dash?',
 '{"options":["She had one goal—win.","She had one goal — win —.","She—had one goal win.","She had—one goal win."]}','{"value":"She had one goal—win."}',
 'An em dash can introduce an emphatic afterthought or appositive.','PUBLISHED');
