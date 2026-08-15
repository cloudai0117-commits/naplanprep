-- V379: Replace all AUDIO_RESPONSE Spelling questions with text-based SHORT_ANSWER
-- Audio delivery is not implemented; product decision is text-only spelling for UAT.
-- S1/S2A/S2B testlets: SHORT_ANSWER sentence-completion
-- S3A/S3B testlets:    MULTIPLE_CHOICE proofreading (unchanged -- already text-based)

-- ============================================================
-- PART A: Y3 FREE (25 questions, existing words kept)
-- ============================================================
UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ the bell and knew it was time for class.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '97c5b0b6-c05a-5c91-bdef-8035384f33f0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her whole __________ came to watch her receive the award.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '944badf9-b808-5ec0-b2bc-c108c3362143';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She only needed one __________ to solve the puzzle.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6cd76009-ec2b-5ed9-b3be-6433dce936e6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Reading is her __________ thing to do after school.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '778f9519-aaad-5dcc-9593-684f52d44e05';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They drove through the __________ on the way to Grandma''s.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6691f0c8-a80c-5a89-acd7-8cca40b11f8a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student chose a __________ book for the reading project.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6ee64c40-aa99-5d09-82b5-4e68d76ec0b6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The long __________ finally ended when they saw the ocean.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aa5edf21-b3f2-571e-89ad-61193e9eb6cf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ packs her bag the night before school.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bea8e99c-7e71-59de-992a-936eef22cf57';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She stayed inside __________ it was raining heavily.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3b31b47f-9407-57d2-8418-65a0c7deebaf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She looked forward to going to __________ every morning.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '53f9d67e-78bb-549e-ad5e-d3d47adacca8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She sat next to her best __________ at the concert.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c07f6b36-f03a-55e4-ab14-b8ce250e6bf2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher gave each student a __________ sticker for effort.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd3a0b8ba-4841-574f-9c94-468a996e84ff';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many __________ came to watch the school performance.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '835c4629-74c5-5c08-8701-f5d3fc675f4e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She arrived __________ to get a good seat at assembly.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '46e903e7-9af0-568e-8f3e-b504402024bc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The award came as a total __________ to the student.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fa2dc685-42cc-5d2d-b002-1dd45de5a5a9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to read the question carefully first.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ec32a7db-56d1-50d8-9063-f33a165548d9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Cold __________ made everyone reach for a warm jumper.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ad56c3ac-9065-5255-812a-3cd54c541ab1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She did not know the __________ to the last question.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '13d2fdc4-cc7b-5a52-845a-e5dd24b650a7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She planned to finish the project __________ after breakfast.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7cd51d2-eae3-5f48-8656-5bfc3834d3b2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She borrowed three books from the school __________ today.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '49886271-9f9a-548e-a430-a635e49aeebb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class worked __________ to finish the mural.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7749509d-013f-5cbd-bb8a-6813eb8d7e59';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The best way to __________ spelling is to practise daily.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '192c8e42-3dd1-528f-a155-a3976bd636d3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden looked __________ after all the spring rain.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '974f2a6a-bcdf-5e0e-aea2-5a2e5abf4a18';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She did not have __________ time to finish the last question.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '83c4f5ea-4013-5777-8670-a40480692cb4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ to bring your library bag tomorrow.',
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd95c053d-27d6-5cbc-8860-80a354cdc3b3';

-- ============================================================
-- PART B: Y7/Y9 (119 unique words, CASE on correct_answer value)
-- ============================================================
UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = CASE correct_answer->>'value'
    WHEN 'accommodate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The hotel can __________ up to two hundred guests in its conference rooms.'
    WHEN 'achievement' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Winning the regional award was a major __________ for the whole team.'
    WHEN 'acquaintance' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She met a friendly __________ at the community library last week.'
    WHEN 'ambiguous' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions were __________ so the students asked the teacher to clarify.'
    WHEN 'appropriate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure your language is __________ for a formal written response.'
    WHEN 'architecture' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The old town hall is a fine example of colonial __________ in Australia.'
    WHEN 'argument' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She constructed a well-supported __________ using evidence from the text.'
    WHEN 'beginning' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

At the __________ of the novel the main character feels completely lost.'
    WHEN 'beneficial' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Regular exercise is __________ for both physical and mental health.'
    WHEN 'boundary' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The surveyor confirmed the exact __________ between the two properties.'
    WHEN 'bureaucracy' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The lengthy approval process was a typical example of government __________.'
    WHEN 'calendar' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mark the assignment due dates clearly on your __________ at the start of term.'
    WHEN 'category' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each entry was placed in the correct __________ before judging began.'
    WHEN 'committee' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school __________ approved the new uniform policy last month.'
    WHEN 'communicate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is important to __________ clearly in both written and spoken English.'
    WHEN 'competition' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The annual science __________ attracted entries from over fifty schools.'
    WHEN 'conscience' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ would not allow her to take credit for someone else''s idea.'
    WHEN 'conscious' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ that the audience was watching her every move.'
    WHEN 'consequence' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

There is always a __________ when rules are broken deliberately.'
    WHEN 'convenient' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new timetable was very __________ for students who catch public transport.'
    WHEN 'coordinate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The event manager needed to __________ volunteers across five different venues.'
    WHEN 'curiosity' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her natural __________ led her to research the topic far beyond what was required.'
    WHEN 'deficiency' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A vitamin D __________ can sometimes cause fatigue and muscle weakness.'
    WHEN 'definite' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

There was no __________ answer to the ethical question they were debating.'
    WHEN 'description' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her vivid __________ of the setting made the reader feel they were really there.'
    WHEN 'desirable' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Strong communication skills are highly __________ in any workplace.'
    WHEN 'desperate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The team made a __________ attempt to score in the final seconds of the match.'
    WHEN 'discipline' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Success in competitive sport requires tremendous self-__________.'
    WHEN 'ecological' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The development project raised concerns about its __________ impact on the wetland.'
    WHEN 'embarrass' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She did not want to __________ her friend by pointing out the error in public.'
    WHEN 'enthusiasm' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The young teacher brought great __________ to every lesson she prepared.'
    WHEN 'environment' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Protecting the __________ is a responsibility shared by every generation.'
    WHEN 'equipment' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

All laboratory __________ must be checked and signed back in after use.'
    WHEN 'exaggerate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Effective persuasive writing should not __________ the evidence it uses.'
    WHEN 'existence' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists continue to debate the __________ of water on other planets.'
    WHEN 'experience' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Travelling broadened her __________ and changed the way she viewed the world.'
    WHEN 'explanation' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her clear __________ helped everyone in the group understand the process.'
    WHEN 'exposure' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Long-term __________ to fine particles can affect respiratory health.'
    WHEN 'familiar' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The tune sounded __________ even though she could not remember where she had heard it.'
    WHEN 'frequent' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ revision is far more effective than cramming the night before.'
    WHEN 'generous' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The community was incredibly __________ in its support for the flood appeal.'
    WHEN 'government' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The state __________ announced new funding for regional schools last Tuesday.'
    WHEN 'guarantee' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Hard work does not always __________ success but it certainly improves the odds.'
    WHEN 'harassment' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school has a clear policy that prohibits bullying and __________ of any kind.'
    WHEN 'identity' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The novel explores questions of cultural __________ and belonging.'
    WHEN 'illustration' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ on the cover of the book captured the theme perfectly.'
    WHEN 'imagination' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her vivid __________ allowed her to create a world that felt entirely real.'
    WHEN 'immediate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The team''s __________ response to the situation prevented any serious harm.'
    WHEN 'independent' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Australia became a fully __________ nation at Federation in 1901.'
    WHEN 'indispensable' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A good dictionary is __________ for any serious student of writing.'
    WHEN 'initiative' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She showed real __________ by organising the event without being asked.'
    WHEN 'interfere' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is not helpful to __________ when two people are trying to resolve a disagreement.'
    WHEN 'knowledge' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Deep __________ of a subject comes from reading widely and thinking critically.'
    WHEN 'language' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She studied three foreign __________ during her time at secondary school.'
    WHEN 'leisure' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

In her __________ time she enjoyed hiking in national parks near the city.'
    WHEN 'liaison' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She acted as the __________ between the school council and the teaching staff.'
    WHEN 'library' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school __________ holds an impressive collection of non-fiction resources.'
    WHEN 'literature' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Great __________ explores universal themes that transcend time and culture.'
    WHEN 'maintenance' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Regular __________ of the equipment prevents costly breakdowns.'
    WHEN 'marvellous' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The view from the summit was absolutely __________ after the long climb.'
    WHEN 'millennium' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The ancient city had stood for more than a __________ when it was finally abandoned.'
    WHEN 'miniature' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She painted a __________ portrait of the landscape in extraordinary detail.'
    WHEN 'mischievous' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ puppy had chewed through the shoelaces of every pair in the house.'
    WHEN 'necessary' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to cite your sources at the end of any research essay.'
    WHEN 'noticeable' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her improvement in reading fluency was __________ after just six weeks of practice.'
    WHEN 'occasionally' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ stayed late to help the teacher prepare resources for the class.'
    WHEN 'occurred' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The most significant breakthrough __________ late in the second year of the project.'
    WHEN 'occurrence' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

An unusual __________ in the data suggested the scientists had found something new.'
    WHEN 'opportunity' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She seized every __________ to improve her public speaking skills.'
    WHEN 'organisation' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school fete required remarkable __________ from the parent community.'
    WHEN 'original' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ approach to the problem impressed the entire judging panel.'
    WHEN 'parallel' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The two storylines developed in __________ until they merged in the final chapter.'
    WHEN 'parliament' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Members of __________ debated the proposed changes to the education legislation.'
    WHEN 'permanent' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new road markings were designed to be __________ rather than temporary.'
    WHEN 'persuade' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She used detailed evidence to __________ the committee to change its decision.'
    WHEN 'persuasive' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ argument relies on credible evidence rather than emotional appeals.'
    WHEN 'physical' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Regular __________ activity is essential for maintaining good health.'
    WHEN 'possible' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to disagree respectfully without damaging the relationship.'
    WHEN 'preference' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student was asked to state their __________ for the end-of-year excursion.'
    WHEN 'prejudice' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Critical thinking helps us identify and challenge __________ in the sources we read.'
    WHEN 'privilege' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Access to quality education is a __________ that not everyone in the world enjoys.'
    WHEN 'pronunciation' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Correct __________ of technical terms is important in a formal oral presentation.'
    WHEN 'questionnaire' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students were asked to complete an anonymous __________ about school wellbeing.'
    WHEN 'receipt' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Keep the __________ in case you need to return or exchange the item.'
    WHEN 'recognise' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could __________ the author''s distinctive style from the very first paragraph.'
    WHEN 'recommend' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The librarian was happy to __________ books suited to each student''s reading level.'
    WHEN 'recommendation' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The panel''s __________ was accepted by the board without further discussion.'
    WHEN 'relevant' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Include only __________ evidence when constructing a well-argued essay response.'
    WHEN 'responsible' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every student is __________ for handing in their own original work.'
    WHEN 'restaurant' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The local __________ donated meals for the school fundraising evening.'
    WHEN 'rhythm' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could feel the __________ of the poem as she read it quietly to herself.'
    WHEN 'schedule' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The revised examination __________ was posted on the school website on Monday.'
    WHEN 'separate' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your recyclable materials before placing them in the correct bin.'
    WHEN 'signature' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each permission note required a parent or guardian''s __________.  '
    WHEN 'sincerely' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A formal letter should end with Yours __________ followed by your name.'
    WHEN 'strength' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Resilience is a __________ that helps people recover from difficult experiences.'
    WHEN 'successful' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ in the competition because she had prepared so thoroughly.'
    WHEN 'sufficient' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Ensure that you have __________ time allocated to check your work at the end.'
    WHEN 'suggestion' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher welcomed every __________ about how to improve the classroom routine.'
    WHEN 'supersede' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

New regulations will eventually __________ the outdated guidelines currently in use.'
    WHEN 'surprise' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The announcement came as a complete __________ to the student community.'
    WHEN 'technique' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She developed a reliable __________ for planning her essay responses under pressure.'
    WHEN 'temperature' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of the solution must remain constant throughout the experiment.'
    WHEN 'threshold' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She stood on the __________ of a major decision that would shape her future.'
    WHEN 'throughout' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The theme of resilience runs __________ the entire novel.'
    WHEN 'tomorrow' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The results of the competition will be announced __________ at the school assembly.'
    WHEN 'unnecessary' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Avoid __________ repetition when editing your written work.'
    WHEN 'vacuum' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ is created when all air is removed from an enclosed space.'
    WHEN 'valuable' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Feedback from the judges proved __________ for improving her next submission.'
    WHEN 'variety' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Reading a wide __________ of texts helps develop a more sophisticated writing style.'
    WHEN 'vegetable' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She grew every __________ in the school garden from seed to harvest.'
    WHEN 'vehicle' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Electric __________ technology is advancing rapidly across the global market.'
    WHEN 'visible' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The mountains were clearly __________ from the city on a clear winter morning.'
    WHEN 'weird' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ sound coming from the old building turned out to be a family of bats.'
    WHEN 'whether' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could not decide __________ to take the advanced class or leave it until next year.'
    WHEN 'wholly' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The decision was not __________ satisfactory but it was the best available option.'
    WHEN 'wilderness' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The national park preserves one of the last areas of true __________ in the state.'
    WHEN 'yacht' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sleek __________ sailed into the harbour just as the sun was setting.'
    WHEN 'zealous' THEN 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was a __________ advocate for environmental protection throughout her career.'
    ELSE question_text
  END,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE question_type = 'AUDIO_RESPONSE'
  AND year_level IN (7, 9);

