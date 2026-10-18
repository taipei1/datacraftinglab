-- ============================================================
-- Databázové technológie (FPVaI/KI/DT/22) | Týždeň 4
-- 02_window_functions.sql
-- Seminár 4 - Zadanie 1d: window functions nad databázou superstore
-- Tabuľky: customers, orders, products
-- ============================================================

-- ------------------------------------------------------------
-- Úloha 1 - Posledné dve objednávky každého zákazníka
-- ------------------------------------------------------------
SELECT
    customer_name,
    order_id,
    order_date
FROM (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC
        ) AS row_num
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
) t
WHERE row_num <= 2
ORDER BY customer_name, row_num;

-- ------------------------------------------------------------
-- Úloha 2 - Poradie zákazníkov podľa zisku v rámci regiónu
-- RANK() vs. DENSE_RANK()
-- ------------------------------------------------------------
WITH customer_profit AS (
    SELECT
        c.region,
        c.customer_name,
        SUM(o.profit) AS total_profit
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.region, c.customer_name
)
SELECT
    region,
    customer_name,
    total_profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_rank,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_dense_rank
FROM customer_profit
ORDER BY region, profit_rank, customer_name;

-- ------------------------------------------------------------
-- Úloha 3 - Rozdelenie zákazníkov do kvartilov podľa predaja
-- ------------------------------------------------------------
WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_name
)
SELECT
    customer_name,
    total_sales,
    NTILE(4) OVER (ORDER BY total_sales DESC) AS quartile
FROM customer_sales
ORDER BY total_sales DESC;

-- kontrola tvrdenia o zákazníkovi Customer_26
SELECT *
FROM (
    SELECT
        c.customer_name,
        SUM(o.sales) AS total_sales,
        NTILE(4) OVER (ORDER BY SUM(o.sales) DESC) AS quartile
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_name
) t
WHERE customer_name = 'Customer_26';

-- ------------------------------------------------------------
-- Úloha 4 - Porovnanie mesačného predaja s predchádzajúcim
-- a nasledujúcim mesiacom (LAG a LEAD)
-- ------------------------------------------------------------
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month)  AS prev_month_sales,
    LEAD(monthly_sales) OVER (ORDER BY month) AS next_month_sales
FROM monthly_sales
ORDER BY month;

-- ------------------------------------------------------------
-- Úloha 5 - Zjednodušenie výpočtu podielu produktu v kategórii
-- pôvodný dotaz chýbal operátor AND medzi stĺpcami a miešal
-- agregáciu s window function v jednom kroku
-- ------------------------------------------------------------
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category, p.product_name
)
SELECT
    category,
    product_name,
    product_sales,
    SUM(product_sales) OVER (PARTITION BY category) AS category_total,
    ROUND(
        product_sales * 100.0 /
        SUM(product_sales) OVER (PARTITION BY category),
        2
    ) AS pct_of_category
FROM product_sales
ORDER BY category, product_sales DESC;

-- ------------------------------------------------------------
-- Úloha 6 - Neaktívni zákazníci za posledných 90 dní
-- hranica sa počíta z najnovšieho dátumu v datasete
-- ------------------------------------------------------------
WITH customer_activity AS (
    SELECT DISTINCT
        o.customer_id,
        c.customer_name,
        MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS last_order_date,
        MAX(o.order_date) OVER ()                          AS latest_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT
    customer_id,
    customer_name,
    last_order_date
FROM customer_activity
WHERE last_order_date < latest_order_date - INTERVAL '90 days'
ORDER BY last_order_date;

-- kontrola zákazníka Customer_14
WITH customer_activity AS (
    SELECT DISTINCT
        c.customer_name,
        MAX(o.order_date) OVER (PARTITION BY o.customer_id) AS last_order_date,
        MAX(o.order_date) OVER ()                          AS latest_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
)
SELECT
    customer_name,
    last_order_date,
    latest_order_date,
    last_order_date >= latest_order_date - INTERVAL '90 days' AS active_last_90_days
FROM customer_activity
WHERE customer_name = 'Customer_14';

-- ------------------------------------------------------------
-- Úloha 7 - Medzimesačný rast predaja (nepovinná)
-- absolútna aj percentuálna zmena oproti predchádzajúcemu mesiacu
-- ------------------------------------------------------------
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
),
with_previous AS (
    SELECT
        month,
        monthly_sales,
        LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales
    FROM monthly_sales
)
SELECT
    month,
    monthly_sales,
    prev_month_sales,
    monthly_sales - prev_month_sales AS sales_change,
    ROUND(
        (monthly_sales - prev_month_sales) /
        prev_month_sales * 100,
        2
    ) AS growth_percentage
FROM with_previous
ORDER BY month;

-- ------------------------------------------------------------
-- Úloha 8 - Návrat zákazníkov po prvom nákupe v júni 2024 (nepovinná)
-- ------------------------------------------------------------
WITH first_purchase AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS first_month
    FROM orders
    GROUP BY customer_id
)
SELECT COUNT(*) AS returning_customers
FROM first_purchase fp
WHERE fp.first_month = '2024-06-01'
  AND EXISTS (
      SELECT 1
      FROM orders o
      WHERE o.customer_id = fp.customer_id
        AND DATE_TRUNC('month', o.order_date) > fp.first_month
  );
