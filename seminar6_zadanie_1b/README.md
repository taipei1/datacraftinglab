# Seminár 6 – Zadanie 1b: Chinook

## Riešenie
- **Grain:** 1 riadok `fact_invoice_line` = 1 položka faktúry (jeden track na jednom invoice line).
- **Fakt:** `quantity`, `unit_price`, `line_amount` (= quantity * unit_price).
- **Dimenzie:** `dim_date`, `dim_customer`, `dim_track`, `dim_employee`.
- **Denormalizácia:** album, interpret, žáner a médium sú v `dim_track`, aby vznikla jednoduchá hviezda bez zbytočných JOINov.
- **Degenerovaný kľúč:** `invoice_id` zostáva vo faktovej tabuľke.

## Súbory
- `chinook_erd.png`
- `chinook_ddl.sql`
- `seminar6_1b_chinook.zip`