-- ============================================================
-- PART C: Y3 ADVANCED + PREMIUM (375 questions)
-- ============================================================
UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had to read the instructions __________ to understand them.',
  correct_answer = '{"value": "again"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b3061f9b-4b88-56af-8e5f-88c1db1b67f0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked __________ the beach collecting shells.',
  correct_answer = '{"value": "along"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b2ec0a08-50c4-5181-b3b6-7955114ea807';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He __________ washes his hands before eating.',
  correct_answer = '{"value": "always"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e6211412-fe50-5660-9442-176a44157c79';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ at the zoo was very friendly.',
  correct_answer = '{"value": "animal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ded28719-9f36-5021-b0a0-ecaa327affd2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can I have __________ piece of cake please?',
  correct_answer = '{"value": "another"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6be80a9c-ca6a-594c-818d-123595bde97a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children ran __________ the oval at lunchtime.',
  correct_answer = '{"value": "around"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '16b691d4-8e82-5c5d-926f-608245c88266';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked hard to __________ a great swimmer.',
  correct_answer = '{"value": "become"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '84ad68a3-8c57-571c-9a7f-166d21e6652f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please wash your hands __________ you eat lunch.',
  correct_answer = '{"value": "before"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb8e51dd-c447-560c-a9bd-8c2be4fc583b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The fish swam __________ the surface of the water.',
  correct_answer = '{"value": "below"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '121a10d4-582d-5c6b-820b-435baed974d6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The park is __________ the school and the shops.',
  correct_answer = '{"value": "between"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '56922d6e-ce88-591a-abd7-4af913555684';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum __________ a new book for the class library.',
  correct_answer = '{"value": "bought"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1bc37701-93de-5a6f-9ad6-6a8211189a1f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They used blocks to __________ a tall tower.',
  correct_answer = '{"value": "build"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8aa1bc92-f0f9-54d8-b3c3-589c6aa0453c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher was very __________ marking the tests.',
  correct_answer = '{"value": "busy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5ef6ec7a-ee89-5557-8f5d-3feadc83e212';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Be __________ when you cross the road.',
  correct_answer = '{"value": "careful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8f13ca61-de4f-5dd3-9531-dabc5420b22d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped her brother __________ the heavy bag.',
  correct_answer = '{"value": "carry"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '98fadfd2-2c38-5f99-af6a-8fe5ccb37142';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ very quickly in spring.',
  correct_answer = '{"value": "change"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b40119a7-88c1-57a5-ae6e-0f3ffdea1f96';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ played happily in the playground.',
  correct_answer = '{"value": "children"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '836871ad-97d9-5bd3-853a-ad33656794f5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to __________ the classroom before we leave.',
  correct_answer = '{"value": "clean"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1e1b920c-2f86-55e6-b644-b09f36da02d6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the door quietly behind you.',
  correct_answer = '{"value": "close"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '03b35601-7fa7-5f2b-ac23-733b2863b40f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her favourite __________ is bright blue.',
  correct_answer = '{"value": "colour"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7c57191-2738-532e-9ece-67996299e99b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ hear the birds singing outside.',
  correct_answer = '{"value": "could"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '48b15652-9f12-53b5-8a9f-779bd2ff7d0e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use a __________ to protect your book.',
  correct_answer = '{"value": "cover"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eadc263b-ebc8-522d-b762-2b81bc377877';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It was hard to __________ which book to read first.',
  correct_answer = '{"value": "decide"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '69b17cb5-4787-50cb-8ece-893a9b5b2668';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The whole family sat together for __________.',
  correct_answer = '{"value": "dinner"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '79bdb9ef-f3bf-5baf-9d7c-0985d42cf41b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We must be quiet __________ the performance.',
  correct_answer = '{"value": "during"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fdff66f8-337d-540e-b821-2b3d4eb71975';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You can sit on __________ side of the table.',
  correct_answer = '{"value": "either"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5272818c-88ff-50f0-b755-1bb071ada3ac';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students __________ art class on Friday afternoons.',
  correct_answer = '{"value": "enjoy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fa3be842-ba8d-5f5c-82e3-a27c3d7458d1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She reads for thirty minutes __________ evening.',
  correct_answer = '{"value": "every"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e09073f5-750e-572d-afbb-8a034eb7230b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ clapped when the play was finished.',
  correct_answer = '{"value": "everyone"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '052199f8-ba5c-5b33-b9dc-d3a47c74b833';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the instructions on the board.',
  correct_answer = '{"value": "follow"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2dfe8b63-ac4b-5d13-86b0-f7dc29108bf4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We have sport on __________ afternoon.',
  correct_answer = '{"value": "Friday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2909f00b-1cdb-5ec1-a108-e79207b8ae97';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum planted flowers in the front __________.',
  correct_answer = '{"value": "garden"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'db495a50-8291-5338-baaa-2a1e5070750c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He is __________ better at spelling every week.',
  correct_answer = '{"value": "getting"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '28288005-2f7a-597a-85d3-52bccf933416';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The leaves fell to the __________ in autumn.',
  correct_answer = '{"value": "ground"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ad064b29-d1dd-58b9-97cf-22c23556858d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Work with your __________ to solve the problem.',
  correct_answer = '{"value": "group"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f74eeb93-026a-5cae-bf3c-44a55acf7a2c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She felt __________ when she got full marks.',
  correct_answer = '{"value": "happy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1d8ac6da-f0f3-5fa4-af2d-742f09ba0915';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We are __________ a picnic in the park today.',
  correct_answer = '{"value": "having"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c103047e-18b2-51a0-8ac8-fb853d6c1236';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The box of books was too __________ to lift.',
  correct_answer = '{"value": "heavy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9aabf658-e3cf-5f77-bec7-df12e8acb339';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to check your work when you finish.',
  correct_answer = '{"value": "helpful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f617d3c8-513c-5e71-ae99-b68854bccf05';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We went to the beach during the school __________.',
  correct_answer = '{"value": "holiday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2fefd6ab-a1f8-51c2-913c-947e89bb9a37';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She learned to ride a __________ at the farm.',
  correct_answer = '{"value": "horse"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '24c06e62-1895-5992-9065-7a6d9660af07';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The old __________ at the end of the street has a red door.',
  correct_answer = '{"value": "house"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '123b7282-d16f-57b1-932b-661a5788ffd8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had a great __________ for the science project.',
  correct_answer = '{"value": "idea"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2bf8323e-8dfd-530f-83ad-4518066d9402';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We played games __________ because it was raining.',
  correct_answer = '{"value": "inside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dcc88f26-e2aa-5d1f-8f86-39f74405d34d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He chose water __________ of juice with his lunch.',
  correct_answer = '{"value": "instead"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0b0244ed-9a17-58db-920a-152571a3a2f9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The tiny __________ was surrounded by clear blue water.',
  correct_answer = '{"value": "island"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4d6ea709-2639-5268-aace-45ea73170ca1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The frog could __________ very high for its size.',
  correct_answer = '{"value": "jump"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '462e4ea7-08a3-50fa-952a-78d7a94ad286';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your workspace tidy during the lesson.',
  correct_answer = '{"value": "keep"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '70e5a9fe-049c-5601-b27b-75076852f217';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is important to be __________ to others.',
  correct_answer = '{"value": "kind"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6b60f70b-9438-5ecc-8c32-1f08c122da81';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The elephant has __________ ears that help it stay cool.',
  correct_answer = '{"value": "large"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c82537e3-6efd-5056-8b46-8ca2b175195c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We will finish the activity __________ this afternoon.',
  correct_answer = '{"value": "later"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a18356fe-7216-50be-a7f2-6af692413b05';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to use __________ three new words in her story.',
  correct_answer = '{"value": "least"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9ddc91cc-efe5-539e-82f0-ed682aa0cd8e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He wrote a __________ to his pen pal in another state.',
  correct_answer = '{"value": "letter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7a3630d4-fc8c-5e27-9e14-d0876ab27dfd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The author __________ near the ocean and writes about the sea.',
  correct_answer = '{"value": "lives"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '40cbec9c-f28c-5dcf-8eae-ec21fd0dfbb9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ both ways before crossing the road.',
  correct_answer = '{"value": "looked"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4a4532fb-9508-522a-b211-6813e44f2bfd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We eat __________ in the undercover area on rainy days.',
  correct_answer = '{"value": "lunch"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '908d1999-27fd-5631-97d8-a67fa4ad7c04';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story was full of __________ and adventure.',
  correct_answer = '{"value": "magic"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0ef62e0e-a824-5faa-b23e-c3be38be0018';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She enjoyed __________ cards for her friends.',
  correct_answer = '{"value": "making"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b329710f-ac16-53c9-ac8d-7134264fac0e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It does not __________ who goes first in the game.',
  correct_answer = '{"value": "matter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4220a0b-8a81-5e9c-a21c-2f6216f71892';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ we will go to the park after school today.',
  correct_answer = '{"value": "maybe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e88ed28f-fd63-5e34-a5c5-ed5076a58501';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher asked her to stand in the __________ of the circle.',
  correct_answer = '{"value": "middle"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9d0552c2-a231-5502-afd1-7d127bb178e3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit Grandma on the weekend.',
  correct_answer = '{"value": "might"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9adb58f5-e175-51a1-a4a7-ec0b784c3bf1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Wait just a __________ while I find the right page.',
  correct_answer = '{"value": "moment"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8e1a9403-be9b-5286-8e43-83e1786e257f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new term starts on __________ morning.',
  correct_answer = '{"value": "Monday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2f004f6e-08ad-55c9-a761-77083f78a19c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She saved her pocket __________ to buy a new book.',
  correct_answer = '{"value": "money"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '95f37809-65a4-5cae-95ae-19c53ae5ff89';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We do spelling practice every __________ after assembly.',
  correct_answer = '{"value": "morning"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '71ace999-cc22-5a36-96fb-006d44b23fd4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her practise reading each night.',
  correct_answer = '{"value": "mother"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ce690882-26f4-5b27-acd8-33f51326df27';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The puppy kept __________ and would not sit still.',
  correct_answer = '{"value": "moving"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a6e5f81e-8bae-54e9-9e30-e84360046cb8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

I built the model aeroplane all by __________.',
  correct_answer = '{"value": "myself"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '68a85588-4a7b-5b72-a7f5-f53e486936c1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has __________ missed a day of school this term.',
  correct_answer = '{"value": "never"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb39a0e4-0028-51d2-987f-a92940cc776f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

There was __________ left in the lunchbox after recess.',
  correct_answer = '{"value": "nothing"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5f0427a1-4a41-56e9-b8e2-696e3626a333';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your name and class __________ on the front page.',
  correct_answer = '{"value": "number"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4c538d27-b63f-59bf-9bcd-459ea0ba5069';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit the library to choose new books.',
  correct_answer = '{"value": "often"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c3c93f1c-9c53-50bc-bd84-e1ca4e606fd6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ upon a time there was a kind young girl.',
  correct_answer = '{"value": "once"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bb3e159d-00f7-5055-a0e4-4a7f82623139';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your books to page twenty-three.',
  correct_answer = '{"value": "open"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '36607ec1-1e2a-5538-8f53-82f68ea94b4c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can you think of an __________ word for happy?',
  correct_answer = '{"value": "other"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '103e4e38-4cf5-57ac-af60-47bcb497b22c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class moved __________ to finish their sketches.',
  correct_answer = '{"value": "outside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '81f65513-5a8e-5067-a29e-80a366569e62';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She folded the __________ carefully to make a boat.',
  correct_answer = '{"value": "paper"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd26132bf-4a0b-55fc-a31c-453a4ca5444e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each __________ was invited to attend the information night.',
  correct_answer = '{"value": "parent"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aae4d69b-4f06-57e8-bbb7-30b50397f5a2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The library is her favourite __________ to read.',
  correct_answer = '{"value": "place"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cd541bcd-04b3-5dd1-9bec-ca64a499bc16';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She watered the __________ every morning before school.',
  correct_answer = '{"value": "plant"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bc0f1e33-a01d-5589-9766-cab15e1fefca';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ remember to bring your permission note tomorrow.',
  correct_answer = '{"value": "please"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f32d9952-627b-5a25-a856-fd29eb8c9c7a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden looked __________ after all the rain.',
  correct_answer = '{"value": "pretty"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2a34141b-b670-5d17-bac8-6568ec74dfcb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked through the maths __________ step by step.',
  correct_answer = '{"value": "problem"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8765af9b-4f58-58a5-9cc3-ccff40c4ee6e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to be __________ or we will miss the bus.',
  correct_answer = '{"value": "quick"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f9c8c3b9-1fe4-5d83-8c85-f91eaed06d4a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The classroom became __________ when the teacher arrived.',
  correct_answer = '{"value": "quiet"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '396af369-7ae4-5553-8da9-dc5c480b1ac5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new student found the test __________ easy.',
  correct_answer = '{"value": "quite"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8daf4443-f4c4-51bb-b7dd-57d9fb9c9edb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ pleased with her work this term.',
  correct_answer = '{"value": "really"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1bb70e51-c7f4-5f4f-974b-2d7e25608469';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure you use the __________ tool for the job.',
  correct_answer = '{"value": "right"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5b306bf9-f2b4-566d-b968-29276573d787';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They spotted a platypus in the shallow __________.',
  correct_answer = '{"value": "river"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'be075377-de48-5744-9aca-86860e8ac676';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children sat in a __________ circle on the mat.',
  correct_answer = '{"value": "round"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0cbf1d36-4576-5108-8865-9c5253bef92a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He enjoys __________ with his dog in the park.',
  correct_answer = '{"value": "running"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd2bd6d9d-bcac-5a94-a034-6d71398f718e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She came __________ in the cross-country race.',
  correct_answer = '{"value": "second"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4e79c579-0282-56bb-b6e8-3e1ec97f9d4e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sun started to __________ after the morning clouds cleared.',
  correct_answer = '{"value": "shine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5d692cd1-fad8-54f9-bd01-2d016f9ca62c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions were clear and __________ to follow.',
  correct_answer = '{"value": "simple"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '01c62dd7-243d-5263-9d8d-6e617cf7d050';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has loved reading __________ she was very young.',
  correct_answer = '{"value": "since"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9f015c97-f526-5fc0-a659-ba8b988514cc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her choose a book from the shelf.',
  correct_answer = '{"value": "sister"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c3e8883a-e464-541a-b3eb-7f4a4fc17a28';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ bird built its nest in the garden hedge.',
  correct_answer = '{"value": "small"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '14cc1a52-d837-5f18-80e7-046148ab0291';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She felt __________ was wrong as soon as she arrived.',
  correct_answer = '{"value": "something"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '53eb4f3d-2ab4-5024-acc7-769c181bd6dc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ it is hard to concentrate on a hot afternoon.',
  correct_answer = '{"value": "sometimes"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '96503a18-1e5c-526c-bbff-4b0018976e5f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of the bell meant it was time for lunch.',
  correct_answer = '{"value": "sound"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0f6f7139-6675-57e7-ae87-7303a975e5c0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project __________ well but needed more planning.',
  correct_answer = '{"value": "started"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '15922aa3-8b2d-539b-ad45-559d72ec6f13';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Stand __________ while I measure your height.',
  correct_answer = '{"value": "still"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c1e82ffe-5dc6-5bae-bf58-595343a0bc95';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ brought heavy rain and strong winds overnight.',
  correct_answer = '{"value": "storm"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '514de4ee-4ca6-5df0-8d8d-797a11f342c3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote a fantastic __________ about a lost puppy.',
  correct_answer = '{"value": "story"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f3ebaa5c-1eba-5e09-8ba9-4cdc1f037f4d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked down the main __________ looking for the shop.',
  correct_answer = '{"value": "street"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8db67e9a-d6e2-552f-a7e4-b5bcc7efab93';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to be __________ and brave when things get hard.',
  correct_answer = '{"value": "strong"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '37ecd688-5245-5268-ae18-6e637dbb88e1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every __________ received a certificate at the assembly.',
  correct_answer = '{"value": "student"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bee61152-5002-5778-a08e-1661a67a4933';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the lights went out during the show.',
  correct_answer = '{"value": "suddenly"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eec59e5e-00f2-5769-9903-0e9fd70f775c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please clear everything off the __________ before dinner.',
  correct_answer = '{"value": "table"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'de2185d5-5803-5263-bddc-4a3cf84504ac';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

All the library books had been __________ out already.',
  correct_answer = '{"value": "taken"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '11f382e0-f2ef-5c4b-bd88-df2ee91f74df';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She left her pencil case over __________ by the window.',
  correct_answer = '{"value": "there"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7e1c3cf2-48e6-56d0-86d7-29d92334a9de';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Take a moment to __________ before you answer the question.',
  correct_answer = '{"value": "think"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1b7bc871-0210-52e0-9f39-d6b030761997';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read __________ chapters of the book before bed.',
  correct_answer = '{"value": "three"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1c0019db-8ef5-51d0-80a4-11e1e55a0e05';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked __________ the park to get to school faster.',
  correct_answer = '{"value": "through"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '497b9ca1-352f-55fa-aa4d-7656a8d71819';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We are presenting our projects __________ after recess.',
  correct_answer = '{"value": "today"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a3758cfd-2142-59c0-b618-3b5f8391b044';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The small __________ had one school and one library.',
  correct_answer = '{"value": "town"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1c0715f7-a276-5d44-98df-cb91af93d2d2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ her best even when the task was hard.',
  correct_answer = '{"value": "tried"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '731f75ac-eb36-515e-bae9-b47c19906cc8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dog hid __________ the table during the thunderstorm.',
  correct_answer = '{"value": "under"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '401dde50-1ddc-5182-bdde-86b17b5f1d08';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised __________ she had every word perfect.',
  correct_answer = '{"value": "until"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '871efb37-d857-5a7b-bfc4-8640b2da11b9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She climbed __________ the hill to see the view.',
  correct_answer = '{"value": "upon"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '500388f9-c0c4-5f47-be47-2bf0c2434d39';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We will __________ the museum as part of our excursion.',
  correct_answer = '{"value": "visit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4cf8930b-6710-5698-b597-28332fad3cdd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher spoke in a calm __________ during the lesson.',
  correct_answer = '{"value": "voice"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '24668c21-5c6f-537a-b3dd-d82d57cf79bc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They __________ to school together every morning.',
  correct_answer = '{"value": "walked"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cbbc656f-9f70-5842-9c0f-90c0016acadd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Remember to drink enough __________ during the hot day.',
  correct_answer = '{"value": "water"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1a2b3cb8-9bf2-5f28-b63e-760ef2b94876';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She likes to __________ nature documentaries on the weekend.',
  correct_answer = '{"value": "watch"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '146a0753-0910-5613-bec2-839d5749ad46';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read her book __________ her brother played outside.',
  correct_answer = '{"value": "while"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a29d9dd3-eaa1-5a66-abc3-b42e59c7c24a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The snow looked bright and __________ in the morning sun.',
  correct_answer = '{"value": "white"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0be19e5a-6030-59ea-ae2c-4b3996772119';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ class worked together to clean the room.',
  correct_answer = '{"value": "whole"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5d35dbdf-f380-597f-bbc4-4732f49f9ae5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She looked out the __________ at the rainy playground.',
  correct_answer = '{"value": "window"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '070b02e3-2fbc-50ec-bab9-c18779044c7a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

