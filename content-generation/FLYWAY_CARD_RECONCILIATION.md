# FLYWAY CARD RECONCILIATION

**Audit Date:** 2026-08-14  
**Purpose:** Maps Master Card (MC) numbers → Download Version (Batch 1 filename prefix) → Repository Flyway Version (applied sequence)  
**Constraint:** V57 in the backend repository is the DDL migration `V57__add_question_calculator_flag.sql`. This occupies Repo slot V57, causing all Batch 1 content files with download V57+ to be shifted to Repo V+1.

---

## Mapping Rules

| Rule | Description |
|---|---|
| MC54–MC56 | Canonical pre-DDL files. MC = Download V = Repo V (no shift) |
| V57 Repo | DDL-only: `V57__add_question_calculator_flag.sql` (backend, not in content batches) |
| MC57–MC213 | Content files delivered with download V57–V213. Repo V = Download V + 1 |
| MC214–MC373 | Batch 2. Repo V = MC + 1 (files already named with Repo V, no download distinction) |

---

## Batch 1 — Y3 Content (Download V54–V133 → Repo V54–V134)

| MC | Download V | Repo V | Filename (Download) | Exam Description | Notes |
|---|---|---|---|---|---|
| MC54 | V54 | V54 | V54__seed_y3_num_free_exam01.sql | Y3 Numeracy Free 01 | CANONICAL |
| MC55 | V55 | V55 | V55__seed_y3_num_advanced_exam01.sql | Y3 Numeracy Advanced 01 | CANONICAL |
| MC56 | V56 | V56 | V56__seed_y3_num_advanced_exam02.sql | Y3 Numeracy Advanced 02 | CANONICAL |
| — | — | V57 | V57__add_question_calculator_flag.sql | DDL migration (backend) | BACKEND ONLY |
| MC57 | V57 | V58 | V57__seed_y3_num_advanced_exam03.sql | Y3 Numeracy Advanced 03 | SHIFT START; P0:calc_missing |
| MC58 | V58 | V59 | V58__seed_y3_num_advanced_exam04.sql | Y3 Numeracy Advanced 04 | P0:calc_missing |
| MC59 | V59 | V60 | V59__seed_y3_num_advanced_exam05.sql | Y3 Numeracy Advanced 05 | P0:calc_missing |
| MC60 | V60 | V61 | V60__seed_y3_num_premium_exam01.sql | Y3 Numeracy Premium 01 | P0:calc_missing |
| MC61 | V61 | V62 | V61__seed_y3_num_premium_exam02.sql | Y3 Numeracy Premium 02 | P0:calc_missing |
| MC62 | V62 | V63 | V62__seed_y3_num_premium_exam03.sql | Y3 Numeracy Premium 03 | P0:calc_missing |
| MC63 | V63 | V64 | V63__seed_y3_num_premium_exam04.sql | Y3 Numeracy Premium 04 | P0:calc_missing |
| MC64 | V64 | V65 | V64__seed_y3_num_premium_exam05.sql | Y3 Numeracy Premium 05 | P0:calc_missing |
| MC65 | V65 | V66 | V65__seed_y3_num_premium_exam06.sql | Y3 Numeracy Premium 06 | P0:calc_missing |
| MC66 | V66 | V67 | V66__seed_y3_num_premium_exam07.sql | Y3 Numeracy Premium 07 | P0:calc_missing |
| MC67 | V67 | V68 | V67__seed_y3_num_premium_exam08.sql | Y3 Numeracy Premium 08 | P0:calc_missing |
| MC68 | V68 | V69 | V68__seed_y3_num_premium_exam09.sql | Y3 Numeracy Premium 09 | P0:calc_missing |
| MC69 | V69 | V70 | V69__seed_y3_num_premium_exam10.sql | Y3 Numeracy Premium 10 | P0:calc_missing |
| MC70 | V70 | V71 | V70__seed_y3_read_free_exam01.sql | Y3 Reading Free 01 | OK |
| MC71 | V71 | V72 | V71__seed_y3_read_advanced_exam01.sql | Y3 Reading Advanced 01 | OK |
| MC72 | V72 | V73 | V72__seed_y3_read_advanced_exam02.sql | Y3 Reading Advanced 02 | OK |
| MC73 | V73 | V74 | V73__seed_y3_read_advanced_exam03.sql | Y3 Reading Advanced 03 | OK |
| MC74 | V74 | V75 | V74__seed_y3_read_advanced_exam04.sql | Y3 Reading Advanced 04 | OK |
| MC75 | V75 | V76 | V75__seed_y3_read_advanced_exam05.sql | Y3 Reading Advanced 05 | OK |
| MC76–MC85 | V76–V85 | V77–V86 | V76–V85__seed_y3_read_premium_exam01–10.sql | Y3 Reading Premium 01–10 | OK |
| MC86 | V86 | V87 | V86__seed_y3_writ_free_exam01.sql | Y3 Writing Free 01 | OK |
| MC87–MC101 | V87–V101 | V88–V102 | V87–V101__seed_y3_writ_*.sql | Y3 Writing Advanced 01-05, Premium 01-10 | OK |
| MC102 | V102 | V103 | V102__seed_y3_gp_free_exam01.sql | Y3 Grammar/Punct Free 01 | OK |
| MC103–MC117 | V103–V117 | V104–V118 | V103–V117__seed_y3_gp_*.sql | Y3 GP Advanced 01-05, Premium 01-10 | OK |
| MC118 | V118 | V119 | V118__seed_y3_spell_free_exam01.sql | Y3 Spelling Free 01 | P1:testlet_names |
| MC119–MC133 | V119–V133 | V120–V134 | V119–V133__seed_y3_spell_*.sql | Y3 Spelling Advanced 01-05, Premium 01-10 | P1:testlet_names |

