# Seminár 4 – Zadanie 1c (window functions, databáza retail)

Zdroj: UKF Moodle, pokus o test `attempt=566143&cmid=289628`.
URL: https://edu.ukf.sk/mod/quiz/attempt.php?attempt=566143&cmid=289628
Uložené: 2026-10-18. Strán spolu: 17.

---

## Strana 1 / 17 — Informácia

### 📘 Window Functions v PostgreSQL

📘 Window Functions v PostgreSQL
Window functions umožňujú vykonávať výpočty nad skupinou súvisiacich riadkov bez toho, aby sa jednotlivé riadky výsledku zlúčili.
To je ich hlavný rozdiel oproti agregačným funkciám používaným spolu s GROUP BY. Pri použití GROUP BY sa viacero vstupných riadkov zoskupí do jedného výsledného riadku. Window function však ponechá jednotlivé riadky zachované a ku každému z nich vypočíta ďalšiu hodnotu.
GROUP BY vs. Window Function
Predstavme si nasledujúce údaje:
region
sales
West
100
West
200
East
300
Ak použijeme agregáciu:
SELECT region, SUM(sales)
FROM orders
GROUP BY region;
výsledok obsahuje iba jeden riadok pre každý región.
Ak však použijeme window function:
SELECT
    region,
    sales,
    SUM(sales) OVER (PARTITION BY region) AS region_sales
FROM orders;
jednotlivé objednávky zostanú zachované a ku každej sa doplní celkový predaj príslušného regiónu.
region
sales
region_sales
West
100
300
West
200
300
East
300
300
💡 Dôležité: GROUP BY znižuje počet riadkov. Window function počet riadkov nemení – iba ku každému riadku dopĺňa vypočítanú hodnotu.
Základná syntax
Window function používa klauzulu OVER().
function_name(...) OVER (
    PARTITION BY ...
    ORDER BY ...
)
Nie každá window function potrebuje PARTITION BY alebo ORDER BY. Ich použitie závisí od typu výpočtu.
OVER()
OVER() určuje, nad akou množinou riadkov sa má daná funkcia vyhodnotiť.
Napríklad:
SUM(sales) OVER ()
znamená, že súčet sa vypočíta nad všetkými riadkami výsledku.
Ak teda použijeme:
SELECT
    order_id,
    sales,
    SUM(sales) OVER () AS total_sales
FROM orders;
každý riadok bude obsahovať svoju vlastnú hodnotu sales a zároveň celkový predaj celej tabuľky.
PARTITION BY
PARTITION BY rozdelí riadky do samostatných skupín. Window function sa potom vypočíta samostatne v každej skupine.
SUM(sales) OVER (
    PARTITION BY region
)
V tomto prípade sa celkový predaj vypočíta samostatne pre každý región.
Pri zmene hodnoty region vzniká nové okno výpočtu.
ORDER BY vo window function
ORDER BY vo vnútri OVER() určuje poradie riadkov, v ktorom sa má window function vyhodnocovať.
Je nevyhnutné napríklad pri funkciách:
ROW_NUMBER(),
RANK(),
DENSE_RANK(),
LAG(),
LEAD().
⚠️ Pozor: ORDER BY vo vnútri OVER() určuje spôsob výpočtu window function. Nezaručuje automaticky poradie výsledných riadkov. Na finálne zoradenie výsledku použite ORDER BY hlavného dotazu.
Najčastejšie window functions
ROW_NUMBER()
Priradí každému riadku poradové číslo.
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY sale_date DESC
)
Typické použitie: posledná objednávka zákazníka, prvý záznam v skupine, odstránenie duplicít.
RANK()
Priradí poradie podľa zvolenej hodnoty. Pri rovnakých hodnotách dostanú riadky rovnaké poradie a nasledujúce poradie sa preskočí.
RANK() OVER (
    PARTITION BY product_category
    ORDER BY total_sales DESC
)
DENSE_RANK()
Funguje podobne ako RANK(), ale po rovnakých hodnotách nepreskakuje ďalšie poradové číslo.
sales
ROW_NUMBER()
RANK()
DENSE_RANK()
1000
1
1
1
900
2
2
2
900
3
2
2
700
4
4
3
LAG()
Sprístupní hodnotu z predchádzajúceho riadku podľa definovaného poradia.
LAG(sales) OVER (
    ORDER BY order_date
)
Typické použitie: porovnanie aktuálneho mesiaca s predchádzajúcim.
LEAD()
Funguje podobne ako LAG(), ale pristupuje k nasledujúcemu riadku.
Agregačné funkcie ako window functions
Aj bežné agregačné funkcie môžeme použiť ako window functions:
SUM(),
AVG(),
MIN(),
MAX(),
COUNT().
Napríklad:
SELECT
    customer_type,
    revenue,
    SUM(revenue) OVER () AS total_revenue