In __________ they wore thick jumpers and coats.',
  correct_answer = '{"value": "winter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e7c05d48-0bcc-5f55-ab7d-b9d1bd2bb5b7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could not finish the puzzle __________ help.',
  correct_answer = '{"value": "without"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ccb7dc66-9660-5836-87f3-5f298550220b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She added a new __________ to her vocabulary list each day.',
  correct_answer = '{"value": "word"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'de4eeb54-3dfa-51cf-a0b1-a01b067333e2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wanted to travel and see the __________ one day.',
  correct_answer = '{"value": "world"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5eee10d8-e6fa-5cc2-a6c9-603b428ac4eb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He practised how to __________ neatly in his journal.',
  correct_answer = '{"value": "write"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f98099cb-e995-5233-ab09-dc13e5f845b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ a thank-you letter to her teacher.',
  correct_answer = '{"value": "wrote"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8e93fab4-0b70-598c-b8e3-16c55f87c28a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They have been best friends since their first __________ at school.',
  correct_answer = '{"value": "year"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cfb55baf-4dc7-53ec-adb1-933474da70a0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Even __________ children can learn to be kind.',
  correct_answer = '{"value": "young"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '054c2028-9bc4-5330-a3f8-6791a8e889b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Is this pencil case __________ or your classmate''s?',
  correct_answer = '{"value": "yours"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fc321ff5-3925-5b77-b07e-e5cf33a77f3f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had to read the instructions __________ to understand them.',
  correct_answer = '{"value": "again"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fb150a18-edc4-5a74-ad93-1338d3d02a87';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked __________ the beach collecting shells.',
  correct_answer = '{"value": "along"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '45dc3cd7-de66-51c8-b05d-6439c4637d49';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He __________ washes his hands before eating.',
  correct_answer = '{"value": "always"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1b8c6dc2-9187-5dae-b416-11196f5ebf8c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ at the zoo was very friendly.',
  correct_answer = '{"value": "animal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '50970d1d-8494-5333-8e51-57ea826c3a32';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can I have __________ piece of cake please?',
  correct_answer = '{"value": "another"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5543544c-345e-5ca4-a21f-31e89630ce0d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children ran __________ the oval at lunchtime.',
  correct_answer = '{"value": "around"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ae1d8bf4-e3fa-5b75-9d60-dec6638706de';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked hard to __________ a great swimmer.',
  correct_answer = '{"value": "become"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a08cfcfb-a91d-5c1b-927e-086123cdd584';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please wash your hands __________ you eat lunch.',
  correct_answer = '{"value": "before"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '611802ea-f89e-5900-bb3a-6c6e87d9fef2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The fish swam __________ the surface of the water.',
  correct_answer = '{"value": "below"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1a77e902-ea73-57b6-b72c-4859979f0de0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The park is __________ the school and the shops.',
  correct_answer = '{"value": "between"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c4d5cefd-0f4c-553b-afee-fbb16a415b82';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum __________ a new book for the class library.',
  correct_answer = '{"value": "bought"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4c888446-883d-51ee-a001-3d7bf905f5b2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They used blocks to __________ a tall tower.',
  correct_answer = '{"value": "build"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '20476ead-c239-52c6-8f70-16d30a74582a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher was very __________ marking the tests.',
  correct_answer = '{"value": "busy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '14778e1c-ea77-5f69-9e37-213e28c1f202';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Be __________ when you cross the road.',
  correct_answer = '{"value": "careful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f03e5cbe-fb77-5d79-a325-3fdbe37ab363';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped her brother __________ the heavy bag.',
  correct_answer = '{"value": "carry"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6e63ede2-0c5f-5ca4-ab3e-7281efd1875a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ very quickly in spring.',
  correct_answer = '{"value": "change"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '55a1b159-f3f6-5d27-8374-79f549d5220c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ played happily in the playground.',
  correct_answer = '{"value": "children"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '44be6edd-161f-5a66-8f02-c9fd03a6ea7c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to __________ the classroom before we leave.',
  correct_answer = '{"value": "clean"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bbfbe406-a5b8-5887-956a-3c5bc2cb621f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the door quietly behind you.',
  correct_answer = '{"value": "close"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2596bd66-f882-56c6-bceb-8dbe8eecc7c5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her favourite __________ is bright blue.',
  correct_answer = '{"value": "colour"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7b3b63d-de1c-5672-9fdb-05b3993e0cc4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ hear the birds singing outside.',
  correct_answer = '{"value": "could"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9fbac494-1110-52e2-86bd-cd0f09409a9a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use a __________ to protect your book.',
  correct_answer = '{"value": "cover"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c227d5d0-29a7-52b9-824f-cb37e5cb5ff3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It was hard to __________ which book to read first.',
  correct_answer = '{"value": "decide"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4159e106-471c-5109-bd17-230be9eef6e2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The whole family sat together for __________.',
  correct_answer = '{"value": "dinner"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0c24363f-74d4-57b2-9efb-7b44a3a6f380';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We must be quiet __________ the performance.',
  correct_answer = '{"value": "during"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c20a734-c4f6-5470-a9d0-83659ca0c08d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You can sit on __________ side of the table.',
  correct_answer = '{"value": "either"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '74c8673d-32bf-5d08-a290-8297451099da';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students __________ art class on Friday afternoons.',
  correct_answer = '{"value": "enjoy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '690fd940-56d9-5e4b-80be-d9f37a46510b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She reads for thirty minutes __________ evening.',
  correct_answer = '{"value": "every"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '44a301db-cca0-531d-9c82-a09c0a35018e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ clapped when the play was finished.',
  correct_answer = '{"value": "everyone"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aae0c2be-cd0b-51d2-956a-1ae1b9be7f5f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the instructions on the board.',
  correct_answer = '{"value": "follow"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c36ed8eb-7e32-52b8-8523-aae96db2e987';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We have sport on __________ afternoon.',
  correct_answer = '{"value": "Friday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1ff1a96f-b273-5758-8bc9-723fa0e357c3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum planted flowers in the front __________.',
  correct_answer = '{"value": "garden"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c8d1d1f-3f21-559f-a852-190e53881d62';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He is __________ better at spelling every week.',
  correct_answer = '{"value": "getting"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1f98a9d4-68f5-56bc-b6c5-03e068f8139a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The leaves fell to the __________ in autumn.',
  correct_answer = '{"value": "ground"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '72fbf071-2b08-5071-a73f-aeae5d5ae79b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Work with your __________ to solve the problem.',
  correct_answer = '{"value": "group"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3e9615ea-ae45-5680-b03c-86cc00c0d221';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She felt __________ when she got full marks.',
  correct_answer = '{"value": "happy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '62ad3898-1a32-5f05-910a-a6e83a78d684';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We are __________ a picnic in the park today.',
  correct_answer = '{"value": "having"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3b10f5b1-c138-5209-83a0-9fe59b5b8bcc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The box of books was too __________ to lift.',
  correct_answer = '{"value": "heavy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd838eaa5-e355-5703-a65b-957c410a43a6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to check your work when you finish.',
  correct_answer = '{"value": "helpful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '465386d6-41f6-53a2-8b55-aea292ea0180';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We went to the beach during the school __________.',
  correct_answer = '{"value": "holiday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c6f45936-a807-5a42-98e8-cf226e8a3060';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She learned to ride a __________ at the farm.',
  correct_answer = '{"value": "horse"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '48226bc3-8fab-550f-9205-40dc7d61b3ea';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The old __________ at the end of the street has a red door.',
  correct_answer = '{"value": "house"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1d02264e-e30b-5ccb-a5d4-d5c8e8fc5f55';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had a great __________ for the science project.',
  correct_answer = '{"value": "idea"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e20fa4e4-bd95-5bbe-b5b2-aecb707ad05c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We played games __________ because it was raining.',
  correct_answer = '{"value": "inside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb63df47-15f2-59c2-a74a-2e5c45db2a34';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He chose water __________ of juice with his lunch.',
  correct_answer = '{"value": "instead"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a794103b-3d09-5b8c-8c57-b2738fc51bfe';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The tiny __________ was surrounded by clear blue water.',
  correct_answer = '{"value": "island"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c44093f9-2a0d-530f-bc5a-4b67cd1f8581';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The frog could __________ very high for its size.',
  correct_answer = '{"value": "jump"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9f088aca-734b-5b93-8f08-c1477a9ff2b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your workspace tidy during the lesson.',
  correct_answer = '{"value": "keep"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd3ba2428-2535-5dcd-89e9-ed4481a0fc8b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is important to be __________ to others.',
  correct_answer = '{"value": "kind"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '838cebd1-2891-5fc5-a035-bceeb7f6efcf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The elephant has __________ ears that help it stay cool.',
  correct_answer = '{"value": "large"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8eccf0e3-8b4e-5d63-9e9e-b34fdfbea183';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We will finish the activity __________ this afternoon.',
  correct_answer = '{"value": "later"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4e6b95d-33e5-5c7b-8c7a-9fb1f5e59fe2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to use __________ three new words in her story.',
  correct_answer = '{"value": "least"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '10d2a8b6-cd28-5ca7-a6d5-9460eb588fe4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He wrote a __________ to his pen pal in another state.',
  correct_answer = '{"value": "letter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '07ddefea-0969-5f52-9cc5-f69c6cab894c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The author __________ near the ocean and writes about the sea.',
  correct_answer = '{"value": "lives"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2f871715-7a80-5156-93a0-64b7b392ef08';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ both ways before crossing the road.',
  correct_answer = '{"value": "looked"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3ffc52a7-2b9c-56d0-8a62-993ec7f10007';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We eat __________ in the undercover area on rainy days.',
  correct_answer = '{"value": "lunch"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '768500bc-4807-5794-8cae-3b0ce8898332';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story was full of __________ and adventure.',
  correct_answer = '{"value": "magic"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fdfc86ff-86e5-5c70-bb9b-c22848517c30';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She enjoyed __________ cards for her friends.',
  correct_answer = '{"value": "making"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9081d4e7-6d62-5cc8-9f91-2dc59f296d23';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It does not __________ who goes first in the game.',
  correct_answer = '{"value": "matter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ddc39e58-364a-5ece-aed1-a0dda27f951f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ we will go to the park after school today.',
  correct_answer = '{"value": "maybe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9ba6d814-52f3-57a0-a511-bf438561242f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher asked her to stand in the __________ of the circle.',
  correct_answer = '{"value": "middle"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ad86408-ea0e-56e6-8aa1-0ebebdf9be3f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit Grandma on the weekend.',
  correct_answer = '{"value": "might"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '80501fec-ba88-5adb-9f8b-58acc4fe7a88';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Wait just a __________ while I find the right page.',
  correct_answer = '{"value": "moment"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '20396eed-1fd5-54a8-b3cf-1c00282c70ac';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new term starts on __________ morning.',
  correct_answer = '{"value": "Monday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e8fc4ff5-0f62-5b60-b514-02989ca0abfd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She saved her pocket __________ to buy a new book.',
  correct_answer = '{"value": "money"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3f3cde8d-e743-5ea4-afb7-f8ad4a3fabe1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We do spelling practice every __________ after assembly.',
  correct_answer = '{"value": "morning"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4663044c-fe16-5ecb-810d-d88fbae0f6b6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her practise reading each night.',
  correct_answer = '{"value": "mother"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5a74ece7-89e9-5bd7-a87b-5d9711f90a67';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The puppy kept __________ and would not sit still.',
  correct_answer = '{"value": "moving"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6a35b581-1f57-5a31-be5a-467fb5ce34d5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

I built the model aeroplane all by __________.',
  correct_answer = '{"value": "myself"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6f46bf9b-bc94-584a-a298-a2d8a2af4e1f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has __________ missed a day of school this term.',
  correct_answer = '{"value": "never"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9bcceebd-8430-518c-bd2f-1daa9922f971';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

There was __________ left in the lunchbox after recess.',
  correct_answer = '{"value": "nothing"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '562fc0a5-9bf9-5e86-affe-0a056cc13bcb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your name and class __________ on the front page.',
  correct_answer = '{"value": "number"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '936775c3-cdd7-592f-9623-ca9cda34cbb3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit the library to choose new books.',
  correct_answer = '{"value": "often"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ede98f9-6932-577b-ac2e-b4523b17aae4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ upon a time there was a kind young girl.',
  correct_answer = '{"value": "once"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9d056978-70e5-5de1-a217-bcba64db914a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your books to page twenty-three.',
  correct_answer = '{"value": "open"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '75cecaf2-ad39-58df-b64c-22cc4b54c24a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can you think of an __________ word for happy?',
  correct_answer = '{"value": "other"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4e5f3dfe-d592-5154-a80b-d30cb2bdbf12';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class moved __________ to finish their sketches.',
  correct_answer = '{"value": "outside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1d1e04cb-c875-52dd-81b4-9d62ce2c81f3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She folded the __________ carefully to make a boat.',
  correct_answer = '{"value": "paper"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '28544605-aab1-575b-b00a-0bb328be47ab';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each __________ was invited to attend the information night.',
  correct_answer = '{"value": "parent"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bdfdea14-9544-5ea3-8db1-802f96f0565c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The library is her favourite __________ to read.',
  correct_answer = '{"value": "place"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2f8c499e-581f-5db8-85cd-c1c523bafe43';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She watered the __________ every morning before school.',
  correct_answer = '{"value": "plant"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '66ac542e-1ff8-5c5b-b4e9-6d76c3c2f25f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ remember to bring your permission note tomorrow.',
  correct_answer = '{"value": "please"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7d7a1f6-61c3-53dc-8e59-5a1ed5b8ea27';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden looked __________ after all the rain.',
  correct_answer = '{"value": "pretty"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ab69cf4b-8682-5871-ba52-9d34f6786ced';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked through the maths __________ step by step.',
  correct_answer = '{"value": "problem"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8b2ac0c0-3673-5b63-be4d-86d71c8f134b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to be __________ or we will miss the bus.',
  correct_answer = '{"value": "quick"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c7b523d-f9d1-5304-8a3c-a46e22304197';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The classroom became __________ when the teacher arrived.',
  correct_answer = '{"value": "quiet"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ca412dd9-ffbb-5709-94bc-24b316b966b6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new student found the test __________ easy.',
  correct_answer = '{"value": "quite"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2eaadb24-9a58-5cb4-b4ce-72eb56ec8ba1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ pleased with her work this term.',
  correct_answer = '{"value": "really"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4e4dbaa7-abac-5405-9328-e276f540c762';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure you use the __________ tool for the job.',
  correct_answer = '{"value": "right"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3a1bf46a-bb15-502e-b146-e74f95105f1b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They spotted a platypus in the shallow __________.',
  correct_answer = '{"value": "river"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c74b8fe3-04a3-5c08-9cda-72dac0b3acff';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children sat in a __________ circle on the mat.',
  correct_answer = '{"value": "round"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e88371b0-91b0-54aa-8078-5007dcff3688';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He enjoys __________ with his dog in the park.',
  correct_answer = '{"value": "running"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bb347349-b1a6-5405-b50f-1231c0a9c853';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She came __________ in the cross-country race.',
  correct_answer = '{"value": "second"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '60054e61-1669-5847-94b8-0cbd383601a8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sun started to __________ after the morning clouds cleared.',
  correct_answer = '{"value": "shine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dc2512f9-2dd0-56c6-96fd-9165d72ff3af';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions were clear and __________ to follow.',
  correct_answer = '{"value": "simple"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1db32ba4-f110-58a0-b5c1-ea85d83409a8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has loved reading __________ she was very young.',
  correct_answer = '{"value": "since"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9d79443d-4b11-59d7-91d7-77f0f9a18b51';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her choose a book from the shelf.',
  correct_answer = '{"value": "sister"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9fc7de38-6d74-5e14-aadb-da0b8a3fabc0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ bird built its nest in the garden hedge.',
  correct_answer = '{"value": "small"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e971acfa-e6e5-5c76-8ab6-757ef5f4b6b5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She felt __________ was wrong as soon as she arrived.',
  correct_answer = '{"value": "something"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5a562e4c-d16d-5565-aef8-c545e599211f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ it is hard to concentrate on a hot afternoon.',
  correct_answer = '{"value": "sometimes"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '496e6fa4-fc89-5e46-b3f3-b4ce31813d33';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of the bell meant it was time for lunch.',
  correct_answer = '{"value": "sound"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fff7ed0a-d84a-5548-ada6-8a79a4b5817f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project __________ well but needed more planning.',
  correct_answer = '{"value": "started"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8b20398c-ecaa-5cbe-9cff-152e8dbbf045';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Stand __________ while I measure your height.',
  correct_answer = '{"value": "still"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b3c5dd10-2914-53aa-9627-65193cd7df33';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ brought heavy rain and strong winds overnight.',
  correct_answer = '{"value": "storm"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '686405ad-b241-556e-9e90-3912aef8bb23';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote a fantastic __________ about a lost puppy.',
  correct_answer = '{"value": "story"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5a118349-85b2-5a03-9072-3a17791b992d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked down the main __________ looking for the shop.',
  correct_answer = '{"value": "street"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2924a8fb-32ae-570e-aa87-ed660bc22d25';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to be __________ and brave when things get hard.',
  correct_answer = '{"value": "strong"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '91aa099b-2af4-50e1-bf6a-95c05f4da43f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every __________ received a certificate at the assembly.',
  correct_answer = '{"value": "student"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4f8c3937-4308-51e4-adf0-c1cba11393fe';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the lights went out during the show.',
  correct_answer = '{"value": "suddenly"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c120b93-8ea8-5e7c-9238-57274a99b5e2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please clear everything off the __________ before dinner.',
  correct_answer = '{"value": "table"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1288cdc6-0583-5adc-b09a-ea219bcd6810';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

