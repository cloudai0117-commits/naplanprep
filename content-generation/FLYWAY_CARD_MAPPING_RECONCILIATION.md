# FLYWAY CARD MAPPING RECONCILIATION
## P0-001 RESOLUTION: V213/V214 Collision Investigation

**Produced by:** P0 Remediation — NAPLANPrep Flyway Audit  
**Date:** 2026-08-14  
**Status:** INVESTIGATION COMPLETE — V214 REMOVED

---

## P0-001 Summary

**Finding:** Batch 1 directory contained 161 files (expected 160). The extra file `V214__seed_y5_spell_premium_exam10.sql` occupied Download slot V214, which maps to Repo slot V215 via the +1 shift rule — colliding with Batch 2's `V215__seed_y7_num_free_exam01.sql`.

**Resolution:** V214 is confirmed ROGUE. Deleted from Batch 1 directory.  
**Post-removal count:** 160 files (correct).

---

## Investigation Evidence

### V213 — CANONICAL (KEEP)

| Field | Value |
|---|---|
| File | `V213__seed_y5_spell_premium_exam10.sql` |
| Exam UUID | `2b21f7e5-3f80-5329-bcf9-bc07605133a4` |
| Title | Year 5 Spelling — Premium Practice Exam 10 |
| time_limit_seconds | 2700 |
| Format | Batch 1 (old) — no spaces in column list, s3:// WAV audio |
| Testlet names | S1, SD, SB, PD, PB (Batch 1 non-standard format) |
| calculator_allowed | Not in question INSERTs (correct — Batch 1 Spelling predates V57) |
| Spelling targets | airless, airlia, airlie, airlift, airlifted, airlifter, airlifters, airlifting, airlifts |
| Master Card | MC213 = Y5 Spelling Premium Exam 10 |
| Repo slot | V214 (Download V213 + 1 DDL shift) |
| Status | **CANONICAL — retained** |

### V214 — ROGUE (DELETED)

| Field | Value |
|---|---|
| File | `V214__seed_y5_spell_premium_exam10.sql` |
| Exam UUID | `153771b7-bd0c-55f1-86c9-1a685fb3cd13` |
| Title | Year 5 Spelling — Premium Practice Exam 10 |
| time_limit_seconds | 1800 |
| Format | Batch 2 (new) — spaces in column list, /content/ MP3 audio |
| Testlet names | S1, S2A, S2B, S3A, S3B (Batch 2 standard format) |
| calculator_allowed | FALSE in question INSERTs (WRONG for Spelling — should be TRUE) |
| Spelling targets | accommodate, calendar, committee (different content from V213) |
| Master Card | NOT an MC214 migration — MC214 = Y7 Num Free Exam 01 (Batch 2) |
| Repo slot | Would occupy V215 — COLLIDES with Batch 2 V215__seed_y7_num_free_exam01.sql |
| ON CONFLICT | Present (Batch 2 marker confirming this was generated as Batch 2 content) |
| Status | **ROGUE — deleted** |

---

## Determination

**V213 is the canonical Y5 Spell Premium Exam 10.** Evidence:
1. Correct Download version number for its Master Card slot (MC213)
2. Uses Batch 1 format consistently (s3:// WAV, non-standard testlet names, no spaces)
3. Occupies Repo V214 correctly via the +1 DDL shift
4. Different content from V214 (different spelling targets, different exam UUID)
5. time_limit_seconds = 2700 matches Y5 Spelling expected duration

**V214 is a rogue file — a Batch 2-format second generation of Y5 Spell Premium 10 accidentally placed in the Batch 1 directory.** Evidence:
1. Uses Batch 2 format (spaces, MP3, S2A/S2B/S3A/S3B testlet names, ON CONFLICT clause)
2. Has calculator_allowed = FALSE in questions (incorrect for Spelling — would have been incorrectly P1-002)
3. Its Download V214 slot maps to Repo V215 — collision with Batch 2's Y7 Num Free Exam 01
4. MC214 = Y7 Numeracy Free Exam 01 (which is correctly in Batch 2 as V215__seed_y7_num_free_exam01.sql)
5. Generated with different content from V213 — confirms it is a second-pass re-generation, not an update

**The collision is resolved by deleting V214 from the Batch 1 directory.**

---

## Master Card to Repo V Mapping (Summary)

See full per-exam table in `FLYWAY_CARD_RECONCILIATION.md`.

| Range | MC | Download V | Repo V | Notes |
|---|---|---|---|---|
| Pre-shift canonical | MC54–MC56 | V54–V56 | V54–V56 | No shift; covered by V57 DDL backfill |
| DDL migration | — | — | V57 | `V57__add_question_calculator_flag.sql` (backend only) |
| Shift block | MC57–MC213 | V57–V213 | V58–V214 | All Download V + 1 = Repo V |
| Rogue file | — | V214 | DELETED | Not a valid MC; removed 2026-08-14 |
| Batch 2 | MC214–MC373 | (Batch 2) | V215–V374 | Already at repo V numbers |

---

## Post-Remediation Batch 1 State

| Metric | Before | After |
|---|---|---|
| Files in Batch 1 dir | 161 | **160** |
| Rogue files | 1 | **0** |
| Repo V collision risk | YES (V215) | **RESOLVED** |
| G-19 gate (Flyway collision) | FAIL | **PASS** |
| G-23 gate (duplicate exam name/slot) | FAIL | **PASS** |

---

## Decision Authority

Investigation used: exam UUID, title, time_limit_seconds, testlet names, audio format, spelling content, ON CONFLICT clause, and format-version indicators.  
Decision was NOT made from filename alone.  
No content was silently deleted — this document records the evidence and rationale.