FROM type_revenue;
Každý riadok si zachová svoju hodnotu revenue, ale zároveň bude obsahovať súčet revenue všetkých riadkov.
Kumulatívny súčet
Window functions sa často používajú aj na výpočet priebežných alebo kumulatívnych hodnôt.
SUM(revenue) OVER (
    ORDER BY month
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
) AS cumulative_revenue
Výsledok pri každom mesiaci obsahuje súčet aktuálneho mesiaca a všetkých predchádzajúcich mesiacov.
Window frame
Pri niektorých window functions môžeme presnejšie určiť, ktoré riadky v rámci okna majú byť zahrnuté do výpočtu.
Napríklad:
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
znamená:
začni prvým riadkom v danom okne,
pokračuj až po aktuálny riadok.
Takto vzniká napríklad kumulatívny súčet.
Kde sa window functions používajú?
Top N produktov v každej kategórii,
poradie zákazníkov podľa predaja,
posledná alebo prvá objednávka zákazníka,
porovnanie aktuálneho obdobia s predchádzajúcim,
výpočet percentuálneho podielu na celku,
kumulatívne súčty,
moving average a ďalšie časové analýzy,
analytické a ETL transformácie.
⚠️ Nezabudnite: Window function nevytvára samostatnú agregovanú tabuľku ako GROUP BY. Výpočet sa vykoná nad definovaným oknom, ale jednotlivé riadky zostávajú vo výsledku zachované.

---

## Strana 2 / 17 — Otázka 1

### 💻 Úloha 1 – Príprava dát pre window functions

💻 Úloha 1 – Príprava dát pre window functions
V tejto časti budete pracovať s novou databázou retail, ktorá obsahuje údaje o faktúrach, produktoch, zákazníkoch a predaji.
Najskôr pripravte databázu a tabuľku, do ktorej následne importujete poskytnuté dáta.
1. Vytvorte databázu
Vo VS Code vytvorte SQL skript a pomocou príkazu CREATE DATABASE vytvorte databázu s názvom:
retail
Po vytvorení databázy sa k nej pripojte a ďalšie SQL príkazy vykonávajte už v tejto databáze.
2. Vytvorte tabuľku retail_sales
Tabuľka bude obsahovať údaje o jednotlivých položkách faktúr. Vytvorte ju podľa nasledujúcej štruktúry:
invoice_no – text s maximálnou dĺžkou 20 znakov,
stock_code – text s maximálnou dĺžkou 50 znakov,
description – text,
quantity – celé číslo,
invoice_date – dátum a čas vystavenia faktúry,
unit_price – číselná hodnota s maximálne 10 číslicami, z toho 2 desatinnými miestami,
customer_id – celé číslo,
country – text s maximálnou dĺžkou 100 znakov.
3. Stiahnite dátový súbor
Pre tabuľku retail_sales je pripravený CSV súbor:
online_retail.csv
Stiahnutý súbor uložte aj do svojho Git repozitára, aby boli SQL skripty aj zdrojové dáta súčasťou vášho pracovného projektu.
4. Importujte dáta pomocou pgAdmin
Po úspešnom vytvorení tabuľky importujte pripravený CSV súbor do tabuľky retail_sales pomocou nástroja Import/Export Data v prostredí pgAdmin.
Pri importe skontrolujte:
správnu databázu a cieľovú tabuľku,
formát súboru CSV,
zapnutú možnosť Header, pretože prvý riadok obsahuje názvy stĺpcov,
oddeľovač nastavený na bodkočiarku ;,
zhodu poradia stĺpcov v CSV súbore s vytvorenou tabuľkou.
5. Overte importované dáta
Po importe skontrolujte, či sa údaje načítali správne:
SELECT *
FROM retail_sales;
⚠️ Nezabudnite: SQL príkaz na vytvorenie tabuľky aj stiahnutý CSV súbor uložte do svojho Git repozitára a po dokončení vykonajte commit a push.

> **Zadaná odpoveď:** `Vlastny SQL skript (CREATE DATABASE retail, CREATE TABLE retail_sales, import online_retail.csv cez pgAdmin)`

---

## Strana 3 / 17 — Informácia

### 📘 Window frame – ROWS a RANGE

📘 Window frame – ROWS a RANGE
Pri window functions môžeme pomocou tzv. window frame určiť, ktoré riadky z aktuálneho okna sa majú zahrnúť do výpočtu. Rámec sa zapisuje v časti OVER() a najčastejšie sa pri jeho definovaní používajú možnosti ROWS a RANGE.
Všeobecná syntax:
aggregate_function(column) OVER (
    PARTITION BY column
    ORDER BY column
    ROWS | RANGE BETWEEN ...
               AND ...
)
ROWS určuje rámec podľa počtu riadkov vzhľadom na aktuálny riadok. Napríklad:
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
Takýto rámec zahrnie do výpočtu:
aktuálny riadok,
jeden predchádzajúci riadok,
dva riadky pred aktuálnym riadkom.
Pri použití ROWS teda nezáleží na tom, aký časový alebo číselný rozdiel je medzi jednotlivými záznamami. Rozhodujúca je ich pozícia vo výsledku.
RANGE naopak určuje rámec podľa hodnoty stĺpca použitého v ORDER BY. Pri dátumoch alebo časových údajoch môžeme pomocou neho vytvoriť napríklad časové okno:
RANGE BETWEEN INTERVAL '14 days' PRECEDING
      AND CURRENT ROW
