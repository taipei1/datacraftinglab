# Seminár 6 – Zadanie 1a: otázky, odpovede a vysvetlenia

Tento súbor je študijná poznámka k testu „Seminár 6 – Zadanie 1a“.
Test bol odoslaný 1. 11. 2026. Výsledok: otázky 1, 3, 4, 5, 6, 7 správne; otázka 2 nesprávna (príliš dlhá odpoveď); otázka 8 odovzdaná ako príloha.

---

## Otázka 1

**Ktorá formulácia najlepšie vystihuje dátový sklad (DWH) podľa Inmon/Kimball?**

- a. Databáza v 3NF s prísnou normalizáciou, kde sa historické dáta ukladajú výhradne formou UPDATE, aby sa šetrilo miesto.
- b. Akékoľvek úložisko, ktoré podporuje SQL a má aspoň jeden dashboard, historizácia a integrácia nie sú podmienkou.
- c. Centrálna tabuľka faktov a povinné snowflake dimenzie, inak systém nespĺňa definíciu DWH.
- d. Predmetovo orientované, integrované, časovo variabilné a logicky nemeniteľné úložisko optimalizované na analytické čítanie a agregácie.

**Správna odpoveď: d.**

**Vysvetlenie:** DWH je predmetovo orientované, integrované, časovo variabilné a nemeniteľné úložisko určené na analytické čítanie, agregácie a historické porovnávania. Star/snowflake je spôsob modelovania, nie podmienka definície DWH.

---

## Otázka 2

**Čo je kľúčový rozdiel medzi OLTP a OLAP?**

**Odporúčaná krátka odpoveď na test:**
> OLTP slúži na transakčné spracovanie, OLAP na analytické spracovanie a agregácie.

**Vysvetlenie:**
- **OLTP** – veľa malých transakcií v reálnom čase, INSERT/UPDATE/DELETE, normalizovaný model, aktuálny stav, dôraz na rýchly zápis a konzistenciu.
- **OLAP** – analytické dotazy a agregácie nad veľkým objemom historických dát, denormalizované dimenzionálne schémy (hviezda/snehová vločka), dôraz na rýchle čítanie.

> **Poznámka z testu:** Dlhá, vecne správna odpoveď bola automaticky vyhodnotená ako nesprávna. Short-answer otázka zrejme očakávala veľmi krátku formuláciu. Na test si zapamätaj hlavne vetu „OLTP = transakcie, OLAP = analýza“.

---

## Otázka 3

**Aký dopad má Snowflake schéma na dotazy v porovnaní so Star schémou?**

- a. žiadny dopad, počet klauzúl JOIN je identický
- b. Snowflake schéma neumožňuje hierarchie, pretože nepodporuje GROUP BY
- c. viac klauzúl JOIN a komplexnejšie dotazy a prínosom je menšia redundancia
- d. menej klauzúl JOIN a všetky hierarchie sú v jednej tabuľke

**Správna odpoveď: c.**

**Vysvetlenie:** Snowflake normalizuje dimenzie do viacerých tabuliek, takže dotazy potrebujú viac JOINov. Výhodou je menšia redundancia a lepšia konzistencia.

---

## Otázka 4

**Priraď, či patrí daný prvok do tabuľky faktov alebo dimenzií:**

| Prvok | Zaradenie |
|---|---|
| `order_amount` | **Fakt** |
| `order_quantity` | **Fakt** |
| `customer_key` | **Fakt** (cudzí kľúč vo faktovej tabuľke) |
| `customer_segment` | **Dimenzia** |
| `product_category` | **Dimenzia** |
| `month/quarter/year` | **Dimenzia** (časová dimenzia) |

**Vysvetlenie:** Miery a cudzie kľúče patria do faktovej tabuľky. Popisné atribúty a hierarchie patria do dimenzií. `customer_key` je technicky cudzí kľúč, preto je vo faktovej tabuľke, hoci odkazuje na dimenziu.

---

## Otázka 5

**Vyberte tvrdenia, ktoré sú pre SCD2 správne.**

- a. história sa neuchováva, iba sa prepisuje aktuálny riadok
- b. pri zmene sa pôvodný aktuálny riadok „uzavrie“ a vloží sa nový riadok s novou hodnotou
- c. používa sa reprezentácia platnosti záznamu pomocou stĺpcov `start_date` alebo `end_date`
- d. SCD2 nedokáže spätne analyzovať stav v čase

**Správne odpovede: b, c.**

**Vysvetlenie:** SCD2 uchováva plnú históriu tak, že starý riadok uzavrie (napr. `end_date`, `is_current = false`) a vloží nový aktuálny riadok. Na analýzu „ako to bolo v čase“ sa používajú dátumy platnosti.

---

## Otázka 6

**Čo sa stane pri použití `INSERT ... ON CONFLICT DO UPDATE` v PostgreSQL?**

- a. príkaz slúži iba na aktualizáciu existujúcich záznamov
- b. ak záznam s daným kľúčom existuje, aktualizuje sa; ak neexistuje, vloží sa nový
- c. existujúci záznam sa najprv vymaže a následne sa vloží nový
- d. vždy sa vloží nový záznam bez ohľadu na existujúci kľúč

**Správna odpoveď: b.**

**Vysvetlenie:** Ide o tzv. upsert – podľa konfliktu na unikátnom kľúči sa vykoná UPDATE, inak INSERT.

---

## Otázka 7

**SCD3 uchováva plnú históriu všetkých zmien.**

- Pravda
- Nepravda

**Správna odpoveď: Nepravda.**

**Vysvetlenie:** SCD3 uchováva len aktuálnu a predošlú hodnotu (napr. `current_value`, `previous_value`), nie plnú históriu. Plnú históriu uchováva SCD2.

---

## Otázka 8 – MovieLens

**Zadanie:** Navrhnite hviezdicovú schému pre MovieLens (ratings, movies, users, prípadne tags). Odovzdajte ERD (.png) a DDL skripty s PK/FK a dátovými typmi.

**Riešenie:**
- **Grain:** 1 riadok `fact_rating` = 1 hodnotenie jedného filmu jedným používateľom v konkrétnom čase.
- **Faktová tabuľka:** `fact_rating` – `rating`, `rating_count` (konštantne 1), cudzie kľúče `date_key`, `user_key`, `movie_key`.
- **Dimenzie:** `dim_date`, `dim_user`, `dim_movie`, `dim_genre`.
- **Bridge:** `bridge_movie_genre` pre M:N vzťah film – žáner. Voliteľne `bridge_movie_tag` + `dim_tag` pre tagy.
- **Prečo bridge:** žáner je multi-valued atribút; bez bridge by vznikali duplicitné riadky alebo nekonzistentné agregácie.

**Odovzdané súbory:**
- `movielens_erd.png`
- `movielens_ddl.sql`
- `seminar6_1a_movielens.zip` (ERD + DDL + README)

---

## Rýchle opakovanie pred testom

1. DWH = predmetovo orientované, integrované, časovo variabilné, nemeniteľné.
2. OLTP = transakcie; OLAP = analýza a agregácie.
3. Star = menej JOINov, denormalizované dimenzie; Snowflake = viac JOINov, menšia redundancia.
4. Fakt = miery + cudzie kľúče; dimenzia = popisné atribúty.
5. SCD1 = prepis; SCD2 = nový riadok + platnosť; SCD3 = aktuálna + predošlá hodnota.
6. `INSERT ... ON CONFLICT DO UPDATE` = upsert.
7. Bridge tabuľka = M:N vzťah (film – žáner).
