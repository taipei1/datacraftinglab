# Seminár 3 – Zadanie 1a (VIEW, indexy, uložené procedúry)

Zdroj: UKF Moodle, pokus o test `attempt=564304&cmid=289607`.
Uložené: 2026-10-11. Strán spolu: 14.

---

## Strana 1 / 14 — Informácia

### 📘 Databázové pohľady – VIEW

📘 Databázové pohľady – VIEW
View je virtuálna tabuľka vytvorená na základe výsledku SQL dotazu. Navonok sa správa podobne ako bežná tabuľka – možno nad ňou používať SELECT, filtrovanie, triedenie alebo ďalšie spojenia.
Na rozdiel od bežnej tabuľky však klasické VIEW neukladá výsledné dáta samostatne. Databáza si ukladá predovšetkým definíciu SQL dotazu, z ktorého je view vytvorené. Pri práci s view sa údaje získavajú z pôvodných tabuliek.
Jednoduchý príklad vytvorenia pohľadu:
CREATE VIEW high_value_sales AS
SELECT product_name,
       region,
       total_amount
FROM flourmills_sales
WHERE total_amount > 500000;
Po vytvorení možno s pohľadom pracovať podobne ako s tabuľkou:
SELECT *
FROM high_value_sales;
Pri tomto príkaze sa údaje nečítajú zo samostatne uložených riadkov pohľadu. PostgreSQL vyhodnotí dotaz definovaný vo view a použije aktuálne údaje zo zdrojových tabuliek.
Prečo sa VIEW používa?

Opätovné použitie dotazov – dlhý alebo zložitý SQL dotaz možno uložiť pod jedným názvom a opakovane používať bez jeho prepisovania.
Zjednodušenie práce s dátami – používateľ môže pracovať s jednoduchým pohľadom namiesto komplikovaného dotazu obsahujúceho viacero spojení, agregácií alebo podmienok.
Konzistentnosť – ak viac používateľov alebo aplikácií potrebuje rovnaký výpočet, view zabezpečí, že všetci používajú rovnakú definíciu a rovnakú logiku.
Obmedzenie prístupu k údajom – view môže sprístupniť iba vybrané stĺpce alebo riadky a skryť údaje, ktoré používateľ nepotrebuje vidieť.
Oddelenie logiky od používateľa – používateľ nemusí vedieť, ako sú údaje uložené alebo ktoré tabuľky sa používajú. Pracuje iba s pripraveným pohľadom.

VIEW vs. TABLE


Vlastnosť
TABLE
VIEW



Ukladá vlastné dáta
Áno
Nie

Obsahuje uloženú definíciu dotazu
Nie
Áno

Možno nad ním použiť SELECT
Áno
Áno

Reaguje na zmeny zdrojových dát
Nie je relevantné
Áno


Ak sa teda zmenia údaje v pôvodnej tabuľke, výsledok pohľadu sa pri ďalšom použití automaticky zmení podľa aktuálneho stavu zdrojových dát.
Úprava a odstránenie pohľadu
Definíciu existujúceho pohľadu možno zmeniť pomocou:
CREATE OR REPLACE VIEW view_name AS
SELECT ...;
Pohľad možno odstrániť pomocou:
DROP VIEW view_name;
💡 Dôležité: Pohľad nie je kópia tabuľky. Ak vytvoríte VIEW a následne sa zmenia údaje v zdrojovej tabuľke, výsledok pohľadu bude pri ďalšom dotaze pracovať s aktuálnymi údajmi.
⚠️ Pozor: Klasické VIEW si netreba zamieňať s MATERIALIZED VIEW. Materializovaný pohľad výsledok dotazu fyzicky ukladá a jeho dáta je potrebné podľa potreby obnovovať.

---

## Strana 2 / 14 — Otázka 1

### 💻 Úloha 1 – Pohľad pre zákazníkov s vysokou hodnotou predaja

💻 Úloha 1 – Pohľad pre zákazníkov s vysokou hodnotou predaja
Vytvorte databázový pohľad high_value_customers nad databázou superstore, ktorý bude poskytovať pripravený prehľad zákazníkov s celkovou hodnotou predaja vyššou ako 2 000.
Pohľad vytvorte nad tabuľkami customers a orders.
Vo výsledku pohľadu zobrazte:

identifikátor zákazníka (customer_id),
meno zákazníka (customer_name),
celkovú hodnotu jeho nákupov ako total_sales.

Pri výpočte najskôr prepojte zákazníkov s objednávkami, následne zoskupte údaje podľa zákazníka a vypočítajte jeho celkový predaj.
Do pohľadu zahrňte iba zákazníkov, ktorých výsledná hodnota total_sales je vyššia ako 2 000.
Po vytvorení pohľadu overte jeho obsah pomocou dotazu:
SELECT *
FROM high_value_customers;
Koľko zákazníkov sa nachádza vo vytvorenom pohľade high_value_customers? Do odpovede zadajte iba počet.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 1 ← **ZVOLENÉ**