All the library books had been __________ out already.',
  correct_answer = '{"value": "taken"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '98f3177a-efdf-5f29-978b-905e1dda1f63';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She left her pencil case over __________ by the window.',
  correct_answer = '{"value": "there"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'df4eaed9-4a07-51c7-8d1e-a06ea431da25';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Take a moment to __________ before you answer the question.',
  correct_answer = '{"value": "think"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e5d4370b-8ce4-5efd-932b-02c08233dde2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read __________ chapters of the book before bed.',
  correct_answer = '{"value": "three"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '400b556e-cfdb-54f8-a78a-f33773ce5b33';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked __________ the park to get to school faster.',
  correct_answer = '{"value": "through"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b430023f-4190-542a-a8d6-03fa35cfd919';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We are presenting our projects __________ after recess.',
  correct_answer = '{"value": "today"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c791cc5-68a3-531e-8af9-67efc62640fc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The small __________ had one school and one library.',
  correct_answer = '{"value": "town"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0b28ff4b-827b-5e26-b809-5461fd6a2a04';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ her best even when the task was hard.',
  correct_answer = '{"value": "tried"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '005317fa-999b-526f-8c4a-83570bb70b33';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dog hid __________ the table during the thunderstorm.',
  correct_answer = '{"value": "under"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dc0c0b8c-f986-5159-be4d-ec9b1098de4c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised __________ she had every word perfect.',
  correct_answer = '{"value": "until"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b494a4c4-c0c5-5118-9978-51049389f7e7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She climbed __________ the hill to see the view.',
  correct_answer = '{"value": "upon"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e036d9de-8d2d-52ef-b9e4-415a0c756efb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We will __________ the museum as part of our excursion.',
  correct_answer = '{"value": "visit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '081892db-0d6e-5293-bb56-d81b6ee7f969';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher spoke in a calm __________ during the lesson.',
  correct_answer = '{"value": "voice"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7acbe553-1a6e-5ef2-9d38-542ad1d8908e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They __________ to school together every morning.',
  correct_answer = '{"value": "walked"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd3380312-f0a1-5877-b696-e120506d13ce';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Remember to drink enough __________ during the hot day.',
  correct_answer = '{"value": "water"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bf0ec320-d8bb-5c74-b185-58585dc3642f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She likes to __________ nature documentaries on the weekend.',
  correct_answer = '{"value": "watch"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1a38a3fa-9574-5f5a-b9bd-ec652172cbc0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read her book __________ her brother played outside.',
  correct_answer = '{"value": "while"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e0778ca4-ef8b-567e-b76a-c66c4a817a4b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The snow looked bright and __________ in the morning sun.',
  correct_answer = '{"value": "white"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1bfd4c4b-d44a-5fbe-9bc0-cc662eaf3b5e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ class worked together to clean the room.',
  correct_answer = '{"value": "whole"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7346d58a-9c27-5012-be78-40d65e5b2bd3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She looked out the __________ at the rainy playground.',
  correct_answer = '{"value": "window"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '013f3b56-a6a5-56e1-880b-0f81353beb92';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

In __________ they wore thick jumpers and coats.',
  correct_answer = '{"value": "winter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c3d1c07-2e59-5301-beaf-853d12692578';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could not finish the puzzle __________ help.',
  correct_answer = '{"value": "without"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cf132b2d-120c-5d25-a586-8680c4d87419';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She added a new __________ to her vocabulary list each day.',
  correct_answer = '{"value": "word"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'adc8e7b9-55ca-5114-b82f-f637c247e792';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wanted to travel and see the __________ one day.',
  correct_answer = '{"value": "world"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '00b8fedb-7472-5922-b900-3b6f3f6eef30';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He practised how to __________ neatly in his journal.',
  correct_answer = '{"value": "write"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2f9772b9-1fb5-5a49-b0b0-da4a08910e4f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ a thank-you letter to her teacher.',
  correct_answer = '{"value": "wrote"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a45713cc-b70b-5c28-9c89-470093cf01d9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They have been best friends since their first __________ at school.',
  correct_answer = '{"value": "year"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '59de2b59-0df5-54f0-9d5e-67498da59a87';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Even __________ children can learn to be kind.',
  correct_answer = '{"value": "young"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '17def5b3-a25c-55b5-bd2a-1843b04016b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Is this pencil case __________ or your classmate''s?',
  correct_answer = '{"value": "yours"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cb299df3-4b0e-5a30-ac79-0d1e17be4d17';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had to read the instructions __________ to understand them.',
  correct_answer = '{"value": "again"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f65a9d54-2917-5a32-80e2-f314d79e4560';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They walked __________ the beach collecting shells.',
  correct_answer = '{"value": "along"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0f5bee74-e2c8-5716-8f34-071c5fa56b7c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He __________ washes his hands before eating.',
  correct_answer = '{"value": "always"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0d9a103a-72d2-5754-a075-5f2b2d325175';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ at the zoo was very friendly.',
  correct_answer = '{"value": "animal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ced04053-5946-5623-b1ff-f65be39cc608';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can I have __________ piece of cake please?',
  correct_answer = '{"value": "another"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3c6894a3-3067-5920-a5c5-2e7b84ca5877';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children ran __________ the oval at lunchtime.',
  correct_answer = '{"value": "around"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '90748904-f5a1-5ba6-9a3c-d890be80aba0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked hard to __________ a great swimmer.',
  correct_answer = '{"value": "become"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0444413c-16c6-5feb-a0c0-e36b6bc0b4bd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please wash your hands __________ you eat lunch.',
  correct_answer = '{"value": "before"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c7509b9d-219c-50a6-8264-f1d466bdb0e6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The fish swam __________ the surface of the water.',
  correct_answer = '{"value": "below"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a6baac12-52ac-55e4-a560-5d97a3252612';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The park is __________ the school and the shops.',
  correct_answer = '{"value": "between"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '10e1db3b-0345-5e74-8519-2b6c46e83d82';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum __________ a new book for the class library.',
  correct_answer = '{"value": "bought"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd03484c9-cd59-54a3-8cd4-a4c23732cbe2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They used blocks to __________ a tall tower.',
  correct_answer = '{"value": "build"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '13568a0f-3c31-5291-86a7-3acba850b236';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher was very __________ marking the tests.',
  correct_answer = '{"value": "busy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd58bc5e6-2d27-5170-af09-54e1d324f179';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Be __________ when you cross the road.',
  correct_answer = '{"value": "careful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'caee7f3e-cbf6-55db-b8f6-499a36362588';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped her brother __________ the heavy bag.',
  correct_answer = '{"value": "carry"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '43e22b1f-f054-598d-aefe-5f95cee8312d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ very quickly in spring.',
  correct_answer = '{"value": "change"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '59fc3335-6658-5eba-8e19-d1b26ec7c5cc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ played happily in the playground.',
  correct_answer = '{"value": "children"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '60da8f5b-2763-5773-b559-d07eb4c524ec';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to __________ the classroom before we leave.',
  correct_answer = '{"value": "clean"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '05bff6be-0a21-5053-8f21-7d21b15e0573';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the door quietly behind you.',
  correct_answer = '{"value": "close"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b63bb6f5-0100-59e6-bfb2-c83728a7dcd3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her favourite __________ is bright blue.',
  correct_answer = '{"value": "colour"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c48de2c1-a232-5db8-a7c7-41bc72cec4bf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ hear the birds singing outside.',
  correct_answer = '{"value": "could"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a26bea60-b787-5030-a79a-af21015b34ba';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use a __________ to protect your book.',
  correct_answer = '{"value": "cover"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '17fa081e-3c1e-58a4-aca9-2c19b68099b2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It was hard to __________ which book to read first.',
  correct_answer = '{"value": "decide"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8a34c49c-0985-5a09-84af-9fb625bd9bf7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The whole family sat together for __________.',
  correct_answer = '{"value": "dinner"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b06db9c1-1294-5fa1-b239-0ea754c2f519';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We must be quiet __________ the performance.',
  correct_answer = '{"value": "during"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9b7e80f4-27ac-57d2-80d2-c9cc0d19fbcc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You can sit on __________ side of the table.',
  correct_answer = '{"value": "either"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '778c104c-d07c-5e98-bf17-e73ed653a180';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students __________ art class on Friday afternoons.',
  correct_answer = '{"value": "enjoy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '827ebffa-c533-50db-856f-d6770aa3d9e3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She reads for thirty minutes __________ evening.',
  correct_answer = '{"value": "every"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c509e553-e6d9-5b3b-b521-e383796f7c1c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ clapped when the play was finished.',
  correct_answer = '{"value": "everyone"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4fbb6f51-5c9c-5270-93a4-5128c89801fd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ the instructions on the board.',
  correct_answer = '{"value": "follow"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dc68e097-aba8-5d12-94c2-8f5cb3af1a0c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We have sport on __________ afternoon.',
  correct_answer = '{"value": "Friday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e5ad7e33-3842-5269-81f8-d4cf8d17d684';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Mum planted flowers in the front __________.',
  correct_answer = '{"value": "garden"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2a33f0ab-2c60-5699-8769-3898e5142928';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He is __________ better at spelling every week.',
  correct_answer = '{"value": "getting"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6d01b9eb-7696-5fab-bbfe-36c8838e02ca';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The leaves fell to the __________ in autumn.',
  correct_answer = '{"value": "ground"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fff22983-d442-5a9c-affc-2817d3ee30ef';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Work with your __________ to solve the problem.',
  correct_answer = '{"value": "group"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9fb1ba5f-86ea-5aa6-876b-0c20e1fd230d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She felt __________ when she got full marks.',
  correct_answer = '{"value": "happy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2a8c9ae7-7450-5081-81db-e7843e49925b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We are __________ a picnic in the park today.',
  correct_answer = '{"value": "having"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '304eb872-3c8a-5973-bb2a-1893bced5834';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The box of books was too __________ to lift.',
  correct_answer = '{"value": "heavy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4399b18-c557-56e5-aa9d-db86e7ec9a82';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is __________ to check your work when you finish.',
  correct_answer = '{"value": "helpful"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b15ba9de-4a78-50d8-b1f1-3f200024e988';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We went to the beach during the school __________.',
  correct_answer = '{"value": "holiday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e70022db-a95e-5645-98db-e8ad2ae5d437';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She learned to ride a __________ at the farm.',
  correct_answer = '{"value": "horse"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a442a631-6e77-5d7c-961b-e62c290cab84';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The old __________ at the end of the street has a red door.',
  correct_answer = '{"value": "house"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '42aeabb1-3ca8-5e5f-89c8-34388877b91d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had a great __________ for the science project.',
  correct_answer = '{"value": "idea"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '23a8baef-799f-5994-af45-197befaf0f1b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We played games __________ because it was raining.',
  correct_answer = '{"value": "inside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '479db177-5692-5456-b348-666e7ff72331';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He chose water __________ of juice with his lunch.',
  correct_answer = '{"value": "instead"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2ef9c6e9-a5e6-5fd2-b406-c3a6396024ff';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The tiny __________ was surrounded by clear blue water.',
  correct_answer = '{"value": "island"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd23eed29-3dc4-5289-9cf1-cff6920d72fb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The frog could __________ very high for its size.',
  correct_answer = '{"value": "jump"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '44c1bd26-8fb2-57ab-a3ea-d771ea738cce';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your workspace tidy during the lesson.',
  correct_answer = '{"value": "keep"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'db8d34cb-f2ce-56f3-a13f-97ac4893b4d6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is important to be __________ to others.',
  correct_answer = '{"value": "kind"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '11c817be-e602-5f3d-978d-8ff5f823c6f9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The elephant has __________ ears that help it stay cool.',
  correct_answer = '{"value": "large"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f86a9dbb-01cc-5fd3-93b6-8111e351804d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We will finish the activity __________ this afternoon.',
  correct_answer = '{"value": "later"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1660bdcb-58b8-5af6-8414-205fa10855fd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to use __________ three new words in her story.',
  correct_answer = '{"value": "least"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5d3b1179-47b3-5106-ba4f-2df212868129';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He wrote a __________ to his pen pal in another state.',
  correct_answer = '{"value": "letter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fc00dafb-07a6-5616-8f56-df6c42bc612b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The author __________ near the ocean and writes about the sea.',
  correct_answer = '{"value": "lives"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e4654363-5210-5873-a239-f42423837df7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She __________ both ways before crossing the road.',
  correct_answer = '{"value": "looked"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '191eaab4-abb4-59e5-827a-5233627f4f5a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We eat __________ in the undercover area on rainy days.',
  correct_answer = '{"value": "lunch"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '421c1524-bfb1-5f1b-8bc4-39c1e2e25e06';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story was full of __________ and adventure.',
  correct_answer = '{"value": "magic"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7f61d612-0553-572e-9e77-6f06b1f740df';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She enjoyed __________ cards for her friends.',
  correct_answer = '{"value": "making"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '269a0e1c-edc3-5ff9-ba39-92e7c4851433';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It does not __________ who goes first in the game.',
  correct_answer = '{"value": "matter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '90cfa056-8849-5ab7-8e29-2d21e338053a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ we will go to the park after school today.',
  correct_answer = '{"value": "maybe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '98a506ba-82e0-50e1-a991-810d662163bf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher asked her to stand in the __________ of the circle.',
  correct_answer = '{"value": "middle"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dc52aeb0-97cf-5a51-a36e-b486f1fd8cbe';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit Grandma on the weekend.',
  correct_answer = '{"value": "might"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6912aeeb-b86e-5722-95a7-04197e8e63f2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Wait just a __________ while I find the right page.',
  correct_answer = '{"value": "moment"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5e9d5cdd-5433-5b76-aaf9-e12da59b55eb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new term starts on __________ morning.',
  correct_answer = '{"value": "Monday"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4ff7a42-c763-5bc1-9bfb-211ca5a60e9e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She saved her pocket __________ to buy a new book.',
  correct_answer = '{"value": "money"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f48dd3e8-d186-5db8-9beb-472a602821c1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We do spelling practice every __________ after assembly.',
  correct_answer = '{"value": "morning"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '60776f94-7103-59ce-aa85-e49a7b574bee';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her practise reading each night.',
  correct_answer = '{"value": "mother"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'efa8fb2d-a5ad-5cd6-a691-697b4649a15b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The puppy kept __________ and would not sit still.',
  correct_answer = '{"value": "moving"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5c40d2df-dcdc-5c01-98f5-7097bfbfc82a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

I built the model aeroplane all by __________.',
  correct_answer = '{"value": "myself"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '036febd4-4c5b-5187-b36f-3ac196a76b67';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has __________ missed a day of school this term.',
  correct_answer = '{"value": "never"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd0977513-55c4-5d5e-b7d0-ec6fd8e8c3c3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

