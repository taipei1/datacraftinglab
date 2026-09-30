-- ============================================================
-- Databázové technológie (FPVaI/KI/DT/22) | Týždeň 1
-- 04_subqueries.sql
-- Seminár 2 - Zadanie 1b: vnorené dotazy (subqueries)
-- Databáza: datacraftinglab_db | Tabuľka: flourmills_sales
-- Dáta: FlourMills_Sales_2022_2024.csv (10 000 záznamov)
-- ============================================================

-- ------------------------------------------------------------
-- Úloha 1 - Príprava databázy a tabuľky
-- ------------------------------------------------------------
CREATE DATABASE datacraftinglab_db;

-- po vytvorení sa k databáze pripojíme a pokračujeme v nej
-- \c datacraftinglab_db

CREATE TABLE flourmills_sales (
    sales_id          INTEGER PRIMARY KEY,
    sale_date         DATE,
    region            VARCHAR(100),
    state             VARCHAR(100),
    product_category  VARCHAR(100),
    product_name      VARCHAR(150),
    customer_type     VARCHAR(100),
    customer_id       INTEGER,
    quantity_sold     INTEGER,
    unit_price        NUMERIC(12,2),
    discount_rate     INTEGER,
    payment_method    VARCHAR(100),
    sales_rep         VARCHAR(150),
    warehouse         VARCHAR(100),
    delivery_status   VARCHAR(100),
    order_channel     VARCHAR(100),
    batch_number      INTEGER,
    production_date   DATE,
    total_amount      NUMERIC(14,2)
);

-- kontrola importu (Import/Export Data v pgAdmin, CSV, hlavička zapnutá)
SELECT * FROM flourmills_sales;


-- ------------------------------------------------------------
-- Úloha 1 - Transakcie nad priemernou hodnotou
-- 4028 transakcií
-- ------------------------------------------------------------
SELECT product_name,
       total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);


-- ------------------------------------------------------------
-- Úloha 2 - Transakcie najpredávanejšej kategórie
-- Najvyšší celkový predaj má kategória Vegetable Oil.
-- ------------------------------------------------------------
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id;


-- ------------------------------------------------------------
-- Úloha 3 - Porovnanie transakcie s priemernou hodnotou
-- Nový stĺpec avg_amount; transakcia 9511208.41 =>
-- Golden Penny Flour 50kg
-- ------------------------------------------------------------
SELECT product_name,
       total_amount,
       (SELECT AVG(total_amount) FROM flourmills_sales) AS avg_amount
FROM flourmills_sales;


-- ------------------------------------------------------------
-- Úloha 4 - Podiel transakcie na celkovom predaji
-- Nový stĺpec amount_share = total_amount / celkový súčet
-- ------------------------------------------------------------
SELECT product_name,
       total_amount,
       total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales;


-- ------------------------------------------------------------
-- Úloha 5 - Mesačný prehľad predaja (subquery v časti FROM)
-- Pre mesiac 8 je monthly_sales = 3801432205.37
-- ------------------------------------------------------------
SELECT month,
       monthly_sales
FROM (
    SELECT EXTRACT(MONTH FROM sale_date) AS month,
           SUM(total_amount)              AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS monthly_view
ORDER BY monthly_sales DESC;


-- ------------------------------------------------------------
-- Úloha 6 - Kategórie s vysokým celkovým predajom
-- Všetkých 5 kategórií má total_sales > 50 000 000.
-- Poradie: Vegetable Oil, Semolina, Pasta, Flour, Noodles
-- ------------------------------------------------------------
SELECT product_category,
       total_sales
FROM (
    SELECT product_category,
           SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS category_sales
WHERE total_sales > 50000000
ORDER BY total_sales DESC;


-- ------------------------------------------------------------
-- Úloha 7 - Predaj nad priemerom vlastnej kategórie
-- Korelovaný vnorený dotaz; 4034 transakcií
-- ------------------------------------------------------------
SELECT t1.product_name,
       t1.product_category,
       t1.total_amount
FROM flourmills_sales t1
WHERE t1.total_amount > (
    SELECT AVG(t2.total_amount)
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
);


-- ------------------------------------------------------------
-- Úloha 8 - Minimálna hodnota predaja v regióne
-- Korelovaný vnorený dotaz cez stĺpec region
-- ------------------------------------------------------------
SELECT t1.product_name,
       t1.region,
       t1.total_amount,
       (SELECT MIN(t2.total_amount)
        FROM flourmills_sales t2
        WHERE t2.region = t1.region) AS region_min_amount
FROM flourmills_sales t1;


-- ------------------------------------------------------------
-- Úloha 9 - Produkty predávané vo viacerých mesiacoch (EXISTS)
-- ------------------------------------------------------------
SELECT t1.product_name
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_name = t1.product_name
    GROUP BY t2.product_name
    HAVING COUNT(DISTINCT EXTRACT(MONTH FROM t2.sale_date)) > 1
)
GROUP BY t1.product_name;


-- ------------------------------------------------------------
-- Úloha 10 - Kategórie s aspoň jedným predajom nad 200 000 (EXISTS)
-- ------------------------------------------------------------
SELECT t1.product_category,
       t1.product_name,
       t1.total_amount
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
      AND t2.total_amount > 200000
);


-- ------------------------------------------------------------
-- Úloha 11 - Kategórie predávané vo viac ako troch regiónoch
-- Skúšaná podmienka: EXISTS + COUNT(DISTINCT region) ... HAVING
-- Každá kategória sa predávala v 6 regiónoch.
-- ------------------------------------------------------------
SELECT t1.product_category
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
    GROUP BY t2.product_category
    HAVING COUNT(DISTINCT t2.region) > 3
)
GROUP BY t1.product_category
ORDER BY t1.product_category;


-- ------------------------------------------------------------
-- Úloha 12 - Regióny s predajom v roku 2024 (EXISTS)
-- Výsledok obsahuje aj transakcie z rokov 2022 a 2023.
-- ------------------------------------------------------------
SELECT t1.*
FROM flourmills_sales t1
WHERE EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
      AND EXTRACT(YEAR FROM t2.sale_date) = 2024
);


-- ------------------------------------------------------------
-- Úloha 13 - Kategórie bez predaja nad 500 000 (NOT EXISTS)
-- Taká kategória neexistuje - výsledok je prázdny (0 riadkov).
-- ------------------------------------------------------------
SELECT t1.product_category
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.product_category = t1.product_category
      AND t2.total_amount > 500000
)
GROUP BY t1.product_category;


-- ------------------------------------------------------------
-- Úloha 14 - Regióny bez predaja múky (NOT EXISTS)
-- Múka (kategória Flour) sa predávala vo všetkých regiónoch,
-- preto je výsledok prázdny (žiadny región).
-- ------------------------------------------------------------
SELECT DISTINCT t1.region
FROM flourmills_sales t1
WHERE NOT EXISTS (
    SELECT 1
    FROM flourmills_sales t2
    WHERE t2.region = t1.region
      AND t2.product_category = 'Flour'
);