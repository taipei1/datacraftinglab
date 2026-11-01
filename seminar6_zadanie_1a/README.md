# Seminár 6 – Zadanie 1a: MovieLens

## Riešenie
- **Grain faktovej tabuľky:** 1 riadok `fact_rating` = 1 hodnotenie jedného filmu jedným používateľom v konkrétnom čase.
- **Faktová tabuľka:** `fact_rating` – `rating`, `rating_count` (konštantne 1), cudzie kľúče na `dim_date`, `dim_user`, `dim_movie`.
- **Dimenzie:** `dim_date`, `dim_user`, `dim_movie`, `dim_genre`.
- **Bridge:** `bridge_movie_genre` rieši M:N vzťah film – žáner. Voliteľne `bridge_movie_tag` + `dim_tag` pre tagy.
- **Prečo nie je všetko v jednej tabuľke:** žáner je multi-valued atribút; bridge zabraňuje redundancii a umožňuje korektné agregácie podľa žánru.

## Súbory
- `movielens_erd.png` – ERD hviezdicovej schémy.
- `movielens_ddl.sql` – PostgreSQL DDL s PK/FK, dátovými typmi a indexmi.
- `seminar6_1a_movielens.zip` – jeden súbor na odovzdanie (ERD + DDL + tento README).

## Odpovede z testu 1a
1. **d** – predmetovo orientované, integrované, časovo variabilné, logicky nemeniteľné úložisko pre analytické čítanie.
2. OLTP = veľa malých transakcií v reálnom čase, normalizovaný model, aktuálny stav; OLAP = analytické dotazy a agregácie nad historickými dátami, denormalizované dimenzionálne schémy (hviezda/snehová vločka), optimalizácia na čítanie.
3. **c** – viac JOINov, komplexnejšie dotazy, menšia redundancia.
4. `order_amount` Fakt; `order_quantity` Fakt; `customer_key` Fakt; `customer_segment` Dimenzia; `product_category` Dimenzia; `month/quarter/year` Dimenzia.
5. **b, c** – uzavretie starého riadku + vloženie nového; platnosť cez `start_date`/`end_date`.
6. **b** – ak kľúč existuje, aktualizuje sa, inak sa vloží nový záznam.
7. **Nepravda** – SCD3 uchováva len aktuálnu a predošlú hodnotu, nie plnú históriu.
