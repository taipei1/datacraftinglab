# Seminár 4 – Zadanie 1d (window functions, databáza superstore)

Zdroj: UKF Moodle, pokus o test `attempt=566144&cmid=289627`.
URL: https://edu.ukf.sk/mod/quiz/attempt.php?attempt=566144&cmid=289627
Uložené: 2026-10-18. Strán spolu: 9.

---

## Strana 1 / 9 — Otázka 1

### 💻 Úloha 1 – Posledné dve objednávky každého zákazníka

💻 Úloha 1 – Posledné dve objednávky každého zákazníka
V tejto a všetkých nasledujúcich úlohách v tomto zadaní pracujte s databázou superstore a tabuľkami customers, orders a products, ktoré ste vytvorili v predchádzajúcich zadaniach.
Vytvorte SQL dotaz, ktorý pre každého zákazníka zobrazí najnovšie dve objednávky.
Vo výsledku zobrazte:
meno zákazníka,
identifikátor objednávky,
dátum objednávky.
Na určenie poradia objednávok použite window function ROW_NUMBER().
Číslovanie objednávok musí začínať od hodnoty 1 samostatne pre každého zákazníka a objednávky musia byť zoradené od najnovšej po najstaršiu.
Výsledok zoraďte podľa mena zákazníka a následne podľa poradia objednávky.
Koľko záznamov vrátil váš SQL dotaz? Do odpovede zadajte iba počet.
💡 Pomôcka: Použite PARTITION BY customer_id a vo vnútri OVER() zoraďte objednávky podľa order_date DESC. Následne ponechajte iba riadky s poradím 1 alebo 2.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `27`

---

## Strana 2 / 9 — Otázka 2

### 💻 Úloha 2 – Poradie zákazníkov podľa zisku v rámci regiónu

💻 Úloha 2 – Poradie zákazníkov podľa zisku v rámci regiónu
Vytvorte SQL dotaz, ktorý zoradí zákazníkov podľa ich celkového zisku v rámci jednotlivých regiónov.
Najskôr pre každého zákazníka vypočítajte celkový zisk pomocou agregačnej funkcie SUM().
Následne použite dve window functions:
RANK() – poradie zákazníka podľa celkového zisku v rámci jeho regiónu,
DENSE_RANK() – alternatívne poradie bez preskakovania nasledujúceho čísla pri zhodných hodnotách.
Obe funkcie aplikujte samostatne pre každý región pomocou PARTITION BY a zákazníkov zoraďte podľa celkového zisku zostupne.
Vo výsledku zobrazte:
región,
meno zákazníka,
celkový zisk ako total_profit,
poradie z funkcie RANK(),
poradie z funkcie DENSE_RANK().
Ktorá z nasledujúcich tabuliek zodpovedá prvým piatim riadkom správne vypočítaného výsledku?
💡 Pomôcka: Poradie sa musí začať od hodnoty 1 nanovo pre každý región. Preto použite PARTITION BY region.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.
region
customer_name
total_profit
profit_rank
profit_dense_rank
Central
Customer_16
533.82
1
1
Central
Customer_17
453.85
2
2
Central
Customer_27
350.88
3
3
Central
Customer_22
73.33
4
4
Central
Customer_8
14.05
5
5
- **b)** b.
region
customer_name
total_profit
profit_rank
profit_dense_rank
Central
Customer_16
533.82
5
5
Central
Customer_17
453.85
4
4
Central
Customer_27
350.88
3
3
Central
Customer_22
73.33
2
2
Central
Customer_8
14.05
1
1
- **c)** c.
region
customer_name
total_profit
profit_rank
profit_dense_rank
Central
Customer_16
533.82
1
1
Central
Customer_17
453.85
3
2
Central
Customer_27
350.88
4
3
Central
Customer_22
73.33
5
4
Central
Customer_8
14.05
6
5
- **d)** d.
region
customer_name
total_profit
profit_rank
profit_dense_rank
Central
Customer_16
533.82
1
1
Central
Customer_27
350.88
2
2
Central
Customer_17
453.85
3
3
Central
Customer_22
73.33
4
4
Central
Customer_8
14.05
5
5

