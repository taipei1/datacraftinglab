# Seminár 3 – Zadanie 1b (CTE, window functions, WITH RECURSIVE)

Zdroj: UKF Moodle, pokus o test `attempt=564335&cmid=289626`.
Uložené: 2026-10-11. Strán spolu: 11.

---

## Strana 1 / 11 — Informácia

### 📘 Common Table Expressions – CTE

📘 Common Table Expressions – CTE
Common Table Expression alebo skrátene CTE je dočasný pomenovaný výsledok SQL dotazu, ktorý možno použiť v rámci jedného nasledujúceho SQL príkazu.
CTE vytvárame pomocou kľúčového slova WITH. Výsledok CTE sa správa podobne ako dočasná tabuľka – môžeme z neho čítať, filtrovať ho, spájať s ďalšími tabuľkami alebo ho použiť v ďalšej časti dotazu.
Základná syntax:
WITH cte_name AS (
    SELECT ...
    FROM ...
    WHERE ...
)
SELECT *
FROM cte_name;
Najskôr sa definuje pomenovaný výsledok cte_name a následne sa použije v hlavnom SQL dotaze.
💡 Dôležité: CTE neexistuje ako trvalý databázový objekt. Je dostupné iba počas vykonania konkrétneho SQL príkazu. Po jeho skončení CTE zaniká.
Prečo používať CTE?
CTE sa používa najmä na zlepšenie čitateľnosti, štruktúry a udržiavateľnosti SQL dotazov.
Najčastejšie dôvody použitia:

Rozdelenie komplexného dotazu na menšie kroky – namiesto jedného dlhého SQL dotazu môžeme jednotlivé transformačné kroky pomenovať.
Lepšia čitateľnosť – názov CTE môže vysvetľovať význam výsledku, napríklad monthly_sales alebo high_value_customers.
Opakované použitie výsledku – jeden pomenovaný výsledok možno použiť viackrát v rámci hlavného dotazu.
Jednoduchšie ladenie – jednotlivé kroky sa dajú ľahšie pochopiť a samostatne otestovať.
Postupné transformácie dát – CTE je veľmi vhodné pri ETL a analytických dotazoch.

Jednoduchý príklad
Predstavme si, že najskôr chceme vypočítať celkový predaj jednotlivých zákazníkov a až následne zobraziť iba zákazníkov s predajom nad 2000.
WITH customer_sales AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > 2000;
CTE customer_sales najskôr vytvorí súhrn predaja pre každého zákazníka.
Hlavný dotaz potom pracuje už iba s týmto pripraveným výsledkom a filtruje zákazníkov podľa stĺpca total_sales.
CTE vs. subquery
CTE a vnorený dotaz často dokážu vyriešiť rovnaký problém. Rozdiel je najmä v spôsobe zápisu a organizácii SQL kódu.
Rovnaká logika pomocou subquery:
SELECT *
FROM (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
) AS customer_sales
WHERE total_sales > 2000;
Pomocou CTE:
WITH customer_sales AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
)
SELECT *
FROM customer_sales
WHERE total_sales > 2000;


Vlastnosť
Subquery
CTE



Čitateľnosť pri zložitejšom dotaze
Môže byť horšia pri viacerých vnoreniach
Zvyčajne prehľadnejšia

Pomenovanie medzivýsledku
Alias
Samostatný názov CTE

Viac krokov transformácie
Rýchlo vznikajú hlboko vnorené dotazy
Jednotlivé kroky možno oddeliť

Trvalý databázový objekt
Nie
Nie


💡 Dôležité: Ak je vnorený dotaz krátky a jednoduchý, subquery môže byť úplne postačujúce. Ak sa dotaz skladá z viacerých transformačných krokov, CTE často poskytne prehľadnejšiu štruktúru.
Viac CTE v jednom dotaze
V jednom SQL príkaze možno vytvoriť viac CTE. Jednotlivé CTE sa oddeľujú čiarkou a neskoršie CTE môže pracovať s výsledkom predchádzajúceho CTE.
WITH customer_sales AS (
    SELECT customer_id,
           SUM(sales) AS total_sales
    FROM orders
    GROUP BY customer_id
),
high_value_customers AS (
    SELECT *
    FROM customer_sales
    WHERE total_sales > 2000
)
SELECT *
FROM high_value_customers;
Spracovanie možno chápať ako postupnosť krokov:

vypočítaj celkový predaj zákazníkov,
z výsledku vyber zákazníkov nad 2000,
zobraz výsledok.

Takýto spôsob zápisu je veľmi užitočný pri analytických a ETL dotazoch, kde údaje často prechádzajú viacerými transformačnými krokmi.
CTE môže obsahovať JOIN, agregácie aj ďalšie operácie
CTE nie je obmedzené iba na jednoduchý SELECT. Môže obsahovať rovnaké operácie ako bežný SQL dotaz.
WITH regional_sales AS (
    SELECT c.region,
           SUM(o.sales) AS total_sales
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.region
)
SELECT *
FROM regional_sales
ORDER BY total_sales DESC;
CTE môže teda obsahovať napríklad:

JOIN,
GROUP BY,
HAVING,
agregačné funkcie,
window functions,
ďalšie CTE.

CTE a ETL
CTE je veľmi užitočné pri spracovaní dát v ETL procesoch, pretože umožňuje rozdeliť komplexnú transformáciu do logických krokov.
Napríklad:
WITH cleaned_data AS (
    -- čistenie vstupných dát
),
aggregated_data AS (
    -- agregácia vyčistených dát
),
final_data AS (
    -- finálna transformácia
)
SELECT *
FROM final_data;
Takýto zápis jasne oddeľuje jednotlivé transformačné fázy a výrazne zjednodušuje údržbu SQL kódu.
💡 Pri čítaní CTE: postupujte zhora nadol. Najskôr si určte, čo vytvára prvé CTE, potom čo s jeho výsledkom robí ďalšie CTE a nakoniec čo vracia hlavný SQL dotaz.
Rekurzívne CTE
Špeciálnym typom je WITH RECURSIVE. Rekurzívne CTE sa dokáže odkazovať samo na seba a používa sa najmä pri hierarchických alebo stromových dátach.
Typickými príkladmi sú:

organizačné štruktúry zamestnancov a manažérov,
kategórie a podkategórie,
stromové štruktúry,
postupné prechádzanie hierarchie.

Jednoduchý princíp:
WITH RECURSIVE numbers AS (
    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 5
)
SELECT *
FROM numbers;
Výsledkom budú hodnoty od 1 do 5.
⚠️ Nezabudnite: Rekurzívne CTE je pokročilejší typ CTE. Pri bežných analytických a ETL dotazoch budete najčastejšie pracovať s nerekurzívnymi CTE vytvorenými pomocou WITH.
CTE nie je automaticky optimalizácia výkonu
CTE používame predovšetkým na organizáciu a čitateľnosť SQL kódu. Samotné prepísanie dotazu zo subquery na CTE neznamená automaticky, že dotaz bude rýchlejší.
PostgreSQL môže pri plánovaní dotazu CTE integrovať do výsledného execution plánu alebo ho v určitých situáciách materializovať. Preto je pri výkonnostne náročných dotazoch vhodné analyzovať skutočný plán pomocou EXPLAIN alebo EXPLAIN ANALYZE.
💡 Dôležité: CTE je predovšetkým spôsob, ako rozložiť komplexný SQL dotaz na pomenované logické kroky. Výsledkom býva čitateľnejší, jednoduchšie udržiavateľný a lepšie testovateľný SQL kód.

---

## Strana 2 / 11 — Otázka 1

### 💻 Úloha 1 – Dni s mimoriadne vysokým predajom

💻 Úloha 1 – Dni s mimoriadne vysokým predajom
Všetky úlohy v časti CTE riešte nad databázou datacraftinglab_db a tabuľkou flourmills_sales, ktoré ste vytvorili a naplnili dátami v úlohe Seminár 2 – Zadanie 2a.
Vedenie chce identifikovať dni, počas ktorých bola celková hodnota predaja vyššia ako 3 000 000.
Vytvorte riešenie pomocou CTE. V prvom kroku vypočítajte celkový predaj pre každý deň a vytvorte pomenovaný medzivýsledok daily_sales.
V hlavnom dotaze následne:

