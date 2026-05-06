# BaseGamePlus: Inner Compass - Implementation Plan

Технічний план реалізації поведінкового DLC-моду для The Sims 4 Base Game. Документ написаний як production backlog: що робити, у якому порядку, які tuning resources потрібні, як тестувати і де ризики.

## 0. Жорсткі правила проєкту

- Target: The Sims 4 Base Game only.
- Current reference date: 2026-05-06.
- Latest released patch considered: PC `1.123.85.1020`, Mac `1.123.85.1220`, Console `2.32` from 2026-04-28.
- Upcoming 2026-05-12 update is not part of baseline until released and tested.
- Baseline version was verified from the official EA 2026-04-28 patch notes on 2026-05-06. If work continues after 2026-05-12, update this baseline before editing tuning.
- No DLC tuning, no DLC tags, no DLC icons, no DLC objects, no DLC interactions.
- Prefer additive tuning and injectors. Avoid overriding EA resources unless there is no other clean route.
- Keep stable IDs forever after public release.
- Every feature must be tested in a clean save with only this mod and required libraries.

## 1. Toolchain

Required:

- Sims 4 Studio: package editing, string tables, tuning resources, validation.
- Scumbumbo XML Extractor or equivalent: extract current game XML tuning after every major patch.
- Lot 51 Tuning Builder / TDESC Browser: safer editing against TDESC schemas.
- Text editor with XML support.
- Spreadsheet for ID registry and string keys.

Recommended:

- Lot 51 Core Library as optional dependency for injections and event-style utilities.
- WinMerge or similar diff tool for comparing extracted tuning between patches.
- Mod Constructor only for prototyping traits/careers quickly, not as the final source of truth.

Decision:

- MVP can be tuning-only.
- Python `.ts4script` is allowed only if hidden-state evaluation becomes too fragile in pure tuning.
- If Python is used, use the Python version expected by the current TS4 script environment and compile in the standard TS4-compatible way. Verify this again before implementation because TS4 Python constraints can change.

Engineering decision for MVP:

- Start tuning-only.
- Keep only one hidden state: `Restlessness`.
- Do not build the full state engine until MVP proves that hidden commodities are useful and stable.
- Escalate to Python only if tuning cannot reliably track the state, cooldowns, or aspiration objectives without fragile overrides.

Pure tuning gate:

- MVP remains tuning-only if `Restlessness` can be expressed as a commodity with XML decay rate, 3-4 threshold zones, buff add on entry through XML loot, buff remove on exit through XML loot, and value changes only through interaction outcomes or periodic decay.
- Python becomes justified if the design needs cross-Sim queries, household-wide polling, logic more complex than available tests, or timers based on history such as "if X happened in the last 24 sim hours, apply Y".
- Research must inspect `commodity_Motive_Hunger` and connected `buff_Motive_Hunger_*` examples, not only `commodity_Bladder`, because hunger shows decay plus threshold buff transitions closer to the intended `Restlessness` model.

## 2. Package layout

Initial development packages:

- `BGP_InnerCompass_Core.package`
- `BGP_InnerCompass_Traits.package`
- `BGP_InnerCompass_Buffs.package`
- `BGP_InnerCompass_Interactions.package`
- `BGP_InnerCompass_Aspirations.package`
- `BGP_InnerCompass_Careers.package`
- `BGP_InnerCompass_STBL.package`

Release options:

- Single merged package for normal players.
- Split packages for debugging and optional modules.

Optional script:

- `BGP_InnerCompass.ts4script`

Do not ship Lot 51 Core Library inside this mod. If used, document it as a dependency and link users to the official download.

## 3. Naming and ID policy

Namespace:

- Creator prefix: `bgp`
- Mod prefix: `inner_compass`

Examples:

- `trait_bgp_inner_compass_restless_dreamer`
- `buff_bgp_inner_compass_spark_of_idea`
- `commodity_bgp_inner_compass_restlessness`
- `si_bgp_inner_compass_seek_inspiration`
- `asp_bgp_inner_compass_find_yourself`
- `career_bgp_inner_compass_life_direction_consultant`

