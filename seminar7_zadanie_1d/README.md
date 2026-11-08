# Seminár 7 – Zadanie 1d: Northwind (snehová vločka)

## Riešenie

- **Grain faktovej tabuľky:** 1 riadok `fact_order_line` = 1 položka objednávky
  (jeden produkt v jednej objednávke).
- **Faktová tabuľka:** `fact_order_line` – `quantity`, `unit_price`, `discount`,
  `line_amount`; cudzie kľúče na `dim_date`, `dim_customer`, `dim_product`,
  `dim_employee`, `dim_shipper`; `order_id` je degenerovaný kľúč.
- **Prvá úroveň dimenzií:** `dim_date`, `dim_customer`, `dim_product`,
  `dim_employee`, `dim_shipper`.
- **Druhá úroveň (snehová vločka):**
  - `dim_customer → dim_city → dim_country`,
  - `dim_employee → dim_city → dim_country`,
  - `dim_shipper → dim_city → dim_country`,
  - `dim_product → dim_category`,
  - `dim_product → dim_supplier → dim_city → dim_country`.
- **Prečo snehová vločka:** kategória, dodávateľ a geografická hierarchia
  (mesto → krajina) sú vyčlenené do samostatných tabuliek. Odstraňuje sa
  redundancia opakovaných textov a dimenzie sa dajú filtrovať na každej
  úrovni hierarchie. Nevýhodou je viac JOINov pri analytických dotazoch.

## Súbory

- `northwind_snowflake_erd.png` – ERD snehovej vločky (fakt v strede).
- `northwind_snowflake_ddl.sql` – PostgreSQL DDL vrátane PK/FK, CHECK
  obmedzení a indexov.
- `seminar7_1d_northwind_snowflake.zip` – jeden archív na odovzdanie.

## Poznámka k zdroju

Vychádzalo sa zo zjednodušenej 3NF schémy Northwind z Moodle
(`categories`, `suppliers`, `products`, `shippers`, `customers`, `employees`,
`orders`, `orderdetails`). Ceny a zľavy sú vo faktovej tabuľke preto, lebo
`OrderDetails` v Northwind ich bežne obsahuje a pre analytiku predaja sú
potrebné.
