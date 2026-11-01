# Týždeň 6 – Dátové sklady a dimenzionálne modelovanie

Tento priečinok obsahuje riešenia seminára 6 pre predmet **Databázové technológie**.
Všetky tri zadania boli odovzdané v Moodle dňa 1. 11. 2026.

## Štruktúra

```
week-06/
├── MovieLens/
│   ├── age_group.csv, genres_movies.csv, genres.csv, movies.csv,
│   │   occupations.csv, ratings.csv, users.csv
│   ├── movielens_erd.png
│   └── movielens_ddl.sql
├── Chinook/
│   ├── Chinook_PostgreSql.sql
│   ├── chinook_erd.png
│   └── chinook.sql
└── Northwind/
    ├── northwind.sql
    ├── northwind_erd.png
    └── northwind_ddl.sql
```

## Kľúčové pojmy na test

### Dátový sklad (DWH)
Podľa Inmona/Kimballa je to **predmetovo orientované, integrované, časovo variabilné a logicky nemeniteľné** úložisko údajov, navrhnuté na analytické čítanie, agregácie a historické porovnávania.

- **Predmetová orientácia** – dáta sú usporiadané podľa tém (predaj, zákazník, produkt), nie podľa aplikácie.
- **Integrácia** – zjednotenie formátov a hodnôt z rôznych zdrojov (WEST/West → West).
- **Časová variabilita** – uchováva sa história, nie len aktuálny stav.
- **Nemeniteľnosť** – do DWH sa primárne nahráva a číta, historické záznamy sa neprepisujú.

### OLTP vs OLAP

| Vlastnosť | OLTP | OLAP |
|---|---|---|
| Účel | každodenné transakcie | analytika, reporting |
| Operácie | INSERT/UPDATE/DELETE, veľa malých transakcií | SELECT, agregácie nad veľkým objemom dát |
| Dáta | aktuálny stav | história, časové porovnania |
| Model | normalizovaný (3NF) | denormalizovaný, hviezda/snehová vločka |
| Optimalizácia | rýchly zápis, konzistencia | rýchle čítanie a agregácie |

> **Pozor na test:** Otázka 2 v Moodle je short-answer a vyžaduje veľmi krátku odpoveď.
> Najbezpečnejšia formulácia je napr.:
> **„OLTP slúži na transakčné spracovanie, OLAP na analytické spracovanie a agregácie.“**
> Dlhá odpoveď s mnohými vetami bola automaticky vyhodnotená ako nesprávna, hoci vecne popisovala rozdiel.

### Hviezda (Star) vs snehová vločka (Snowflake)

- **Star schema** – jedna centrálna faktová tabuľka a denormalizované dimenzie. Menej JOINov, jednoduchšie a rýchlejšie dotazy.
- **Snowflake schema** – dimenzie sú normalizované do viacerých tabuliek (napr. produkt → kategória → nadkategória). Viac JOINov, zložitejšie dotazy, menšia redundancia.

### Faktová tabuľka a dimenzie

- **Grain** = čo predstavuje jeden riadok faktovej tabuľky. Musí byť určený pred návrhom.
- **Faktová tabuľka** obsahuje cudzie kľúče na dimenzie a **miery/metriky** (napr. `rating`, `quantity`, `unit_price`, `line_amount`).
- **Dimenzia** obsahuje popisné atribúty na filtrovanie a zoskupovanie (napr. zákazník, produkt, čas, žáner).
- **Degenerovaný kľúč** – napr. `invoice_id` alebo `order_id` zostáva vo faktovej tabuľke bez samostatnej dimenzie.
- **Bridge tabuľka** – rieši M:N vzťah, napr. film – žáner (`bridge_movie_genre`).

### Pomaly sa meniace dimenzie (SCD)

- **SCD1** – prepis existujúcej hodnoty, bez histórie.
- **SCD2** – uzavretie starého riadku (`end_date`, `is_current = false`) a vloženie nového riadku s novou hodnotou; uchováva plnú históriu.
- **SCD3** – uchováva len aktuálnu a predošlú hodnotu v samostatných stĺpcoch (`current_value`, `previous_value`); neuchováva plnú históriu.

### Upsert

`INSERT ... ON CONFLICT ... DO UPDATE` – ak kľúč existuje, aktualizuje sa; inak sa vloží nový záznam.

## Riešenia – stručne

### 1a – MovieLens
- **Grain:** 1 riadok `fact_rating` = 1 hodnotenie jedného filmu jedným používateľom v danom čase.
- **Fakt:** `rating`, `rating_count` (konštantne 1).
- **Dimenzie:** `dim_date`, `dim_user`, `dim_movie`, `dim_genre`.
- **Bridge:** `bridge_movie_genre` pre M:N film – žáner; voliteľne `bridge_movie_tag` + `dim_tag`.

### 1b – Chinook
- **Grain:** 1 riadok `fact_invoice_line` = 1 položka faktúry.
- **Fakt:** `quantity`, `unit_price`, `line_amount`.
- **Dimenzie:** `dim_date`, `dim_customer`, `dim_track`, `dim_employee`.
- **Denormalizácia:** album, interpret, žáner a médium sú v `dim_track` – jednoduchá hviezda.

### 1c – Northwind (voliteľné)
- **Grain:** 1 riadok `fact_order_line` = 1 položka objednávky.
- **Fakt:** `quantity`, `unit_price`, `discount`, `line_amount`.
- **Dimenzie:** `dim_date`, `dim_customer`, `dim_product`, `dim_employee`, `dim_shipper`.
- **Denormalizácia:** kategória a dodávateľ sú v `dim_product`.

## Výsledok testu 1a

- Otázky 1, 3, 4, 5, 6, 7: **správne**.
- Otázka 2 (short answer): **nesprávna** – odpoveď bola príliš dlhá; viď poznámka vyššie.
- Otázka 8 (MovieLens ERD + DDL): odovzdaná príloha `seminar6_1a_movielens.zip`.
- Test bol odoslaný a ukončený.