> **Zadaná odpoveď:** `0 (moznost a)`

---

## Strana 3 / 9 — Otázka 3

### 💻 Úloha 3 – Rozdelenie zákazníkov do kvartilov podľa predaja

💻 Úloha 3 – Rozdelenie zákazníkov do kvartilov podľa predaja
Vytvorte SQL dotaz, ktorý rozdelí zákazníkov do štyroch kvartilov podľa ich celkového predaja.
Najskôr pre každého zákazníka vypočítajte celkový predaj pomocou agregačnej funkcie SUM().
Následne použite window function NTILE(4), ktorá rozdelí zoradené riadky do štyroch približne rovnako veľkých skupín.
Pri zoradení podľa celkového predaja zostupne bude:
quartile 1 obsahovať zákazníkov s najvyšším predajom,
quartile 2 ďalšiu skupinu zákazníkov,
quartile 3 zákazníkov s nižším predajom,
quartile 4 zákazníkov s najnižším predajom.
Vo výsledku zobrazte:
meno zákazníka,
jeho celkový predaj ako total_sales,
číslo kvartilu ako quartile.
Určite na základe získaných výsledkov, či je nasledovné tvrdenie pravdivé alebo nepravdivé. Zákazník Customer_26 má hodnotu total_sales = 1319.64 a patrí do quartile = 3.
💡 Pomôcka: Použite NTILE(4) OVER (ORDER BY ... DESC). Funkcia NTILE() nepriraďuje poradie ako RANK(), ale rozdeľuje celý zoradený výsledok do zadaného počtu skupín.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** 
- **b)** 

> **Zadaná odpoveď:** `0 (Nepravda)`

---

## Strana 4 / 9 — Otázka 4

### 💻 Úloha 4 – Porovnanie mesačného predaja s predchádzajúcim a nasledujúcim mesiacom

💻 Úloha 4 – Porovnanie mesačného predaja s predchádzajúcim a nasledujúcim mesiacom
Vytvorte SQL dotaz, ktorý umožní porovnať predaj v jednotlivých mesiacoch s hodnotou predaja v predchádzajúcom a nasledujúcom mesiaci.
Najskôr vypočítajte celkový predaj za každý mesiac pomocou SUM() a dátumy zoskupte na úroveň mesiaca pomocou DATE_TRUNC().
Následne použite window functions LAG() a LEAD().
LAG() umožňuje získať hodnotu z predchádzajúceho riadku podľa poradia definovaného vo OVER().
LAG(value, 1) OVER (ORDER BY month)
Číslo 1 znamená, že chceme hodnotu o jeden riadok späť. Pri mesačných dátach zoradených podľa mesiaca teda získame hodnotu predchádzajúceho mesiaca.
LEAD() funguje opačne – umožňuje pristúpiť k hodnote nasledujúceho riadku.
LEAD(value, 1) OVER (ORDER BY month)
Vo výsledku vytvorte nasledujúce stĺpce:
month – mesiac predaja,
monthly_sales – celkový predaj za aktuálny mesiac,
prev_month_sales – predaj za predchádzajúci mesiac,
next_month_sales – predaj za nasledujúci mesiac.
Výsledok zoraďte podľa mesiaca vzostupne. Ktorá z nasledujúcich tabuliek správne zodpovedá výsledku vášho SQL dotazu?
💡 Dôležité:> Pre marec bude hodnota prev_month_sales predstavovať februárový predaj a next_month_sales aprílový predaj. Funkcie teda nemenia poradie riadkov, ale umožňujú aktuálnemu riadku pristupovať k hodnotám jeho susedov.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.
month
monthly_sales
prev_month_sales
next_month_sales
2024-01-01
5921.44
6062.89
NULL
2024-02-01
6062.89
6664.95
5921.44
2024-03-01
6664.95
10472.55
6062.89
2024-04-01
10472.55
NULL
6664.95
- **b)** b.
month
monthly_sales
prev_month_sales
next_month_sales
2024-01-01
5921.44
0.00
6062.89
2024-02-01
6062.89
5921.44
6664.95
2024-03-01
6664.95
6062.89
10472.55
2024-04-01
10472.55
6664.95
0.00
- **c)** c.
month
monthly_sales
prev_month_sales
next_month_sales
2024-01-01
5921.44
NULL
6664.95
2024-02-01
6062.89
5921.44
10472.55
2024-03-01
6664.95
6062.89
NULL
2024-04-01
10472.55
6664.95
6062.89
- **d)** d.
month
monthly_sales
prev_month_sales
next_month_sales
2024-01-01
5921.44
NULL
6062.89
2024-02-01
6062.89
5921.44
6664.95
2024-03-01
6664.95
6062.89
10472.55
2024-04-01
10472.55
6664.95
NULL

