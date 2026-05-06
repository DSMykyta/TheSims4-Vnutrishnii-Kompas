# Inner Compass Research Workspace

This folder holds the research material for `BaseGamePlus: Inner Compass`.

## Rules

- Research baseline is clean The Sims 4 Base Game with no gameplay mods.
- `extracted/` is raw EA tuning reference. Treat it as read-only.
- Do not annotate or hand-edit files inside `extracted/`.
- Copy selected files into `annotated/` before adding comments.
- Keep `snapshot_manifest.csv` updated after every full extraction.
- Keep IDs and strings in CSV before creating final package resources.
- Do not design against WW, MCCC, Basemental, RPO or any other third-party mod. Those are late smoke-test targets only.

## Workflow

1. Run a full base-game `Extract All` tuning snapshot.
2. Put raw XML under `research/extracted/`.
3. Generate SHA-256 rows in `snapshot_manifest.csv` with `scripts/generate_snapshot_manifest.ps1`.
4. Copy target examples into `research/annotated/`.
5. Fill `patterns/*.md` with concrete findings.
6. Stop research only after the five stop-rule questions are answered.

## Snapshot Manifest

After `Extract All`, run from the workspace root:

```powershell
.\research\scripts\generate_snapshot_manifest.ps1 -GameVersion "PC 1.123.85.1020"
```

The manifest hashes extracted XML files, not game `.package` files.

Expected CSV columns:

```csv
relative_path,sha256,file_size,extracted_date,game_version
```

## Stop-Rule Questions

1. How does EA connect a trait to buff-on-addition and buff-on-trigger?
2. How does EA implement threshold buffs on a commodity, with concrete threshold values?
3. What differs structurally between a buff objective, skill-level objective and interaction-count objective?
4. What is inside a career level XML, and how does one level differ from another?
5. Where does the selected rabbit-hole/timed interaction attach its completion loot or moodlet payload?

## Target Annotated Subset

- Traits: `trait_Creative.xml`, `trait_Genius.xml`, `trait_Bookworm.xml`, `trait_Loner.xml`.
- Buffs: one `buff_Inspired_*`, one tense/overwhelmed style buff, one aspiration reward pattern.
- Aspirations: `aspiration_Author_BestsellingAuthor.xml`, `aspiration_Knowledge_RenaissanceSim.xml`, connected milestone/objective files.
- Careers: `career_Adult_Writer.xml`, selected `careerLevel_Writer_*.xml`, selected `careerTrack_Writer_*.xml`, `career_Adult_Business.xml`.
- Interactions: `superInteraction_Sim_GoJogging` or exact equivalent, one `superInteraction_Phone_RequestService_*`.
- Commodities: `commodity_Motive_Hunger`, connected `buff_Motive_Hunger_*`, one useful `commodity_Hidden_*`.
- Phone/computer preference and cooldown/test examples.