Takýto rámec zahrnie všetky záznamy, ktorých hodnota dátumu alebo času patrí do obdobia 14 dní pred aktuálnym záznamom až po aktuálny záznam.
Počet zahrnutých riadkov preto nemusí byť vždy rovnaký. Ak má zákazník počas tohto obdobia 3 záznamy, do výpočtu sa zahrnú 3. Ak ich má 20, zahrnie sa všetkých 20.
Rozdiel medzi oboma spôsobmi možno zjednodušene chápať takto:
ROWS – pracuje s počtom riadkov,
RANGE – pracuje s rozsahom hodnôt podľa ORDER BY.
💡 Dôležité: Ak chceme vypočítať napríklad súčet za posledné 3 záznamy, je vhodné použiť ROWS. Ak však chceme vypočítať súčet za posledných 14 dní, použijeme RANGE, pretože nás zaujíma časové obdobie, nie pevný počet záznamov.

---

## Strana 4 / 17 — Otázka 2

### 💻 Úloha 2 – Tržby zákazníka za posledných 14 dní

💻 Úloha 2 – Tržby zákazníka za posledných 14 dní
V tejto úlohe pracujte s tabuľkou retail_sales, ktorú ste vytvorili a naplnili údajmi v predchádzajúcej úlohe.
Vytvorte SQL dotaz, ktorý pre každý záznam vypočíta tržbu a zároveň zobrazí súčet tržieb daného zákazníka za posledných 14 dní vzhľadom na dátum aktuálneho riadku.
Tržbu pre jeden riadok vypočítajte ako:
quantity * unit_price
Vo výsledku zobrazte:
identifikátor zákazníka,
číslo faktúry,
dátum a čas faktúry,
množstvo,
jednotkovú cenu,
tržbu aktuálneho riadku ako revenue,
súčet tržieb za posledných 14 dní ako revenue_last_14_days.
Do výsledku zahrňte iba záznamy, pri ktorých je customer_id vyplnené.
Na výpočet tržieb za posledných 14 dní použite window function SUM() a vytvorte časové okno samostatne pre každého zákazníka.
Výsledok zoraďte podľa identifikátora zákazníka a dátumu faktúry.
Ktorá z nasledujúcich možností správne zodpovedá prvým trom riadkom výsledku?
💡 Pomôcka: Použite PARTITION BY customer_id a záznamy vo window function zoraďte podľa invoice_date. Keďže potrebujete zahrnúť všetky záznamy z časového obdobia posledných 14 dní, použite rámec RANGE s intervalom INTERVAL '14 days' PRECEDING až po aktuálny riadok.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.
customer_id
invoice_no
invoice_date
quantity
unit_price
revenue
revenue_last_14_days
12346
541431
2011-01-18 10:01:00
74215
1.04
77183.60
0.00
12346
C541433
2011-01-18 10:17:00
-74215
1.04
-77183.60
-77183.60
12347
537626
2010-12-07 14:57:00
36
0.65
23.40
23.40
- **b)** b.
customer_id
invoice_no
invoice_date
quantity
unit_price
revenue
revenue_last_14_days
12346
541431
2011-01-18 10:01:00
74215
1.04
77183.60
77183.60
12346
C541433
2011-01-18 10:17:00
-74215
1.04
-77183.60
77183.60
12347
537626
2010-12-07 14:57:00
36
0.65
23.40
23.40
- **c)** c.
customer_id
invoice_no
invoice_date
quantity
unit_price
revenue
revenue_last_14_days
12346
541431
2011-01-18 10:01:00
74215
1.04
77183.60
77183.60
12346
C541433
2011-01-18 10:17:00
-74215
1.04
-77183.60
0.00
12347
537626
2010-12-07 14:57:00
36
0.65
23.40
711.79

> **Zadaná odpoveď:** `2 (moznost b)`

---

## Strana 5 / 17 — Otázka 3

### 💻 Úloha 3 – Priemerné množstvo predaja za posledných 7 dní

💻 Úloha 3 – Priemerné množstvo predaja za posledných 7 dní
V tejto úlohe pracujte s tabuľkou retail_sales, ktorú ste vytvorili a naplnili údajmi v predchádzajúcich úlohách.
Vytvorte SQL dotaz, ktorý pre každý záznam vypočíta priemerné predané množstvo produktu za posledných 7 dní vzhľadom na dátum aktuálnej faktúry.
Priemer počítajte vždy samostatne pre kombináciu:
produktu – stock_code,
krajiny – country.
Na výpočet použite window function AVG() a časové okno, ktoré zahrnie všetky záznamy z obdobia 7 dní pred aktuálnym záznamom až po aktuálny záznam.
Keďže v tejto úlohe potrebujete pracovať s konkrétnym časovým intervalom, použite rámec RANGE, nie ROWS.
Do výpočtu zahrňte iba záznamy, pri ktorých je hodnota quantity väčšia ako 1.
Vo výsledku zobrazte:
kód produktu,
krajinu,
dátum a čas faktúry,
predané množstvo,
priemerné množstvo za posledných 7 dní ako avg_quantity_7_days.
Výsledný priemer zaokrúhlite na dve desatinné miesta a výsledok zoraďte podľa produktu, krajiny a dátumu faktúry.
Akú hodnotu má avg_quantity_7_days pre prvý záznam produktu 10002 v krajine EIRE? Do odpovede zadajte iba číselnú hodnotu zaokrúhlenú na dve desatinné miesta.
💡 Pomôcka: V časti PARTITION BY použite kombináciu produktu a krajiny. Záznamy vo window function zoraďte podľa invoice_date a vytvorte rámec od INTERVAL '7 days' PRECEDING po aktuálny riadok. Pri RANGE sa do výpočtu zahrnú všetky záznamy patriace do daného časového intervalu, bez ohľadu na ich počet.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `12.00`