There was __________ left in the lunchbox after recess.',
  correct_answer = '{"value": "nothing"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '498c9cd5-2fb4-57c8-a1a7-74d54075cde3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your name and class __________ on the front page.',
  correct_answer = '{"value": "number"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2748395a-d8c5-5ba9-8180-78462762ed74';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We __________ visit the library to choose new books.',
  correct_answer = '{"value": "often"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5a9c68c9-b6dd-539e-851f-11989e882e60';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ upon a time there was a kind young girl.',
  correct_answer = '{"value": "once"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aa8309bd-1575-59c5-a678-fb9d7b970cbb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your books to page twenty-three.',
  correct_answer = '{"value": "open"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1986e50f-45ea-5025-a30c-b325da4cf2c5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Can you think of an __________ word for happy?',
  correct_answer = '{"value": "other"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2eb4f14d-ae8c-5d95-9ff3-b4fdbb0a4559';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class moved __________ to finish their sketches.',
  correct_answer = '{"value": "outside"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '25b11311-07c7-5937-b1bd-57e5227eacfa';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She folded the __________ carefully to make a boat.',
  correct_answer = '{"value": "paper"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fdf77828-32d7-5ab8-b7d5-771d3b02861a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each __________ was invited to attend the information night.',
  correct_answer = '{"value": "parent"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '045c402a-2bc1-5e34-a9a0-b9446ad6e3f4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The library is her favourite __________ to read.',
  correct_answer = '{"value": "place"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7e8be3ae-0243-5c25-a700-a61a2a653755';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She watered the __________ every morning before school.',
  correct_answer = '{"value": "plant"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7888f7dd-710c-5f6e-89e7-d6724c431c57';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ remember to bring your permission note tomorrow.',
  correct_answer = '{"value": "please"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5841cb98-18d7-5ae0-bd5d-968dc175580c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden looked __________ after all the rain.',
  correct_answer = '{"value": "pretty"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '90f2391c-173b-5809-b8da-85d9fbc9a956';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She worked through the maths __________ step by step.',
  correct_answer = '{"value": "problem"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9e2cb591-a6ef-55bf-a26e-97e5b858d05e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

We need to be __________ or we will miss the bus.',
  correct_answer = '{"value": "quick"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9700dc35-d95e-543d-8c97-f920751bfc39';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The classroom became __________ when the teacher arrived.',
  correct_answer = '{"value": "quiet"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bbddeafa-91d6-5ed4-86d8-25798b2d02a5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The new student found the test __________ easy.',
  correct_answer = '{"value": "quite"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '57ff2bad-7cb9-5d2e-a2d2-d063ee6e5f87';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ pleased with her work this term.',
  correct_answer = '{"value": "really"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c74cd6e-0376-5d3f-89fd-ee60fd6875ee';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure you use the __________ tool for the job.',
  correct_answer = '{"value": "right"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '224ebdde-3260-5daf-bcea-821e215a7562';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

They spotted a platypus in the shallow __________.',
  correct_answer = '{"value": "river"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd93ebeed-75c6-5378-a7e5-8801e9212a63';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The children sat in a __________ circle on the mat.',
  correct_answer = '{"value": "round"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b15224f1-32ae-5309-bb20-569a57d8d373';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He enjoys __________ with his dog in the park.',
  correct_answer = '{"value": "running"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '837195e5-3baf-5422-8834-f948994554e4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She came __________ in the cross-country race.',
  correct_answer = '{"value": "second"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5d8fda7a-5ec7-5bf3-acd1-0cc76bf57774';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sun started to __________ after the morning clouds cleared.',
  correct_answer = '{"value": "shine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f65ca922-8a91-5279-b7c9-540b3edec49f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions were clear and __________ to follow.',
  correct_answer = '{"value": "simple"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f633c27d-693e-5377-9e42-89460a4c4f46';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She has loved reading __________ she was very young.',
  correct_answer = '{"value": "since"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47f0c2ff-8983-5a16-9bf6-4c2a977172ad';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her __________ helped her choose a book from the shelf.',
  correct_answer = '{"value": "sister"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5b2a7925-8320-56af-8814-06b1d4f988f8';

-- ============================================================
-- PART D: Y5 ALL (400 questions)
-- ============================================================
UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ certain the answer was correct.',
  correct_answer = '{"value": "absolute"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7519d260-dcc0-531f-8a40-74861123bbdc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her description of the events was very __________.',
  correct_answer = '{"value": "accurate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3e033c24-58be-5ae7-92d7-793ddf0d80f8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

With practice anyone can __________ their goals.',
  correct_answer = '{"value": "achieve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '81d846e7-e89d-59db-8f8e-bad0ecd2dfd3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your __________ clearly on the envelope.',
  correct_answer = '{"value": "address"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7312f1bc-ab9c-50c4-9360-a099ccf9a56e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many students __________ the way she explains things clearly.',
  correct_answer = '{"value": "admire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'df547f66-7ae1-5617-83e9-43e040eb4854';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The team made good __________ during the project.',
  correct_answer = '{"value": "advance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47ab0900-7ab2-5cfd-97c5-d320fd0ab480';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ how well you sleep.',
  correct_answer = '{"value": "affect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dec716ef-8f8b-50c9-bac3-5723a8507160';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Both teams could not __________ on the rules of the game.',
  correct_answer = '{"value": "agree"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f1cd2b33-4e6f-56b3-94a0-769970d62c97';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The museum displayed __________ tools from thousands of years ago.',
  correct_answer = '{"value": "ancient"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c08caa91-7378-53bb-9ec7-a8c219decf3d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The colourful display had great __________ for the visitors.',
  correct_answer = '{"value": "appeal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '888c0222-dd92-5f3f-95d3-50dc1d7a05ed';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped __________ the chairs into a circle.',
  correct_answer = '{"value": "arrange"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb79e926-a20e-5827-8d82-1c888c3851a3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote an __________ about recycling for the school newsletter.',
  correct_answer = '{"value": "article"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e8373734-4d23-56d8-b9bc-620ac886b298';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is kind to __________ someone who is struggling.',
  correct_answer = '{"value": "assist"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '108f0fc0-7f9c-5fc8-9db9-c02e90eb86e8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your permission form to the email.',
  correct_answer = '{"value": "attach"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '64675ca3-41a7-5ba0-9e41-f490d0ce3108';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make at least one __________ before asking for help.',
  correct_answer = '{"value": "attempt"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4532015c-0993-587c-bcca-b2107ca741e3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Bright flowers __________ bees and butterflies to the garden.',
  correct_answer = '{"value": "attract"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e867a5f3-8125-5093-bed1-9d172c5f788f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised __________ on one foot during gymnastics.',
  correct_answer = '{"value": "balance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1bc3dc7f-14d0-5ff4-8199-8aaea0774dec';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Exercise is a great __________ for both the mind and body.',
  correct_answer = '{"value": "benefit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2d31f1cc-d042-52a8-8b68-8ddaab1ea6bb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden has a neat flower __________ along each edge.',
  correct_answer = '{"value": "border"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a910cc7d-86e5-5ee3-8647-40435e5146b6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She gave a __________ summary of the chapter she had read.',
  correct_answer = '{"value": "brief"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8033bcd5-19e5-599d-bbe9-812e006aa49a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The student came up with a __________ solution to the problem.',
  correct_answer = '{"value": "brilliant"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ff480f5-ae27-5526-8ac7-2e0fec137490';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class had a small __________ for the science project materials.',
  correct_answer = '{"value": "budget"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f50eebf4-f7c1-57a4-a51d-ba972f7f0404';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She is __________ of completing the task on her own.',
  correct_answer = '{"value": "capable"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '803a8926-8e1a-54f5-9b0a-0bd8b41179d4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The photographer managed to __________ the moment perfectly.',
  correct_answer = '{"value": "capture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9d6fd4c2-2f70-5f52-852b-87f175a1da45';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The building was built in the nineteenth __________.',
  correct_answer = '{"value": "century"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '56b1bda6-1fdb-5a4b-b1d1-4ae7843de52d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ she had packed her library book.',
  correct_answer = '{"value": "certain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c2d0dd1d-275b-5688-ae4d-181bccc44927';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The puzzle was a great __________ for the whole group.',
  correct_answer = '{"value": "challenge"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd80e6152-7216-5d52-8923-08d63f334faf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read the first __________ before going to sleep.',
  correct_answer = '{"value": "chapter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e0a2348a-52b3-505a-b9c4-efd59bb0237f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The main __________ in the story was brave and kind.',
  correct_answer = '{"value": "character"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3ca294e1-9474-5603-944f-07ea4b74e8df';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every __________ has a responsibility to care for the environment.',
  correct_answer = '{"value": "citizen"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2be0c452-2a35-5f4d-ad13-f4dca8da4c2f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dry __________ means the town rarely receives heavy rain.',
  correct_answer = '{"value": "climate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '676d0d88-f9a4-5c0c-bf2a-8200656f3abc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She loves to __________ interesting rocks from the beach.',
  correct_answer = '{"value": "collect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8c98f07f-1b29-59db-9b89-6c2546e587dd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Add the numbers in each __________ to find the total.',
  correct_answer = '{"value": "column"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1f1ba024-ebaf-5bcc-8b41-85bd8083ad64';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the flour and butter to make the dough.',
  correct_answer = '{"value": "combine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '361378f2-d656-5097-8fe9-69e777d46d29';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She offered her friend __________ after the disappointing result.',
  correct_answer = '{"value": "comfort"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9b971230-dc0f-5cfc-8778-98acfe616903';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He made a helpful __________ about the presentation.',
  correct_answer = '{"value": "comment"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0470783c-c61d-5ce1-93a6-07bcc13b4644';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions looked __________ at first but became clear.',
  correct_answer = '{"value": "complex"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb4c4603-1787-5b89-870e-b2a0c6d44f2a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher showed __________ for the student who was absent.',
  correct_answer = '{"value": "concern"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0500abc8-c0e0-569c-ab82-5abdd029dec5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