---

## Batch 1 — Y5 Content (Download V134–V213 → Repo V135–V214)

| MC | Download V | Repo V | Filename (Download) | Exam Description | Notes |
|---|---|---|---|---|---|
| MC134 | V134 | V135 | V134__seed_y5_num_free_exam01.sql | Y5 Numeracy Free 01 | P0:calc_missing |
| MC135–MC149 | V135–V149 | V136–V150 | V135–V149__seed_y5_num_*.sql | Y5 Numeracy Advanced 01-05, Premium 01-10 | P0:calc_missing |
| MC150 | V150 | V151 | V150__seed_y5_read_free_exam01.sql | Y5 Reading Free 01 | OK |
| MC151–MC165 | V151–V165 | V152–V166 | V151–V165__seed_y5_read_*.sql | Y5 Reading Advanced 01-05, Premium 01-10 | OK |
| MC166 | V166 | V167 | V166__seed_y5_writ_free_exam01.sql | Y5 Writing Free 01 | OK |
| MC167–MC181 | V167–V181 | V168–V182 | V167–V181__seed_y5_writ_*.sql | Y5 Writing Advanced 01-05, Premium 01-10 | OK |
| MC182 | V182 | V183 | V182__seed_y5_gp_free_exam01.sql | Y5 Grammar/Punct Free 01 | OK |
| MC183–MC197 | V183–V197 | V184–V198 | V183–V197__seed_y5_gp_*.sql | Y5 GP Advanced 01-05, Premium 01-10 | OK |
| MC198 | V198 | V199 | V198__seed_y5_spell_free_exam01.sql | Y5 Spelling Free 01 | P1:testlet_names |
| MC199–MC212 | V199–V212 | V200–V213 | V199–V212__seed_y5_spell_*.sql | Y5 Spelling Advanced 01-05, Premium 01-09 | P1:testlet_names |
| MC213 | V213 | V214 | V213__seed_y5_spell_premium_exam10.sql | Y5 Spelling Premium 10 | P1:testlet_names (LAST VALID B1) |

---

## EXTRA FILE — Version Collision

| MC | Download V | Repo V (claimed) | Filename | Status |
|---|---|---|---|---|
| MC214 | V214 | **V215 (COLLISION)** | V214__seed_y5_spell_premium_exam10.sql | **P0 BLOCKER** |

This extra file, if treated as a Batch 1 download V214 content file, would occupy Repo V215 — which is already claimed by Batch 2 `V215__seed_y7_num_free_exam01.sql`. Flyway will fail.

---

## Batch 2 — Y7 Content (Repo V215–V294)

> Batch 2 files are already named with Repo versions. MC = Repo V - 1.