> Vložená odpoveď: `4`

---

## Strana 3 / 14 — Otázka 2

### 💻 Úloha 2 – Mesačný predaj podľa regiónu

💻 Úloha 2 – Mesačný predaj podľa regiónu
Vytvorte databázový pohľad regional_monthly_sales nad databázou superstore, ktorý bude poskytovať mesačný súhrn predaja pre jednotlivé regióny.
Pohľad vytvorte nad tabuľkami customers a orders.
Vo výsledku pohľadu zobrazte:

región zákazníka,
mesiac objednávky ako month,
celkový predaj za daný región a mesiac ako monthly_sales.

Na zoskupenie dát podľa mesiaca použite funkciu DATE_TRUNC().
Ktorá z nasledujúcich tabuliek zodpovedá výsledku dotazu pre región West?
💡 Pomôcka: Výraz DATE_TRUNC('month', order_date) prevedie dátum objednávky na začiatok príslušného mesiaca. Vďaka tomu možno všetky objednávky z rovnakého mesiaca zoskupiť a agregovať.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    region month monthly_sales     West 2024-01-01 1333.84   West 2024-02-01 1016.46   West 2024-03-01 2004.98
- **b)** b.    region month monthly_sales     West 2024-01-01 1333.84   West 2024-02-01 2004.98   West 2024-03-01 1016.46   West 2024-04-01 29.79
- **c)** c.    region month monthly_sales     West 2024-01-01 1333.84   West 2024-02-01 1016.46   West 2024-03-01 2004.98   West 2024-04-01 29.79 ← **ZVOLENÉ**
- **d)** d.    region month monthly_sales     West 2024-01-01 1333.84   West 2024-02-01 1016.46   West 2024-03-01 29.79   West 2024-04-01 2004.98

> Vložená odpoveď: `2`

---

## Strana 4 / 14 — Otázka 3

### 💻 Úloha 3 – Pohľad pre analytikov

💻 Úloha 3 – Pohľad pre analytikov
Vytvorte databázový pohľad analyst_orders nad databázou superstore, ktorý bude analytikom poskytovať údaje o objednávkach, ale nebude obsahovať informáciu o zisku.
Pohľad vytvorte nad tabuľkou orders.
Vo výsledku pohľadu sprístupnite iba nasledujúce stĺpce:

order_id,
customer_id,
product_id,
sales,
quantity,
discount.

Stĺpec profit sa vo vytvorenom pohľade nesmie nachádzať.
Po vytvorení pohľadu overte jeho obsah:
SELECT *
FROM analyst_orders;
Predpokladajme, že používateľ analyst má povolený SELECT nad pohľadom analyst_orders. Ktoré tvrdenie najpresnejšie opisuje, čo ešte musí byť splnené, aby používateľ nemohol získať hodnoty stĺpca profit priamo zo zdrojovej tabuľky orders?
💡 Pomôcka: View nemusí obsahovať všetky stĺpce zdrojovej tabuľky. Do jeho definície môžete zahrnúť iba tie údaje, ktoré chcete používateľom sprístupniť.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a. Zdrojovú tabuľku je potrebné po vytvorení VIEW odstrániť, pretože VIEW obsahuje všetky údaje potrebné na ďalšie dotazovanie.
- **b)** b. Používateľ nesmie mať oprávnenie SELECT nad zdrojovou tabuľkou orders alebo musí mať prístup k jej stĺpcom vhodne obmedzený. Prístup mu môže byť poskytnutý iba cez pripravený VIEW. ← **ZVOLENÉ**
- **c)** c. Stačí nastaviť stĺpec profit na hodnotu NULL v definícii VIEW.
- **d)** d. Nie je potrebné nič ďalšie. Ak stĺpec profit nie je súčasťou VIEW, PostgreSQL automaticky zakáže používateľovi prístup k tomuto stĺpcu aj v tabuľke orders.

> Vložená odpoveď: `1`

---

## Strana 5 / 14 — Informácia

### 📘 Indexy v PostgreSQL

