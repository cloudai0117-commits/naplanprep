# Content Card Reconciliation

Generated: 2026-08-14  
Source: `C:\Users\PC\Downloads\NAPLANPrep_Batch1_V54_V213\flyway`  
PDF: `NAPLANPrep_320_Exam_Master_Content_Generation_Prompt.pdf` — unreadable (poppler-utils not installed); catalog inferred from filenames  
Repo: `backend/src/main/resources/db/migration`

---

## Legend

| Symbol | Meaning |
|--------|---------|
| ✓ | Card match — filename confirms correct exam |
| ✗ | Card mismatch or conflict |
| BLOCKER | Requires explicit decision before content can be incorporated |

---

## Flyway Version → Card Map (All 160 Download Files)

| Flyway | Download Filename | Expected Card (from filename) | Match | Notes |
|--------|------------------|-------------------------------|-------|-------|
| V54 | V54__seed_y3_num_free_exam01.sql | Y3_NUM_FREE_EXAM01 | ✓ | **Same filename as repo — DIFFERENT content/UUID** |
| V55 | V55__seed_y3_num_advanced_exam01.sql | Y3_NUM_ADV_EXAM01 | ✓* | *Filename differs: download=`advanced`, repo=`adv` — DIFFERENT content/UUID* |
| V56 | V56__seed_y3_num_advanced_exam02.sql | Y3_NUM_ADV_EXAM02 | ✓* | *Same name issue as V55 — DIFFERENT content/UUID* |
| V57 | V57__seed_y3_num_advanced_exam03.sql | Y3_NUM_ADV_EXAM03 | ✗ | **BLOCKER: Repo V57 = P0 DDL migration, not content** |
| V58 | V58__seed_y3_num_advanced_exam04.sql | Y3_NUM_ADV_EXAM04 | ✓ | Download only (not in repo) |
| V59 | V59__seed_y3_num_advanced_exam05.sql | Y3_NUM_ADV_EXAM05 | ✓ | Download only |
| V60 | V60__seed_y3_num_premium_exam01.sql | Y3_NUM_PRM_EXAM01 | ✓ | Download only |
| V61 | V61__seed_y3_num_premium_exam02.sql | Y3_NUM_PRM_EXAM02 | ✓ | Download only |
| V62 | V62__seed_y3_num_premium_exam03.sql | Y3_NUM_PRM_EXAM03 | ✓ | Download only |
| V63 | V63__seed_y3_num_premium_exam04.sql | Y3_NUM_PRM_EXAM04 | ✓ | Download only |
| V64 | V64__seed_y3_num_premium_exam05.sql | Y3_NUM_PRM_EXAM05 | ✓ | Download only |
| V65 | V65__seed_y3_num_premium_exam06.sql | Y3_NUM_PRM_EXAM06 | ✓ | Download only |
| V66 | V66__seed_y3_num_premium_exam07.sql | Y3_NUM_PRM_EXAM07 | ✓ | Download only |
| V67 | V67__seed_y3_num_premium_exam08.sql | Y3_NUM_PRM_EXAM08 | ✓ | Download only |
| V68 | V68__seed_y3_num_premium_exam09.sql | Y3_NUM_PRM_EXAM09 | ✓ | Download only |
| V69 | V69__seed_y3_num_premium_exam10.sql | Y3_NUM_PRM_EXAM10 | ✓ | Download only |
| V70 | V70__seed_y3_read_free_exam01.sql | Y3_READ_FREE_EXAM01 | ✓ | Download only |
| V71 | V71__seed_y3_read_advanced_exam01.sql | Y3_READ_ADV_EXAM01 | ✓ | Download only |
| V72 | V72__seed_y3_read_advanced_exam02.sql | Y3_READ_ADV_EXAM02 | ✓ | Download only |
| V73 | V73__seed_y3_read_advanced_exam03.sql | Y3_READ_ADV_EXAM03 | ✓ | Download only |
| V74 | V74__seed_y3_read_advanced_exam04.sql | Y3_READ_ADV_EXAM04 | ✓ | Download only |
| V75 | V75__seed_y3_read_advanced_exam05.sql | Y3_READ_ADV_EXAM05 | ✓ | Download only |
| V76 | V76__seed_y3_read_premium_exam01.sql | Y3_READ_PRM_EXAM01 | ✓ | Download only |
| V77 | V77__seed_y3_read_premium_exam02.sql | Y3_READ_PRM_EXAM02 | ✓ | Download only |
| V78 | V78__seed_y3_read_premium_exam03.sql | Y3_READ_PRM_EXAM03 | ✓ | Download only |
| V79 | V79__seed_y3_read_premium_exam04.sql | Y3_READ_PRM_EXAM04 | ✓ | Download only |
| V80 | V80__seed_y3_read_premium_exam05.sql | Y3_READ_PRM_EXAM05 | ✓ | Download only |
| V81 | V81__seed_y3_read_premium_exam06.sql | Y3_READ_PRM_EXAM06 | ✓ | Download only |
| V82 | V82__seed_y3_read_premium_exam07.sql | Y3_READ_PRM_EXAM07 | ✓ | Download only |
| V83 | V83__seed_y3_read_premium_exam08.sql | Y3_READ_PRM_EXAM08 | ✓ | Download only |
| V84 | V84__seed_y3_read_premium_exam09.sql | Y3_READ_PRM_EXAM09 | ✓ | Download only |
| V85 | V85__seed_y3_read_premium_exam10.sql | Y3_READ_PRM_EXAM10 | ✓ | Download only |
| V86 | V86__seed_y3_writ_free_exam01.sql | Y3_WRIT_FREE_EXAM01 | ✓ | Download only |
| V87 | V87__seed_y3_writ_advanced_exam01.sql | Y3_WRIT_ADV_EXAM01 | ✓ | Download only |
| V88 | V88__seed_y3_writ_advanced_exam02.sql | Y3_WRIT_ADV_EXAM02 | ✓ | Download only |
| V89 | V89__seed_y3_writ_advanced_exam03.sql | Y3_WRIT_ADV_EXAM03 | ✓ | Download only |
| V90 | V90__seed_y3_writ_advanced_exam04.sql | Y3_WRIT_ADV_EXAM04 | ✓ | Download only |
| V91 | V91__seed_y3_writ_advanced_exam05.sql | Y3_WRIT_ADV_EXAM05 | ✓ | Download only |
| V92 | V92__seed_y3_writ_premium_exam01.sql | Y3_WRIT_PRM_EXAM01 | ✓ | Download only |
| V93 | V93__seed_y3_writ_premium_exam02.sql | Y3_WRIT_PRM_EXAM02 | ✓ | Download only |
| V94 | V94__seed_y3_writ_premium_exam03.sql | Y3_WRIT_PRM_EXAM03 | ✓ | Download only |
| V95 | V95__seed_y3_writ_premium_exam04.sql | Y3_WRIT_PRM_EXAM04 | ✓ | Download only |
| V96 | V96__seed_y3_writ_premium_exam05.sql | Y3_WRIT_PRM_EXAM05 | ✓ | Download only |
| V97 | V97__seed_y3_writ_premium_exam06.sql | Y3_WRIT_PRM_EXAM06 | ✓ | Download only |
| V98 | V98__seed_y3_writ_premium_exam07.sql | Y3_WRIT_PRM_EXAM07 | ✓ | Download only |
| V99 | V99__seed_y3_writ_premium_exam08.sql | Y3_WRIT_PRM_EXAM08 | ✓ | Download only |
| V100 | V100__seed_y3_writ_premium_exam09.sql | Y3_WRIT_PRM_EXAM09 | ✓ | Download only |
| V101 | V101__seed_y3_writ_premium_exam10.sql | Y3_WRIT_PRM_EXAM10 | ✓ | Download only |
| V102 | V102__seed_y3_gp_free_exam01.sql | Y3_GP_FREE_EXAM01 | ✓ | Download only |
| V103 | V103__seed_y3_gp_advanced_exam01.sql | Y3_GP_ADV_EXAM01 | ✓ | Download only |
| V104 | V104__seed_y3_gp_advanced_exam02.sql | Y3_GP_ADV_EXAM02 | ✓ | Download only |
| V105 | V105__seed_y3_gp_advanced_exam03.sql | Y3_GP_ADV_EXAM03 | ✓ | Download only |
| V106 | V106__seed_y3_gp_advanced_exam04.sql | Y3_GP_ADV_EXAM04 | ✓ | Download only |
| V107 | V107__seed_y3_gp_advanced_exam05.sql | Y3_GP_ADV_EXAM05 | ✓ | Download only |
| V108 | V108__seed_y3_gp_premium_exam01.sql | Y3_GP_PRM_EXAM01 | ✓ | Download only |
| V109 | V109__seed_y3_gp_premium_exam02.sql | Y3_GP_PRM_EXAM02 | ✓ | Download only |
| V110 | V110__seed_y3_gp_premium_exam03.sql | Y3_GP_PRM_EXAM03 | ✓ | Download only |
| V111 | V111__seed_y3_gp_premium_exam04.sql | Y3_GP_PRM_EXAM04 | ✓ | Download only |
| V112 | V112__seed_y3_gp_premium_exam05.sql | Y3_GP_PRM_EXAM05 | ✓ | Download only |
| V113 | V113__seed_y3_gp_premium_exam06.sql | Y3_GP_PRM_EXAM06 | ✓ | Download only |
| V114 | V114__seed_y3_gp_premium_exam07.sql | Y3_GP_PRM_EXAM07 | ✓ | Download only |
| V115 | V115__seed_y3_gp_premium_exam08.sql | Y3_GP_PRM_EXAM08 | ✓ | Download only |
| V116 | V116__seed_y3_gp_premium_exam09.sql | Y3_GP_PRM_EXAM09 | ✓ | Download only |
| V117 | V117__seed_y3_gp_premium_exam10.sql | Y3_GP_PRM_EXAM10 | ✓ | Download only |
| V118 | V118__seed_y3_spell_free_exam01.sql | Y3_SPELL_FREE_EXAM01 | ✓ | Download only |
| V119 | V119__seed_y3_spell_advanced_exam01.sql | Y3_SPELL_ADV_EXAM01 | ✓ | Download only |
| V120 | V120__seed_y3_spell_advanced_exam02.sql | Y3_SPELL_ADV_EXAM02 | ✓ | Download only |
| V121 | V121__seed_y3_spell_advanced_exam03.sql | Y3_SPELL_ADV_EXAM03 | ✓ | Download only |
| V122 | V122__seed_y3_spell_advanced_exam04.sql | Y3_SPELL_ADV_EXAM04 | ✓ | Download only |
| V123 | V123__seed_y3_spell_advanced_exam05.sql | Y3_SPELL_ADV_EXAM05 | ✓ | Download only |
| V124 | V124__seed_y3_spell_premium_exam01.sql | Y3_SPELL_PRM_EXAM01 | ✓ | Download only |
| V125 | V125__seed_y3_spell_premium_exam02.sql | Y3_SPELL_PRM_EXAM02 | ✓ | Download only |
| V126 | V126__seed_y3_spell_premium_exam03.sql | Y3_SPELL_PRM_EXAM03 | ✓ | Download only |
| V127 | V127__seed_y3_spell_premium_exam04.sql | Y3_SPELL_PRM_EXAM04 | ✓ | Download only |
| V128 | V128__seed_y3_spell_premium_exam05.sql | Y3_SPELL_PRM_EXAM05 | ✓ | Download only |
| V129 | V129__seed_y3_spell_premium_exam06.sql | Y3_SPELL_PRM_EXAM06 | ✓ | Download only |
| V130 | V130__seed_y3_spell_premium_exam07.sql | Y3_SPELL_PRM_EXAM07 | ✓ | Download only |
| V131 | V131__seed_y3_spell_premium_exam08.sql | Y3_SPELL_PRM_EXAM08 | ✓ | Download only |
| V132 | V132__seed_y3_spell_premium_exam09.sql | Y3_SPELL_PRM_EXAM09 | ✓ | Download only |
| V133 | V133__seed_y3_spell_premium_exam10.sql | Y3_SPELL_PRM_EXAM10 | ✓ | Download only |
| V134 | V134__seed_y5_num_free_exam01.sql | Y5_NUM_FREE_EXAM01 | ✓ | Download only |
| V135 | V135__seed_y5_num_advanced_exam01.sql | Y5_NUM_ADV_EXAM01 | ✓ | Download only |
| V136 | V136__seed_y5_num_advanced_exam02.sql | Y5_NUM_ADV_EXAM02 | ✓ | Download only |
| V137 | V137__seed_y5_num_advanced_exam03.sql | Y5_NUM_ADV_EXAM03 | ✓ | Download only |
| V138 | V138__seed_y5_num_advanced_exam04.sql | Y5_NUM_ADV_EXAM04 | ✓ | Download only |
| V139 | V139__seed_y5_num_advanced_exam05.sql | Y5_NUM_ADV_EXAM05 | ✓ | Download only |
| V140 | V140__seed_y5_num_premium_exam01.sql | Y5_NUM_PRM_EXAM01 | ✓ | Download only |
| V141 | V141__seed_y5_num_premium_exam02.sql | Y5_NUM_PRM_EXAM02 | ✓ | Download only |
| V142 | V142__seed_y5_num_premium_exam03.sql | Y5_NUM_PRM_EXAM03 | ✓ | Download only |
| V143 | V143__seed_y5_num_premium_exam04.sql | Y5_NUM_PRM_EXAM04 | ✓ | Download only |
| V144 | V144__seed_y5_num_premium_exam05.sql | Y5_NUM_PRM_EXAM05 | ✓ | Download only |
| V145 | V145__seed_y5_num_premium_exam06.sql | Y5_NUM_PRM_EXAM06 | ✓ | Download only |
| V146 | V146__seed_y5_num_premium_exam07.sql | Y5_NUM_PRM_EXAM07 | ✓ | Download only |
| V147 | V147__seed_y5_num_premium_exam08.sql | Y5_NUM_PRM_EXAM08 | ✓ | Download only |
| V148 | V148__seed_y5_num_premium_exam09.sql | Y5_NUM_PRM_EXAM09 | ✓ | Download only |
| V149 | V149__seed_y5_num_premium_exam10.sql | Y5_NUM_PRM_EXAM10 | ✓ | Download only |
| V150 | V150__seed_y5_read_free_exam01.sql | Y5_READ_FREE_EXAM01 | ✓ | Download only |
| V151 | V151__seed_y5_read_advanced_exam01.sql | Y5_READ_ADV_EXAM01 | ✓ | Download only |
| V152 | V152__seed_y5_read_advanced_exam02.sql | Y5_READ_ADV_EXAM02 | ✓ | Download only |
| V153 | V153__seed_y5_read_advanced_exam03.sql | Y5_READ_ADV_EXAM03 | ✓ | Download only |
| V154 | V154__seed_y5_read_advanced_exam04.sql | Y5_READ_ADV_EXAM04 | ✓ | Download only |
| V155 | V155__seed_y5_read_advanced_exam05.sql | Y5_READ_ADV_EXAM05 | ✓ | Download only |
| V156 | V156__seed_y5_read_premium_exam01.sql | Y5_READ_PRM_EXAM01 | ✓ | Download only |
| V157 | V157__seed_y5_read_premium_exam02.sql | Y5_READ_PRM_EXAM02 | ✓ | Download only |
| V158 | V158__seed_y5_read_premium_exam03.sql | Y5_READ_PRM_EXAM03 | ✓ | Download only |
| V159 | V159__seed_y5_read_premium_exam04.sql | Y5_READ_PRM_EXAM04 | ✓ | Download only |
| V160 | V160__seed_y5_read_premium_exam05.sql | Y5_READ_PRM_EXAM05 | ✓ | Download only |
| V161 | V161__seed_y5_read_premium_exam06.sql | Y5_READ_PRM_EXAM06 | ✓ | Download only |
| V162 | V162__seed_y5_read_premium_exam07.sql | Y5_READ_PRM_EXAM07 | ✓ | Download only |
| V163 | V163__seed_y5_read_premium_exam08.sql | Y5_READ_PRM_EXAM08 | ✓ | Download only |
| V164 | V164__seed_y5_read_premium_exam09.sql | Y5_READ_PRM_EXAM09 | ✓ | Download only |
| V165 | V165__seed_y5_read_premium_exam10.sql | Y5_READ_PRM_EXAM10 | ✓ | Download only |
| V166 | V166__seed_y5_writ_free_exam01.sql | Y5_WRIT_FREE_EXAM01 | ✓ | Download only |
| V167 | V167__seed_y5_writ_advanced_exam01.sql | Y5_WRIT_ADV_EXAM01 | ✓ | Download only |
| V168 | V168__seed_y5_writ_advanced_exam02.sql | Y5_WRIT_ADV_EXAM02 | ✓ | Download only |
| V169 | V169__seed_y5_writ_advanced_exam03.sql | Y5_WRIT_ADV_EXAM03 | ✓ | Download only |
| V170 | V170__seed_y5_writ_advanced_exam04.sql | Y5_WRIT_ADV_EXAM04 | ✓ | Download only |
| V171 | V171__seed_y5_writ_advanced_exam05.sql | Y5_WRIT_ADV_EXAM05 | ✓ | Download only |
| V172 | V172__seed_y5_writ_premium_exam01.sql | Y5_WRIT_PRM_EXAM01 | ✓ | Download only |
| V173 | V173__seed_y5_writ_premium_exam02.sql | Y5_WRIT_PRM_EXAM02 | ✓ | Download only |
| V174 | V174__seed_y5_writ_premium_exam03.sql | Y5_WRIT_PRM_EXAM03 | ✓ | Download only |
| V175 | V175__seed_y5_writ_premium_exam04.sql | Y5_WRIT_PRM_EXAM04 | ✓ | Download only |
| V176 | V176__seed_y5_writ_premium_exam05.sql | Y5_WRIT_PRM_EXAM05 | ✓ | Download only |
| V177 | V177__seed_y5_writ_premium_exam06.sql | Y5_WRIT_PRM_EXAM06 | ✓ | Download only |
| V178 | V178__seed_y5_writ_premium_exam07.sql | Y5_WRIT_PRM_EXAM07 | ✓ | Download only |
| V179 | V179__seed_y5_writ_premium_exam08.sql | Y5_WRIT_PRM_EXAM08 | ✓ | Download only |
| V180 | V180__seed_y5_writ_premium_exam09.sql | Y5_WRIT_PRM_EXAM09 | ✓ | Download only |
| V181 | V181__seed_y5_writ_premium_exam10.sql | Y5_WRIT_PRM_EXAM10 | ✓ | Download only |
| V182 | V182__seed_y5_gp_free_exam01.sql | Y5_GP_FREE_EXAM01 | ✓ | Download only |
| V183 | V183__seed_y5_gp_advanced_exam01.sql | Y5_GP_ADV_EXAM01 | ✓ | Download only |
| V184 | V184__seed_y5_gp_advanced_exam02.sql | Y5_GP_ADV_EXAM02 | ✓ | Download only |
| V185 | V185__seed_y5_gp_advanced_exam03.sql | Y5_GP_ADV_EXAM03 | ✓ | Download only |
| V186 | V186__seed_y5_gp_advanced_exam04.sql | Y5_GP_ADV_EXAM04 | ✓ | Download only |
| V187 | V187__seed_y5_gp_advanced_exam05.sql | Y5_GP_ADV_EXAM05 | ✓ | Download only |
| V188 | V188__seed_y5_gp_premium_exam01.sql | Y5_GP_PRM_EXAM01 | ✓ | Download only |
| V189 | V189__seed_y5_gp_premium_exam02.sql | Y5_GP_PRM_EXAM02 | ✓ | Download only |
| V190 | V190__seed_y5_gp_premium_exam03.sql | Y5_GP_PRM_EXAM03 | ✓ | Download only |
| V191 | V191__seed_y5_gp_premium_exam04.sql | Y5_GP_PRM_EXAM04 | ✓ | Download only |
| V192 | V192__seed_y5_gp_premium_exam05.sql | Y5_GP_PRM_EXAM05 | ✓ | Download only |
| V193 | V193__seed_y5_gp_premium_exam06.sql | Y5_GP_PRM_EXAM06 | ✓ | Download only |
| V194 | V194__seed_y5_gp_premium_exam07.sql | Y5_GP_PRM_EXAM07 | ✓ | Download only |
| V195 | V195__seed_y5_gp_premium_exam08.sql | Y5_GP_PRM_EXAM08 | ✓ | Download only |
| V196 | V196__seed_y5_gp_premium_exam09.sql | Y5_GP_PRM_EXAM09 | ✓ | Download only |
| V197 | V197__seed_y5_gp_premium_exam10.sql | Y5_GP_PRM_EXAM10 | ✓ | Download only |
| V198 | V198__seed_y5_spell_free_exam01.sql | Y5_SPELL_FREE_EXAM01 | ✓ | Download only |
| V199 | V199__seed_y5_spell_advanced_exam01.sql | Y5_SPELL_ADV_EXAM01 | ✓ | Download only |
| V200 | V200__seed_y5_spell_advanced_exam02.sql | Y5_SPELL_ADV_EXAM02 | ✓ | Download only |
| V201 | V201__seed_y5_spell_advanced_exam03.sql | Y5_SPELL_ADV_EXAM03 | ✓ | Download only |
| V202 | V202__seed_y5_spell_advanced_exam04.sql | Y5_SPELL_ADV_EXAM04 | ✓ | Download only |
| V203 | V203__seed_y5_spell_advanced_exam05.sql | Y5_SPELL_ADV_EXAM05 | ✓ | Download only |
| V204 | V204__seed_y5_spell_premium_exam01.sql | Y5_SPELL_PRM_EXAM01 | ✓ | Download only |
| V205 | V205__seed_y5_spell_premium_exam02.sql | Y5_SPELL_PRM_EXAM02 | ✓ | Download only |
| V206 | V206__seed_y5_spell_premium_exam03.sql | Y5_SPELL_PRM_EXAM03 | ✓ | Download only |
| V207 | V207__seed_y5_spell_premium_exam04.sql | Y5_SPELL_PRM_EXAM04 | ✓ | Download only |
| V208 | V208__seed_y5_spell_premium_exam05.sql | Y5_SPELL_PRM_EXAM05 | ✓ | Download only |
| V209 | V209__seed_y5_spell_premium_exam06.sql | Y5_SPELL_PRM_EXAM06 | ✓ | Download only |
| V210 | V210__seed_y5_spell_premium_exam07.sql | Y5_SPELL_PRM_EXAM07 | ✓ | Download only |
| V211 | V211__seed_y5_spell_premium_exam08.sql | Y5_SPELL_PRM_EXAM08 | ✓ | Download only |
| V212 | V212__seed_y5_spell_premium_exam09.sql | Y5_SPELL_PRM_EXAM09 | ✓ | Download only |
| V213 | V213__seed_y5_spell_premium_exam10.sql | Y5_SPELL_PRM_EXAM10 | ✓ | Download only |

