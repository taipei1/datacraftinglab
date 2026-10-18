# Datacraftinglab

Repozitár k predmetu Databázové technológie (FPVaI/KI/DT/22) — 1. týždeň.

## Vetva week-01

Obsahuje SQL skripty a dátové súbory k cvičeniam 1. týždňa:

```
week-01
│
├── 01_create_tables.sql
├── 02_joins.sql
├── 03_aggregations.sql
├── 04_subqueries.sql
│
├── customers.csv
├── orders.csv
├── products.csv
└── FlourMills_Sales_2022_2024.csv
```

- `01_create_tables.sql` — vytvorenie databázy Northwind a tabuliek (Customers, Orders, Products, OrderDetails, ...).
- `02_joins.sql` — spájanie tabuliek (JOIN, LEFT JOIN).
- `03_aggregations.sql` — agregácie a zoskupovanie (GROUP BY, HAVING).
- `04_subqueries.sql` — vnorené dotazy k databáze `datacraftinglab_db`, tabuľka `flourmills_sales` (CREATE DATABASE/TABLE + 14 úloh).
- `northwind_data.sql` — vkladané dáta Northwind (INSERT).
- `FlourMills_Sales_2022_2024.csv` — zdrojové dáta k tabuľke `flourmills_sales` (10 000 záznamov).

Dátové súbory sú v repozitári zámerne, aby bolo možné databázy a riešenia znovu vytvoriť.

## Vetva week-04

Obsahuje SQL skripty a dátové súbory k cvičeniam 4. týždňa:

```
week-04
│
├── 01_window_functions_retail.sql
├── 02_window_functions.sql
│
└── online_retail.csv
```

- `01_window_functions_retail.sql` — window functions nad databázou `retail` (tabuľka `retail_sales`,
  11 úloh: príprava tabuľky, rámce RANGE, LAG/LEAD, NTILE, ROW_NUMBER, RANK/DENSE_RANK).
- `02_window_functions.sql` — window functions nad databázou `superstore` (tabuľky `customers`,
  `orders`, `products`, 8 úloh).
- `online_retail.csv` — zdrojové dáta k tabuľke `retail_sales` (92 822 záznamov, oddeľovač `;`).

Archív zadania: `seminar4_zadanie_1c/`, `seminar4_zadanie_1d/`.
