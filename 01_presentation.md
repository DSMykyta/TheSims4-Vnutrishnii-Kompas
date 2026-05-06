# The Sims 4: Внутрішній Компас

Повна концепція поведінкового DLC-моду для The Sims 4 Base Game. Робоча назва: `BaseGamePlus: Inner Compass`.

Мета: зробити базову гру глибшою без нових світів, предметів, одягу, анімацій або DLC-залежностей. Усе тримається на поведінці: traits, moodlets/buffs, hidden states, rabbit-hole активностях, аспіраціях, кар'єрах, автономії та реакціях на події.

## Поточний стан base game на 2026-05-06

Останній випущений патч, який я враховую в цьому документі: 2026-04-28, PC `1.123.85.1020`, Mac `1.123.85.1220`, Console `2.32`. Це підтверджено офіційною сторінкою EA patch notes. EA також анонсувала base-game update на 2026-05-12, але станом на 2026-05-06 він ще не вийшов, тому його не можна вважати стабільною базою.

Важливі base-game системи, на які можна спертися:

- Rabbit-hole careers: EA Help описує звичайні careers як роботи, де Sim залишає lot і повертається після зміни. Active professions прив'язані до DLC, тому для цього моду ми робимо тільки rabbit-hole careers.
- Підтверджені EA Help base-game careers для орієнтиру: Astronaut, Athlete, Business, Criminal, Culinary, Entertainer, Painter, Secret Agent, Tech Guru, Writer. Freelancer згадується EA Help як base-game career, але окремі trades треба перевірити в чистій base game перед використанням.
- Neighborhood Stories є base-game системою: сусіди можуть автономно змінювати життя, зокрема вступати/лишати кар'єри, а traits впливають на частину рішень.
- Wants & Fears замінили whims у base-game update 2022-07-26. Для першої версії ми не робимо кастомні wants/fears як основну систему, бо їхня модинг-стабільність потребує окремої перевірки.
- У березні 2026 EA додала base-game preferences `Likes Phones`, `Likes Computers`, `Dislikes Phones`, `Dislikes Computers`, щоб керувати автономним використанням телефонів і комп'ютерів. Це напряму корисно для нашого моду.
- EA у 2026 офіційно фокусується на Sim autonomy, sleep behavior, infant/caregiver autonomy, dining behavior, family trees і relationships. Наш мод має не ламати ці системи й не спамити autonomy.

## Тема DLC

`Внутрішній Компас` додає Sims відчуття життєвого напряму. Сим не просто має trait, який інколи дає +1 moodlet. Trait створює стиль життя:

- що Sim обирає автономно;
- від чого втомлюється;
- які rabbit-hole дії відкриває;
- які цілі йому легше виконувати;
- які career paths природно підсилює;
- як Sim переживає успіх, рутину, провал, підтримку і самотність.

## Основні стовпи дизайну

1. Характер має ціну.
   Кожен trait дає сильну перевагу, але також створює слабке місце.

2. Настрій має причину.
   Moodlets з'являються не випадково, а після дій, бездіяльності, роботи, соціальних взаємодій або rabbit-hole активностей.

3. Розвиток не тільки через навички.
   Життєві цілі вимірюють не лише skill level, а й послідовність, зв'язки, відпочинок, ризик, сенс і вибір.

4. Base game не має відчуватися бідною.
   Ми використовуємо те, що вже є: phone, computer, socials, careers, skills, emotions, aspirations, Neighborhood Stories.

5. Жодних DLC-залежностей.
   У першій стабільній версії не використовувати pack tags, pack icons, pack interactions, pack careers, active professions, clubs, calendar events, lot types або предмети з DLC.

## Нові traits