After all the research she could __________ the experiment.',
  correct_answer = '{"value": "conclude"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c0ca62f3-b7a1-5bb3-a748-41bd7ff84c85';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story had a strong __________ between the two characters.',
  correct_answer = '{"value": "conflict"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '41ea6c00-bc5e-5bd8-822d-9cb3bc3dc0cf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to __________ the ideas in each paragraph.',
  correct_answer = '{"value": "connect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7d4fd6c5-e3d1-5c83-8270-545a13239d2f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The jar can __________ up to two litres of water.',
  correct_answer = '{"value": "contain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5253310a-c92a-5bd9-a1b1-da771d8907e9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ with the result of her hard work.',
  correct_answer = '{"value": "content"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c8c57a1b-b37e-50f0-85ac-d89b2652cb7d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ between the two characters made the story interesting.',
  correct_answer = '{"value": "contrast"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a50df3ce-dc83-52cb-a514-a64577669f0b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientist worked to __________ the temperature of the experiment.',
  correct_answer = '{"value": "control"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7b1f5c70-1407-52b4-a9bc-3b0cd1fc91d0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to __________ the measurements from metres to centimetres.',
  correct_answer = '{"value": "convert"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '667b8b23-fde9-56a8-a1eb-059b2c4d6453';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Check your answers to make sure each one is __________.',
  correct_answer = '{"value": "correct"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a67716bb-421e-5f94-8521-8d805c8e4345';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The student __________ met every Tuesday to discuss ideas.',
  correct_answer = '{"value": "council"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ebc0f92-82d8-5d2a-80e8-8004f74e11d3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She used her imagination to __________ a fantastic short story.',
  correct_answer = '{"value": "create"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e729be64-0541-5599-add7-9d56f8dc3f42';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ news includes reports on local environment issues.',
  correct_answer = '{"value": "current"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1d4bd0db-45d3-5181-8620-9bacaa76b597';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class held a __________ about the importance of recycling.',
  correct_answer = '{"value": "debate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0b85a3bb-4752-50b5-bba4-cf549bcecc87';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She stood up to __________ her idea to the whole class.',
  correct_answer = '{"value": "declare"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3a15c570-cf73-58b8-b186-36ed6aa9f69d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A good writer can __________ their argument with evidence.',
  correct_answer = '{"value": "defend"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e965c2d7-6af4-5c18-875a-b69829af3b25';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use a dictionary to __________ any unfamiliar words you find.',
  correct_answer = '{"value": "define"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '99a016b9-323d-5e49-adea-458df5e9f161';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project requires a high __________ of effort and time.',
  correct_answer = '{"value": "demand"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'abfa2c45-6c0b-50e0-920c-0cb193922591';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the setting of the story using sensory details.',
  correct_answer = '{"value": "describe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b1eec854-c95a-5180-a24a-37e4742593dc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was asked to __________ the cover for the class magazine.',
  correct_answer = '{"value": "design"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7696b04b-88be-5fe5-8979-118fbf660d96';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Adding specific __________ makes your writing much more vivid.',
  correct_answer = '{"value": "detail"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '46e8c10b-761d-5eb8-b9a8-4507323385aa';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists can __________ very small changes in temperature.',
  correct_answer = '{"value": "detect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '41112a69-6c0b-51a4-853a-e19bc7f7db9d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Regular reading helps __________ vocabulary and comprehension.',
  correct_answer = '{"value": "develop"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c5366c02-2647-5091-ac65-bb2d6075e794';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student was given a __________ to use during the lesson.',
  correct_answer = '{"value": "device"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '12fa0523-42e3-5b86-85ac-8f3effb0bf9a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school library offers both print and __________ resources.',
  correct_answer = '{"value": "digital"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c39ad50-58fc-56f8-abba-ea3183e69bcb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class will __________ the topic before writing their essays.',
  correct_answer = '{"value": "discuss"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '71a29ac0-d564-5904-b47b-135284759b7e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The artwork was put on __________ in the school foyer.',
  correct_answer = '{"value": "display"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f1778bd8-999e-5193-bf20-9e4cb3b76604';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She ran the full __________ of the cross-country course.',
  correct_answer = '{"value": "distance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '233acc62-6c70-5bc7-8f1c-5932e9f234fb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class had a __________ range of opinions on the topic.',
  correct_answer = '{"value": "diverse"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '32b392b4-007c-568a-a71f-330935ffe037';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She kept a __________ of all the research she had gathered.',
  correct_answer = '{"value": "document"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cc826d8e-82a5-5e10-960d-899edc6ce5b1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Learning to save money is part of understanding __________.',
  correct_answer = '{"value": "economy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '57f83aff-482e-5faf-87ed-f3ad97ab1be6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She borrowed the latest __________ from the school library.',
  correct_answer = '{"value": "edition"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '80d3e90a-6ce3-5ed9-a096-4df72b06a718';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The rainy weather had a calming __________ on the afternoon.',
  correct_answer = '{"value": "effect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4267d3ec-3e6b-5967-a89d-da10a3a8eaae';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is an important __________ for all living things.',
  correct_answer = '{"value": "element"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c2f7fb8-2c4f-580f-8619-cd74f5e10cf8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The Roman __________ covered a vast area of Europe.',
  correct_answer = '{"value": "empire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '57e0fc29-618c-5245-be85-cdffc94ad42d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her teacher always tried to __________ her to do her best.',
  correct_answer = '{"value": "encourage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9b4b65c5-be6e-5633-8d56-c43a78f7709e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Solar panels use __________ from the sun to produce electricity.',
  correct_answer = '{"value": "energy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '62e19809-a9b9-5cd7-a9ff-62716f8af75a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good books __________ the reader from the very first page.',
  correct_answer = '{"value": "engage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f3070273-d36e-54a9-a15a-ee92561b35c1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read the __________ novel in one rainy weekend.',
  correct_answer = '{"value": "entire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '13fd599c-39a6-51c7-9a71-ce34685a6d46';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her competition __________ was chosen as the class winner.',
  correct_answer = '{"value": "entry"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '29180b58-932b-50dd-9b2a-8a4e874b0e37';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ how long the task would take.',
  correct_answer = '{"value": "estimate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '27181e41-d90e-56c6-a02c-1c09611c5338';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sports __________ attracted families from across the district.',
  correct_answer = '{"value": "event"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3c8b5627-298a-57e4-a695-a8e96e2bf3f6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She gathered __________ from the text to support her argument.',
  correct_answer = '{"value": "evidence"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f900f7d5-48e0-50cf-a2b1-71c3461be677';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists __________ the data carefully before drawing conclusions.',
  correct_answer = '{"value": "examine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '73ab6e2b-02eb-502d-b40c-ba9dc6263b87';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Everyone passed the test __________ for the student who was absent.',
  correct_answer = '{"value": "except"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '980f2017-e34b-583e-a0f2-cd26459bb611';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wanted to __________ her vocabulary by reading widely.',
  correct_answer = '{"value": "expand"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd2eff46e-01f1-520b-9d4a-6cfa4e3ca8c1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students can __________ feedback on their work within one week.',
  correct_answer = '{"value": "expect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e6d4ba85-1694-56fd-bd3c-d0988664b773';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The excursion gave students a chance to __________ the forest.',
  correct_answer = '{"value": "explore"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9827adb0-91d0-5dd2-9d71-f00ff4e05c74';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good writing allows you to __________ your ideas clearly.',
  correct_answer = '{"value": "express"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f503f66f-525e-5924-9305-970c344919f0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She hoped to __________ her research beyond the classroom.',
  correct_answer = '{"value": "extend"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '285a57a1-9636-53d6-baa3-7ba3c57606b5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Rainfall is an important __________ in farming decisions.',
  correct_answer = '{"value": "factor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8c0445bd-b984-5e40-ab56-0b78d5c1215c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The main __________ of the park is the large ornamental lake.',
  correct_answer = '{"value": "feature"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '34bec7b2-674b-58ff-a712-81fb7c5872de';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She used a bar graph to display the __________ in her report.',
  correct_answer = '{"value": "figure"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e572ff9a-6ab5-5417-9a74-bb28fa8c1bd7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Try to __________ on one task at a time for best results.',
  correct_answer = '{"value": "focus"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '102732e0-ec66-58e9-b6d1-a3f346e7d4bb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The letter used __________ language suitable for the audience.',
  correct_answer = '{"value": "formal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3f353f4d-5a5b-52fe-8670-f9e45458ab78';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientists discovered a rare __________ in the desert rock.',
  correct_answer = '{"value": "fossil"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '36e23af1-ef04-5ee1-b91d-70191bb49715';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each part of the machine has a specific __________.',
  correct_answer = '{"value": "function"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bbead578-a86f-522f-b6d8-f9f02e168291';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class helped __________ data for the science investigation.',
  correct_answer = '{"value": "gather"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2002fc16-a03a-5574-85e4-5d396462e628';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Wind turbines __________ electricity without producing pollution.',
  correct_answer = '{"value": "generate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f65ebc5c-5738-51ff-b05d-f8ac60f312b9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Climate change is a __________ issue that affects everyone.',
  correct_answer = '{"value": "global"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '90a5af5e-09ae-548a-b16b-2ff32b302143';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The improvement in her spelling was slow but __________.',
  correct_answer = '{"value": "gradual"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7049b6b6-1e38-596e-8759-9bdc6d852bfb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She designed a clear __________ to display her survey results.',
  correct_answer = '{"value": "graphic"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '42de429e-15a3-57af-a919-e38d2743b5d0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The wetland provides a vital __________ for many waterbirds.',
  correct_answer = '{"value": "habitat"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '88bbf4b0-d1a2-53da-b8a2-dce61b960ed0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She enjoyed learning about the __________ of ancient civilisations.',
  correct_answer = '{"value": "history"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '04b8461c-3940-500f-b895-20d8fb510f88';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It was a great __________ to receive the award at assembly.',
  correct_answer = '{"value": "honour"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a688c418-14d5-51f5-b284-9e13192ac96c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The drought had a severe __________ on the farming community.',
  correct_answer = '{"value": "impact"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8cc0d0ec-d897-59f1-a0cc-1c3aa4eb0be7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised daily to __________ her handwriting.',
  correct_answer = '{"value": "improve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd0e26dbd-493d-561a-913c-ea8e5ee6cee0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure you __________ a clear introduction in your essay.',
  correct_answer = '{"value": "include"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'baadfd14-20fd-5961-86cf-3908a74b2382';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The number of students in the class will __________ next term.',
  correct_answer = '{"value": "increase"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e011fc25-d1d8-5bf3-9103-7ae0b5813f53';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The newsletter is used to __________ families about school events.',
  correct_answer = '{"value": "inform"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0370992c-e535-568c-a8fb-bcfc8f73dffc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Great stories can __________ readers to think differently.',
  correct_answer = '{"value": "inspire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '251d9d58-7c84-5f9d-9542-d9fb2a38ea4a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She showed a keen __________ in science from an early age.',
  correct_answer = '{"value": "interest"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a3e35b13-f018-5731-b961-affdf25024c0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project will __________ every student in the year group.',
  correct_answer = '{"value": "involve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '929cf3bb-cdcb-5808-8909-7316c7c80853';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists sometimes need to __________ a single variable.',
  correct_answer = '{"value": "isolate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c11ac159-b86d-53d7-b72c-cba645001882';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote her ideas in a __________ every evening.',
  correct_answer = '{"value": "journal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dcd2d7a6-1262-5814-bacb-507c736eb858';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She spoke up for __________ when she saw someone treated unfairly.',
  correct_answer = '{"value": "justice"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a3d52aea-06ba-5d96-b06a-73a215219fa3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use the index to __________ the correct page quickly.',
  correct_answer = '{"value": "locate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c0900611-0ddd-5e2b-86ba-624bfd212496';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She made a __________ argument using facts and examples.',
  correct_answer = '{"value": "logical"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1ce62dd4-2a16-5e1b-98cb-541fa5ddf0ee';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Learning to __________ your time helps you finish tasks.',
  correct_answer = '{"value": "manage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f450b251-f9b1-5a2a-9044-044bb4f6fa12';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Leave a clear __________ on the left side of the page.',
  correct_answer = '{"value": "margin"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fa109ec1-f601-5abf-9b38-abdb02f5acf8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She forgot to __________ the most important piece of evidence.',
  correct_answer = '{"value": "mention"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0bd4b70e-e9b1-55cf-a7dc-db8401d46a98';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientist described the __________ used in the experiment.',
  correct_answer = '{"value": "method"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c3e843ef-3dbc-5f0f-a4d7-a7d45bba6909';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many birds __________ south in winter to find warmer weather.',
  correct_answer = '{"value": "migrate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c59a477d-fe6e-5da3-aebe-442df17a6542';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The error was __________ and did not change the final result.',
  correct_answer = '{"value": "minor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aa8ea82f-4639-58c6-a51d-4bbd8134300f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The astronaut trained hard to prepare for the __________.',
  correct_answer = '{"value": "mission"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9deb7c25-f97b-568b-b8ba-bcd66c1a607f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Concrete is a __________ of sand, water and cement.',
  correct_answer = '{"value": "mixture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '45b83edc-6da2-5334-83fe-436c82498cc8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Teachers __________ student progress throughout the year.',
  correct_answer = '{"value": "monitor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '72c17192-cde7-575e-bb46-5fa192f6a2aa';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The detective tried to find the __________ behind the mystery.',
  correct_answer = '{"value": "motive"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4c9de630-7d57-5cd2-b614-663fbbfbc5a5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was chosen to __________ the school production this year.',
  correct_answer = '{"value": "narrate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47aa24d0-28c5-5ceb-bd2d-3513017e5594';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The kangaroo is a __________ animal found only in Australia.',
  correct_answer = '{"value": "native"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '737c6f59-794d-5a9f-9505-700c1079a565';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had a __________ talent for music that surprised everyone.',
  correct_answer = '{"value": "natural"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7d309f94-b882-5ae1-87b5-c9f93a0e141a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists __________ carefully before recording their results.',
  correct_answer = '{"value": "observe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b38d8619-76d5-5f4a-849c-242007652ad5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You can __________ more information from the school website.',
  correct_answer = '{"value": "obtain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bdaa7a1a-76e4-584f-99de-fff2558c4fa3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The answer was __________ once she read the question again.',
  correct_answer = '{"value": "obvious"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cf5973ff-9bce-5418-9a9a-06da04192168';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She shared her __________ in a well-structured paragraph.',
  correct_answer = '{"value": "opinion"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '96a6b5a2-2a76-5e2d-8461-c97e36beafa3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had the __________ to choose between two different topics.',
  correct_answer = '{"value": "option"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '27108724-0a4e-5de7-91fd-47b17cc4d4b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The positive __________ was the result of many weeks of effort.',
  correct_answer = '{"value": "outcome"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a3dd6c38-cd27-5474-bdf1-82b4d630153d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Before writing she created an __________ of her main ideas.',
  correct_answer = '{"value": "outline"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0fd71a4b-2678-50f1-8ebd-71c4de0821f0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She noticed a clear __________ in the data she had collected.',
  correct_answer = '{"value": "pattern"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cbede945-068e-5469-ade9-f165d6bc5b74';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of exploration lasted several hundred years.',
  correct_answer = '{"value": "period"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '568f1bac-aef1-5923-87e9-4287727b4959';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students need a signed form to __________ them to leave early.',
  correct_answer = '{"value": "permit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a53d1b50-a15b-512d-90bd-b2343bfdbeae';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ her class to support the recycling project.',
  correct_answer = '{"value": "persuade"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'af523607-9d87-53fa-9a84-600a2ee4b555';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists use data to __________ future weather conditions.',
  correct_answer = '{"value": "predict"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b674e958-8e48-5272-8bb3-77c3bd08c0da';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She spent a week to __________ for the debating competition.',
  correct_answer = '{"value": "prepare"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5d89f08e-11d3-53fd-a200-ade990069968';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was asked to __________ her findings to the whole year group.',
  correct_answer = '{"value": "present"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7f49d90-fb81-5626-b5bc-a6c8ff2feba7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is a __________ resource that must be used carefully.',
  correct_answer = '{"value": "primary"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9b85bb4f-cd62-540c-ad4e-8f20c87c5280';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Follow each step in the __________ to get the correct result.',
  correct_answer = '{"value": "process"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '61a1638c-2865-5575-ac82-cfedbb4feb8c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Farms use technology to __________ food more efficiently.',
  correct_answer = '{"value": "produce"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3f36c89f-bace-5332-a7db-1cc1172028c4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The campaign aims to __________ healthy eating habits in schools.',
  correct_answer = '{"value": "promote"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b3010e3d-744f-5c65-8d89-695fcc2c5fa7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Always use __________ punctuation at the end of each sentence.',
  correct_answer = '{"value": "proper"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd8c7d21e-364b-5feb-b177-ae018a814fba';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Laws exist to __________ native animals and their habitats.',
  correct_answer = '{"value": "protect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '24e48d47-280d-5cf4-832d-7a37e40c2f9c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of the introduction is to hook the reader.',
  correct_answer = '{"value": "purpose"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1ac273dd-2f81-5367-8544-887adca7f174';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The book covered a wide __________ of topics in science.',
  correct_answer = '{"value": "range"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1d04e722-3916-543b-88d7-5728833fe386';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Give at least one __________ to support your point of view.',
  correct_answer = '{"value": "reason"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '95509bd5-3f14-5971-8fab-1bb9c75724c9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She kept a __________ of her reading progress across the term.',
  correct_answer = '{"value": "record"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c04e257d-bdf1-58b6-8dd9-c07b7ff1aa58';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Schools are trying to __________ the amount of plastic waste.',
  correct_answer = '{"value": "reduce"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '95f96840-68c8-5cc4-b0b2-a3c5b275df8a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good writers __________ on their work before submitting it.',
  correct_answer = '{"value": "reflect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '81dd99fd-ad6e-5f8d-96f8-3c089d07e6ef';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The northern __________ of Australia has a tropical climate.',
  correct_answer = '{"value": "region"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fee57e40-baf3-5ec9-9343-dc33c074922a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The conservation group decided to __________ the bird into the wild.',
  correct_answer = '{"value": "release"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c56b0d0-03fe-5b7e-ae6a-4eb7007efb8d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A good reference source must be accurate and __________.',
  correct_answer = '{"value": "reliable"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ee5c1aa7-725c-5b07-8967-fae47e4d4c96';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each symbol on the map is used to __________ a feature.',
  correct_answer = '{"value": "represent"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b9ce61f9-d056-5997-be60-8001c90956d4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The assignment will __________ careful research and planning.',
  correct_answer = '{"value": "require"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b4dcb773-0e27-5cee-9d44-70e4b411a83d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ the disagreement in a calm and fair way.',
  correct_answer = '{"value": "resolve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'afd05854-60b7-5d36-84ea-8f99584c98e9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is the most important natural __________ on Earth.',
  correct_answer = '{"value": "resource"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bdc30734-3ace-517f-a3b1-a3536f1dde42';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was quick to __________ to the question with a clear answer.',
  correct_answer = '{"value": "respond"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cc871fb8-d1ca-5f3d-86db-aae94f6be1cf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Volunteers worked hard to __________ the native bushland.',
  correct_answer = '{"value": "restore"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b2d106bd-7142-5f29-aecc-f918d0dcdb6a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story slowly begins to __________ the mystery at the end.',
  correct_answer = '{"value": "reveal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f4f0f1c4-14af-5921-9dd4-0982bf5e4ee3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote a book __________ for the school newsletter.',
  correct_answer = '{"value": "review"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8fd9dce5-c669-541a-bc49-8cb8ba3b0614';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is helpful to __________ your work before handing it in.',
  correct_answer = '{"value": "revise"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9306952c-945d-5e68-911f-b07f7e208570';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could feel the __________ of the poem as she read it aloud.',
  correct_answer = '{"value": "rhythm"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f9d9bbdc-a36d-58bd-88d7-70cd95f3be4c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Complete one __________ of the test at a time.',
  correct_answer = '{"value": "section"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9417d29d-15b2-5376-8288-48fe7bfaff94';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Number the steps in the correct __________ for the experiment.',
  correct_answer = '{"value": "sequence"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0cf667fc-728f-57b3-b5a6-dde750837b1c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She borrowed the whole __________ of books from the library.',
  correct_answer = '{"value": "series"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c7a90f7-3c1f-5a2f-badc-51c563deadee';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The two stories had __________ themes about friendship and courage.',
  correct_answer = '{"value": "similar"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a1f277ba-cccf-565e-b813-1caed6776196';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She remained calm in a difficult __________.',
  correct_answer = '{"value": "situation"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '35474785-c461-5c8f-b254-640bcea149d0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every member of __________ has a role to play in protecting the environment.',
  correct_answer = '{"value": "society"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '82e2c2f8-0d66-5d6b-8898-b553b9d334a6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She found a clever __________ to the difficult maths problem.',
  correct_answer = '{"value": "solution"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9d4446c7-d160-5654-b69a-90052efa4c06';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The river is a valuable __________ of fresh water for the region.',
  correct_answer = '{"value": "source"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6d3acb18-7eaa-594f-a398-c29c48dec2e5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use __________ examples to support your main argument.',
  correct_answer = '{"value": "specific"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '33d3ed73-21eb-57e9-aaaf-7b963db1403c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her essay had a clear __________ with an introduction and conclusion.',
  correct_answer = '{"value": "structure"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '52ff8d69-19d6-562a-bc36-7d13dfe289d9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write a __________ of the chapter in your own words.',
  correct_answer = '{"value": "summary"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f7c5c552-0741-5804-8ec5-8e60c3e2468b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good friends __________ each other through difficult times.',
  correct_answer = '{"value": "support"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cc3325d5-c283-5578-ac9b-58239b8f7fe2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dove is a __________ of peace in many cultures.',
  correct_answer = '{"value": "symbol"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2a88ecf5-0d6f-50c9-b92c-e7825427ce7b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The water cycle is a natural __________ that never stops.',
  correct_answer = '{"value": "system"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '55b692a6-1165-5f07-a6d2-80dedfb652e5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She described the __________ of the rock as rough and grainy.',
  correct_answer = '{"value": "texture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9fdae4ee-a020-5ac9-b826-5cb5a77682af';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists develop a __________ and then test it with experiments.',
  correct_answer = '{"value": "theory"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4c1f25ad-0e3c-5b80-b006-c83bb44f3b9e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Sharing a meal together is a __________ in many families.',
  correct_answer = '{"value": "tradition"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6e32b090-fb65-50c2-af43-b2e0c7d7fbc8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped __________ the information from her notes to her essay.',
  correct_answer = '{"value": "transfer"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '74231d56-c521-5bba-aff1-581f55cb6be8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Exposure to the sun can __________ a caterpillar habitat quickly.',
  correct_answer = '{"value": "transform"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7c1fed08-0f1c-5587-8317-a8aca121c691';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ school day begins with reading and maths.',
  correct_answer = '{"value": "typical"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2b4fdc30-4587-5560-b098-3e0f1f41b347';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student''s writing voice is completely __________.',
  correct_answer = '{"value": "unique"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c1a8edf4-8029-5509-b194-357c55613962';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher gave an __________ on the class project progress.',
  correct_answer = '{"value": "update"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '024120e1-1de9-556a-b0dc-f1b0941530ab';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The report included __________ types of graphs to display the data.',
  correct_answer = '{"value": "various"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e966839f-d2c6-5e5c-acf1-57e39a7d47a6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She edited the first __________ of her essay many times.',
  correct_answer = '{"value": "version"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b795dc67-cc63-51be-891d-99b88905a4ae';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Adjust the __________ of the speaker so everyone can hear.',
  correct_answer = '{"value": "volume"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2b29b5d0-b9ce-545c-b6ef-eda3c852e067';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ certain the answer was correct.',
  correct_answer = '{"value": "absolute"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eeaa8cfc-cee7-5c1b-8a9f-8e7092ad3b6c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her description of the events was very __________.',
  correct_answer = '{"value": "accurate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9c07b8ba-235c-545e-87a0-760bda94b802';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

