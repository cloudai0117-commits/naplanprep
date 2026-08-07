-- Link questions to exams based on matching year_level, domain, and package_type.
-- Each exam gets a randomly-shuffled selection of questions from the matching pool.
-- FREE exams: 8 questions each; ADVANCED: 12; PREMIUM: 15

DO $$
DECLARE
  exam_rec  RECORD;
  q_ids     UUID[];
  q_count   INT;
  i         INT;
BEGIN
  FOR exam_rec IN
    SELECT id, year_level, domain, package_type
    FROM   exams
    WHERE  status = 'PUBLISHED'
    ORDER  BY year_level, domain, package_type, id
  LOOP
    q_count := CASE exam_rec.package_type
      WHEN 'FREE'     THEN 8
      WHEN 'ADVANCED' THEN 12
      WHEN 'PREMIUM'  THEN 15
      ELSE 10
    END;

    SELECT ARRAY(
      SELECT q.id
      FROM   questions q
      WHERE  q.year_level    = exam_rec.year_level
        AND  q.domain        = exam_rec.domain
        AND  q.package_type  = exam_rec.package_type
        AND  q.status        = 'PUBLISHED'
      ORDER  BY RANDOM()
      LIMIT  q_count
    ) INTO q_ids;

    IF q_ids IS NOT NULL AND ARRAY_LENGTH(q_ids, 1) > 0 THEN
      FOR i IN 1 .. ARRAY_LENGTH(q_ids, 1) LOOP
        INSERT INTO exam_questions (exam_id, question_id, question_order)
        VALUES (exam_rec.id, q_ids[i], i)
        ON CONFLICT (exam_id, question_id) DO NOTHING;
      END LOOP;
    END IF;
  END LOOP;
END $$;