---

## Strana 6 / 17 — Informácia

### 📘 Window functions LAG() a LEAD()

📘 Window functions LAG() a LEAD()
Funkcie LAG() a LEAD() umožňujú pristupovať k hodnotám z predchádzajúcich alebo nasledujúcich riadkov bez toho, aby bolo potrebné tabuľku spájať samu so sebou.
Poradie riadkov, medzi ktorými sa funkcia pohybuje, určuje časť ORDER BY vo vnútri OVER().
Všeobecná syntax:
LAG(column, offset) OVER (
    PARTITION BY column
    ORDER BY column
)
LEAD(column, offset) OVER (
    PARTITION BY column
    ORDER BY column
)
LAG() vráti hodnotu z riadku, ktorý sa nachádza pred aktuálnym riadkom.
Napríklad:
LAG(monthly_sales, 1) OVER (
    ORDER BY month
)
Tento zápis znamená: pre aktuálny mesiac vráť hodnotu monthly_sales z predchádzajúceho riadku. Ak sú mesiace zoradené chronologicky, výsledkom bude predaj za predchádzajúci mesiac.
LEAD() funguje opačne – vráti hodnotu z riadku, ktorý sa nachádza za aktuálnym riadkom.
Napríklad:
LEAD(monthly_sales, 1) OVER (
    ORDER BY month
)
Tento zápis vráti hodnotu predaja z nasledujúceho mesiaca.
Druhý parameter funkcie určuje, o koľko riadkov sa má funkcia posunúť:
LAG(value, 1) – jeden riadok späť,
LAG(value, 2) – dva riadky späť,
LEAD(value, 1) – jeden riadok dopredu.
Ak parameter posunu neuvediete, predvolená hodnota je 1.
Ak používate PARTITION BY, funkcie sa pohybujú iba v rámci príslušnej skupiny. Napríklad:
LAG(sales) OVER (
    PARTITION BY customer_id
    ORDER BY order_date
)
V tomto prípade sa predchádzajúca hodnota hľadá iba medzi objednávkami rovnakého zákazníka. Pri prechode na ďalšieho zákazníka sa výpočet začne nanovo.
Funkcie LAG() a LEAD() sa často používajú napríklad na:
porovnanie aktuálnej hodnoty s predchádzajúcim obdobím,
výpočet medzimesačného alebo medziročného rastu,
sledovanie zmien cien alebo predaja,
porovnanie predchádzajúcej a nasledujúcej udalosti zákazníka.
💡 Dôležité: Funkcie LAG() a LEAD() nemenia počet riadkov vo výsledku. Ku každému riadku iba doplnia hodnotu z iného riadku podľa poradia definovaného v OVER(). Ak predchádzajúci alebo nasledujúci riadok neexistuje, výsledkom je NULL.

---

## Strana 7 / 17 — Otázka 4

### 💻 Úloha 4 – Počet dní do nasledujúcej objednávky zákazníka

💻 Úloha 4 – Počet dní do nasledujúcej objednávky zákazníka
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý pre každú objednávku zákazníka zistí dátum jeho nasledujúcej objednávky a následne vypočíta, koľko dní medzi týmito dvoma objednávkami uplynulo.
Keďže tabuľka môže obsahovať viacero riadkov patriacich k rovnakej faktúre, najskôr si pripravte zoznam jedinečných objednávok obsahujúci:
identifikátor zákazníka,
číslo faktúry,
dátum objednávky.
Na získanie dátumu nasledujúcej objednávky použite window function LEAD(). Objednávky musia byť vyhodnocované samostatne pre každého zákazníka a chronologicky zoradené podľa dátumu objednávky.
Vo výsledku zobrazte:
customer_id,
invoice_no,
invoice_date,
next_invoice_date,
days_to_next_invoice.
Do výsledku zahrňte iba objednávky, pri ktorých existuje ďalšia objednávka rovnakého zákazníka. Výsledok následne zoraďte podľa počtu dní do nasledujúcej objednávky od najvyššej hodnoty po najnižšiu.
Vyzerajú prvé riadky správneho výsledku nasledovne:
customer_id
invoice_no
invoice_date
next_invoice_date
days_to_next_invoice
13305
536671
2010-12-02
2011-02-17
77
17567
536782
2010-12-02
2011-02-16
76
16098
536382
2010-12-01
2011-02-14
75
13941
C537024
2010-12-03
2011-02-15
74
💡 Pomôcka: Použite PARTITION BY customer_id a vo vnútri OVER() zoraďte objednávky podľa dátumu. Funkcia LEAD() vám umožní získať dátum nasledujúcej objednávky rovnakého zákazníka. Rozdiel dvoch hodnôt typu DATE v PostgreSQL vráti počet dní medzi nimi.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** 
- **b)** 

