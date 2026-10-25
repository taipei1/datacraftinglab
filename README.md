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

## Vetva week-05

Obsahuje notebooky a dátové súbory k cvičeniam 5. týždňa:

```
week-05
│
├── file_handling.ipynb            práca so súbormi (Excel, CSV, Parquet)
├── error_handling.ipynb           validácia dát a spracovanie chýb
│
├── sales_report.xlsx              vstup – Excel
├── employees.csv                  vstup – CSV
├── sales_report+(1).csv           vstup – CSV pre Parquet
├── sales_data_dirty.csv           vstup – nekonzistentné dáta
│
├── west_region_sales.xlsx         výstup (filtrácia regiónu West)
├── it_employees.csv               výstup (IT oddelenie)
├── high_salary.csv                výstup (nadpriemerné platy)
├── sales_report.parquet           výstup (CSV → Parquet)
├── sales_report2.parquet          výstup (nový Parquet dataset)
├── sales_data_clean.csv           výstup validácie – čisté dáta
├── sales_data_rejected.csv        výstup validácie – zamietnuté záznamy
├── validation_report.csv          výstup validácie – prehľad pravidiel
│
├── green_tripdata_2024-01.parquet pridelený NYC Green Taxi dataset
└── yellow_tripdata_2024-01.parquet NYC Yellow Taxi dataset
```

- `file_handling.ipynb` — načítanie a zápis CSV, XLSX a Parquet, schéma a metadáta
  Parquet súboru, row groups, column pruning, samostatné úlohy 1–6 nad Green Taxi dátami.
- `error_handling.ipynb` — bezpečné načítanie, audit datasetu, validačné pravidlá pre
  OrderID, kategórie, čísla, dátumy a telefónne čísla, validačný report, oddelenie
  čistých a zamietnutých záznamov.
