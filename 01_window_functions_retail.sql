-- ============================================================
-- Databázové technológie (FPVaI/KI/DT/22) | Týždeň 4
-- 01_window_functions_retail.sql
-- Seminár 4 - Zadanie 1c: window functions nad databázou retail
-- Dáta: online_retail.csv (92 822 záznamov)
-- ============================================================

-- ------------------------------------------------------------
-- Úloha 1 - Príprava databázy a tabuľky retail_sales
-- ------------------------------------------------------------
CREATE DATABASE retail;

-- po vytvorení sa k databáze pripojíme a pokračujeme v nej
-- \c retail

CREATE TABLE retail_sales (
    invoice_no    VARCHAR(20),
    stock_code    VARCHAR(50),
    description   TEXT,
    quantity      INTEGER,
    invoice_date  TIMESTAMP,
    unit_price    NUMERIC(10,2),
    customer_id   INTEGER,
    country       VARCHAR(100)
);

-- dátumy sú v CSV v tvare den.mesiac.rok, preto nastavíme DMY
-- (Import/Export Data v pgAdmin, CSV, hlavička zapnutá, oddeľovač ;)
SELECT * FROM retail_sales;

-- ------------------------------------------------------------
-- Úloha 2 - Tržby zákazníka za posledných 14 dní
-- vlastný časový rámec pre každého zákazníka (RANGE + interval)
-- ------------------------------------------------------------
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    quantity,
    unit_price,
    quantity * unit_price AS revenue,
    SUM(quantity * unit_price) OVER (
        PARTITION BY customer_id
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '14 days' PRECEDING AND CURRENT ROW
    ) AS revenue_last_14_days
FROM retail_sales
WHERE customer_id IS NOT NULL
ORDER BY customer_id, invoice_date;

-- ------------------------------------------------------------
-- Úloha 3 - Priemerné množstvo predaja za posledných 7 dní
-- priemer zvlášť pre kombináciu produktu a krajiny
-- ------------------------------------------------------------
SELECT
    stock_code,
    country,
    invoice_date,
    quantity,
    ROUND(AVG(quantity) OVER (
        PARTITION BY stock_code, country
        ORDER BY invoice_date
        RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
    ), 2) AS avg_quantity_7_days
FROM retail_sales
WHERE quantity > 1
ORDER BY stock_code, country, invoice_date;

-- kontrola pre prvý záznam produktu 10002 v krajine EIRE
SELECT *
FROM (
    SELECT
        stock_code,
        country,
        invoice_date,
        quantity,
        ROUND(AVG(quantity) OVER (
            PARTITION BY stock_code, country
            ORDER BY invoice_date
            RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
        ), 2) AS avg_quantity_7_days
    FROM retail_sales
    WHERE quantity > 1
) t
WHERE stock_code = '10002' AND country = 'EIRE'
ORDER BY invoice_date;

-- ------------------------------------------------------------
-- Úloha 4 - Počet dní do nasledujúcej objednávky zákazníka
-- najskôr jedinečné faktúry, potom LEAD() na dátum
-- ------------------------------------------------------------
WITH invoices AS (
    SELECT DISTINCT
        customer_id,
        invoice_no,
        invoice_date::date AS invoice_date
    FROM retail_sales
    WHERE customer_id IS NOT NULL
),
next_invoices AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        LEAD(invoice_date) OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) AS next_invoice_date
    FROM invoices
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    next_invoice_date,
    next_invoice_date - invoice_date AS days_to_next_invoice
FROM next_invoices
WHERE next_invoice_date IS NOT NULL
ORDER BY days_to_next_invoice DESC;

-- ------------------------------------------------------------
-- Úloha 5 - Zmena ceny produktu oproti predchádzajúcej hodnote
-- LAG() s PARTITION BY stock_code
-- ------------------------------------------------------------
WITH prices AS (
    SELECT
        stock_code,
        invoice_no,
        invoice_date,
        LAG(unit_price) OVER (
            PARTITION BY stock_code
            ORDER BY invoice_date
        ) AS previous_price,
        unit_price AS current_price
    FROM retail_sales
)
SELECT
    stock_code,
    invoice_no,
    invoice_date,
    previous_price,
    current_price,
    current_price - previous_price AS price_difference