With practice anyone can __________ their goals.',
  correct_answer = '{"value": "achieve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5045b525-6e42-516f-afae-172624c29e38';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your __________ clearly on the envelope.',
  correct_answer = '{"value": "address"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd45fa4b8-b0de-5694-9eda-4dda95fbb23d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many students __________ the way she explains things clearly.',
  correct_answer = '{"value": "admire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ddcd08d-504d-5d1c-b796-95005a996958';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The team made good __________ during the project.',
  correct_answer = '{"value": "advance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0d2ced98-b861-5acf-ba38-0c62d6e7a5d3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ how well you sleep.',
  correct_answer = '{"value": "affect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c55d0895-4da4-56d5-aa9c-1a99aa5fbd83';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Both teams could not __________ on the rules of the game.',
  correct_answer = '{"value": "agree"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '75d9117e-6ae1-53ba-a139-0249340ffca8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The museum displayed __________ tools from thousands of years ago.',
  correct_answer = '{"value": "ancient"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8a5230aa-3aca-5d87-8185-c395e89a2fc1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The colourful display had great __________ for the visitors.',
  correct_answer = '{"value": "appeal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'db2cd7c8-71cb-58b0-8901-cfd9c07b288c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped __________ the chairs into a circle.',
  correct_answer = '{"value": "arrange"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c76ef885-ace8-540e-9ff3-44a85ab33a3e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote an __________ about recycling for the school newsletter.',
  correct_answer = '{"value": "article"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a217a4db-1138-5631-961c-954bed1d9087';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is kind to __________ someone who is struggling.',
  correct_answer = '{"value": "assist"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c42d7323-d517-5c5d-83fb-0cad1e0d4ec3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your permission form to the email.',
  correct_answer = '{"value": "attach"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4a253d7-d788-582f-a260-5c95a91602a8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make at least one __________ before asking for help.',
  correct_answer = '{"value": "attempt"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e40ee3a3-e731-57fb-a790-8fd16a35086a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Bright flowers __________ bees and butterflies to the garden.',
  correct_answer = '{"value": "attract"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eaeeec42-9931-5038-8d85-dc111f62df26';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised __________ on one foot during gymnastics.',
  correct_answer = '{"value": "balance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c01a2bd2-1ed9-501e-9060-8661cfda7bda';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Exercise is a great __________ for both the mind and body.',
  correct_answer = '{"value": "benefit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '232e9364-0123-5677-bb48-c7484981aa95';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The garden has a neat flower __________ along each edge.',
  correct_answer = '{"value": "border"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c4a67cd0-b044-530b-afd0-d6fd3679fe17';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She gave a __________ summary of the chapter she had read.',
  correct_answer = '{"value": "brief"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c9c63cdc-5805-5499-bff7-cada5c603f07';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The student came up with a __________ solution to the problem.',
  correct_answer = '{"value": "brilliant"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '321caaa8-2141-5dbb-bba2-f1bc540f2463';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class had a small __________ for the science project materials.',
  correct_answer = '{"value": "budget"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '91b40566-e49a-594d-8902-ea16f6113d19';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She is __________ of completing the task on her own.',
  correct_answer = '{"value": "capable"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f8a1d496-a6a0-5e74-8772-e5c519545816';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The photographer managed to __________ the moment perfectly.',
  correct_answer = '{"value": "capture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47f275fc-63db-5f1f-9c66-1989d58d53b0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The building was built in the nineteenth __________.',
  correct_answer = '{"value": "century"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '34291dfe-572c-5632-a2c9-537b08ce404c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ she had packed her library book.',
  correct_answer = '{"value": "certain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0bda7e77-bc32-57aa-8ac4-e267773b1915';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The puzzle was a great __________ for the whole group.',
  correct_answer = '{"value": "challenge"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '796938e8-ca70-5274-abe5-1a2b70e4fc54';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read the first __________ before going to sleep.',
  correct_answer = '{"value": "chapter"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1c6cfa88-37fe-50d1-bbe7-d923adfa651f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The main __________ in the story was brave and kind.',
  correct_answer = '{"value": "character"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b7350695-7544-5712-849b-926a00b3aea5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every __________ has a responsibility to care for the environment.',
  correct_answer = '{"value": "citizen"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f526d303-a5e2-5a6c-9ad7-3b3874d8d6fc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dry __________ means the town rarely receives heavy rain.',
  correct_answer = '{"value": "climate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0b6b59ff-5a7d-520a-bdf9-be45fcda7467';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She loves to __________ interesting rocks from the beach.',
  correct_answer = '{"value": "collect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '862eb7e6-2806-5e08-8ff2-ae6bda15a51d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Add the numbers in each __________ to find the total.',
  correct_answer = '{"value": "column"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2c1564a9-bd57-5628-b7e3-d3e195c0aafa';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the flour and butter to make the dough.',
  correct_answer = '{"value": "combine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ab5ef137-44a2-5d26-a42d-289a4b9b1d8c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She offered her friend __________ after the disappointing result.',
  correct_answer = '{"value": "comfort"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '08e41e03-b851-53e8-9fae-1d888497f1c5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

He made a helpful __________ about the presentation.',
  correct_answer = '{"value": "comment"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0168c085-570a-57b2-b899-e0c415973144';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The instructions looked __________ at first but became clear.',
  correct_answer = '{"value": "complex"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e4c01acb-c442-5943-a3b6-66a856fec586';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher showed __________ for the student who was absent.',
  correct_answer = '{"value": "concern"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '27c3c616-c679-53a3-99c8-0b222dc211bf';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

After all the research she could __________ the experiment.',
  correct_answer = '{"value": "conclude"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '87d8fc00-fb76-56a3-a1e3-c980ad571936';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story had a strong __________ between the two characters.',
  correct_answer = '{"value": "conflict"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1ddb8b89-0119-5237-8a8b-3f6e26fd1745';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to __________ the ideas in each paragraph.',
  correct_answer = '{"value": "connect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '94cb923f-dbf6-5b99-a002-91a4a87b846a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The jar can __________ up to two litres of water.',
  correct_answer = '{"value": "contain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '30d7aeff-7aa9-53f2-bc6a-4cd002a63c5a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ with the result of her hard work.',
  correct_answer = '{"value": "content"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1031f54e-8936-5a2f-9596-dcdefeab73aa';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ between the two characters made the story interesting.',
  correct_answer = '{"value": "contrast"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '26a611cc-6682-5c97-8ab7-9892185acab2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientist worked to __________ the temperature of the experiment.',
  correct_answer = '{"value": "control"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47e8f301-3955-59cd-9e7b-299b04522f6e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You need to __________ the measurements from metres to centimetres.',
  correct_answer = '{"value": "convert"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '994812e8-cb0b-5f73-a090-c0b9ce0f0dec';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Check your answers to make sure each one is __________.',
  correct_answer = '{"value": "correct"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '24354a07-a7a3-587f-89d7-027928362e3d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The student __________ met every Tuesday to discuss ideas.',
  correct_answer = '{"value": "council"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '61927e52-4a98-5747-8229-cc8a3990bdb5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She used her imagination to __________ a fantastic short story.',
  correct_answer = '{"value": "create"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c61a8159-da2d-5e9f-b941-893408471a0c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ news includes reports on local environment issues.',
  correct_answer = '{"value": "current"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e69abb8b-2d93-59bb-9c27-00b64df1411d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class held a __________ about the importance of recycling.',
  correct_answer = '{"value": "debate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7d14e632-d96b-5735-817a-a96a67ba7f1f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She stood up to __________ her idea to the whole class.',
  correct_answer = '{"value": "declare"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2e19721d-cc60-5ad1-b0d4-ad80bd41304d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A good writer can __________ their argument with evidence.',
  correct_answer = '{"value": "defend"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1ccddb39-6049-54a4-ad39-52f81a29c445';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use a dictionary to __________ any unfamiliar words you find.',
  correct_answer = '{"value": "define"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '51a820ad-d0be-590a-8924-5e7e1a170c95';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project requires a high __________ of effort and time.',
  correct_answer = '{"value": "demand"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6594118f-c518-5eea-a561-38c84c7d141d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

__________ the setting of the story using sensory details.',
  correct_answer = '{"value": "describe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '53cb7383-49fa-5889-afbd-4907a29c7df2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was asked to __________ the cover for the class magazine.',
  correct_answer = '{"value": "design"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '97181a85-11b8-5b40-bc72-55e81d16845d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Adding specific __________ makes your writing much more vivid.',
  correct_answer = '{"value": "detail"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '06e46cba-8113-5e3e-a17a-e30295171732';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists can __________ very small changes in temperature.',
  correct_answer = '{"value": "detect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b84cb8dd-b1ad-5072-8f7f-b4adb503612a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Regular reading helps __________ vocabulary and comprehension.',
  correct_answer = '{"value": "develop"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a4bd21df-66c8-5789-b12c-8e622ce693b2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student was given a __________ to use during the lesson.',
  correct_answer = '{"value": "device"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '46d93987-3058-5c60-beb7-011ef3bf6e94';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The school library offers both print and __________ resources.',
  correct_answer = '{"value": "digital"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e7c42ffe-9e4b-52ab-8946-af847c30e103';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class will __________ the topic before writing their essays.',
  correct_answer = '{"value": "discuss"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b5ed0392-7b6c-5e32-a8d3-c57e0e8d9082';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The artwork was put on __________ in the school foyer.',
  correct_answer = '{"value": "display"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a7374afc-bd8b-5ba8-ba79-1a8b5e37e4a6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She ran the full __________ of the cross-country course.',
  correct_answer = '{"value": "distance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '69f82ee1-8c9e-58b0-a8d8-1925238692de';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class had a __________ range of opinions on the topic.',
  correct_answer = '{"value": "diverse"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f83bd4ff-4eac-587f-8c61-0220e926d5bb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She kept a __________ of all the research she had gathered.',
  correct_answer = '{"value": "document"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '888b9e37-698f-5ed2-93e5-5f0509b5d260';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Learning to save money is part of understanding __________.',
  correct_answer = '{"value": "economy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '738ae2a6-e693-562b-a4c0-bdfc7c6dcab6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She borrowed the latest __________ from the school library.',
  correct_answer = '{"value": "edition"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '507b0457-596a-54df-9fe0-49653b922154';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The rainy weather had a calming __________ on the afternoon.',
  correct_answer = '{"value": "effect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a822d89a-3768-5d42-8fec-34527917b043';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is an important __________ for all living things.',
  correct_answer = '{"value": "element"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'adfd9150-34f5-50d9-b3e6-2c17bbe9da8c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The Roman __________ covered a vast area of Europe.',
  correct_answer = '{"value": "empire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4d34e718-f7b5-5f6a-86b3-32836f1c00ee';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her teacher always tried to __________ her to do her best.',
  correct_answer = '{"value": "encourage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bafa7cdd-bfdc-57f4-ac76-986bdebf25dd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Solar panels use __________ from the sun to produce electricity.',
  correct_answer = '{"value": "energy"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '05b5745f-8779-54c1-8f6b-b64fb05f3674';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good books __________ the reader from the very first page.',
  correct_answer = '{"value": "engage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c5f0d03b-b4b6-59cd-bac0-8a8fcd96067d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She read the __________ novel in one rainy weekend.',
  correct_answer = '{"value": "entire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c0d07a5c-08bd-5774-a1e2-1c719bba8125';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her competition __________ was chosen as the class winner.',
  correct_answer = '{"value": "entry"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '589c35aa-e4dc-5b3e-8c70-978f26d9c501';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ how long the task would take.',
  correct_answer = '{"value": "estimate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8876f561-aa90-5fbc-ad25-78a9206c4608';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The sports __________ attracted families from across the district.',
  correct_answer = '{"value": "event"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e3bef706-b517-551b-90ea-2017395c3070';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She gathered __________ from the text to support her argument.',
  correct_answer = '{"value": "evidence"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6b924ffe-978a-5a0d-b854-f94a8bafe379';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists __________ the data carefully before drawing conclusions.',
  correct_answer = '{"value": "examine"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd775a651-0ece-586e-b6d0-0f8fcb2ea08d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Everyone passed the test __________ for the student who was absent.',
  correct_answer = '{"value": "except"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9f4ff442-8fba-512d-8d2b-adfac17b2301';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wanted to __________ her vocabulary by reading widely.',
  correct_answer = '{"value": "expand"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '905ccada-d57a-5f9a-ae79-163f64dd16ff';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students can __________ feedback on their work within one week.',
  correct_answer = '{"value": "expect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b063b20d-f251-53ff-abe7-50cc4737e0a6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The excursion gave students a chance to __________ the forest.',
  correct_answer = '{"value": "explore"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ac7dc0fb-bf54-5be2-9fcb-f91a041cd532';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good writing allows you to __________ your ideas clearly.',
  correct_answer = '{"value": "express"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a1099df5-5328-536e-a8dd-fadf4eec1181';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She hoped to __________ her research beyond the classroom.',
  correct_answer = '{"value": "extend"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '805067db-84b5-56e8-9f32-09169e4e93d6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Rainfall is an important __________ in farming decisions.',
  correct_answer = '{"value": "factor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '96becb3d-8879-5f66-b71e-90b46aae4b6b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The main __________ of the park is the large ornamental lake.',
  correct_answer = '{"value": "feature"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7a0767ac-5636-55fe-b8be-b2669b6b5498';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She used a bar graph to display the __________ in her report.',
  correct_answer = '{"value": "figure"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1b027887-bfb3-50cb-9aff-1b182a71d302';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Try to __________ on one task at a time for best results.',
  correct_answer = '{"value": "focus"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '203b6991-835e-5a04-9b76-1c7de5e9b5a0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The letter used __________ language suitable for the audience.',
  correct_answer = '{"value": "formal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '14243d0b-42f9-5b9c-9df6-64904b29d318';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientists discovered a rare __________ in the desert rock.',
  correct_answer = '{"value": "fossil"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '679039e1-03d7-59e0-8590-4cda8a286459';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each part of the machine has a specific __________.',
  correct_answer = '{"value": "function"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '45a92bfd-b93d-59aa-94ac-877d0539f3ef';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The class helped __________ data for the science investigation.',
  correct_answer = '{"value": "gather"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f6629436-1250-59be-8292-94f4c6b23903';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Wind turbines __________ electricity without producing pollution.',
  correct_answer = '{"value": "generate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b846f1fb-4c03-5529-9d04-120047b93004';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Climate change is a __________ issue that affects everyone.',
  correct_answer = '{"value": "global"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd5419470-ac71-5ae2-8687-faa3b85658d8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The improvement in her spelling was slow but __________.',
  correct_answer = '{"value": "gradual"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9fe8f4ae-55f1-556f-bb48-66f42e02b145';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She designed a clear __________ to display her survey results.',
  correct_answer = '{"value": "graphic"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4f4e546e-af13-5fe1-b94b-f4fde770e0a2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The wetland provides a vital __________ for many waterbirds.',
  correct_answer = '{"value": "habitat"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '519f580b-4682-5782-b853-37876d5abe6d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She enjoyed learning about the __________ of ancient civilisations.',
  correct_answer = '{"value": "history"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '70e53470-04f9-5d92-a6d5-0aca896692a1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It was a great __________ to receive the award at assembly.',
  correct_answer = '{"value": "honour"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c435d8ff-bfa7-5db8-9cdc-f9d4ffa69e93';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The drought had a severe __________ on the farming community.',
  correct_answer = '{"value": "impact"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '49d577b4-098e-51e3-9235-c58c648c934d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She practised daily to __________ her handwriting.',
  correct_answer = '{"value": "improve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd4844144-bc5d-5cd1-867c-0d355f942ef2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make sure you __________ a clear introduction in your essay.',
  correct_answer = '{"value": "include"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cda8114c-8397-5267-9775-fa16632dbc90';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The number of students in the class will __________ next term.',
  correct_answer = '{"value": "increase"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c198cf6b-a37e-5251-8ef7-d8f9ddccbc76';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The newsletter is used to __________ families about school events.',
  correct_answer = '{"value": "inform"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fdcb0791-33cf-565a-a25e-f7f2484e4895';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Great stories can __________ readers to think differently.',
  correct_answer = '{"value": "inspire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2fd2a8c8-e2e9-5df8-9502-929e987b4b42';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She showed a keen __________ in science from an early age.',
  correct_answer = '{"value": "interest"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '96c12f10-81bb-5c44-ac33-96739cb556ec';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The project will __________ every student in the year group.',
  correct_answer = '{"value": "involve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '59e5b7f4-e6ee-5d3a-994a-219c3465a6dd';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists sometimes need to __________ a single variable.',
  correct_answer = '{"value": "isolate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2e475226-5251-5a1c-8bb8-6150d59ed17f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote her ideas in a __________ every evening.',
  correct_answer = '{"value": "journal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '47883098-20dc-549d-bfb2-bc431fa15076';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She spoke up for __________ when she saw someone treated unfairly.',
  correct_answer = '{"value": "justice"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eef2b835-7552-510c-a3e6-2f8dd134081b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use the index to __________ the correct page quickly.',
  correct_answer = '{"value": "locate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '9df93d5c-3f91-5cae-9814-60a9f43d7991';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She made a __________ argument using facts and examples.',
  correct_answer = '{"value": "logical"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '58c0f5bc-af45-5826-a44c-e17b12ff95b7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Learning to __________ your time helps you finish tasks.',
  correct_answer = '{"value": "manage"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e9f8f9ae-4700-51eb-8172-e8e81e9e6d7c';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Leave a clear __________ on the left side of the page.',
  correct_answer = '{"value": "margin"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a38211ad-4b06-5ea8-994a-1cf3faa0b92e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She forgot to __________ the most important piece of evidence.',
  correct_answer = '{"value": "mention"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '69b23ddc-7f98-5fe4-a6d6-eca4b016cb2d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The scientist described the __________ used in the experiment.',
  correct_answer = '{"value": "method"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '915a8cca-06d7-59f7-b7ab-c0f39fbb9ba8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many birds __________ south in winter to find warmer weather.',
  correct_answer = '{"value": "migrate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a957216c-c75e-53f1-a5d4-48e94ac8bd11';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The error was __________ and did not change the final result.',
  correct_answer = '{"value": "minor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd3dfa5d9-3559-54d7-8634-8ca2b6c7c684';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The astronaut trained hard to prepare for the __________.',
  correct_answer = '{"value": "mission"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8eafd25c-4519-5ecf-b0d4-4adbcb775433';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Concrete is a __________ of sand, water and cement.',
  correct_answer = '{"value": "mixture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a3e97179-a122-59dd-9fad-8cc6c659b67a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Teachers __________ student progress throughout the year.',
  correct_answer = '{"value": "monitor"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1660fffd-3a8f-53d0-a5ab-b55d44a811f4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The detective tried to find the __________ behind the mystery.',
  correct_answer = '{"value": "motive"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5685e924-df83-5b2d-a6bf-275fe55a3f39';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was chosen to __________ the school production this year.',
  correct_answer = '{"value": "narrate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4f134279-6f9b-5c91-99c0-32b6e7a94c25';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The kangaroo is a __________ animal found only in Australia.',
  correct_answer = '{"value": "native"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '60b3b345-3dcf-56b8-9267-7b961888c56a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had a __________ talent for music that surprised everyone.',
  correct_answer = '{"value": "natural"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e607bc64-3694-5312-9816-29ecfc9d7253';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists __________ carefully before recording their results.',
  correct_answer = '{"value": "observe"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'bceb9782-08f3-501b-85cd-1428ad3b2347';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