| Trait | Роль у gameplay | Сильна сторона | Ціна |
| --- | --- | --- | --- |
| Неспокійний Мрійник | Творчий Sim, якому тісно в рутині | Inspired, нові ідеї, rabbit-hole пошук натхнення | Bored/Tense від повторення |
| Самодисциплінований | Sim, який живе через режим і прогрес | Focused, швидший skill/career rhythm | Tense, якщо довго нічого не робить |
| Теплий Серцем | Соціальна підтримка і турбота | Happy після дружніх дій, сильніша дружба | Sad після сварок і відмов |
| Тихий Аналітик | Логіка, спостереження, інтелектуальна праця | Focused, Logic/Programming/Writing synergy | Social fatigue |
| Шукач Схвалення | Sim живе через реакцію інших | Confident після похвали, швидша соціальна інерція | Embarrassed/Tense після провалу |
| Стійкий Будівничий | Повільний, стабільний розвиток | Handiness/Cooking/Gardening/Fitness consistency | Bored від хаосу, слабша імпульсивність |
| Принциповий Бунтар | Не любить порожні правила | Confident від чесного конфлікту, Mischief/Charisma edge | Angry/Tense після компромісів |
| Опортуніст | Кар'єрний, гнучкий, ризиковий | Faster money/career outcomes in chance events | Moral hangover, weaker trust |

## Життєві стани

Це не нові occult states. Це поведінкові стани через hidden commodities, hidden traits і visible buffs.

Важлива правка після рев'ю: у MVP залишається тільки `Restlessness`. Інші states не йдуть у першу реалізацію автоматично. Їх треба додавати лише якщо вони дають нову gameplay information поверх звичайних emotions. Якщо state просто дублює `Tense`, `Bored`, `Happy` або `Confident`, він видаляється або лишається тільки як visible buff без hidden layer.

| State | Що означає | Видимі емоції | Gameplay ефект |
| --- | --- | --- | --- |
| Flow | Sim у потоці | Focused / Inspired | краще вчиться, менше відволікається |
| Drift | Sim втратив напрям | Bored / Sad | хоче змінити активність, гірші career outcomes |
| Restlessness | Sim потребує нового досвіду | Tense / Inspired | відкриває rabbit-hole пошук ідей |
| Grounded | Sim має опору | Happy / Confident | стабільніша соціалка і відпочинок |
| Burnout Edge | Sim на межі вигорання | Tense / Uncomfortable | гірша автономія продуктивності, потреба у відновленні |
| Clarity | Sim зрозумів наступний крок | Focused / Confident | бонус до aspiration/career задач |

Критерій для повної версії: hidden state має впливати на щонайменше дві системи одночасно, наприклад rabbit-hole outcomes і aspiration objectives, або career chance cards і autonomy. Інакше він не вартий складності.

## Moodlets

Перший великий набір: 48 moodlets, розбитих на позитивні, негативні, trait-specific і career-specific.

Приклади:

| Moodlet | Emotion | Trigger |
| --- | --- | --- |
| Спалах Ідеї | Inspired +2 | Неспокійний Мрійник повернувся з rabbit-hole пошуку |
| Світ Тісний | Bored +1 | довга рутина без творчої або нової дії |
| Забагато Думок | Tense +1 | багато mental/social тиску за день |
| Чіткий План | Focused +2 | планування майбутнього на computer/phone |
| Маленька Перемога | Confident +1 | завершення skill/career/aspiration micro-goal |
| Тепла Розмова | Happy +1 | успішна supportive social interaction |
| Порожній Успіх | Sad +1 | кар'єрний успіх без відпочинку або стосунків |
| Соціальне Перевантаження | Tense +2 | Тихий Аналітик після довгої розмови |
| Моральний Осад | Embarrassed/Sad +1 | Опортуніст отримав вигоду через mean/mischief шлях |
| На Межі Вигорання | Tense +2 | накопичена продуктивність без recovery дій |

Баланс: більшість moodlets мають бути +1. +2 лише для trait-defining моментів. +3 краще уникати, щоб не провокувати випадкові emotional deaths.

## Життєві цілі й аспірації

Custom aspiration categories не використовуються. Аспірації inject-яться у стабільні base-game категорії.