> **Zadaná odpoveď:** `1 (Pravda)`

---

## Strana 8 / 17 — Otázka 5

### 💻 Úloha 5 – Zmena ceny produktu oproti predchádzajúcej hodnote

💻 Úloha 5 – Zmena ceny produktu oproti predchádzajúcej hodnote
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý pre každý produkt porovná jeho aktuálnu jednotkovú cenu s predchádzajúcou zaznamenanou cenou.
Na získanie predchádzajúcej ceny použite window function LAG(). Porovnanie vykonávajte samostatne pre každý produkt a záznamy zoraďte chronologicky podľa dátumu faktúry.
Vo výsledku zobrazte:
kód produktu,
číslo faktúry,
dátum a čas faktúry,
predchádzajúcu cenu ako previous_price,
aktuálnu cenu ako current_price,
rozdiel medzi aktuálnou a predchádzajúcou cenou ako price_difference.
Do výsledku zahrňte iba záznamy, pri ktorých predchádzajúca cena existuje a zároveň sa aktuálna cena od predchádzajúcej ceny líši.
Rozdiel vypočítajte podľa vzťahu:
current_price - previous_price
Výsledok zoraďte podľa dátumu faktúry vzostupne.
Presuňte správne hodnoty do stĺpca price_difference podľa výsledku vášho SQL dotazu.
stock_code
invoice_no
previous_price
current_price
price_difference
22086
536381
2.55
2.95
 Blank 1 Otázka 5
22783
536382
16.95
19.95
 Blank 2 Otázka 5
85099C
536386
1.95
1.65
 Blank 3 Otázka 5
21731
536387
1.65
1.25
 Blank 4 Otázka 5
21523
536388
6.75
7.95
 Blank 5 Otázka 5
💡 Pomôcka: Funkciu LAG() použite s PARTITION BY stock_code. Tak zabezpečíte, že predchádzajúca cena bude vždy patriť rovnakému produktu.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti na presunutie (drag & drop):**

  0.40, -0.30, 1.20, -0.40, 3.00

> **Zadaná odpoveď:** `Blank1=0.40, Blank2=3.00, Blank3=-0.30, Blank4=-0.40, Blank5=1.20`

---

## Strana 9 / 17 — Informácia

### 📘 Window function NTILE()

📘 Window function NTILE()
Funkcia NTILE() rozdelí zoradené riadky výsledku do zadaného počtu približne rovnako veľkých skupín.
Každému riadku následne priradí číslo skupiny od 1 až po zadaný počet skupín.
Všeobecná syntax:
NTILE(number_of_groups) OVER (
    PARTITION BY column
    ORDER BY column
)
Napríklad:
NTILE(4) OVER (
    ORDER BY total_sales DESC
)
Tento zápis rozdelí všetky riadky do štyroch skupín. Ak sú hodnoty zoradené podľa predaja zostupne, jednotlivé skupiny možno interpretovať napríklad ako kvartily:
1. skupina – zákazníci s najvyšším predajom,
2. skupina – ďalšia časť zákazníkov podľa výšky predaja,
3. skupina – zákazníci s nižším predajom,
4. skupina – zákazníci s najnižším predajom.
Argument funkcie určuje počet skupín. Napríklad:
NTILE(2) – rozdelenie do 2 skupín,
NTILE(4) – rozdelenie do 4 skupín,
NTILE(10) – rozdelenie do 10 skupín.
Ak počet riadkov nie je presne deliteľný počtom skupín, skupiny nemusia mať úplne rovnaký počet riadkov. PostgreSQL rozdelí riadky čo najrovnomernejšie a väčšie skupiny budú pridelené ako prvé.
Napríklad pri 10 riadkoch a použití NTILE(4) môžu mať jednotlivé skupiny veľkosť:
Skupina 1 → 3 riadky
Skupina 2 → 3 riadky
Skupina 3 → 2 riadky
Skupina 4 → 2 riadky
Ak použijete PARTITION BY, rozdelenie do skupín sa vykoná samostatne v rámci každej partition.
NTILE(4) OVER (
    PARTITION BY region
    ORDER BY total_sales DESC
)
V tomto prípade by sa zákazníci rozdelili do štyroch skupín samostatne v každom regióne.
Funkcia NTILE() sa často používa napríklad na:
rozdelenie zákazníkov podľa hodnoty predaja alebo obratu,
vytváranie kvartilov, decilov alebo iných segmentov,
segmentáciu produktov podľa výkonu,
rozdelenie výsledkov do výkonnostných skupín.
💡 Dôležité: Funkcia NTILE() nerozdeľuje riadky podľa konkrétnych hraníc hodnôt, ale podľa ich poradia. Hodnota použitá v ORDER BY preto určuje, ktoré riadky sa dostanú do jednotlivých skupín.

---

## Strana 10 / 17 — Otázka 6

### 💻 Úloha 6 – Rozdelenie zákazníkov do kvartilov podľa celkového predaja