📘 Indexy v PostgreSQL
Index je pomocná dátová štruktúra, ktorú databázový systém používa na rýchlejšie vyhľadávanie riadkov v tabuľke. Jeho úlohou je znížiť množstvo dát, ktoré musí PostgreSQL pri vykonávaní dotazu prehľadať.
Bez indexu môže PostgreSQL pri vyhľadávaní konkrétnej hodnoty prechádzať veľkú časť alebo dokonca celú tabuľku. Tento spôsob sa označuje ako Sequential Scan alebo skrátene Seq Scan.
Ak existuje vhodný index, databáza môže namiesto prehľadávania celej tabuľky použiť index na rýchlejšie nájdenie požadovaných riadkov.
💡 Dôležité: Index v databáze funguje podobne ako register na konci knihy. Ak hľadáte konkrétny pojem, nemusíte prechádzať všetky strany knihy – register vás nasmeruje na miesto, kde sa daný pojem nachádza.
Vytvorenie indexu
Index vytvoríme pomocou príkazu CREATE INDEX:
CREATE INDEX idx_orders_customer_id
ON orders(customer_id);
V tomto prípade sa vytvorí index nad stĺpcom customer_id v tabuľke orders.
Index sa následne nemusí v SQL dotazoch explicitne uvádzať. PostgreSQL obsahuje query planner, ktorý pri vykonávaní dotazu rozhoduje, či je použitie konkrétneho indexu výhodné.
Napríklad:
SELECT *
FROM orders
WHERE customer_id = 'C017';
Ak existuje vhodný index nad customer_id, PostgreSQL môže použiť index namiesto prehľadania celej tabuľky.
Kedy má index zmysel?
Indexy sa najčastejšie vytvárajú nad stĺpcami, ktoré sa často používajú pri:

filtrovaní údajov pomocou WHERE,
spájaní tabuliek pomocou JOIN,
triedení pomocou ORDER BY,
zoskupovaní pomocou GROUP BY,
vyhľadávaní konkrétnych alebo rozsahových hodnôt.

Typickými kandidátmi na index sú napríklad:
customer_id
product_id
order_date
region
To však neznamená, že každý často používaný stĺpec automaticky potrebuje index. PostgreSQL vždy zvažuje, či bude použitie indexu lacnejšie ako sekvenčné čítanie tabuľky.
Index nie je zadarmo
Index môže výrazne zrýchliť čítanie dát, ale zároveň prináša určitú réžiu.

zaberá dodatočné miesto na disku,
pri INSERT musí PostgreSQL aktualizovať aj index,
pri UPDATE môže byť potrebné aktualizovať indexovanú hodnotu,
pri DELETE musí byť odstránený aj príslušný záznam z indexu.

Preto platí, že indexy môžu zrýchliť SELECT dotazy, ale môžu mierne spomaliť operácie, ktoré menia dáta.
⚠️ Pozor: Viac indexov neznamená automaticky vyšší výkon. Príliš veľa indexov môže spomaliť zápis dát a zbytočne zaberať miesto. Indexy je preto potrebné navrhovať podľa reálne používaných SQL dotazov.
Primárny kľúč a index
Pri vytvorení PRIMARY KEY PostgreSQL automaticky vytvorí unikátny index.
Napríklad:
CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100)
);
Nie je preto potrebné vytvárať ďalší index nad customer_id, pretože index už existuje.
💡 Dôležité: PostgreSQL automaticky vytvára index pre PRIMARY KEY a UNIQUE obmedzenia. Pri samotnom FOREIGN KEY sa však index na odkazujúcom stĺpci automaticky vytvoriť nemusí.
Typy indexov v PostgreSQL
PostgreSQL podporuje viacero typov indexov. Jednotlivé typy sú navrhnuté pre rôzne druhy dát a spôsob ich vyhľadávania.
1. B-tree
B-tree je predvolený a najčastejšie používaný typ indexu v PostgreSQL.
Je vhodný najmä pre:

porovnanie rovnosti =,
rozsahové podmienky <, >, BETWEEN,
triedenie dát pomocou ORDER BY.

CREATE INDEX idx_orders_sales
ON orders(sales);
2. Hash
HASH index je určený najmä pre presné porovnanie pomocou operátora =.
CREATE INDEX idx_orders_customer_hash
ON orders USING HASH (customer_id);
3. GIN – Generalized Inverted Index
GIN sa používa najmä pri dátach, kde jeden riadok obsahuje viacero hodnôt alebo prvkov, ktoré chceme samostatne vyhľadávať.
Typickými príkladmi sú:

full-text search,
polia ARRAY,
dokumenty JSONB.

4. BRIN – Block Range Index
BRIN index je veľmi malý a je vhodný najmä pre veľké tabuľky, v ktorých sú hodnoty prirodzene usporiadané.
Typickým príkladom sú časové alebo sekvenčné dáta:
CREATE INDEX idx_orders_date_brin
ON orders USING BRIN (order_date);
BRIN si neukladá detailný záznam pre každý riadok. Namiesto toho uchováva súhrnné informácie o rozsahoch hodnôt v jednotlivých blokoch tabuľky, preto môže byť pri veľmi veľkých tabuľkách výrazne menší ako B-tree index.
Viacstĺpcové indexy
Index môže obsahovať aj viac ako jeden stĺpec:
CREATE INDEX idx_orders_customer_date
ON orders(customer_id, order_date);
Takýto index môže byť vhodný napríklad pre dotazy typu:
SELECT *
FROM orders
WHERE customer_id = 'C017'
  AND order_date >= '2024-01-01';