vyberte iba dni s celkovým predajom vyšším ako 3 000 000,
zobrazte dátum predaja a celkový denný predaj,
výsledok zoraďte podľa celkového denného predaja od najvyššieho po najnižší.

Ktorá z nasledujúcich tabuliek zodpovedá prvým piatim riadkom správne zoradeného výsledku?
💡 Pomôcka: CTE najskôr vytvorí denný súhrn pomocou SUM() a GROUP BY. Hlavný dotaz potom pracuje už s pripraveným medzivýsledkom.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    sale_date total_daily_sales     2023-01-22 100714415.97   2023-06-30 99408647.63   2023-08-24 98980443.52   2022-04-21 91126961.61   2024-11-02 87024708.52 ← **ZVOLENÉ**
- **b)** b.    sale_date total_daily_sales     2023-01-22 100714415.97   2023-08-24 98980443.52   2023-06-30 99408647.63   2022-04-21 91126961.61   2024-11-02 87024708.52
- **c)** c.    sale_date total_daily_sales     2023-01-22 100714415.97   2023-06-30 99408647.63   2023-08-24 98980443.52   2022-04-21 87024708.52   2024-11-02 91126961.61
- **d)** d.    sale_date total_daily_sales     2023-01-22 100714415.97   2023-06-30 99408647.63   2023-08-24 98980443.52   2024-11-02 87024708.52   2022-04-21 91126961.61

> Vložená odpoveď: `0`

---

## Strana 3 / 11 — Otázka 2

### 💻 Úloha 2 – Predaj podľa produktových kategórií

💻 Úloha 2 – Predaj podľa produktových kategórií
Vytvorte SQL dotaz pomocou CTE, ktorý vypočíta celkový predaj pre jednotlivé produktové kategórie.
V CTE vytvorte pomenovaný medzivýsledok category_sales, v ktorom:

zoskupíte údaje podľa product_category,
vypočítate súčet stĺpca total_amount pre každú kategóriu.

V hlavnom dotaze zobrazte všetky kategórie a výsledok zoraďte podľa celkového predaja od najvyššieho po najnižší.
Akú hodnotu total_sales má vo výsledku produktová kategória Noodles? Do odpovede zadajte iba číselnú hodnotu.
💡 Pomôcka: Agregáciu vykonajte v CTE a hlavný dotaz použite už iba na zobrazenie a zoradenie pripraveného výsledku.
💡 Dôležité: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 2 ← **ZVOLENÉ**

> Vložená odpoveď: `8025966980.13`

---

## Strana 4 / 11 — Informácia

### 📘 Window Functions – RANK(), OVER() a PARTITION BY

📘 Window Functions – RANK(), OVER() a PARTITION BY
Window functions (okenné funkcie) umožňujú vykonávať výpočty nad skupinou riadkov bez toho, aby sa jednotlivé riadky výsledku zlúčili do jedného záznamu.
To je zásadný rozdiel oproti GROUP BY. Pri použití GROUP BY sa viacero riadkov zoskupí do jedného výsledného riadku. Window function však pôvodné riadky zachová a ku každému z nich vypočíta ďalšiu hodnotu.
Jednou z najčastejšie používaných window functions je RANK(), ktorá priradí jednotlivým riadkom poradie.
Základná syntax:
RANK() OVER (
    PARTITION BY column_name
    ORDER BY value_column DESC
)
Čo znamená OVER()?
Klauzula OVER() definuje okno riadkov, nad ktorým sa má window function vyhodnotiť.
Vo vnútri OVER() môžeme určiť napríklad:

podľa čoho sa majú riadky rozdeliť do samostatných skupín,
podľa čoho sa majú riadky v každej skupine zoradiť,
nad akou časťou riadkov sa má výpočet vykonať.