💻 Úloha 6 – Rozdelenie zákazníkov do kvartilov podľa celkového predaja
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý najskôr pre každého zákazníka vypočíta jeho celkovú hodnotu predaja a následne zákazníkov rozdelí do štyroch kvartilov podľa tejto hodnoty.
Celkovú hodnotu predaja zákazníka vypočítajte ako súčet:
quantity * unit_price
Do výpočtu zahrňte iba záznamy, pri ktorých je customer_id vyplnené.
Po vypočítaní celkového predaja každého zákazníka použite window function NTILE(4), ktorá rozdelí zákazníkov do štyroch približne rovnako veľkých skupín.
Zákazníkov pri rozdeľovaní zoraďte podľa celkového predaja od najvyššej hodnoty po najnižšiu.
Vo výsledku zobrazte:
identifikátor zákazníka,
celkovú hodnotu jeho predaja ako total_amount,
číslo kvartilu ako sales_quartile.
Výsledok zoraďte podľa celkového predaja zostupne.
Koľko záznamov vrátil váš SQL dotaz? Do odpovede zadajte iba počet.
💡 Pomôcka: Najskôr si pomocou CTE alebo vnoreného dotazu pripravte jeden riadok pre každého zákazníka s jeho celkovým predajom. Až nad týmto výsledkom použite NTILE(4). Pri zoradení podľa total_amount DESC budú zákazníci s najvyšším predajom patriť do prvého kvartilu.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `1583`

---

## Strana 11 / 17 — Otázka 7

### 💻 Úloha 7 – Kvartily mesačného predaja podľa krajiny

💻 Úloha 7 – Kvartily mesačného predaja podľa krajiny
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý najskôr vypočíta celkový predaj za každý mesiac v každej krajine a následne pomocou window function NTILE(4) rozdelí mesiace do štyroch skupín podľa výšky predaja.
Mesačný predaj vypočítajte ako súčet:
quantity * unit_price
Pri rozdeľovaní do kvartilov musí byť poradie vytvorené samostatne pre každú krajinu. Mesiace s najvyšším predajom majú dostať najnižšie číslo kvartilu.
Vo výsledku zobrazte:
krajinu,
mesiac,
celkový mesačný predaj ako total_amount,
číslo kvartilu ako sales_quartile.
Výsledok zoraďte podľa krajiny a mesiaca vzostupne.
Doplňte správne hodnoty do stĺpca sales_quartile podľa výsledku vášho SQL dotazu:
country
month
total_amount
sales_quartile
Australia
2010-12-01
1005.10
 Blank 1 Otázka 7
Australia
2011-01-01
9017.71
 Blank 2 Otázka 7
Australia
2011-02-01
14214.92
 Blank 3 Otázka 7
Austria
2010-12-01
257.04
 Blank 4 Otázka 7
Austria
2011-02-01
518.36
 Blank 5 Otázka 7
💡 Pomôcka: Najskôr si pripravte mesačný predaj pre každú krajinu. Následne použite NTILE(4) s PARTITION BY country a zoradením podľa total_amount DESC. Číslovanie kvartilov sa začne od 1 nanovo pre každú krajinu.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti na presunutie (drag & drop):**

  3, 1, 2

> **Zadaná odpoveď:** `Blank1=3, Blank2=2, Blank3=1, Blank4=2, Blank5=1`

---

## Strana 12 / 17 — Informácia

### 📘 Window function ROW_NUMBER()

📘 Window function ROW_NUMBER()
Funkcia ROW_NUMBER() priradí každému riadku vo výsledku jedinečné poradové číslo podľa poradia definovaného v časti ORDER BY vo vnútri OVER().
Číslovanie začína hodnotou 1 a pokračuje po jednom pre každý ďalší riadok.
Všeobecná syntax:
ROW_NUMBER() OVER (
    PARTITION BY column
    ORDER BY column
)
Napríklad:
ROW_NUMBER() OVER (
    ORDER BY order_date DESC
)
Tento zápis zoradí riadky podľa dátumu objednávky od najnovšej po najstaršiu a následne im priradí poradové čísla:
1 → najnovšia objednávka
2 → druhá najnovšia objednávka
3 → tretia najnovšia objednávka
...
Ak použijete PARTITION BY, číslovanie sa začne od hodnoty 1 samostatne pre každú skupinu.
Napríklad:
ROW_NUMBER() OVER (
    PARTITION BY customer_id
    ORDER BY order_date DESC
)
V tomto prípade sa objednávky zoradia samostatne pre každého zákazníka. Najnovšia objednávka každého zákazníka dostane číslo 1, druhá najnovšia číslo 2 a podobne.
Takéto číslovanie je vhodné napríklad vtedy, keď chceme následne vybrať:
najnovšiu objednávku každého zákazníka,
posledné dve alebo tri objednávky každého zákazníka,
najdrahší produkt v každej kategórii,
prvých niekoľko záznamov v každej skupine.
Ak chceme napríklad ponechať iba dve najnovšie objednávky každého zákazníka, môžeme najskôr vytvoriť poradové číslo a následne vo vonkajšom dotaze vybrať iba riadky s poradím 1 a 2.
💡 Dôležité: Funkcia ROW_NUMBER() vždy priradí každému riadku iné poradové číslo. Aj keď majú dva riadky rovnakú hodnotu v stĺpci použitom v ORDER BY, budú mať rozdielne poradové čísla. Ak potrebujete, aby riadky s rovnakou hodnotou mali rovnaké poradie, použite skôr RANK() alebo DENSE_RANK().