⚠️ Pozor: Pri viacstĺpcových indexoch záleží na poradí stĺpcov. Index (customer_id, order_date) nie je z hľadiska optimalizácie automaticky ekvivalentný indexu (order_date, customer_id).
Ako zistíme, či PostgreSQL index používa?
Samotná existencia indexu ešte neznamená, že ho PostgreSQL pri každom dotaze použije. Rozhodnutie robí query planner podľa odhadovaných nákladov.
Plán vykonania dotazu môžeme zobraziť pomocou:
EXPLAIN
SELECT *
FROM orders
WHERE customer_id = 'C017';
V pláne môžeme napríklad vidieť:

Seq Scan – PostgreSQL prechádza tabuľku sekvenčne,
Index Scan – PostgreSQL používa index,
Bitmap Index Scan – PostgreSQL využíva index pri získaní väčšieho počtu riadkov.

Na získanie reálnych časov vykonania môžeme použiť:
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C017';
💡 Dôležité: Index nevytvárame preto, aby „existoval“. Index má zmysel vtedy, keď podporuje konkrétne často vykonávané dotazy a query planner ho dokáže efektívne využiť.
Odstránenie indexu
Ak index už nie je potrebný, môžeme ho odstrániť pomocou:
DROP INDEX idx_orders_customer_id;

---

## Strana 6 / 14 — Otázka 4

### 💻 Úloha 4 – Index pre vyhľadávanie objednávok zákazníka

💻 Úloha 4 – Index pre vyhľadávanie objednávok zákazníka
Vytvorte index nad stĺpcom customer_id v tabuľke orders v databáze superstore.
Cieľom je pripraviť databázu na efektívnejšie vyhľadávanie objednávok konkrétneho zákazníka.
Index pomenujte:
idx_orders_customer_id
Po vytvorení indexu zobrazte všetky objednávky zákazníka s identifikátorom C001.
Ktoré tvrdenie najlepšie opisuje vzťah medzi vytvoreným indexom a plánom vykonania dotazu?
💡 Pomôcka: PostgreSQL nemusí použiť index pri každom dotaze. Query planner vyberá plán podľa veľkosti tabuľky, selektivity podmienky a odhadovaných nákladov. Pri malej tabuľke môže byť sekvenčné čítanie stále lacnejšie.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a. Index je dostupný query planneru, ale PostgreSQL ho použije iba vtedy, ak vyhodnotí jeho použitie ako výhodnejšie než sekvenčné čítanie tabuľky. ← **ZVOLENÉ**
- **b)** b. Index ovplyvňuje iba triedenie pomocou ORDER BY, nie filtrovanie cez WHERE.
- **c)** c. Index sa použije iba vtedy, ak ho explicitne uvedieme v príkaze SELECT.
- **d)** d. Po vytvorení indexu PostgreSQL vždy použije Index Scan.

> Vložená odpoveď: `0`

---

## Strana 7 / 14 — Otázka 5

### 💻 Úloha 5 – Index nad dátumom objednávky

💻 Úloha 5 – Index nad dátumom objednávky
Vytvorte index nad stĺpcom order_date v tabuľke orders v databáze superstore.
Index pomenujte:
idx_orders_order_date
Následne vytvorte SQL dotaz, ktorý vypočíta celkový predaj za jednotlivé mesiace.
Vo výsledku zobrazte:

mesiac objednávky,
súčet hodnoty predaja za daný mesiac.

Na zoskupenie objednávok podľa mesiaca použite funkciu DATE_TRUNC() a výsledok zoraďte podľa mesiaca vzostupne.
Ktorá z nasledujúcich tabuliek zodpovedá výsledku vášho dotazu po zoradení podľa mesiaca vzostupne?
💡 Pomôcka: Index nad dátumovým stĺpcom môže byť užitočný najmä pri dotazoch, ktoré často filtrujú, zoraďujú alebo pracujú s rozsahmi dátumov. Samotná existencia indexu však neznamená, že ho PostgreSQL použije pri každom agregačnom dotaze.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a.    month sum     2024-01-01 6062.89   2024-02-01 5921.44   2024-03-01 6664.95   2024-04-01 10472.55
- **b)** b.    month sum     2024-01-01 5921.44   2024-02-01 6062.89   2024-03-01 6664.95
- **c)** c.    month sum     2024-01-01 5921.44   2024-02-01 6062.89   2024-03-01 10472.55   2024-04-01 6664.95
- **d)** d.    month sum     2024-01-01 5921.44   2024-02-01 6062.89   2024-03-01 6664.95   2024-04-01 10472.55 ← **ZVOLENÉ**