Čo znamená PARTITION BY?
PARTITION BY rozdelí výsledné riadky do samostatných skupín, tzv. partitions. Window function sa potom vyhodnotí samostatne v každej skupine.
Napríklad:
RANK() OVER (
    PARTITION BY product_category
    ORDER BY total_product_sales DESC
)
znamená:

rozdeľ produkty podľa product_category,
v každej kategórii ich zoraď podľa total_product_sales od najvyššej hodnoty,
priraď poradie začínajúce od 1 samostatne pre každú kategóriu.

Poradie sa teda pri zmene kategórie začne počítať opäť od hodnoty 1.


category
product
sales
rank



Flour
Product A
900
1

Flour
Product B
700
2

Noodles
Product C
1200
1

Noodles
Product D
800
2


V tomto príklade sa poradie nevypočítava globálne pre všetky produkty. Produkty kategórie Flour majú vlastné poradie a produkty kategórie Noodles majú opäť vlastné poradie začínajúce od 1.
ORDER BY vo window function
ORDER BY vo vnútri OVER() určuje, podľa čoho sa vypočíta poradie.
ORDER BY total_product_sales DESC
znamená, že produkt s najvyšším predajom dostane rank = 1, druhý najvyšší rank = 2 atď.
⚠️ Pozor: ORDER BY vo vnútri OVER() určuje spôsob výpočtu poradia. Neznamená automaticky, že celý výsledok dotazu bude zobrazený v rovnakom poradí. Na výsledné zoradenie sa používa samostatný ORDER BY hlavného dotazu.
RANK() a rovnaké hodnoty
Ak majú dva riadky rovnakú hodnotu použitú na zoradenie, funkcia RANK() im priradí rovnaké poradie.
Napríklad:


sales
RANK()



1000
1

900
2

900
2

700
4


Hodnota 3 sa preskočila, pretože dve položky obsadili druhé miesto.
PostgreSQL poskytuje aj podobné funkcie:

ROW_NUMBER() – každému riadku priradí unikátne poradové číslo,
RANK() – pri rovnakých hodnotách priradí rovnaké poradie a ďalšie miesto preskočí,
DENSE_RANK() – pri rovnakých hodnotách priradí rovnaké poradie, ale ďalšie miesto nepreskočí.

💡 Dôležité: PARTITION BY určuje v rámci akej skupiny sa poradie počíta, zatiaľ čo ORDER BY vo vnútri OVER() určuje podľa čoho sa toto poradie vypočíta.

---

## Strana 5 / 11 — Otázka 3

### 💻 Úloha 3 – Top produkty v jednotlivých kategóriách

💻 Úloha 3 – Top produkty v jednotlivých kategóriách
Vedenie chce zistiť, ktoré produkty dosahujú najvyšší celkový predaj v rámci jednotlivých produktových kategórií.
Vytvorte SQL riešenie pomocou dvoch CTE.
V prvom CTE:

zoskupte údaje podľa produktovej kategórie a názvu produktu,
vypočítajte celkový predaj každého produktu,
výslednú hodnotu pomenujte total_product_sales.

V druhom CTE použite funkciu RANK() a každému produktu priraďte poradie podľa jeho predaja samostatne v rámci jeho produktovej kategórie.
Výsledné poradie pomenujte category_rank.
V hlavnom dotaze:

ponechajte iba produkty s poradím 1 až 3,
výsledok zoraďte najskôr podľa produktovej kategórie a následne podľa poradia.