> **Zadaná odpoveď:** `3 (moznost d)`

---

## Strana 5 / 9 — Otázka 5

### 💻 Úloha 5 – Zjednodušenie výpočtu podielu produktu v kategórii

💻 Úloha 5 – Zjednodušenie výpočtu podielu produktu v kategórii
Nasledujúci SQL dotaz má vypočítať, aký percentuálny podiel z celkového predaja svojej kategórie predstavuje každý produkt.
SELECT
    p.category,
    p.product_name,
    SUM(o.sales) AS product_sales
    SUM(SUM(o.sales)) OVER (PARTITION BY p.category) AS category_total,
    ROUND(
        SUM(o.sales) * 100.0 /
        SUM(SUM(o.sales)) OVER (PARTITION BY p.category),
        2
    ) AS pct_of_category
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category, p.product_name;
Vašou úlohou je tento dotaz najskôr opraviť a potom prepísať do prehľadnejšej podoby.
Pri riešení postupujte v dvoch krokoch:
Najskôr vypočítajte predaj jednotlivých produktov.
Vytvorte medzivýsledok, v ktorom bude pre každý produkt dostupná jeho kategória, názov produktu a celkový predaj product_sales.
Až nad týmto medzivýsledkom použite window function.
Pre každý produkt vypočítajte celkový predaj jeho kategórie pomocou SUM(product_sales) OVER (PARTITION BY category) a následne vypočítajte percentuálny podiel produktu na tejto hodnote.
Výsledný dotaz má obsahovať:
kategóriu produktu,
názov produktu,
celkový predaj produktu,
celkový predaj celej kategórie,
percentuálny podiel produktu na predaji kategórie zaokrúhlený na dve desatinné miesta.
💡 Dôležité: V pôvodnom dotaze sa agregačný výpočet produktu a window function vykonávajú v jednom výraze. PostgreSQL to dokáže spracovať, ale zápis je horšie čitateľný. Ak si najskôr pripravíte product_sales, v ďalšom kroku už pracujete s hotovou hodnotou a window function je jednoduchšia na pochopenie aj úpravu.
⚠️ Nezabudnite: Upravené SQL riešenie uložte do svojho súboru pre window functions a vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `Vlastny opraveny SQL dotaz s CTE product_sales + SUM(product_sales) OVER (PARTITION BY category)`

---

## Strana 6 / 9 — Otázka 6

### 💻 Úloha 6 – Neaktívni zákazníci za posledných 90 dní

💻 Úloha 6 – Neaktívni zákazníci za posledných 90 dní
Vedenie chce identifikovať zákazníkov, ktorí nevytvorili žiadnu objednávku za posledných 90 dní, pričom do analýzy zahrňte iba zákazníkov, ktorí už v minulosti aspoň jednu objednávku vytvorili.
Keďže pracujete s historickým datasetom, nepoužívajte aktuálny systémový dátum. Hranicu 90 dní určte vzhľadom na najnovší dátum objednávky nachádzajúci sa v datasete.
Pri riešení použite window function MAX() spolu s OVER().
Pre každého zákazníka potrebujete určiť:
last_order_date – dátum jeho poslednej objednávky,
latest_order_date – najnovší dátum objednávky v celom datasete.
Na výpočet poslednej objednávky zákazníka použite princíp:
MAX(order_date) OVER (
    PARTITION BY customer_id
)
Na získanie najnovšieho dátumu objednávky v celom datasete použite rovnakú window function bez PARTITION BY.
Vo výsledku zobrazte:
identifikátor zákazníka,
meno zákazníka,
dátum jeho poslednej objednávky.
Výsledok zoraďte podľa dátumu poslednej objednávky od najstaršej po najnovšiu.
Na základe výsledku vášho SQL dotazu rozhodnite, či je nasledujúce tvrdenie pravdivé. Zákazník Customer_14 vytvoril aspoň jednu objednávku počas posledných 90 dní sledovaného obdobia.
💡 Pomôcka: Zákazník sa považuje za neaktívneho, ak jeho posledná objednávka vznikla skôr ako latest_order_date - INTERVAL '90 days'.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** 
- **b)** 