Rules:

- Maintain `ids_registry.csv` before creating final tuning IDs.
- Do not reuse deleted IDs.
- Do not rename tuning instance names after public release unless only display text changes.
- For custom CAS traits, verify current ID width expectations before release. Older custom trait UI issues around 64-bit IDs make stable, compatible IDs important.

## 4. Resource types to create

Core systems:

- Trait tuning.
- Buff tuning.
- Loot actions for applying/removing buffs and hidden commodities.
- Hidden commodities/statistics for states.
- SuperInteraction tuning for self/phone/computer interactions.
- Rabbit-hole interaction tuning or interaction + situation/rabbithole pattern, depending on extracted EA examples.
- Aspiration tuning.
- Aspiration milestone/objective tuning.
- Reward trait tuning.
- Career tuning.
- Career level and branch tuning.
- Career outfit references only if base-safe; otherwise skip custom outfits.
- STBL string tables: English first, Ukrainian second.
- SimData resources where required by UI-facing traits, aspirations, careers or categories.

Potentially needed:

- Pie menu category tuning if interactions need their own clean menu.
- Notification tuning for rabbit-hole outcomes.
- Autonomy modifiers for trait behavior.
- Injector snippets if using Lot 51 Core Library.

## 5. Research pass before editing

Extraction scope:

- Run `Extract All` for a full raw base-game tuning snapshot.
- Treat `research/extracted/` as read-only reference by convention.
- Copy only selected files into `research/annotated/` before adding comments.
- Generate SHA-256 hashes for extracted XML and store them in `research/snapshot_manifest.csv`.
- On each EA patch, re-extract and diff against the previous snapshot manifest plus raw XML.

Target annotated subset:

- Traits: `trait_Creative.xml`, `trait_Genius.xml`, `trait_Bookworm.xml`, `trait_Loner.xml`.
- Buffs: one `buff_Inspired_*`, one tense/overwhelmed style buff if present, one aspiration reward trait buff/reference pattern.
- Aspirations: `aspiration_Author_BestsellingAuthor.xml`, `aspiration_Knowledge_RenaissanceSim.xml`, and at least one milestone/objective file connected to each.
- Careers: `career_Adult_Writer.xml`, selected `careerLevel_Writer_*.xml`, selected `careerTrack_Writer_*.xml`, and `career_Adult_Business.xml`.
- Rabbit-hole/timed interactions: `superInteraction_Sim_GoJogging` or exact current equivalent, plus one `superInteraction_Phone_RequestService_*` style phone example.
- Commodities: `commodity_Motive_Hunger`, connected `buff_Motive_Hunger_*`, and at least one `commodity_Hidden_*` with threshold-style buff behavior if present.
- Phone/computer preferences from the 2026-03-17 patch.
- Any base interaction showing cooldown/test gating relevant to anti-spam.

Output of this phase:

- `research/README.md`
- `research/extracted/` full raw snapshot.
- `research/annotated/` commented subset.
- `research/patterns/*.md` summaries.
- `research/snapshot_manifest.csv`
- `research/ids_registry.csv`
- `research/strings_workbook.csv`
- Decision whether the MVP remains tuning-only.
- Decision on exact start animation/affordance for `Піти шукати натхнення`.
- Confirmation that custom aspiration categories remain out of scope.

Research stop rule:

- Do not create gameplay packages until at least one base trait, one base buff, one base aspiration objective, one rabbit-hole/career example and one phone/computer cooldown example have been inspected from extracted tuning.
- Research is closed only when we can answer these without re-extraction or web search:
- How does EA connect a trait to buff-on-addition and buff-on-trigger?
- How does EA implement threshold buffs on a commodity, with concrete threshold values from extracted tuning?
- What is the structural difference between an objective triggered by a buff, a skill level and an interaction count?
- What is inside a career level XML, and how does level 3 differ from level 4 structurally?
- How does the selected rabbit-hole/timed interaction return the Sim or complete the timed action, and where is the outcome moodlet/loot payload attached?