Ktorá z nasledujúcich tabuliek zodpovedá prvým desiatim riadkom správne zoradeného výsledku?
💡 Pomôcka: Poradie sa musí začať od hodnoty 1 nanovo pre každú produktovú kategóriu. Použite preto PARTITION BY product_category a produkty v každej kategórii zoraďte podľa total_product_sales zostupne.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    product_category total_product_sales category_rank     Flour 1774596649.83 1   Flour 1671164473.48 1   Flour 1587690801.30 1   Noodles 1777357933.46 1   Noodles 1660578534.12 1   Noodles 1657003299.77 1   Pasta 1754311409.15 1   Pasta 1691265705.48 1   Pasta 1642665131.86 1   Semolina 1781719163.67 1
- **b)** b.    product_category total_product_sales category_rank     Flour 1774596649.83 3   Flour 1671164473.48 2   Flour 1587690801.30 1   Noodles 1777357933.46 3   Noodles 1660578534.12 2   Noodles 1657003299.77 1   Pasta 1754311409.15 3   Pasta 1691265705.48 2   Pasta 1642665131.86 1   Semolina 1781719163.67 3
- **c)** c.    product_category total_product_sales category_rank     Flour 1774596649.83 1   Flour 1671164473.48 2   Flour 1587690801.30 3   Noodles 1777357933.46 4   Noodles 1660578534.12 5   Noodles 1657003299.77 6   Pasta 1754311409.15 7   Pasta 1691265705.48 8   Pasta 1642665131.86 9   Semolina 1781719163.67 10
- **d)** d.    product_category total_product_sales category_rank     Flour 1774596649.83 1   Flour 1671164473.48 2   Flour 1587690801.30 3   Noodles 1777357933.46 1   Noodles 1660578534.12 2   Noodles 1657003299.77 3   Pasta 1754311409.15 1   Pasta 1691265705.48 2   Pasta 1642665131.86 3   Semolina 1781719163.67 1 ← **ZVOLENÉ**

> Vložená odpoveď: `3`

---

## Strana 6 / 11 — Otázka 4

### 💻 Úloha 4 – Podiel zákazníckych typov na celkovom predaji

💻 Úloha 4 – Podiel zákazníckych typov na celkovom predaji
Vedenie chce zistiť, ktoré typy zákazníkov generujú najvyšší obrat a aký percentuálny podiel z celkového predaja jednotlivé typy predstavujú.
Vytvorte SQL riešenie pomocou dvoch CTE.
V prvom CTE:

zoskupte údaje podľa customer_type,
vypočítajte celkový predaj každého typu zákazníka,
výslednú hodnotu pomenujte revenue.

V druhom CTE:

zachovajte typ zákazníka a jeho hodnotu revenue,
pomocou window function vypočítajte celkový predaj všetkých typov zákazníkov ako total_revenue,
vypočítajte percentuálny podiel každého typu zákazníka na celkovom predaji a výsledok zaokrúhlite na dve desatinné miesta,
percentuálnu hodnotu pomenujte revenue_percentage.

V hlavnom dotaze zobrazte:

customer_type,
revenue,
total_revenue,
revenue_percentage.

Výsledok zoraďte podľa hodnoty revenue od najvyššej po najnižšiu.
Ktorý customer_type má hodnotu revenue_percentage = 33.31? Do odpovede uveďte iba názov typu zákazníka.
💡 Pomôcka: Na výpočet celkového predaja zo všetkých riadkov druhého CTE použite window function SUM(revenue) OVER (). Prázdne zátvorky v OVER() znamenajú, že výpočet sa vykoná nad celým výsledkom bez rozdelenia na partitions.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 4 ← **ZVOLENÉ**

> Vložená odpoveď: `Distributor`

---

## Strana 7 / 11 — Otázka 5

### 💻 Úloha 5 – Posledný nákup každého zákazníka

💻 Úloha 5 – Posledný nákup každého zákazníka
Vedenie chce zistiť, kedy jednotliví zákazníci nakúpili naposledy a aký produkt bol súčasťou ich poslednej transakcie.
Vytvorte riešenie pomocou CTE a window function ROW_NUMBER().
V CTE:

pracujte s identifikátorom zákazníka, názvom produktu, dátumom predaja a hodnotou transakcie,
rozdeľte záznamy podľa customer_id,
transakcie každého zákazníka zoraďte podľa sale_date zostupne,
pomocou ROW_NUMBER() priraďte najnovšej transakcii každého zákazníka hodnotu 1.