---

## Strana 13 / 17 — Otázka 8

### 💻 Úloha 8 – Prvý nákup každého zákazníka

💻 Úloha 8 – Prvý nákup každého zákazníka
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý pre každého zákazníka zobrazí jeho prvý zaznamenaný nákup.
Na určenie prvého nákupu použite window function ROW_NUMBER(). Číslovanie musí začínať od hodnoty 1 samostatne pre každého zákazníka a záznamy musia byť zoradené od najstaršej faktúry po najnovšiu.
Vo výsledku zobrazte:
identifikátor zákazníka,
číslo faktúry,
dátum a čas faktúry,
kód produktu,
popis produktu,
množstvo,
jednotkovú cenu.
Do výsledku zahrňte iba riadok s poradím 1 pre každého zákazníka a výsledok zoraďte podľa identifikátora zákazníka vzostupne.
Ktorá z nasledujúcich možností správne zodpovedá prvým piatim riadkom výsledku?
💡 Pomôcka: Použite PARTITION BY customer_id a vo vnútri OVER() zoraďte záznamy podľa invoice_date vzostupne. Následne ponechajte iba riadky s poradím 1.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.
customer_id
invoice_no
invoice_date
stock_code
quantity
unit_price
12346
C541433
2011-01-18 10:17:00
23166
-74215
1.04
12347
537626
2010-12-07 14:57:00
22727
4
3.75
12348
539318
2010-12-16 19:09:00
21977
24
0.55
12350
543037
2011-02-02 16:01:00
22348
24
0.85
12352
544156
2011-02-16 12:33:00
21754
3
5.95
- **b)** b.
customer_id
invoice_no
invoice_date
stock_code
quantity
unit_price
12346
541431
2011-01-18 10:01:00
23166
74215
1.04
12347
537626
2010-12-07 14:57:00
22727
4
3.75
12348
539318
2010-12-16 19:09:00
21977
24
0.55
12350
543037
2011-02-02 16:01:00
22348
12
0.85
12352
544156
2011-02-16 12:33:00
21754
3
5.95
- **c)** c.
customer_id
invoice_no
invoice_date
stock_code
description
quantity
unit_price
12346
541431
2011-01-18 10:01:00
23166
MEDIUM CERAMIC TOP STORAGE JAR
74215
1.04
12347
537626
2010-12-07 14:57:00
22727
ALARM CLOCK BAKELIKE RED
4
3.75
12348
539318
2010-12-16 19:09:00
21977
PACK OF 60 PINK PAISLEY CAKE CASES
24
0.55
12350
543037
2011-02-02 16:01:00
22348
TEA BAG PLATE RED RETROSPOT
24
0.85
12352
544156
2011-02-16 12:33:00
21754
HOME BUILDING BLOCK WORD
3
5.95

> **Zadaná odpoveď:** `2 (moznost c)`

---

## Strana 14 / 17 — Otázka 9

### 💻 Úloha 9 – Tri najhodnotnejšie položky každej faktúry

💻 Úloha 9 – Tri najhodnotnejšie položky každej faktúry
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý pre každú faktúru určí tri položky s najvyššou hodnotou predaja.
Hodnotu položky vypočítajte ako:
quantity * unit_price
Na určenie poradia položiek použite window function ROW_NUMBER(). Číslovanie musí začínať od hodnoty 1 samostatne pre každú faktúru a položky musia byť zoradené podľa hodnoty predaja od najvyššej po najnižšiu.
Vo výsledku zobrazte:
číslo faktúry,
kód produktu,
popis produktu,
množstvo,
jednotkovú cenu,
hodnotu položky ako amount,
poradie položky ako row_num.
Do výsledku ponechajte iba prvé tri položky každej faktúry a výsledok zoraďte podľa čísla faktúry a poradia položky.
Akú hodnotu row_num má produkt 22632 vo faktúre 536366? Do odpovede zadajte iba číslo.
💡 Pomôcka: Použite PARTITION BY invoice_no a vo vnútri OVER() zoraďte položky podľa hodnoty quantity * unit_price DESC. Následne ponechajte iba riadky s poradím 1 až 3.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `2`

---

## Strana 15 / 17 — Informácia

### 📘 Window functions RANK() a DENSE_RANK()