## 6. MVP vertical slice

Goal: one complete loop from CAS to gameplay to aspiration progress.

### Feature set

- CAS trait: `Неспокійний Мрійник`.
- Hidden commodity/state: `Restlessness`.
- Self interaction: `Піти шукати натхнення`.
- 8 moodlets.
- 1 aspiration: `Знайти Себе`, first milestone only.
- Reward trait placeholder: `Внутрішній Стержень`.
- English + Ukrainian strings.

### Trait behavior

`Неспокійний Мрійник`:

- Age: Teen, Young Adult, Adult, Elder.
- Conflict candidates: `Самодисциплінований` may conflict later if the gameplay overlap is too strong; do not block in MVP.
- Idle tendency: slightly more likely to use creative/mental interactions if base-safe affordances can be injected.
- Positive tendency: gains `Спалах Ідеї` after creative/rabbit-hole success.
- Negative tendency: gains `Світ Тісний` after long routine or failed inspiration search.

### MVP moodlets

| Internal | Display | Emotion | Duration | Trigger |
| --- | --- | --- | --- | --- |
| `spark_of_idea` | Спалах Ідеї | Inspired +2 | 4h | successful inspiration rabbit-hole |
| `fresh_perspective` | Нова Перспектива | Focused +1 | 4h | neutral-good rabbit-hole |
| `world_too_small` | Світ Тісний | Bored +1 | 3h | routine/fail |
| `too_many_thoughts` | Забагато Думок | Tense +1 | 3h | overload outcome |
| `quiet_momentum` | Тиха Інерція | Focused +1 | 6h | planning/recovery outcome |
| `failed_walk` | Невдала Прогулянка | Sad +1 | 2h | bad rabbit-hole roll |
| `came_back_lit` | Повернувся з Натхненням | Inspired +1 | 5h | good but not rare outcome |
| `need_a_change` | Потрібна Зміна | Tense +1 | 4h | high restlessness |

### Rabbit-hole interaction

`Піти шукати натхнення`:

- Target: self first. Phone duplicate later.
- Availability: Teen+ with `Неспокійний Мрійник`.
- Duration: 60-90 sim minutes.
- Cost: no money in MVP.
- Cooldown: 8 sim hours.
- Autonomy: disabled in MVP.
- Start animation: reuse an existing base-game short interaction animation. Candidate families to inspect in extracted tuning: phone browse, thoughtful idle, walk-away/travel setup, or generic self interaction. No custom animation.
- Outcomes:
  - 35% `Спалах Ідеї`
  - 25% `Нова Перспектива`
  - 20% `Повернувся з Натхненням`
  - 15% `Забагато Думок`
  - 5% `Невдала Прогулянка`
- Weight modifiers:
  - Inspired/Focused before leaving increases positive outcomes.
  - Tense/Bored increases mixed outcomes.
  - Creative/Genius traits increase idea outcomes if safe to test.

### Aspiration first milestone

`Знайти Себе` -> milestone `Спробувати нове`:

- Use `Піти шукати натхнення` 1 time.
- Get `Нова Перспектива` or `Спалах Ідеї` 1 time.
- Reach level 2 in any one base-game major skill, if objective can be generic. If generic skill objective is awkward, use Writing or Painting for MVP.

## 7. Full feature backlog

### Traits

1. `Неспокійний Мрійник`
2. `Самодисциплінований`
3. `Теплий Серцем`
4. `Тихий Аналітик`
5. `Шукач Схвалення`
6. `Стійкий Будівничий`
7. `Принциповий Бунтар`
8. `Опортуніст`

Implementation order:

1. Неспокійний Мрійник
2. Самодисциплінований
3. Теплий Серцем
4. Тихий Аналітик
5. Шукач Схвалення
6. Стійкий Будівничий
7. Принциповий Бунтар
8. Опортуніст

Reasoning:

- First four cover core loops: creativity, productivity, social support, mental focus.
- Last four add complexity: approval, routine, conflict, moral tradeoffs.

### Hidden states

Create as commodities/statistics with thresholds:

- `Restlessness`
- `Clarity`
- `Grounded`
- `Burnout`
- `Drift`
- `SocialFatigue`

Scope correction:

- Only `Restlessness` is implemented in MVP.
- `Clarity`, `Grounded`, `Burnout`, `Drift`, and `SocialFatigue` are backlog candidates, not guaranteed systems.
- A hidden state ships only if it changes behavior across at least two surfaces: interaction availability, rabbit-hole outcomes, aspiration objectives, career chance cards, autonomy, or reward traits.
- If a hidden state only maps to one visible emotion, replace it with a normal buff.

Threshold pattern:

- 0-25: inactive
- 26-50: mild state
- 51-75: visible buff possible
- 76-100: strong visible buff or forced recovery cue

Decay:

- Restlessness decays through novelty, social support, creative action.
- Clarity decays slowly over days.
- Grounded decays slowly, grows through rest and supportive social actions.
- Burnout grows from repeated productive outcomes without recovery.
- Drift grows from inactivity and failed outcomes.
- SocialFatigue grows from long social chains for specific traits.

### Aspirations

1. `Знайти Себе`
   - Focus: novelty, doubt, direction.
   - Category: Knowledge.
   - Reward: `Своя Лінія`.

2. `Жити Усвідомлено`
   - Focus: rhythm, rest, work-life balance.
   - Category: Knowledge.
   - Reward: `У Своєму Темпі`.

3. `Бути Опорою`
   - Focus: supporting friends, family, neighbor Sims.
   - Category: Family.
   - Reward: `Той, Хто Поряд`.

4. `Запалити Іскру`
   - Focus: creativity, risk, public expression.
   - Category: Creativity.
   - Reward: `Невгомонний`.

5. `Збудувати Шлях`
   - Focus: career, skill growth, avoiding burnout.
   - Category: Fortune.
   - Reward: `Без Зривів`.

### Careers

All careers use base-game rabbit-hole format.

#### Career A: Консультант Життєвого Напряму

Core skills:

- Charisma
- Logic
- Writing

Ideal moods:

- Focused
- Confident

Ranks:

1. Волонтер слухавки
2. Асистент групи підтримки
3. Координатор звичок
4. Молодший консультант
5. Фахівець з життєвого планування

Branch 1: Персональний Стратег

6. Аналітик рішень
7. Стратег рутини
8. Консультант великих змін
9. Архітектор життєвих систем
10. Майстер особистої стратегії

Branch 2: Громадський Ментор

6. Радник сусідів
7. Координатор підтримки
8. Ментор складних розмов
9. Керівник спільнотного центру
10. Голос громади

#### Career B: Незалежний Творець

Core skills:

- Writing
- Painting
- Guitar or Comedy
- Programming for commercial branch if base-safe

Ideal moods:

- Inspired
- Confident

Ranks:

1. Автор нотаток
2. Нічний ідейник
3. Вільний виконавець
4. Локальний автор
5. Самостійний професіонал

Branch 1: Культурний Автор

6. Автор малих робіт
7. Помітний голос
8. Майстер форми
9. Культурний провокатор
10. Жива легенда сцени

Branch 2: Комерційний Ідейник

6. Асистент брифів
7. Ідейний підрядник
8. Стратег кампаній
9. Директор концептів
10. Магнат ідей

#### Career C: Архітектор Рутини

Core skills:

- Logic
- Fitness
- Handiness
- Cooking

Ideal moods:

- Focused
- Energized

Ranks:

1. Помічник розкладу
2. Тестер звичок
3. Оператор побутових систем
4. Координатор балансу
5. Аналітик ритму

Branch 1: Продуктивний Аналітик

6. Оптимізатор задач
7. Менеджер фокусу
8. Інженер процесів
9. Директор продуктивності
10. Архітектор ідеального дня