> Vložená odpoveď: `3`

---

## Strana 8 / 14 — Otázka 6

### 💻 Úloha 6 – Viacstĺpcový index a filtrovanie podľa regiónu a dátumu

💻 Úloha 6 – Viacstĺpcový index a filtrovanie podľa regiónu a dátumu
Vytvorte viacstĺpcový index nad tabuľkou orders, ktorý bude obsahovať stĺpce customer_id a order_date.
Index pomenujte:
idx_orders_region_category
Následne vytvorte SQL dotaz, ktorý prepojí tabuľky orders a customers a zobrazí iba objednávky zákazníkov z regiónu West, ktoré boli vytvorené od 2024-01-01.
Akú hodnotu profit má vo výsledku zákazník Customer_25? Do odpovede zadajte iba číselnú hodnotu.
💡 Pomôcka: Pri viacstĺpcovom indexe záleží na poradí stĺpcov. Index (customer_id, order_date) môže byť vhodný pre dotazy, ktoré najskôr pracujú so zákazníkom a následne s dátumovým obmedzením.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 6 ← **ZVOLENÉ**

> Vložená odpoveď: `34.53`

---

## Strana 9 / 14 — Otázka 7

### 💻 Úloha 7 – Analýza plánu vykonania dotazu

💻 Úloha 7 – Analýza plánu vykonania dotazu
Pomocou príkazu EXPLAIN ANALYZE analyzujte spôsob, akým PostgreSQL vykoná dotaz na vyhľadanie objednávok konkrétneho zákazníka.
Spustite:
EXPLAIN ANALYZE
SELECT *
FROM orders
WHERE customer_id = 'C001';
Výsledkom nebude samotný obsah tabuľky, ale plán vykonania dotazu. PostgreSQL v ňom zobrazí, aký spôsob prístupu k dátam zvolil, aké podmienky aplikoval a aký bol skutočný čas vykonania.
Pri analýze plánu si všímajte najmä:

Seq Scan alebo Index Scan,
podmienku uvedenú pri Filter,
počet riadkov odstránených filtrom,
Planning Time,
Execution Time.

Zvážte či je nasledovné tvrdenie pravdivé alebo nepravdivé. Aj keď nad stĺpcom customer_id existuje index, PostgreSQL môže pri vykonaní dotazu stále zvoliť Seq Scan, ak query planner vyhodnotí sekvenčné čítanie tabuľky ako efektívnejšie.
💡 Dôležité: Aj keď nad stĺpcom existuje index, PostgreSQL ho nemusí použiť. Query planner vždy porovnáva odhadované náklady jednotlivých plánov. Pri veľmi malej tabuľke môže byť sekvenčné prečítanie celej tabuľky lacnejšie než použitie indexu.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Pravda ← **ZVOLENÉ**
- **b)** Nepravda

> Vložená odpoveď: `1`

---

## Strana 10 / 14 — Informácia

### 📘 Uložené procedúry – STORED PROCEDURES

📘 Uložené procedúry – STORED PROCEDURES
Uložená procedúra (stored procedure) je pomenovaný blok SQL a procedurálneho kódu, ktorý je uložený priamo v databáze a možno ho opakovane spúšťať.
Na rozdiel od bežného SQL dotazu môže procedúra obsahovať viacero príkazov, prijímať vstupné parametre, pracovať s premennými, vykonávať podmienky a riadiť priebeh spracovania.
Procedúry sa používajú najmä vtedy, keď potrebujeme:

opakovať rovnakú databázovú operáciu bez opätovného zapisovania celej logiky,
vykonať viac SQL príkazov ako jeden logický proces,
prijímať vstupné hodnoty prostredníctvom parametrov,
vykonávať aktualizácie, vkladanie alebo mazanie údajov,
používať podmienky IF / ELSE,
používať cykly a pomocné premenné,
zapuzdriť databázovú logiku na jednom mieste.

V PostgreSQL sa procedúry vytvárajú pomocou príkazu CREATE PROCEDURE. Procedurálna logika sa často zapisuje v jazyku PL/pgSQL.
Základná syntax
CREATE PROCEDURE procedure_name()
LANGUAGE plpgsql
AS $procedure$
BEGIN
    -- SQL statements
