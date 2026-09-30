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