Branch 2: Координатор Добробуту

6. Радник відновлення
7. Тренер побутового балансу
8. Спеціаліст стійкості
9. Керівник програми добробуту
10. Майстер здорового ритму

### Part-time jobs

- `Study Buddy`
- `Night Desk Clerk`
- `Community Caller`

These can ship after full careers if career UI work is stable.

## 8. Interaction backlog

Self interactions:

- `Піти шукати натхнення`
- `Зібрати думки`
- `Переосмислити день`
- `Дати собі обіцянку`
- `Вийти з рутини`

Phone interactions:

- `Скласти план майбутнього`
- `Попросити пораду`
- `Допомогти на гарячій лінії`
- `Взяти день без телефону`

Computer interactions:

- `Створити карту цілей`
- `Дослідити новий напрям`
- `Написати особистий маніфест`
- `Переглянути робочі звички`

Social interactions:

- `Підтримати друга`
- `Поговорити про майбутнє`
- `М'яко підштовхнути до змін`
- `Запитати, що справді важливо`
- `Поскаржитися на рутину`
- `Попросити чесну думку`

Autonomy:

- Trait-specific interactions may be autonomous only at low frequency.
- Phone/computer interactions must respect phone/computer likes/dislikes where possible.
- Support interactions should require relationship threshold to avoid random public spam.

Anti-spam rules:

- MVP rabbit-hole interactions are player-directed only.
- Active household autonomous rabbit-hole cooldown, if enabled later: minimum 24 sim hours.
- Visible negative moodlet cooldown per trait: minimum 12 sim hours.
- Same buff cannot stack with itself.
- If a Sim has `Dislikes Phones` or `Dislikes Computers`, phone/computer interactions from this mod must not be autonomous.
- No interaction from this mod should outrank urgent needs such as hunger, bladder, hygiene, infant care, work/school departure or sleep.

## 9. Buff design rules

Intensity:

- +1: normal gameplay feedback.
- +2: trait-defining or important state.
- +3: avoid except rare celebratory outcomes.

Duration:

- 1-2h: sharp reaction.
- 3-6h: standard moodlet.
- 8-12h: major state, use carefully.
- 24h: only for reward/major story outcomes.

Stacking:

- Prevent repeated rabbit-hole spam from stacking the same buff.
- Use cooldowns.
- Use mutually exclusive visible state buffs where needed.

Emotion safety:

- Avoid stacking Playful, Angry, Embarrassed too aggressively because extreme emotions can kill Sims.
- Tense/Bored/Focused/Inspired are safer for repeated systems.
- Flirty is not a core emotion for this mod.

## 10. Career balancing rules

Pay:

- Match base-game career curve, not DLC money inflation.
- Career A and C should be stable middle-income.
- Career B can have lower base pay but better chance-event spikes.

Promotion speed:

- `Самодисциплінований` and `Стійкий Будівничий` improve consistency.
- `Неспокійний Мрійник` helps creative career, hurts routine career if unmanaged.
- `Опортуніст` gets stronger chance events but relationship/mood costs.

Chance cards:

- Start with 2 per career branch.
- Outcomes should use moodlets and small performance changes, not huge money rewards.

Career daily tasks:

- Use base-game skills and interactions only.
- If a daily task references computer/phone, verify it still functions for Sims who dislike those objects. Preference should shape autonomy, not hard-block a required task.

## 11. Aspirations implementation details

Objective types to prefer:

- Skill level reached.
- Buff acquired.
- Interaction completed.
- Career level reached.
- Relationship threshold reached.
- Social interaction completed with target relationship threshold.

Objective types to avoid in first version:

- DLC event participation.
- Calendar events.
- Club actions.
- Lot trait checks.
- Pack-specific venue checks.
- Custom wants/fears checks until researched.
- Custom aspiration categories.

Reward traits:

- `Своя Лінія`: weaker negative Drift/Burnout decay.
- `У Своєму Темпі`: recovery actions stronger, sleep/rest buffs better.
- `Той, Хто Поряд`: support socials rarely fail and give small happy/confident buffs.
- `Невгомонний`: creative failure less punishing, inspired buffs last longer.
- `Без Зривів`: career performance steadier, fewer burnout spikes.

## 12. Compatibility plan

Preferred:

- Additive custom resources.
- Lot 51 Core Library TuningInjector for interactions and injections.
- No direct edits to EA careers, traits, aspirations unless a tiny compatibility patch is explicitly needed.

Avoid:

- Overriding `phone`, `computer`, major autonomy tunings.
- Replacing EA trait tunings.
- Editing core aspiration categories directly if injection/category addition is available.
- Pack-specific tags that silently fail in base game.

Potential conflict areas:

- Trait overhaul mods.
- More traits in CAS mods.
- Career overhaul mods.
- Autonomy overhaul mods.
- UI mods after major patches.
- MCCC.
- WickedWhims / WonderfulWhims.
- Lumpinou RPO.
- Slice of Life or similar personality/emotion overhauls.
- Basemental, if later versions add substance-related mood/autonomy hooks that overlap with stress or burnout systems.

Mitigation:

- Keep modules split during development.
- Publish a compatibility note.
- Provide no-overrides version if possible.
- Do not intentionally integrate adult mods in the base release. Compatibility means "does not break alongside them", not feature dependency.
- Smoke-test with the user's real mod stack only after clean base-game testing passes.
- Mykyta must provide the actual active script/tuning mod list before compatibility QA. CC-only clothing/furniture is not required for this matrix.

Compatibility matrix for release notes:

| Mod family | Expected risk | Test |
| --- | --- | --- |
| MCCC | Low-medium | save/load, career cheats, trait add/remove |
| WickedWhims/WonderfulWhims | Medium | autonomy, social queues, Last Exceptions |
| Lumpinou RPO | Medium | relationship/social interactions |
| Slice of Life/personality mods | High | moodlet spam, trait overlap |
| Career overhauls | High | Find a Job UI, career tuning conflicts |
| UI mods | Patch-dependent | CAS trait UI, aspiration panel |

## 13. Localization plan

Languages:

- English source strings.
- Ukrainian full translation.

String categories:

- Trait names/descriptions.
- Buff names/descriptions.
- Interaction names/tooltips.
- Career names, levels, branches, descriptions.
- Aspiration names, milestones, objectives.
- Reward trait names/descriptions.
- Notifications and chance cards.

Tone:

- No meme-heavy text.
- Short, Maxis-like descriptions.
- Ukrainian text should sound natural, not literal machine translation.

Example:

- EN: `Restless Dreamer`
- UK: `Неспокійний Мрійник`
- EN desc: `These Sims chase meaning in motion. Routine can make them tense, but a good idea can carry them for hours.`
- UK desc: `Ці сими шукають сенс у русі. Рутина швидко тисне на них, зате добра ідея здатна тримати їх годинами.`

## 14. QA checklist

Clean install:

- Only base game enabled.
- Only this mod and required dependency installed.
- Script Mods enabled only if script exists.

Test saves:

- Clean MVP save: one Sim with `Неспокійний Мрійник`, no other mods except required libraries.
- Mid-state save: 4-6 Sims, one played week, several hobbies/skills/careers active, used to detect autonomy spam and buff stacking.

CAS:

- Traits visible in correct age categories.
- Trait icons display.
- Trait conflicts work.
- Trait descriptions fit UI.

Live mode:

- Trait buffs trigger.
- Trait buffs do not spam.
- Interactions appear only when eligible.
- Rabbit-hole interaction removes Sim, returns Sim, applies outcome.
- Cooldowns work.
- Save/load preserves hidden states.
- Travel does not break states.

Aspirations:

- Aspiration visible in correct category.
- Milestones show localized text.
- Objectives complete reliably.
- Reward trait applies once.
- Switching aspirations does not corrupt progress.

Careers:

- Careers appear in Find a Job.
- Work schedule displays.
- Sim goes to work and returns.
- Daily tasks display and complete.
- Promotions work.
- Branch selection works.
- Career outfits do not break if custom outfits are skipped.
- Chance cards do not produce Last Exceptions.

Autonomy:

- Sims do not endlessly use phone/computer.
- Likes/Dislikes Phones/Computers are respected where possible.
- Social interactions do not appear too often with strangers.
- MVP rabbit-hole does not run autonomously.
- If autonomous mode is enabled in later builds, observe one 7-day active household test and confirm no Sim chooses the same custom rabbit-hole more than once unless player-directed.

Performance:

- No heavy every-tick script.
- No repeated broad injections.
- No Last Exceptions after 3 sim days.
- No noticeable simulation lag in a 20-Sim public lot test.

Regression:

- Retest after every EA patch.
- Diff extracted tuning after major updates.
- Rebuild only affected modules.
- Compare `research/snapshot_manifest.csv` against the new extraction manifest before editing.

Rollback:

- Every milestone has a QA tag.
- If a milestone fails because cross-trait interactions or shared states become unstable, return to the last QA-passing milestone.
- Do not stack emergency patches on top of an unstable design. Remove or postpone the unstable feature, update the design note, then retest.
- Deprecated IDs stay in `research/ids_registry.csv` and are never reused.

Popular mod smoke test, after clean QA only:

- MCCC installed.
- WickedWhims or WonderfulWhims installed, if present in the user's normal setup.
- Lumpinou RPO installed, if present in the user's normal setup.
- One personality/emotion overhaul installed, if the user actually plays with one.
- Run 3 sim days and check for Last Exceptions, stuck queues, aspiration panel issues and career UI issues.

## 15. Milestones

### Milestone 1: Research and registry

Deliverables:

- Extracted base tuning references.
- SHA-256 snapshot manifest.
- ID registry.
- String workbook.
- Final MVP implementation decision.

Done when:

- We know exact tuning patterns for trait, buff, aspiration objective and rabbit-hole interaction.

### Milestone 2: MVP trait loop

Deliverables:

- `Неспокійний Мрійник`.
- 8 moodlets.
- `Піти шукати натхнення`.
- `Restlessness`.
- First milestone of `Знайти Себе`.

Done when:

- Clean save can create a Sim, run the interaction, receive moodlets and complete aspiration objective.

### Milestone 3: Core trait set

Deliverables:

- First 4 traits.
- Shared state system.
- 20-24 moodlets.
- 8-10 interactions.

Done when:

- Traits feel different in a 3-day gameplay test.

### Milestone 4: Aspiration pack

Deliverables:

- 5 aspirations.
- 5 reward traits.
- All milestone/objective strings.

Done when:

- Each aspiration can be completed in a clean save without cheats.

### Milestone 5: Career pack

Deliverables:

- 3 full rabbit-hole careers.
- 6 branches total.
- 6-12 chance cards.
- Career-specific moodlets.

Done when:

- Each career supports joining, promotion, branch choice and completion.

### Milestone 6: Integration and balance

Deliverables:

- Existing trait integrations.
- Autonomy tuning pass.
- Cooldowns and anti-spam.
- Compatibility notes.

Done when:

- 7 sim days with a mixed household produces no Last Exceptions and no obvious spam.

### Milestone 7: Release candidate

Deliverables:

- Merged release package.
- Split debug packages.
- Readme.
- Install instructions.
- Changelog.
- Known issues.

Done when:

- Clean base-game test passes.
- Existing save smoke test passes.
- All strings have English and Ukrainian values.

## 16. String budget

Estimated localization scope:

| Feature group | Approx. strings |
| --- | --- |
| 8 traits | 16-32 |
| 48 moodlets | 96 |
| 5 aspirations | 80-140 |
| 5 reward traits | 10-20 |
| 3 full careers | 180-300 |
| Interactions, notifications, chance cards | 120-250 |
| QA/debug/internal notes not shipped | separate |

Expected shipped string workload:

- English source strings: roughly 300-450.
- Ukrainian translations: roughly 300-450.
- Total workbook rows: roughly 600-900.

Localization is a real milestone, not cleanup. No public release until names, descriptions and notifications pass `maxis_like_check`.

## 17. Time estimates

These are calendar estimates, not guaranteed build times.

| Phase | Solo beginner/modder learning | With Codex help after research | Notes |
| --- | --- | --- | --- |
| Research and examples | 1-2 weeks | 2-5 days | Depends on tooling setup and extracted tuning |
| MVP trait loop | 2-4 weeks | 1-3 weeks | Main risk is rabbit-hole pattern and aspiration objective |
| Four-trait alpha | 1-2 months | 3-6 weeks | Balance and anti-spam matter more than XML volume |
| Aspirations pack | 1-2 months | 3-6 weeks | Objective reliability is the risk |
| Career pack | 1-2 months | 3-8 weeks | Branch UI, chance cards, schedule tuning |
| Full beta QA | 1-3 months | 1-2 months | Real playtesting cannot be skipped |

Practical release strategy:

1. Ship internal MVP.
2. Play 7 sim days in clean save.
3. Add only one new trait at a time.
4. Do not start careers until traits + moodlets feel stable.

## 18. Closed technical decisions

- Extraction scope: full `Extract All` raw snapshot plus annotated subset.
- Raw extracted XML is read-only by convention.
- Custom aspiration categories are out of scope; use existing categories.
- Aspiration mapping: `Знайти Себе` -> Knowledge, `Жити Усвідомлено` -> Knowledge, `Бути Опорою` -> Family, `Запалити Іскру` -> Creativity, `Збудувати Шлях` -> Fortune.
- Custom wants/fears are out of MVP and first stable release.
- MVP rabbit-hole autonomy is disabled.
- `Restlessness` is the only MVP hidden state.

## 19. Open technical questions

- Best current base-game-safe pattern for custom rabbit-hole interactions.
- Whether phone/computer preference checks are exposed cleanly enough for interaction tests.
- Whether careers require SimData resources beyond what Sims 4 Studio handles.
- Whether custom career icons can safely use base-game icons without redistributing assets.
- Which base-game animation/affordance is the cleanest launch behavior for `Піти шукати натхнення`.
- Whether the career concepts feel distinct enough after prototyping, or should be postponed.
- Whether milestone 3+ shared state logic needs Python after MVP proves tuning-only commodities.

## 20. Source links

- EA latest released patch checked, 2026-04-28: https://www.ea.com/games/the-sims/the-sims-4/news/update-4-28-2026
- EA upcoming base-game update note, 2026-05-05: https://www.ea.com/games/the-sims/the-sims-4/news/laundry-list-may-5-2026
- EA 2026 Quality of Life Roadmap: https://www.ea.com/games/the-sims/the-sims-4/news/the-sims-4-quality-of-life-roadmap-2026
- EA autonomy/preferences patch, 2026-03-17: https://www.ea.com/games/the-sims/the-sims-4/news/update-3-17-2026
- EA Wants & Fears base-game update, 2022-07-26: https://www.ea.com/games/the-sims/the-sims-4/news/update-7-26-2022
- EA Neighborhood Stories system: https://www.ea.com/games/the-sims/the-sims-4/news/neighborhood-stories-system
- EA Neighborhood Stories first phase and aspirations: https://www.ea.com/games/the-sims/news/update-11-30-2021
- EA Help career types: https://help.ea.com/en/articles/the-sims/the-sims-4/the-sims-4-careers/
- EA Help base game free-to-play/install: https://help.ea.com/articles/the-sims/the-sims-4/base-game-install/
- Lot 51 Core Library: https://lot51.cc/mods/core-library
- Lot 51 Core Library source: https://github.com/lot51/core-library
- Lot 51 Simdex: https://lot51.cc/simdex
- Sims 4 Studio: https://sims4studio.com/
- XML Extractor reference: https://thesims4moddersreference.org/tutorials/xml-extractor/