END;
$procedure$;
Časť BEGIN ... END označuje telo procedúry. Medzi tieto príkazy možno vložiť jeden alebo viac SQL príkazov.
Procedúru spúšťame pomocou:
CALL procedure_name();
💡 Dôležité: Procedúru nespúšťame pomocou SELECT, ale pomocou CALL.
Parametre procedúry
Procedúra môže prijímať vstupné hodnoty prostredníctvom parametrov. Vďaka tomu možno rovnakú procedúru použiť pre rôzne vstupné údaje.
Príklad:
CREATE PROCEDURE update_order_discount(
    p_order_id VARCHAR(20),
    p_discount NUMERIC(5,2)
)
LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE orders
    SET discount = p_discount
    WHERE order_id = p_order_id;
END;
$procedure$;
Procedúra má dva vstupné parametre:

p_order_id – identifikátor objednávky,
p_discount – nová hodnota zľavy.

Procedúru možno následne spustiť napríklad takto:
CALL update_order_discount('O1004', 0.15);
Po zavolaní procedúry PostgreSQL vykoná UPDATE s hodnotami odovzdanými pri volaní.
Premenné
PL/pgSQL umožňuje vytvárať aj lokálne premenné. Deklarujú sa v časti DECLARE pred blokom BEGIN.
CREATE PROCEDURE example_procedure()
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_total NUMERIC(10,2);
BEGIN
    SELECT SUM(sales)
    INTO v_total
    FROM orders;
END;
$procedure$;
Príkaz SELECT ... INTO uloží výsledok dotazu do premennej.
Podmienky IF / ELSE
Procedúry môžu obsahovať aj rozhodovaciu logiku.
IF condition THEN
    -- statements
ELSE
    -- statements
END IF;
Napríklad:
IF p_discount > 0.50 THEN
    RAISE NOTICE 'Discount is too high';
ELSE
    UPDATE orders
    SET discount = p_discount
    WHERE order_id = p_order_id;
END IF;
Takto môže procedúra najskôr overiť podmienku a až následne rozhodnúť, ktorý príkaz sa vykoná.
RAISE NOTICE
Počas práce s procedúrami možno použiť príkaz RAISE NOTICE, ktorý vypíše informačnú správu.
RAISE NOTICE 'Order % was updated', p_order_id;
Znak % sa nahradí hodnotou uvedenou za textom.
Procedúra môže vykonať viac príkazov
Jednou z hlavných výhod procedúr je možnosť spojiť viac databázových operácií do jedného pomenovaného procesu.
BEGIN
    UPDATE orders
    SET discount = p_discount
    WHERE order_id = p_order_id;

    INSERT INTO audit_log(message)
    VALUES ('Order discount updated');

    RAISE NOTICE 'Update completed';
END;
Jedno zavolanie procedúry tak môže vykonať viac krokov, ktoré spolu tvoria jednu databázovú operáciu alebo proces.
Stored procedure vs. bežný SQL dotaz


Vlastnosť
SQL dotaz
Stored procedure



Uložená v databáze
Nie nevyhnutne
Áno

Prijíma parametre
Bežne nie ako databázový objekt
Áno

Viac SQL príkazov
Samostatné príkazy
Môžu byť súčasťou jedného bloku

IF / ELSE, cykly
Nie v bežnom SELECT dotaze
Áno

Spustenie
SELECT / INSERT / UPDATE / DELETE
CALL


Procedúra vs. funkcia
V PostgreSQL existujú okrem procedúr aj funkcie. Ide o podobné databázové objekty, ale ich spôsob použitia sa líši.

Funkcia sa používa najmä vtedy, keď chceme vypočítať a vrátiť hodnotu alebo množinu riadkov.
Procedúra sa používa najmä na vykonanie databázového procesu alebo série operácií.
Funkciu možno volať napríklad pomocou SELECT.
Procedúru voláme pomocou CALL.

💡 Dôležité: Ak potrebujete získať hodnotu, často je vhodná funkcia. Ak potrebujete vykonať proces alebo viac databázových operácií, vhodným riešením môže byť procedúra.
Odstránenie procedúry
Procedúru možno odstrániť pomocou:
DROP PROCEDURE procedure_name;
⚠️ Pozor: Procedúra vykonáva SQL príkazy priamo nad databázou. Ak obsahuje UPDATE, INSERT alebo DELETE, jej spustenie môže meniť uložené dáta. Pred použitím preto vždy skontrolujte podmienky a hodnoty vstupných parametrov.

---

## Strana 11 / 14 — Otázka 8

### 💻 Príprava databázy Retail Sales

💻 Príprava databázy Retail Sales
V ďalších úlohách budete pracovať s novou databázou retail_sales. Najskôr vytvorte databázu a tabuľku podľa zadanej štruktúry a následne importujte pripravený dátový súbor.
1. Vytvorte databázu
Vo VS Code vytvorte SQL skript a pomocou príkazu CREATE DATABASE vytvorte databázu s názvom:
retail_sales
Po vytvorení databázy sa k nej pripojte a všetky ďalšie príkazy vykonávajte už v databáze retail_sales.
2. Vytvorte tabuľku orders
Tabuľka bude obsahovať údaje o objednávkach. Vytvorte ju podľa nasledujúcej štruktúry:

order_id – text s maximálnou dĺžkou 20 znakov, primárny kľúč,
customer_id – text s maximálnou dĺžkou 20 znakov, povinná hodnota,
product_id – text s maximálnou dĺžkou 20 znakov, povinná hodnota,
order_date – dátum objednávky, povinná hodnota,
region – text s maximálnou dĺžkou 20 znakov, povinná hodnota,
category – text s maximálnou dĺžkou 50 znakov, povinná hodnota,
ship_mode – text s maximálnou dĺžkou 30 znakov, povinná hodnota,
sales – číselná hodnota s presnosťou na dve desatinné miesta, povinná hodnota,
profit – číselná hodnota s presnosťou na dve desatinné miesta, povinná hodnota.

3. Nastavte formát dátumu databázy
Dátový súbor používa zápis dátumu zodpovedajúci formátu mesiac – deň – rok. Preto nastavte pre databázu retail_sales parameter datestyle na hodnotu:
ISO, MDY
Nastavenie vykonajte pomocou príkazu ALTER DATABASE.
4. Stiahnite dátový súbor
Pre tabuľku orders je pripravený CSV súbor:

retail_sales.csv

CSV súbor uložte aj do svojho Git repozitára spolu so SQL skriptom.
5. Importujte dáta pomocou pgAdmin
Po vytvorení tabuľky importujte pripravený CSV súbor do tabuľky orders pomocou nástroja Import/Export Data v prostredí pgAdmin.
Pri importe skontrolujte najmä:

správnu databázu a cieľovú tabuľku,
formát súboru CSV,
správne nastavený oddeľovač,
zapnutú možnosť Header, ak prvý riadok obsahuje názvy stĺpcov,
zhodu stĺpcov CSV súboru so štruktúrou tabuľky.

6. Overte importované dáta
Po importe overte, či sa údaje načítali správne a SQL skrip pre vytvorenie databázy a tabuľky vložte do Moodle:
SELECT *
FROM orders;
💡 Dôležité: Skontrolujte, či databáza obsahuje tabuľku orders, či boli dáta úspešne importované a či sa dátumy zobrazujú správne.
⚠️ Nezabudnite: SQL skript na vytvorenie databázy a tabuľky aj CSV súbor s dátami uložte do svojho Git repozitára a vykonajte commit a push.

**Možnosti odpovede:**

- **a)** 

> Vložená odpoveď: `<p>-- Databazove technologie (FPVaI/KI/DT/22)</p>
<p>-- Seminar 3 - Zadanie 1a: priprava databazy retail_sales</p>
<p> </p>
<p>CREATE DATABASE retail_sales;</p>
<p> </p>
<p>-- po vytvoreni sa pripojime k databaze retail_sales, dalsie prikazy uz vykonavame v nej</p>
<p> </p>
<p>CREATE TABLE orders (</p>
<p>order_id VARCHAR(20) PRIMARY KEY,</p>
<p>customer_id VARCHAR(20) NOT NULL,</p>
<p>product_id VARCHAR(20) NOT NULL,</p>
<p>order_date DATE NOT NULL,</p>
<p>region VARCHAR(20) NOT NULL,</p>
<p>category VARCHAR(50) NOT NULL,</p>
<p>ship_mode VARCHAR(30) NOT NULL,</p>
<p>sales DECIMAL(10,2) NOT NULL,</p>
<p>profit DECIMAL(10,2) NOT NULL</p>
<p>);</p>
<p> </p>
<p>-- datumy v CSV su v tvare mesiac-den-rok (napr. 1/5/2024)</p>
<p>ALTER DATABASE retail_sales SET datestyle TO 'ISO, MDY';</p>
<p> </p>
<p>-- kontrola po importe (Import/Export Data v pgAdmin, 10 000 zaznamov)</p>
<p>SELECT * FROM orders;</p>`

---

## Strana 12 / 14 — Otázka 9

### 💻 Úloha 8 – Celkový predaj zákazníka pomocou procedúry

💻 Úloha 8 – Celkový predaj zákazníka pomocou procedúry
Manažment potrebuje opakovane zisťovať celkovú hodnotu predaja konkrétneho zákazníka. Namiesto opakovaného zapisovania agregačného SQL dotazu vytvorte uloženú procedúru, ktorá túto operáciu vykoná na základe zadaného identifikátora zákazníka.
Vytvorte procedúru s názvom get_customer_sales.
Procedúra má:

prijímať ako vstupný parameter identifikátor zákazníka,
vypočítať súčet všetkých jeho predajov zo stĺpca sales,
uložiť vypočítanú hodnotu do lokálnej premennej,
vypísať identifikátor zákazníka a jeho celkový predaj pomocou RAISE NOTICE.

Pri vytváraní procedúry použite jazyk PL/pgSQL. Procedúru navrhnite tak, aby bolo možné rovnaký kód použiť pre ľubovoľného zákazníka iba zmenou hodnoty vstupného parametra.
Po vytvorení procedúry ju otestujte vytvorené riešenie pre zákazníka:
CALL get_customer_sales('C001');
Spustite procedúru pre zadaného zákazníka a do odpovede uveďte počet záznamov, ktoré procedúra vráti pomocou RAISE NOTICE.
💡 Pomôcka: Výsledok agregačného dotazu môžete uložiť do lokálnej premennej pomocou konštrukcie SELECT ... INTO. Procedúru následne spustíte pomocou príkazu CALL.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 9 ← **ZVOLENÉ**

> Vložená odpoveď: `1`

---

## Strana 13 / 14 — Otázka 10

### 💻 Úloha 9 – Procedúra na aplikovanie regionálnej zľavy

💻 Úloha 9 – Procedúra na aplikovanie regionálnej zľavy
Manažment chce počas promo akcie vedieť hromadne znížiť hodnotu predaja všetkých objednávok zákazníkov z vybraného regiónu. Vytvorte uloženú procedúru, ktorá túto operáciu automatizuje.
Procedúru pomenujte:
apply_regional_discount
Procedúra musí prijímať dva vstupné parametre:

region_name – názov regiónu, pre ktorý sa má zľava aplikovať,
discount_rate – výška zľavy zapísaná ako desatinné číslo, napríklad 0.10 pre 10 %.

Procedúra má:

nájsť všetky objednávky zákazníkov patriacich do zadaného regiónu,
znížiť hodnotu sales podľa zadanej hodnoty zľavy,
po úspešnom vykonaní vypísať informačnú správu pomocou RAISE NOTICE, ktorá uvedie použitú zľavu a názov regiónu.

Pri výpočte novej hodnoty predaja použite princíp:
new_sales = sales × (1 - discount_rate)
Procedúru následne otestujte pre región West a zľavu 10 %.
Predpokladajme, že procedúru spustíte dvakrát po sebe s rovnakými parametrami:  CALL apply_regional_discount('West', 0.10);  Čo sa stane s hodnotami sales objednávok zákazníkov z regiónu West?
💡 Pomôcka: Informácia o regióne sa nenachádza priamo v tabuľke orders. Pri aktualizácii preto budete musieť pracovať aj s tabuľkou customers a prepojiť objednávky so zákazníkmi pomocou customer_id.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** a. druhé volanie opäť zníži už znížené hodnoty o ďalších 10 %. ← **ZVOLENÉ**
- **b)** b. zľava 10 % sa aplikuje iba pri prvom spustení, druhé volanie už hodnoty nezmení
- **c)** c. PostgreSQL druhé volanie procedúry automaticky odmietne
- **d)** d. druhé volanie nastaví celkovú zľavu presne na 20 % z pôvodnej hodnoty

> Vložená odpoveď: `0`

---

## Strana 14 / 14 — Otázka 11

### 💻 Úloha 10 – Celkový predaj medzi dvoma dátumami

💻 Úloha 10 – Celkový predaj medzi dvoma dátumami
Vytvorte uloženú procedúru, ktorá umožní zistiť celkovú hodnotu predaja za ľubovoľné časové obdobie bez potreby opakovane zapisovať celý agregačný SQL dotaz.
Procedúru pomenujte:
get_sales_between
Procedúra musí prijímať dva vstupné parametre:

start_date – dátum začiatku sledovaného obdobia,
end_date – dátum konca sledovaného obdobia.

Procedúra má:

vybrať objednávky, ktorých dátum sa nachádza medzi zadanými hodnotami start_date a end_date,
vypočítať súčet stĺpca sales pre vybrané obdobie,
uložiť výsledok do lokálnej premennej,
vypísať začiatok obdobia, koniec obdobia a vypočítanú hodnotu pomocou RAISE NOTICE.

Procedúru následne otestujte pre obdobie od 2024-01-01 do 2024-03-31.
Akú hodnotu celkového predaja vypíše procedúra pre obdobie od 2024-01-01 do 2024-03-31? Do odpovede zadajte iba číselnú hodnotu.
⚠️ Nezabudnite: SQL riešenie uložte do svojho súboru pre subqueries a po dokončení vykonajte commit a push do Git repozitára.

**Možnosti odpovede:**

- **a)** Odpoveď: Otázka 11 ← **ZVOLENÉ**

> Vložená odpoveď: `18649.28`

---