> **Zadaná odpoveď:** `0 (Nepravda)`

---

## Strana 7 / 9 — Otázka 7

### 💻 Úloha 7 – Medzimesačný rast predaja (Nepovinná)

💻 Úloha 7 – Medzimesačný rast predaja (Nepovinná)
V tejto úlohe budete analyzovať, ako sa predaj menil medzi jednotlivými mesiacmi. Nestačí teda zistiť iba celkový predaj za každý mesiac – každý mesiac potrebujete zároveň porovnať s hodnotou, ktorá mu bezprostredne predchádzala.
Výsledkom má byť pre každý mesiac informácia o tom:
aký bol celkový predaj v aktuálnom mesiaci,
aký bol predaj v predchádzajúcom mesiaci,
o akú hodnotu sa predaj zvýšil alebo znížil,
akú percentuálnu zmenu tento rozdiel predstavuje.
1. Najskôr vytvorte mesačný prehľad predaja.
Zdrojová tabuľka obsahuje jednotlivé objednávky, preto najskôr potrebujete previesť detailné záznamy na úroveň mesiacov. Dátum objednávky zoskupte podľa mesiaca a pomocou SUM() vypočítajte celkový predaj za každý mesiac.
Po tomto kroku by mal medzivýsledok obsahovať jeden riadok pre každý mesiac, napríklad:
month        monthly_sales
2024-01-01   ...
2024-02-01   ...
2024-03-01   ...
...
2. Ku každému mesiacu doplňte predaj predchádzajúceho mesiaca.
Na to použite window function LAG(). Funkcia umožňuje aktuálnemu riadku pristúpiť k hodnote z predchádzajúceho riadku bez potreby spájať tabuľku samu so sebou.
Keďže potrebujete porovnávať po sebe idúce mesiace, musí byť poradie vo window function definované chronologicky:
LAG(monthly_sales) OVER (ORDER BY month)
Takto bude mať napríklad marcový riadok k dispozícii februárový predaj ako hodnotu prev_month_sales.
3. Vypočítajte absolútnu zmenu predaja.
Absolútna zmena vyjadruje, o koľko jednotiek sa predaj zmenil oproti predchádzajúcemu mesiacu:
monthly_sales - prev_month_sales
Výsledok interpretujte nasledovne:
kladná hodnota znamená, že predaj sa zvýšil,
záporná hodnota znamená, že predaj sa znížil,
hodnota 0 reprezentuje, že predaj zostal rovnaký.
4. Vypočítajte percentuálnu zmenu.
Samotný rozdiel ešte nehovorí, aký veľký bol rast vzhľadom na pôvodnú hodnotu. Preto vypočítajte aj percentuálnu zmenu voči predchádzajúcemu mesiacu:
((monthly_sales - prev_month_sales)
 / prev_month_sales) * 100
Percentuálnu hodnotu zaokrúhlite na dve desatinné miesta.
💡 Odporúčanie: Nesnažte sa celý výpočet zapísať do jedného výrazu. Najskôr si pripravte mesačné predaje, následne v ďalšom kroku pomocou LAG() pridajte predaj predchádzajúceho mesiaca a až potom vypočítajte rozdiel a percentuálnu zmenu. Na oddelenie jednotlivých krokov môžete použiť CTE alebo vnorený dotaz.
Vo výsledku zobrazte nasledujúce stĺpce:
month – mesiac,
monthly_sales – predaj v aktuálnom mesiaci,
prev_month_sales – predaj v predchádzajúcom mesiaci,
sales_change – absolútna zmena predaja,
growth_percentage – percentuálna zmena predaja.
Výsledok zoraďte podľa mesiaca vzostupne.
O koľko percent vzrástol predaj v apríli oproti marcu? Do odpovede zadajte iba číselnú hodnotu zaokrúhlenú na dve desatinné miesta.
💡 Dôležité: Prvý mesiac vo výsledku nemá žiadny predchádzajúci mesiac, s ktorým by sa dal porovnať. Funkcia LAG() preto vráti NULL. Z toho dôvodu budú pre prvý mesiac hodnoty sales_change aj growth_percentage tiež NULL.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `57.13`