V hlavnom dotaze zobrazte iba poslednú transakciu každého zákazníka a výsledok zoraďte podľa customer_id vzostupne.
Ktorá z nasledujúcich tabuliek zodpovedá prvým piatim riadkom správne zoradeného výsledku?
💡 Pomôcka: Funkcia ROW_NUMBER() priradí každému riadku poradové číslo. V kombinácii s PARTITION BY customer_id sa číslovanie začne od 1 samostatne pre každého zákazníka.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    customer_id product_name sale_date total_amount     1000 Golden Penny Semovita 5kg 2024-03-31 2474807.81   1001 Golden Penny Vegetable Oil 2023-08-01 6433230.47   1005 Golden Penny Flour 50kg 2023-05-01 12000887.73   1006 Golden Penny Vegetable Oil 2022-08-11 615983.15   1007 Golden Penny Vegetable Oil 2024-05-25 13194291.00 ← **ZVOLENÉ**
- **b)** b.    customer_id product_name sale_date total_amount     1000 Golden Penny Semovita 5kg 2024-03-31 2474807.81   1001 Golden Penny Vegetable Oil 2023-08-01 6433230.47   1005 Golden Penny Flour 50kg 2023-05-01 12000887.73   1006 Golden Penny Vegetable Oil 2022-08-11 13194291.00   1007 Golden Penny Vegetable Oil 2024-05-25 615983.15
- **c)** c.    customer_id product_name sale_date total_amount     1000 Golden Penny Semovita 5kg 2024-03-31 2474807.81   1001 Golden Penny Vegetable Oil 2023-08-01 6433230.47   1005 Golden Penny Flour 50kg 2024-05-01 12000887.73   1006 Golden Penny Vegetable Oil 2022-08-11 13194291.00   1007 Golden Penny Vegetable Oil 2024-05-25 615983.15
- **d)** d.    customer_id product_name sale_date total_amount     1000 Golden Penny Semovita 5kg 2024-03-31 2474807.81   1001 Golden Penny Vegetable Oil 2023-08-01 6433230.47   1005 Golden Penny Flour 50kg 2023-05-01 12000887.73   1006 Golden Penny Vegetable Oil 2024-08-11 13194291.00   1007 Golden Penny Vegetable Oil 2024-05-25 615983.15

> Vložená odpoveď: `0`

---

## Strana 8 / 11 — Informácia

### 📘 Rekurzívne CTE – WITH RECURSIVE

📘 Rekurzívne CTE – WITH RECURSIVE
Rekurzívne CTE je špeciálny typ Common Table Expression, ktorý sa dokáže odkazovať sám na seba.
Používa sa najmä v situáciách, keď potrebujeme opakovane nadväzovať na výsledok predchádzajúceho kroku, napríklad pri:

hierarchiách zamestnancov a manažérov,
stromových štruktúrach kategórií a podkategórií,
prechádzaní nadradených a podradených objektov,
generovaní postupností hodnôt,
spracovaní dát s opakujúcou sa závislosťou medzi riadkami.

Základná štruktúra rekurzívneho CTE obsahuje dve časti:
WITH RECURSIVE cte_name AS (

    -- 1. Anchor query
    SELECT ...

    UNION ALL

    -- 2. Recursive query
    SELECT ...
    FROM cte_name
    WHERE ...

)
SELECT *
FROM cte_name;
1. Anchor query
Anchor query je počiatočná časť rekurzie. Vytvorí prvý riadok alebo prvú množinu riadkov, od ktorých sa ďalšie spracovanie začne.
Táto časť ešte neodkazuje na samotné CTE.
2. Recursive query
Recursive query pracuje s výsledkom, ktorý CTE vytvorilo v predchádzajúcom kroku, a na jeho základe vytvára ďalšie riadky.
Práve v tejto časti sa CTE odkazuje samo na seba.
⚠️ Nezabudnite: Rekurzívna časť musí obsahovať podmienku, ktorá rekurziu zastaví. Bez vhodnej ukončovacej podmienky by sa ďalšie kroky mohli generovať neobmedzene.
Jednoduchý príklad
Nasledujúce rekurzívne CTE vytvorí postupnosť čísel od 1 do 5:
WITH RECURSIVE numbers AS (

    SELECT 1 AS n

    UNION ALL

    SELECT n + 1
    FROM numbers
    WHERE n < 5

)
SELECT *
FROM numbers;
Spracovanie prebieha postupne:


Krok
Výsledok



Anchor query
1

1. rekurzívny krok
2