| Aspiration | Base-game category | Тема | Reward trait |
| --- | --- | --- | --- |
| Знайти Себе | Knowledge | пробувати різні шляхи, пережити сумнів, вибрати напрям | Своя Лінія |
| Жити Усвідомлено | Knowledge | баланс продуктивності, відпочинку і стосунків через self-knowledge | У Своєму Темпі |
| Бути Опорою | Family | підтримка близьких, друзів, сусідів і "обраної родини" | Той, Хто Поряд |
| Запалити Іскру | Creativity | творчий ризик, ідеї, публічне самовираження | Невгомонний |
| Збудувати Шлях | Fortune | career/skill progression без вигорання | Без Зривів |

Приклад aspiration `Знайти Себе`:

1. Спробувати нове
   - виконати 3 різні rabbit-hole активності;
   - отримати moodlet `Нова Перспектива`;
   - поговорити з 2 Sims про майбутнє.

2. Зіткнутися з сумнівом
   - пережити `Drift` або `Restlessness`;
   - завершити 1 skill level під час негативного moodlet;
   - попросити пораду або підтримку.

3. Вибрати напрям
   - досягти level 4 у будь-якій major skill;
   - отримати career promotion або завершити значущу social goal;
   - скласти план майбутнього.

4. Внутрішній Стержень
   - досягти `Clarity`;
   - підтримувати `Grounded` 2 дні;
   - завершити одну довгу ціль без Burnout Edge.

## Rabbit-hole careers

Усі кар'єри робляться як base-game rabbit-hole careers. Жодних active profession механік.

Кар'єри не мають бути просто Writer/Painter/Business під іншими назвами. Їхня відмінність повинна йти не з назви, а з системної петлі: у кожної кар'єри є власні chance cards, trait hooks, moodlet risks, recovery mechanics і зв'язок з життєвими станами.

| Нова кар'єра | Чим схожа на EA base game | Чим має відрізнятися |
| --- | --- | --- |
| Консультант Життєвого Напряму | Business + Charisma | не про гроші, а про вплив на інших Sims, advice outcomes, Neighborhood Stories-adjacent socials |
| Незалежний Творець | Writer/Painter/Entertainer | не окрема творча професія, а нестабільний freelance-style шлях з натхненням, провалами, public approval і burnout |
| Архітектор Рутини | Business/Tech Guru/Logic | не офісна кар'єра, а системний стиль життя: sleep, habits, recovery, planning, stress control |

Якщо в research phase не вдасться зробити careers відчутно іншими через tuning, careers треба перенести в пізніший milestone і спершу випустити traits + aspirations + rabbit-hole activities.

### 1. Консультант Життєвого Напряму

Skills: Charisma, Logic, Writing.

Рівні 1-5:

1. Волонтер слухавки
2. Асистент групи підтримки
3. Координатор звичок
4. Молодший консультант
5. Фахівець з життєвого планування

Branches:

- Персональний Стратег: кар'єра про планування, продуктивність, рішення.
- Громадський Ментор: кар'єра про підтримку, Neighborhood Stories, соціальні зв'язки.

### 2. Незалежний Творець

Skills: Writing, Painting, Guitar, Comedy або Programming залежно від branch.

Рівні 1-5:

1. Автор нотаток
2. Нічний ідейник
3. Вільний виконавець
4. Локальний автор
5. Самостійний професіонал

Branches:

- Культурний Автор: творчість, натхнення, публічні реакції.
- Комерційний Ідейник: гроші, deadlines, stress, social approval.

### 3. Архітектор Рутини

Skills: Logic, Fitness, Handiness, Cooking.

Рівні 1-5:

1. Помічник розкладу
2. Тестер звичок
3. Оператор побутових систем
4. Координатор балансу
5. Аналітик ритму

Branches:

- Продуктивний Аналітик: Focused, career speed, risk of burnout.
- Координатор Добробуту: recovery, relationships, sleep/autonomy friendly.

### Part-time jobs