---

## Strana 8 / 9 — Otázka 8

### 💻 Úloha 8 – Návrat zákazníkov po prvom nákupe v júni 2024 (Nepovinná)

💻 Úloha 8 – Návrat zákazníkov po prvom nákupe v júni 2024 (Nepovinná)
V tejto úlohe budete analyzovať správanie zákazníkov podľa dátumu ich prvého nákupu.
Vašou úlohou je zistiť, koľko zákazníkov uskutočnilo svoj úplne prvý nákup v júni 2024 a následne vytvorilo aspoň jednu ďalšiu objednávku v niektorom z neskorších mesiacov.
Riešenie si rozdeľte na dva logické kroky.
1. Určte prvý mesiac nákupu každého zákazníka.
Pre každého zákazníka nájdite najskorší dátum objednávky pomocou MIN() a následne ho pomocou DATE_TRUNC() upravte na úroveň mesiaca.
Výsledkom tohto kroku by mal byť pre každého zákazníka jeden riadok obsahujúci:
identifikátor zákazníka,
mesiac jeho prvého nákupu.
2. Overte, či sa zákazník po svojom prvom nákupe ešte vrátil.
Zo zákazníkov, ktorých prvý nákup pripadol na 2024-06-01, ponechajte iba tých, ktorí majú v tabuľke orders ešte aspoň jednu objednávku z neskoršieho mesiaca.
💡 Pomôcka: Na overenie existencie neskoršej objednávky môžete použiť operátor EXISTS. Nemusíte zisťovať počet všetkých ďalších objednávok – stačí overiť, či existuje aspoň jedna.
Výsledkom má byť jedna číselná hodnota – počet zákazníkov, ktorí spĺňajú obe podmienky:
ich prvý nákup bol v júni 2024,
neskôr uskutočnili aspoň jednu ďalšiu objednávku.
Koľko zákazníkov, ktorí uskutočnili svoj prvý nákup v júni 2024, sa vrátilo a nakúpilo aj v niektorom z nasledujúcich mesiacov?
💡 Dôležité:Zákazník sa počíta ako „vrátený“ iba vtedy, ak jeho ďalšia objednávka patrí do mesiaca neskoršieho než mesiac prvého nákupu. Ďalšia objednávka vytvorená ešte v júni sa preto nepovažuje za návrat v neskoršom mesiaci.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a. 4
- **b)** b. 15
- **c)** c. 9
- **d)** d. 0

> **Zadaná odpoveď:** `3 (moznost c)`

---

## Strana 9 / 9 — Informácia

### 📘 Kontrola Git repozitára po 4. týždni

📘 Kontrola Git repozitára po 4. týždni
Po dokončení všetkých úloh zo 4. týždňa skontrolujte, či máte vo svojom Git repozitári vytvorenú ďalšiu samostatnú vetvu, napr. week-04, a či sa v nej nachádzajú všetky SQL skripty a dátové súbory používané počas cvičenia.
Obsah vetvy week-04 by mal mať približne nasledujúcu štruktúru:
week-04
│
├── 01_window_functions_retail.sql
├── 02_window_functions.sql
│
└── online_retail.csv
Dátový súbor online_retail.csv ponechajte v repozitári spolu so SQL skriptmi, aby bolo možné databázu a riešenia neskôr znovu vytvoriť.
⚠️ Kontrola GitHubu: Vzdialený repozitár na GitHube by mal obsahovať rovnaké súbory ako váš lokálny repozitár. Ak niektorý SQL alebo CSV súbor vidíte iba vo VS Code, ale nie na GitHube, zmena ešte nebola úspešne odoslaná pomocou push.

---
