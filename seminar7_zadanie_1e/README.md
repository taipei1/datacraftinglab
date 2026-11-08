# Seminár 7 – Zadanie 1e: Pagila (snehová vločka)

## Riešenie

- **Grain faktovej tabuľky:** 1 riadok `fact_rental` = 1 výpožička jednej
  kópie filmu (`inventory`) jedným zákazníkom, obsluhovaná jedným
  zamestnancom v konkrétnom obchode.
- **Faktová tabuľka:** `fact_rental` – `rental_fee`, `rental_days`,
  `late_days`, `late_fee`, `rental_count`, `is_returned`; cudzie kľúče na
  `dim_date` (dva role-playing odkazy: dátum výpožičky a dátum vrátenia),
  `dim_customer`, `dim_staff`, `dim_inventory`; `rental_id` je degenerovaný
  kľúč.
- **Prvá úroveň dimenzií:** `dim_date`, `dim_customer`, `dim_staff`,
  `dim_inventory`.
- **Druhá a ďalšia úroveň (snehová vločka):**
  - `dim_customer → dim_address → dim_city → dim_country`,
  - `dim_staff → dim_store → dim_address → dim_city → dim_country`,
  - `dim_inventory → dim_film → dim_language`,
  - `dim_inventory → dim_store → dim_address → dim_city → dim_country`.
- **Bridge tabuľka:** `bridge_film_category` rieši M:N vzťah film –
  kategória. Film môže mať viac kategórií a kategória viac filmov, preto
  priama väzba na `dim_film` by nebola korektná.
- **Prečo snehová vločka:** adresa, mesto a krajina tvoria normalizovanú
  hierarchiu; film a obchod sú pripojené cez `dim_inventory`. Znižuje sa
  redundancia a dimenzie možno filtrovať na jednotlivých úrovniach.
  Nevýhodou je viac JOINov.
- **Poznámka k cenám:** v zjednodušenej 3NF schéme Pagila z Moodle nie je
  tabuľka `payment`. Fakt preto používa `film.rental_rate` ako
  `rental_fee` a odvodené `late_days` / `late_fee`. Ak by boli dostupné
  platby, `payment` by sa dal doplniť ako samostatná faktová tabuľka alebo
  ako miera do `fact_rental`.

## Súbory

- `pagila_snowflake_erd.png` – ERD snehovej vločky (fakt v strede).
- `pagila_snowflake_ddl.sql` – PostgreSQL DDL vrátane PK/FK, CHECK
  obmedzení a indexov.
- `seminar7_1e_pagila_snowflake.zip` – jeden archív na odovzdanie.

## Poznámka k zdroju

Vychádzalo sa zo 3NF schémy Pagila z Moodle: `actor`, `film_actor`, `film`,
`film_category`, `category`, `language`, `customer`, `rental`, `inventory`,
`staff`, `store`, `address`, `city`, `country`. Tabuľky `actor` a
`film_actor` nie sú súčasťou DWH návrhu, pretože pre analýzu predaja
(nájmu) nie sú potrebné; ich doplnenie by bolo možné cez ďalšiu bridge
tabuľku `bridge_film_actor` a `dim_actor`.