- Study Buddy: teen+ підтримка навчання і mental/social skills.
- Night Desk Clerk: low social, stable money, Tense risk.
- Community Caller: social rabbit-hole job, дружба і advice outcomes.

## Rabbit-hole активності

Доступ через self, phone або computer залежно від контексту:

- Піти шукати натхнення
- Скласти план майбутнього
- Піти на тиху прогулянку
- Відвідати безкоштовний воркшоп
- Допомогти на гарячій лінії
- Взяти день без телефону
- Попросити професійну пораду
- Провести вечір без мети
- Переглянути життєві пріоритети
- Вийти з рутини

Кожна активність має 3-5 можливих outcomes, які залежать від trait, mood, skill і hidden state.

## Реворки існуючих систем

Це не повне переписування EA tuning. Це легкі injections і нові реакції.

- Ambitious отримує більше шансів на `Чіткий План`, але швидше накопичує `Burnout Edge`.
- Creative сильніше взаємодіє з `Неспокійний Мрійник` і `Запалити Іскру`.
- Genius і Bookworm добре працюють із `Тихий Аналітик`.
- Good і Family-Oriented підсилюють `Теплий Серцем` і aspiration `Бути Опорою`.
- Noncommittal частіше входить у `Restlessness`, але гірше тримає `Grounded`.
- Loner має менше social fatigue від самотності, але складніше виконує підтримувальні цілі.
- Likes/Dislikes Phones/Computers використовуються як autonomy guard: мод не змушує Sims безкінечно лізти в phone/computer.

## Тон і назви

Поточний тон свідомо ближчий до self-help / life direction. Це може бути сильним стилем моду, але для The Sims 4 є ризик пафосу. Перед релізом треба вибрати один із двох тонів:

| Варіант | Приклад назв | Відчуття |
| --- | --- | --- |
| Серйозний | Внутрішній Компас, Внутрішній Стержень, Жити Усвідомлено | глибше, доросліше, трохи self-help |
| Maxis-like іронічний | Не знаю, але йду, План на серветці, Дорослішання болить | легше, ближче до Sims, менше пафосу |

Прийняте рішення: змішаний тон. Traits і aspirations можуть бути серйозними, бо це риси характеру і життєві цілі. Reward traits мають бути приземленішими, щоб не звучати як мотиваційний блог.

Обрані reward trait назви:

- `Внутрішній Стержень` -> `Своя Лінія`
- `Ясний Ритм` -> `У Своєму Темпі`
- `Надійна Присутність` -> `Той, Хто Поряд`
- `Невгасимий` -> `Невгомонний`
- `Стійкий Прогрес` -> `Без Зривів`

Buff/moodlet tone лишається ближчим до Maxis: `Спалах Ідеї`, `Тепла Розмова`, `Маленька Перемога`, `Порожній Успіх`.

## Research дисципліна

Перед першим tuning-файлом робиться research snapshot:

- `Extract All` для повного raw snapshot.
- Raw snapshot вважається read-only reference. Його не коментувати і не редагувати.
- Для роботи робляться копії в `research/annotated/`.
- Після extraction зберігаються SHA-256 hashes extracted XML, щоб після EA patch diff показував реальні зміни.
- Research закривається тільки після відповідей на 5 stop-rule питань з implementation plan.

## Anti-spam і комфорт гравця

Мод не має карати гравця за звичайну гру. Негативні moodlets повинні пояснювати поведінку, а не створювати постійну emotional spiral.

- У MVP максимум 8 moodlets, з них не більше 3 негативних.
- Негативні moodlets для `Неспокійний Мрійник` не тригеряться частіше ніж раз на 12 sim hours.
- Автономна rabbit-hole дія в MVP вимкнена. Player запускає її вручну.
- Якщо автономія буде додана пізніше, потрібні relationship/mood/context gates і cooldown не менше 24 sim hours для active household.
- Phone/computer interactions поважають `Dislikes Phones` і `Dislikes Computers`, або не запускаються автономно взагалі.