2. rekurzívny krok
3

3. rekurzívny krok
4

4. rekurzívny krok
5


Keď hodnota dosiahne 5, podmienka n < 5 už nie je splnená a rekurzia sa ukončí.
UNION ALL
Anchor a recursive časť sa najčastejšie spájajú pomocou UNION ALL.
UNION ALL zachová všetky vytvorené riadky a databáza nemusí pri každom kroku odstraňovať duplicity.
💡 Dôležité: Rekurzívne CTE má vždy počiatočný krok, rekurzívny krok a podmienku ukončenia. Rekurzívna časť používa výsledok predchádzajúceho kroku na vytvorenie ďalšieho výsledku.

---

## Strana 9 / 11 — Otázka 6

### 💻 Úloha 6 – Súvislý kalendár predajov

💻 Úloha 6 – Súvislý kalendár predajov
Vytvorte pomocou WITH RECURSIVE súvislý zoznam dátumov od najstaršieho po najnovší dátum predaja v tabuľke flourmills_sales.
Výsledok musí obsahovať každý kalendárny deň v danom období, vrátane dní, počas ktorých sa neuskutočnil žiadny predaj.
Riešenie rozdeľte na dva kroky:

v prvom CTE určte najskorší a najneskorší dátum predaja,
v rekurzívnom CTE vytvorte postupnosť dátumov po jednom dni od počiatočného dátumu až po koncový dátum.

V rekurzívnej časti vždy vytvorte ďalší dátum pridaním jedného dňa k dátumu z predchádzajúceho kroku.
Výsledok zoraďte podľa dátumu vzostupne.
Koľko dátumov obsahuje výsledný súvislý kalendár od najstaršieho po najnovší dátum predaja? Do odpovede zadajte iba počet vrátených riadkov.
💡 Pomôcka: Najskorší a najneskorší dátum môžete určiť pomocou funkcií MIN() a MAX(). Rekurziu ukončite v momente, keď aktuálny dátum dosiahne najneskorší dátum predaja.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 6 ← **ZVOLENÉ**

> Vložená odpoveď: `1096`

---

## Strana 10 / 11 — Otázka 7

### 💻 Úloha 7 – Dosiahnutie hranice 500 miliónov kumulatívneho predaja

💻 Úloha 7 – Dosiahnutie hranice 500 miliónov kumulatívneho predaja
Vedenie chce zistiť, v ktorom mesiaci celkový kumulatívny predaj prvýkrát dosiahne alebo presiahne hodnotu 500 000 000.
Pri riešení použite kombináciu:

bežného CTE na mesačnú agregáciu,
window function ROW_NUMBER(),
rekurzívneho CTE na postupné sčítavanie mesačných hodnôt.

💡 Dôležité: Riešenie si rozdeľte na tri samostatné kroky. Najskôr potrebujete vedieť predaj za každý mesiac, potom musíte mesiace jednoznačne zoradiť a očíslovať a až následne môžete pomocou rekurzie postupne vytvárať kumulatívny súčet.
Krok 1 – Vypočítajte mesačný predaj
V prvom CTE vytvorte mesačný súhrn predaja.
Pre každý mesiac potrebujete:

mesiac získaný zo stĺpca sale_date,
celkovú hodnotu predaja za daný mesiac.

Na vytvorenie mesiaca použite:
DATE_TRUNC('month', sale_date)
Výsledok prvého CTE by mal mať logicky dva stĺpce:
month | revenue
Krok 2 – Zoraďte a očíslujte mesiace
Rekurzívna časť potrebuje vedieť, ktorý mesiac nasleduje po ktorom. Preto v ďalšom CTE priraďte každému mesiacu poradové číslo pomocou:
ROW_NUMBER() OVER (ORDER BY month)
Najstarší mesiac tak dostane hodnotu rn = 1, nasledujúci rn = 2 atď.
Výsledok tohto kroku bude mať tvar:
rn | month | revenue
💡 Prečo potrebujeme rn? V rekurzívnej časti potom môžeme jednoducho povedať: k aktuálnemu mesiacu pripoj nasledujúci mesiac, teda riadok, pre ktorý platí next.rn = current.rn + 1.
Krok 3 – Vytvorte kumulatívny súčet pomocou rekurzie
V treťom CTE vytvorte rekurzívny výpočet.
Anchor query musí začať prvým mesiacom, teda riadkom s hodnotou:
rn = 1
V prvom mesiaci je kumulatívny predaj rovnaký ako samotný mesačný predaj:
cumulative_revenue = revenue
Recursive query následne vždy:

nájde nasledujúci mesiac,
vezme jeho mesačný predaj,
pripočíta ho ku kumulatívnej hodnote z predchádzajúceho kroku.

Výpočet teda zodpovedá princípu:
new_cumulative_revenue =
    previous_cumulative_revenue + current_month_revenue
Rekurziu vykonávajte dovtedy, kým kumulatívny predaj nedosiahne hranicu 500 000 000.
⚠️ Nezabudnite: Cieľom nie je vypočítať kumulatívny predaj za celé obdobie. Rekurzia má pokračovať iba dovtedy, kým predchádzajúca kumulatívna hodnota ešte neprekročila cieľovú hranicu. Výsledok tak bude obsahovať aj riadok, v ktorom sa hranica 500 000 000 prvýkrát dosiahne alebo presiahne.
Odporúčaná štruktúra riešenia
Vaše riešenie bude mať približne takúto logickú štruktúru:
WITH RECURSIVE monthly_revenue AS (
    -- mesačný predaj
),
ordered_months AS (
    -- očíslovanie mesiacov pomocou ROW_NUMBER()
),
cumulative_target AS (

    -- anchor query: prvý mesiac

    UNION ALL

    -- recursive query:
    -- predchádzajúci cumulative_revenue + revenue ďalšieho mesiaca

)
SELECT ...
FROM cumulative_target
ORDER BY rn;
V ktorom mesiaci kumulatívny predaj prvýkrát dosiahne alebo presiahne hodnotu 500 000 000 a aká je v tomto riadku hodnota cumulative_revenue? Do odpovede uveďte hodnoty v poradí month, cumulative_revenue a oddeľte ich čiarkou.
💡 Odporúčanie: Nevytvárajte celý dotaz naraz. Najskôr samostatne spustite prvé CTE a skontrolujte mesačné predaje. Potom pridajte očíslovanie mesiacov a až keď sú tieto dva kroky správne, doplňte rekurzívne CTE.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre CTE a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    rn month revenue cumulative_revenue     2 2022-02-01 1213547365.75 1213547365.75
- **b)** b.    rn month revenue cumulative_revenue     1 2022-01-01 1213547365.75 1213547365.75 ← **ZVOLENÉ**
- **c)** c.    rn month revenue cumulative_revenue     1 2022-01-01 1213547365.75 500000000.00
- **d)** d.    rn month revenue cumulative_revenue     1 2022-01-01 500000000.00 1213547365.75

> Vložená odpoveď: `1`

---

## Strana 11 / 11 — Informácia

### 📘 Kontrola Git repozitára po 2. týždni

📘 Kontrola Git repozitára po 2. týždni
Po dokončení všetkých úloh z 2. týždňa skontrolujte, či máte vo svojom Git repozitári vytvorenú ďalšiu samostatnú vetvu napr. week-02 a či sa v nej nachádzajú všetky SQL skripty vytvorené počas cvičenia.
Obsah vetvy week-02 by mal mať približne nasledujúcu štruktúru:
week-02
│
├── 01_views.sql
├── 02_indexes.sql
├── 03_stored_procedures.sql
└── 04_cte.sql│
└── superstore_dataset.csv
Dátový súbor .csv ponechajte v repozitári spolu so SQL skriptmi, aby bolo možné databázy a riešenia neskôr znovu vytvoriť.
⚠️ Kontrola GitHubu: Vzdialený repozitár na GitHube by mal obsahovať rovnaké súbory ako váš lokálny repozitár. Ak niektorý SQL súbor vidíte iba vo VS Code, ale nie na GitHube, zmena ešte nebola úspešne odoslaná pomocou push.

---