---

## BLOCKERS

### BLOCKER 1 — V57 Type Conflict (CRITICAL)

| | Download | Repo |
|--|---------|------|
| Filename | `V57__seed_y3_num_advanced_exam03.sql` | `V57__add_question_calculator_flag.sql` |
| Type | Content migration (DML) | Schema migration (DDL) |
| Content | Y3 Numeracy Advanced Exam 03 | ALTER TABLE + backfill UPDATE |
| Can coexist at V57? | **NO** | **NO** |

The P0 DDL migration MUST remain in the repo (it adds `calculator_allowed` to the questions table). It cannot be at V57 if the download's V57 content is also at V57.

**Resolution required:** One of:
- (A) Shift download V57-V213 → V58-V214 (P0 DDL stays at V57, content shifts +1)
- (B) Move P0 DDL to a different version and keep download V57 as-is

### BLOCKER 2 — V54/V55/V56 Content Divergence

All three early versions have conflicting content between the repo and the download:

| Version | Download Exam UUID | Repo Exam UUID | Same content? |
|---------|--------------------|----------------|---------------|
| V54 | `fcd31c21-9680-5cd3-b56a-522b4ad8f762` | `a0000054-0000-4000-a000-000000000001` | **NO** |
| V55 | Random UUIDv5 | `a0000055-0000-4000-a000-000000000001` | **NO** |
| V56 | Random UUIDv5 | `a0000056-0000-4000-a000-000000000001` | **NO** |

The repo's V55/V56 were hand-crafted in the P0 session with commutative-duplicate fixes. The download's V55/V56 are batch-generated with generic explanations and random UUIDs.

**Resolution required:** Which V54/V55/V56 to keep? This MUST be decided before incorporating the download.

---

## Summary

| Category | Count |
|----------|-------|
| Total download files | 160 |
| Card match (filename confirms correct content) | 160/160 |
| Version conflicts requiring decision | 4 (V54, V55, V56, V57) |
| BLOCKERS | 2 |
| Download-only (not in repo, no conflict) | 156 (V58-V213) |