📘 Window functions RANK() a DENSE_RANK()
Funkcie RANK() a DENSE_RANK() slúžia na určenie poradia riadkov podľa zvolenej hodnoty. Na rozdiel od ROW_NUMBER() dokážu zohľadniť situáciu, keď majú viaceré riadky rovnakú hodnotu.
Všeobecná syntax:
RANK() OVER (
    PARTITION BY column
    ORDER BY column
)
DENSE_RANK() OVER (
    PARTITION BY column
    ORDER BY column
)
Poradie určuje časť ORDER BY vo vnútri OVER(). Ak napríklad zoradíme zákazníkov podľa celkového zisku zostupne, zákazník s najvyšším ziskom dostane poradie 1.
Napríklad:
RANK() OVER (
    ORDER BY total_profit DESC
)
Ak majú všetky hodnoty rozdielny zisk, výsledok funkcií RANK() a DENSE_RANK() bude rovnaký. Rozdiel medzi nimi sa prejaví až pri zhodných hodnotách.
Predstavme si nasledujúce hodnoty:
total_profit
RANK()
DENSE_RANK()
500
1
1
400
2
2
400
2
2
300
4
3
Obidve funkcie priradia rovnaké poradie riadkom s rovnakou hodnotou. Rozdiel je v tom, aké číslo nasleduje po zhode.
RANK() po zhode preskočí nasledujúce poradové čísla. Ak sa dve hodnoty umiestnia na 2. mieste, ďalší riadok dostane poradie 4.
DENSE_RANK() poradie nepreskakuje. Po dvoch hodnotách s poradím 2 nasleduje poradie 3.
Ak použijete PARTITION BY, poradie sa počíta samostatne pre každú skupinu.
Napríklad:
RANK() OVER (
    PARTITION BY region
    ORDER BY total_profit DESC
)
V tomto prípade sa zákazníci zoradia podľa zisku samostatne v každom regióne. Najziskovejší zákazník každého regiónu preto dostane poradie 1.
Funkcie RANK() a DENSE_RANK() sa používajú napríklad na:
zoradenie zákazníkov podľa obratu alebo zisku,
určenie najpredávanejších produktov v jednotlivých kategóriách,
porovnanie výkonu v rámci regiónov alebo oddelení,
výber najlepších hodnôt v jednotlivých skupinách.
💡 Dôležité: Pri zhodných hodnotách priradia RANK() aj DENSE_RANK() rovnaké poradie. Rozdiel je v ďalšom poradovom čísle: RANK() môže vytvoriť medzeru v poradí, zatiaľ čo DENSE_RANK() vytvára súvislé poradie bez medzier.

---

## Strana 16 / 17 — Otázka 10

### 💻 Úloha 10 – Poradie zákazníkov podľa mesačného predaja

💻 Úloha 10 – Poradie zákazníkov podľa mesačného predaja
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý najskôr vypočíta celkový predaj každého zákazníka za jednotlivé mesiace v každej krajine a následne určí jeho poradie podľa výšky predaja.
Na určenie poradia použite window function DENSE_RANK(). Poradie sa musí počítať samostatne pre každú kombináciu krajiny a mesiaca.
Zákazníkov zoraďte podľa celkového predaja od najvyššej hodnoty po najnižšiu a vo výsledku ponechajte iba zákazníkov s poradím 1 až 5.
Vo výsledku zobrazte:
krajinu,
mesiac,
identifikátor zákazníka,
celkový mesačný predaj zákazníka ako total_amount,
poradie zákazníka ako sales_rank.
Výsledok zoraďte podľa krajiny, mesiaca, poradia a identifikátora zákazníka.
Presuňte správne hodnoty do stĺpca sales_rank podľa výsledku vášho SQL dotazu:
country
month
customer_id
total_amount
sales_rank
Australia
2011-01-01
12393
639.50
 Blank 1 Otázka 10
Australia
2011-01-01
12388
431.30
 Blank 2 Otázka 10
Australia
2011-01-01
12431
384.68
 Blank 3 Otázka 10
Australia
2011-01-01
12422
238.50
 Blank 4 Otázka 10
Australia
2011-02-01
12415
14022.92
 Blank 5 Otázka 10
💡 Pomôcka: Najskôr si pripravte mesačný predaj každého zákazníka. Následne použite DENSE_RANK() s PARTITION BY country, month a zoradením podľa total_amount DESC.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti na presunutie (drag & drop):**

  3, 4, 1, 5, 2

> **Zadaná odpoveď:** `Blank1=2, Blank2=3, Blank3=4, Blank4=5, Blank5=1`

---

## Strana 17 / 17 — Otázka 11

### 💻 Úloha 11 – Päť najvyšších cien na každej faktúre

💻 Úloha 11 – Päť najvyšších cien na každej faktúre
V tejto úlohe pracujte s tabuľkou retail_sales.
Vytvorte SQL dotaz, ktorý pre každú faktúru určí poradie položiek podľa jednotkovej ceny od najvyššej po najnižšiu.
Na určenie poradia použite window function DENSE_RANK(). Poradie sa musí začínať od hodnoty 1 samostatne pre každú faktúru.
Vo výsledku zobrazte:
číslo faktúry,
kód produktu,
popis produktu,
množstvo,
jednotkovú cenu,
poradie podľa ceny ako price_rank.
Do výsledku ponechajte iba položky s poradím 1 až 5 a výsledok zoraďte podľa čísla faktúry, poradia a kódu produktu.
Koľko záznamov vrátil váš SQL dotaz? Do odpovede zadajte iba počet.
💡 Pomôcka: Použite PARTITION BY invoice_no a vo vnútri OVER() zoraďte položky podľa unit_price DESC. Keďže používate DENSE_RANK(), viaceré položky s rovnakou cenou môžu dostať rovnaké poradie.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre window functions a po dokončení vykonajte commit a push do Git repozitára.

> **Zadaná odpoveď:** `25727`

---
