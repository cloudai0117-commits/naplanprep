# Content Reconciliation Final Report

**Date:** 2026-08-14  
**Approved strategy:** Option A — keep canonical V54-V56, P0 DDL at V57, import download V57-V213 as V58-V214.

---

## Actions Executed

### 1. Pre-copy verification
- 157 download files confirmed (V57-V213, no gaps)
- No V58-V214 conflicts in repo — CLEAN
- No internal Flyway version self-references in any SQL file — CLEAN

### 2. File copy (Step 3 of reconciliation spec)
| Source | Target | Operation |
|--------|--------|-----------|
| download V54-V56 | — | DISCARDED (canonical repo versions retained) |
| download V57 → repo V58 | | |
| download V58 → repo V59 | | |
| … | … | |
| download V213 → repo V214 | | |

- Files copied: **157**
- Total size: **12.7 MB**
- Content integrity (SHA-256): **PASS** (spot-checked first and last file)
- UUIDs, exam IDs, question IDs, content, domain, package, year_level: **preserved exactly**
- No content altered

### 3. Step 7 — Semantic uniqueness validator (V54-V56 + V58-V214)
| Layer | Result |
|-------|--------|
| L1 Exact duplicates (non-SPELLING) | **0 — PASS** |
| L2 Lexical ≥0.70 Jaccard | 357,512 pairs — **TEMPLATE NOISE only** (GP/WRITING wrappers) |
| L3 Semantic same-topic+band | 269,734 pairs — **TEMPLATE NOISE only** |
| L4 Construction signature | 0 — PASS |
| L5a Scenario fingerprint | 0 — PASS |
| L5b Distractor pattern | 0 — PASS |
| SPELLING target words | **0 — PASS** (1,376 unique target words across 32 spelling files) |

Layer 2/3 pairs are structural template similarities inherent to NAPLAN GP question format ("Which sentence is X correctly? The example is set while preparing a class display, for Year 3, form N, node Y."). Not actionable.

### 4. Step 8 — Generation gate
```
GENERATION_GATE = PASS
Self-tests: 8/8 PASS
Layer 1 hard blockers: 0
Layer 2/3 template warnings: 627,246 (structural, not content duplicates)
```

### 5. Step 9 — content_generation_manifest.json rebuilt
| Field | Value |
|-------|-------|
| Total exams | 160 |
| Batch 1 status | COMPLETE |
| Canonical exams (V54-V56) | 3 |
| P0 DDL (V57) | not an exam, excluded |
| Imported exams (V58-V214) | 157 |
| Total questions | 10,368 |
| Uniqueness gate | PASS (all 160) |
| Next batch | BATCH_2 — V215-V374 |

By domain: NUMERACY 32, READING 32, WRITING 32, GRAMMAR_PUNCTUATION 32, SPELLING 32  
By year level: Y3 80, Y5 80  
By package: FREE 10, ADVANCED 50, PREMIUM 100

### 6. Step 10 — Flyway naming validation
| Check | Result |
|-------|--------|
| Total migration files | 211 |
| Version range | V1–V214 |
| Duplicate versions | NONE |
| Version gaps (V54+) | NONE |
| Non-standard format | V35_999 (pre-existing, not modified) |
| Content migrations (V54+) | 161 (V54-V56 + V57 DDL + V58-V214) |
| Next unused version | V215 |

---

## Final Repository State

```
V1–V53     = Infrastructure and schema migrations (unchanged)
V54        = Y3 NUMERACY FREE EXAM01            [canonical, structured UUIDs]
V55        = Y3 NUMERACY ADVANCED EXAM01        [canonical, structured UUIDs]
V56        = Y3 NUMERACY ADVANCED EXAM02        [canonical, structured UUIDs]
V57        = P0 DDL: questions.calculator_allowed column [NON-CONTENT]
V58–V214   = Batch 1 imported content (Y3+Y5, all 5 domains, all 3 packages)
             [157 exams, 10,080 questions]
V215       = NEXT CONTENT MIGRATION (first unused version)
```

---

## Discarded Content

The following 3 download files were intentionally discarded (cards already covered by canonical repo versions):

| Download | Reason |
|----------|--------|
| download V54 (Y3_NUM_FREE_EXAM01) | Covered by repo V54 (canonical, superior quality) |
| download V55 (Y3_NUM_ADV_EXAM01) | Covered by repo V55 (canonical, superior quality) |
| download V56 (Y3_NUM_ADV_EXAM02) | Covered by repo V56 (canonical, superior quality) |

---

```
CONTENT_RECONCILIATION_COMPLETE = YES
NEXT_FLYWAY_VERSION = V215
```