You can __________ more information from the school website.',
  correct_answer = '{"value": "obtain"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ff5f7c3-d436-5aa9-a65a-d141a24210ec';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The answer was __________ once she read the question again.',
  correct_answer = '{"value": "obvious"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7ee48bce-1f62-58d8-a232-15eb84e29216';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She shared her __________ in a well-structured paragraph.',
  correct_answer = '{"value": "opinion"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '87f3e3b6-d31d-52ec-9832-2de3a5315ec5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She had the __________ to choose between two different topics.',
  correct_answer = '{"value": "option"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5e0d603d-8c02-5ed2-9906-55c1398b1511';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The positive __________ was the result of many weeks of effort.',
  correct_answer = '{"value": "outcome"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '2a77df9d-d657-5328-940e-097ec21ce0cc';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Before writing she created an __________ of her main ideas.',
  correct_answer = '{"value": "outline"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a4cf76b1-5a43-5841-bd11-1c76e7267c9b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She noticed a clear __________ in the data she had collected.',
  correct_answer = '{"value": "pattern"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '7e22849f-4103-56e8-b161-d68c446a4d0d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of exploration lasted several hundred years.',
  correct_answer = '{"value": "period"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '23ccd8a3-e256-5bca-ba68-dca9752df0d0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Students need a signed form to __________ them to leave early.',
  correct_answer = '{"value": "permit"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e64fa560-4240-543a-aaf8-86519bfae0a5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ her class to support the recycling project.',
  correct_answer = '{"value": "persuade"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '79520187-48b2-500c-9246-8094f192e955';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists use data to __________ future weather conditions.',
  correct_answer = '{"value": "predict"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '958d5dc3-ad58-5f95-9dda-1f4121d6bd76';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She spent a week to __________ for the debating competition.',
  correct_answer = '{"value": "prepare"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'd2e63cd7-1ec7-5d43-b727-1857209f8f42';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was asked to __________ her findings to the whole year group.',
  correct_answer = '{"value": "present"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1162137c-7cce-5548-bce5-6f534183e561';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is a __________ resource that must be used carefully.',
  correct_answer = '{"value": "primary"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4f6fbe91-acaf-5a3c-9ca1-ce8ef548c5c4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Follow each step in the __________ to get the correct result.',
  correct_answer = '{"value": "process"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'dbf49b15-0fd8-542e-a6b1-50807f5e681b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Farms use technology to __________ food more efficiently.',
  correct_answer = '{"value": "produce"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0a53c861-59df-5719-b3e6-8dac3b0e560b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The campaign aims to __________ healthy eating habits in schools.',
  correct_answer = '{"value": "promote"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ee72390c-e54c-5a57-9f53-ee15ee3c4e50';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Always use __________ punctuation at the end of each sentence.',
  correct_answer = '{"value": "proper"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '268ed29f-651e-5a48-af7c-a2fed6aa35c8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Laws exist to __________ native animals and their habitats.',
  correct_answer = '{"value": "protect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'afc5b617-fb43-5476-b83d-3ddc63abca01';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The __________ of the introduction is to hook the reader.',
  correct_answer = '{"value": "purpose"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5e0a675f-6d1d-5e9a-a3fe-b8e2f785ece1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The book covered a wide __________ of topics in science.',
  correct_answer = '{"value": "range"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c9082637-e0a5-5fe6-b42e-fb9202d517e4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Give at least one __________ to support your point of view.',
  correct_answer = '{"value": "reason"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '84985e57-efa4-5bfc-9a5a-d800358696eb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She kept a __________ of her reading progress across the term.',
  correct_answer = '{"value": "record"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8d45c9bf-0fc5-51e1-a789-6219523c5845';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Schools are trying to __________ the amount of plastic waste.',
  correct_answer = '{"value": "reduce"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '300aa6f5-0208-5124-88c4-e6e40666292d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good writers __________ on their work before submitting it.',
  correct_answer = '{"value": "reflect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a29063fe-ae4f-5293-b874-09c46a8ecfa7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The northern __________ of Australia has a tropical climate.',
  correct_answer = '{"value": "region"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8c65ee8a-5d96-5b8a-861f-4d8c31c0bbc7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The conservation group decided to __________ the bird into the wild.',
  correct_answer = '{"value": "release"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '83ca69d9-1a53-5740-b7bc-2dbda957a263';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A good reference source must be accurate and __________.',
  correct_answer = '{"value": "reliable"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '3176dea1-f837-5da1-82d4-91d14fdf0743';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each symbol on the map is used to __________ a feature.',
  correct_answer = '{"value": "represent"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4a308d76-0157-58db-a8f7-5ee87e311201';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The assignment will __________ careful research and planning.',
  correct_answer = '{"value": "require"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'abb4d0b1-b66e-53bb-a818-2d4df4f52838';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She tried to __________ the disagreement in a calm and fair way.',
  correct_answer = '{"value": "resolve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1e9dd568-5f62-5240-b8ff-d359dcbc6a94';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Water is the most important natural __________ on Earth.',
  correct_answer = '{"value": "resource"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6d8c2a22-9b82-5d4e-a5ae-576f9f47efc7';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was quick to __________ to the question with a clear answer.',
  correct_answer = '{"value": "respond"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f21da9c4-46a1-534a-a47f-c1bca7cdb6c1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Volunteers worked hard to __________ the native bushland.',
  correct_answer = '{"value": "restore"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c82b2dc4-ed50-5074-87bb-00001d55d28f';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The story slowly begins to __________ the mystery at the end.',
  correct_answer = '{"value": "reveal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b4ed1e3b-12ab-5398-970a-d3ab6a690c92';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote a book __________ for the school newsletter.',
  correct_answer = '{"value": "review"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '8bf66ca7-ee15-55f5-90c7-ad3ab3327c07';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is helpful to __________ your work before handing it in.',
  correct_answer = '{"value": "revise"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e0cd4dcf-4798-5bbd-8579-95892306b477';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She could feel the __________ of the poem as she read it aloud.',
  correct_answer = '{"value": "rhythm"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '66bc0c35-0e57-5804-93af-1f66895e73f6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Complete one __________ of the test at a time.',
  correct_answer = '{"value": "section"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '533e86a0-be1e-5b34-96e0-6e531e0a32e2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Number the steps in the correct __________ for the experiment.',
  correct_answer = '{"value": "sequence"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b08359cb-0d2d-50d5-9c80-4846226b28b2';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She borrowed the whole __________ of books from the library.',
  correct_answer = '{"value": "series"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '88314050-4f5d-5bd6-b20e-4aa32666b56b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The two stories had __________ themes about friendship and courage.',
  correct_answer = '{"value": "similar"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fe25d740-5623-528e-8169-bfef6110125d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She remained calm in a difficult __________.',
  correct_answer = '{"value": "situation"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cadc21e5-e950-5200-a0a0-386edcfbb45a';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Every member of __________ has a role to play in protecting the environment.',
  correct_answer = '{"value": "society"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4ed197eb-7cb7-55d1-96e6-c5a4621a1505';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She found a clever __________ to the difficult maths problem.',
  correct_answer = '{"value": "solution"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0ba4943a-4105-5b3c-97ad-d53cbeaf9694';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The river is a valuable __________ of fresh water for the region.',
  correct_answer = '{"value": "source"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'fd1fa88c-5bfb-5896-9aa3-01b792529e5b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Use __________ examples to support your main argument.',
  correct_answer = '{"value": "specific"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '67c16263-69d1-5270-9bc9-9ae2ffdca4ad';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her essay had a clear __________ with an introduction and conclusion.',
  correct_answer = '{"value": "structure"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '989996b1-699c-5eae-bd99-4e222cb0abe9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write a __________ of the chapter in your own words.',
  correct_answer = '{"value": "summary"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '137fa5e4-1af6-5d40-b6c6-beb0faa21bf0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Good friends __________ each other through difficult times.',
  correct_answer = '{"value": "support"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e2e084f0-8fe4-5a07-a1eb-4f4fe647dab0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The dove is a __________ of peace in many cultures.',
  correct_answer = '{"value": "symbol"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '6b7a3b4b-a8ce-54ba-bafd-5c70c88d2339';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The water cycle is a natural __________ that never stops.',
  correct_answer = '{"value": "system"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '5ab75001-7a48-5cd3-80d1-a0972cc6a91b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She described the __________ of the rock as rough and grainy.',
  correct_answer = '{"value": "texture"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4f4b8de4-823f-5f21-89e9-e2bba1c06d7d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Scientists develop a __________ and then test it with experiments.',
  correct_answer = '{"value": "theory"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '69c44ed7-5494-57fb-a3ef-bbc21b7108b4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Sharing a meal together is a __________ in many families.',
  correct_answer = '{"value": "tradition"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'cb0c9d6a-b589-5b7d-842a-adbe51311405';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped __________ the information from her notes to her essay.',
  correct_answer = '{"value": "transfer"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1daad328-dbd6-5971-8e03-cb0f0b19e971';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Exposure to the sun can __________ a caterpillar habitat quickly.',
  correct_answer = '{"value": "transform"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '97c7ec9e-4981-59e0-9748-c1c73d7e2a2d';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

A __________ school day begins with reading and maths.',
  correct_answer = '{"value": "typical"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '60b8eae9-e5ee-5026-a48a-0e3bda35d091';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Each student''s writing voice is completely __________.',
  correct_answer = '{"value": "unique"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'e494a634-e867-5f2d-8399-09ccba95ebfb';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The teacher gave an __________ on the class project progress.',
  correct_answer = '{"value": "update"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '83421b37-618a-5f50-be34-dc13958acea0';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The report included __________ types of graphs to display the data.',
  correct_answer = '{"value": "various"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'a1084694-be00-59a3-ad28-5158097757ba';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She edited the first __________ of her essay many times.',
  correct_answer = '{"value": "version"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'b2640197-bb52-5b8c-a475-a251230893d3';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Adjust the __________ of the speaker so everyone can hear.',
  correct_answer = '{"value": "volume"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'f396bca3-50d7-5bdb-be4e-3be163341739';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She was __________ certain the answer was correct.',
  correct_answer = '{"value": "absolute"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'accacd48-5b2d-5e82-8fa4-6580549078d5';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Her description of the events was very __________.',
  correct_answer = '{"value": "accurate"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '149fa54e-7338-53d4-bc85-3d5c05b5d0e9';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

With practice anyone can __________ their goals.',
  correct_answer = '{"value": "achieve"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '0a9af8aa-0e54-54ff-b9a2-8663e625ec29';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Write your __________ clearly on the envelope.',
  correct_answer = '{"value": "address"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '51d92d32-4ed4-57ae-81fb-92dae9b6e3c6';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Many students __________ the way she explains things clearly.',
  correct_answer = '{"value": "admire"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c9fa72c9-7ff7-5b16-95a8-27faf97b27ed';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The team made good __________ during the project.',
  correct_answer = '{"value": "advance"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '79b1f927-5bb5-5b32-89b6-07622c0110ff';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The weather can __________ how well you sleep.',
  correct_answer = '{"value": "affect"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'eb12075e-9d16-502b-af7c-f02e2dc956d4';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Both teams could not __________ on the rules of the game.',
  correct_answer = '{"value": "agree"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ba68a0da-1818-5b66-afdb-3ae720dba051';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The museum displayed __________ tools from thousands of years ago.',
  correct_answer = '{"value": "ancient"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'ab11022c-ab42-52d8-bea0-561edd3b095b';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

The colourful display had great __________ for the visitors.',
  correct_answer = '{"value": "appeal"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4593c16f-d2fe-5bcd-a0a0-4fa23158ddb8';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She helped __________ the chairs into a circle.',
  correct_answer = '{"value": "arrange"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'aef5d93e-1a6e-517c-b8aa-0a4f55ec5563';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

She wrote an __________ about recycling for the school newsletter.',
  correct_answer = '{"value": "article"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '06190d61-9429-58d9-9709-02c16783c9d1';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

It is kind to __________ someone who is struggling.',
  correct_answer = '{"value": "assist"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '1f31b65c-a755-5255-9304-f9938515c856';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Please __________ your permission form to the email.',
  correct_answer = '{"value": "attach"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '4bb4cb10-75f5-581a-9035-abc15f5f540e';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Make at least one __________ before asking for help.',
  correct_answer = '{"value": "attempt"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = '531b262f-7436-5a14-b9ed-4b77e7871520';

UPDATE questions SET
  question_type = 'SHORT_ANSWER',
  question_text = 'Complete the sentence by spelling the missing word correctly. Type the missing word in the box below.

Bright flowers __________ bees and butterflies to the garden.',
  correct_answer = '{"value": "attract"}'::jsonb,
  options       = NULL,
  audio_url     = NULL,
  stimulus_id   = NULL,
  stimulus_type = NULL,
  updated_at    = NOW()
WHERE id = 'c505be5a-1fb9-51c4-81b7-98b5fe5ddf88';

-- ============================================================
-- PART E: Archive audio stimuli records for Spelling domain
-- ============================================================
UPDATE stimuli SET status = 'ARCHIVED', updated_at = NOW()
WHERE stimulus_type = 'AUDIO' AND domain = 'SPELLING';

-- Verify: should be 0 rows
-- SELECT COUNT(*) FROM questions WHERE question_type = 'AUDIO_RESPONSE' AND domain = 'SPELLING';
