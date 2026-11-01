# Seminár 6 – Zadanie 1c: Northwind (voliteľné)

## Riešenie
- **Grain:** 1 riadok `fact_order_line` = 1 položka objednávky (jeden produkt v jednej objednávke).
- **Fakt:** `quantity`, `unit_price`, `discount`, `line_amount` (= quantity * unit_price * (1 - discount)).
- **Dimenzie:** `dim_date`, `dim_customer`, `dim_product`, `dim_employee`, `dim_shipper`.
- **Denormalizácia:** kategória a dodávateľ sú v `dim_product`; pre detailnejšie členenie ich možno normalizovať.

## Súbory
- `northwind_erd.png`
- `northwind_ddl.sql`
- `seminar6_1c_northwind.zip`