FROM prices
WHERE previous_price IS NOT NULL
  AND current_price <> previous_price
ORDER BY invoice_date;

-- ------------------------------------------------------------
-- Úloha 6 - Rozdelenie zákazníkov do kvartilov podľa celkového predaja
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY customer_id
)
SELECT
    customer_id,
    total_amount,
    NTILE(4) OVER (ORDER BY total_amount DESC) AS sales_quartile
FROM customer_sales
ORDER BY total_amount DESC;

-- ------------------------------------------------------------
-- Úloha 7 - Kvartily mesačného predaja podľa krajiny
-- ------------------------------------------------------------
WITH monthly_sales AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date) AS month,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    GROUP BY country, DATE_TRUNC('month', invoice_date)
)
SELECT
    country,
    month,
    total_amount,
    NTILE(4) OVER (
        PARTITION BY country
        ORDER BY total_amount DESC
    ) AS sales_quartile
FROM monthly_sales
ORDER BY country, month;

-- ------------------------------------------------------------
-- Úloha 8 - Prvý nákup každého zákazníka
-- ROW_NUMBER() od najstaršej faktúry, ponecháme poradie 1
-- ------------------------------------------------------------
WITH numbered_purchases AS (
    SELECT
        customer_id,
        invoice_no,
        invoice_date,
        stock_code,
        description,
        quantity,
        unit_price,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY invoice_date
        ) AS row_num
    FROM retail_sales
    WHERE customer_id IS NOT NULL
)
SELECT
    customer_id,
    invoice_no,
    invoice_date,
    stock_code,
    description,
    quantity,
    unit_price
FROM numbered_purchases
WHERE row_num = 1
ORDER BY customer_id;

-- ------------------------------------------------------------
-- Úloha 9 - Tri najhodnotnejšie položky každej faktúry
-- ------------------------------------------------------------
WITH ranked_items AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        quantity * unit_price AS amount,
        ROW_NUMBER() OVER (
            PARTITION BY invoice_no
            ORDER BY quantity * unit_price DESC
        ) AS row_num
    FROM retail_sales
)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    amount,
    row_num
FROM ranked_items
WHERE row_num <= 3
ORDER BY invoice_no, row_num;

-- ------------------------------------------------------------
-- Úloha 10 - Poradie zákazníkov podľa mesačného predaja
-- DENSE_RANK() pre každú kombináciu krajiny a mesiaca
-- ------------------------------------------------------------
WITH customer_month AS (
    SELECT
        country,
        DATE_TRUNC('month', invoice_date) AS month,
        customer_id,
        SUM(quantity * unit_price) AS total_amount
    FROM retail_sales
    WHERE customer_id IS NOT NULL
    GROUP BY country, DATE_TRUNC('month', invoice_date), customer_id
),
ranked_customers AS (
    SELECT
        country,
        month,
        customer_id,
        total_amount,
        DENSE_RANK() OVER (
            PARTITION BY country, month
            ORDER BY total_amount DESC
        ) AS sales_rank
    FROM customer_month
)
SELECT
    country,
    month,
    customer_id,
    total_amount,
    sales_rank
FROM ranked_customers
WHERE sales_rank <= 5
ORDER BY country, month, sales_rank, customer_id;

-- ------------------------------------------------------------
-- Úloha 11 - Päť najvyšších cien na každej faktúre
-- DENSE_RANK() podľa jednotkovej ceny
-- ------------------------------------------------------------
WITH ranked_prices AS (
    SELECT
        invoice_no,
        stock_code,
        description,
        quantity,
        unit_price,
        DENSE_RANK() OVER (
            PARTITION BY invoice_no
            ORDER BY unit_price DESC
        ) AS price_rank
    FROM retail_sales
)
SELECT
    invoice_no,
    stock_code,
    description,
    quantity,
    unit_price,
    price_rank
FROM ranked_prices
WHERE price_rank <= 5
ORDER BY invoice_no, price_rank, stock_code;