| Repo V | MC | Filename | Exam Description | Notes |
|---|---|---|---|---|
| V215 | MC214 | V215__seed_y7_num_free_exam01.sql | Y7 Numeracy Free 01 | P0:Choice4 |
| V216–V230 | MC215–MC229 | V216–V230__seed_y7_num_*.sql | Y7 Numeracy Advanced 01-05, Premium 01-10 | P0:Choice4 |
| V231 | MC230 | V231__seed_y7_read_free_exam01.sql | Y7 Reading Free 01 | OK |
| V232–V246 | MC231–MC245 | V232–V246__seed_y7_read_*.sql | Y7 Reading Advanced 01-05, Premium 01-10 | OK |
| V247 | MC246 | V247__seed_y7_writ_free_exam01.sql | Y7 Writing Free 01 | OK |
| V248–V262 | MC247–MC261 | V248–V262__seed_y7_writ_*.sql | Y7 Writing Advanced 01-05, Premium 01-10 | OK |
| V263 | MC262 | V263__seed_y7_gp_free_exam01.sql | Y7 Grammar/Punct Free 01 | P0:Choice4 |
| V264–V278 | MC263–MC277 | V264–V278__seed_y7_gp_*.sql | Y7 GP Advanced 01-05, Premium 01-10 | P0:Choice4 |
| V279 | MC278 | V279__seed_y7_spell_free_exam01.sql | Y7 Spelling Free 01 | OK |
| V280–V294 | MC279–MC293 | V280–V294__seed_y7_spell_*.sql | Y7 Spelling Advanced 01-05, Premium 01-10 | OK |

---

## Batch 2 — Y9 Content (Repo V295–V374)

| Repo V | MC | Filename | Exam Description | Notes |
|---|---|---|---|---|
| V295 | MC294 | V295__seed_y9_num_free_exam01.sql | Y9 Numeracy Free 01 | P0:Choice4 |
| V296–V310 | MC295–MC309 | V296–V310__seed_y9_num_*.sql | Y9 Numeracy Advanced 01-05, Premium 01-10 | P0:Choice4 |
| V311 | MC310 | V311__seed_y9_read_free_exam01.sql | Y9 Reading Free 01 | OK |
| V312–V326 | MC311–MC325 | V312–V326__seed_y9_read_*.sql | Y9 Reading Advanced 01-05, Premium 01-10 | OK |
| V327 | MC326 | V327__seed_y9_writ_free_exam01.sql | Y9 Writing Free 01 | OK |
| V328–V342 | MC327–MC341 | V328–V342__seed_y9_writ_*.sql | Y9 Writing Advanced 01-05, Premium 01-10 | OK |
| V343 | MC342 | V343__seed_y9_gp_free_exam01.sql | Y9 Grammar/Punct Free 01 | P0:Choice4 |
| V344–V358 | MC343–MC357 | V344–V358__seed_y9_gp_*.sql | Y9 GP Advanced 01-05, Premium 01-10 | P0:Choice4 |
| V359 | MC358 | V359__seed_y9_spell_free_exam01.sql | Y9 Spelling Free 01 | OK |
| V360–V374 | MC359–MC373 | V360–V374__seed_y9_spell_*.sql | Y9 Spelling Advanced 01-05, Premium 01-10 | OK |

---

## Reconciliation Summary

| Metric | Count |
|---|---|
| Total canonical MC slots | MC54–MC373 = 320 MCs |
| Total Repo content slots (excl. DDL V57) | V54–V374 minus V57 = 320 slots |
| Batch 1 canonical files (MC54–MC56 = no shift) | 3 |
| Batch 1 shifted files (MC57–MC213 = Repo V58–V214) | 157 |
| Batch 2 files (MC214–MC373 = Repo V215–V374) | 160 |
| **Total expected content migrations** | **320** |
| Extra rogue file (V214 download → Repo V215 collision) | 1 |
| **Total files on disk** | **321** |

**Reconciliation Verdict: FAIL** — Extra file V214 (download) creates an unresolvable Repo V215 collision.

---

## Key Version Shift Reference

```
Download V54 → Repo V54  (Y3 Num Free, CANONICAL)
Download V55 → Repo V55  (Y3 Num Adv 01, CANONICAL)
Download V56 → Repo V56  (Y3 Num Adv 02, CANONICAL)
[V57 DDL in backend — occupies Repo V57]
Download V57 → Repo V58  (Y3 Num Adv 03 — FIRST SHIFTED)
Download V213 → Repo V214  (Y5 Spell Prem 10 — LAST BATCH 1)
Download V214 → Repo V215  [COLLISION — Batch 2 already owns V215]
Batch 2 V215 = Repo V215  (Y7 Num Free 01 — FIRST BATCH 2)
Batch 2 V374 = Repo V374  (Y9 Spell Prem 10 — LAST BATCH 2)
```