## Оцінка масштабу

Це не weekend-мод. Реалістична оцінка:

| Обсяг | Що входить | Оцінка |
| --- | --- | --- |
| MVP | 1 trait, 8 moodlets, 1 rabbit-hole, 1 milestone | 1-3 тижні після research |
| Alpha | 4 traits, базові states, 10 interactions | 1-2 місяці |
| Beta | 5 aspirations, 3 careers, QA | 3-6 місяців |
| Full DLC-like release | баланс, локалізація, сумісність, патчі | 6-12 місяців |

Codex може прискорити XML/STBL рутину, але не скасовує playtesting. Основний час піде не на написання tuning, а на перевірку, баланс і фікс Last Exceptions.

## Gameplay loop

1. Player обирає trait і aspiration.
2. Trait відкриває 1-3 унікальні дії та змінює автономію.
3. Дії дають moodlets і рухають hidden states.
4. Hidden states впливають на кар'єру, аспірації, соціалку і rabbit-hole outcomes.
5. Кар'єри й аспірації дають reward traits.
6. Reward traits стабілізують стиль життя або відкривають сильніші версії дій.

## MVP першої версії

Перший вертикальний зріз:

- Trait `Неспокійний Мрійник`.
- 8 moodlets.
- 1 hidden state: `Restlessness`.
- Rabbit-hole interaction `Піти шукати натхнення`.
- Aspiration `Знайти Себе`, milestone 1.
- Reward trait stub `Своя Лінія`.
- Українська й англійська string table.

Цей MVP перевіряє повний pipeline: CAS trait, buffs, interaction, rabbit-hole outcome, aspiration tracking, strings, save/load.

## Що не входить у першу стабільну версію

- Active careers.
- DLC hooks.
- Нові objects, CAS, animations, worlds.
- Кастомні wants/fears як головна система.
- Custom aspiration categories.
- Глибокі overrides базової автономії.
- Системи, які потребують Seasons calendar, Get Together clubs, Get to Work active lots або pack-specific skills.

## Джерела

- EA patch 2026-04-28, latest released version checked: https://www.ea.com/games/the-sims/the-sims-4/news/update-4-28-2026
- EA Laundry List 2026-05-05, upcoming May 12 update: https://www.ea.com/games/the-sims/the-sims-4/news/laundry-list-may-5-2026
- EA Quality of Life Roadmap 2026: https://www.ea.com/games/the-sims/the-sims-4/news/the-sims-4-quality-of-life-roadmap-2026
- EA patch 2026-03-17, autonomy and phone/computer preferences: https://www.ea.com/games/the-sims/the-sims-4/news/update-3-17-2026
- EA patch 2022-07-26, Wants & Fears and base-game systems: https://www.ea.com/games/the-sims/the-sims-4/news/update-7-26-2022
- EA Neighborhood Stories system: https://www.ea.com/games/the-sims/the-sims-4/news/neighborhood-stories-system
- EA Neighborhood Stories first phase and two base-game aspirations: https://www.ea.com/games/the-sims/news/update-11-30-2021
- EA Help, career types: https://help.ea.com/en/articles/the-sims/the-sims-4/the-sims-4-careers/
- EA Help, base game install/free-to-play: https://help.ea.com/articles/the-sims/the-sims-4/base-game-install/
- Lot 51 Core Library: https://lot51.cc/mods/core-library
- Lot 51 Core Library source/docs: https://github.com/lot51/core-library
- Lot 51 Simdex/Tuning tools: https://lot51.cc/simdex
- Sims 4 Studio: https://sims4studio.com/
- XML Extractor tutorial/reference: https://thesims4moddersreference.org/tutorials/xml-extractor/
- Community reference for base-game traits, verify against extracted tuning before release: https://sims.fandom.com/wiki/Category:Traits_from_The_Sims_4_(base_game)
- Community reference for aspirations, verify against extracted tuning before release: https://sims.fandom.com/wiki/Aspiration_(The_Sims_4)
