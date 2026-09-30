-- ============================================================
-- Databázové technológie (FPVaI/KI/DT/22) | Týždeň 1
-- 03_aggregations.sql
-- Agregačné funkcie a zoskupovanie (GROUP BY, HAVING) nad Northwind.
-- ============================================================

-- 1) Počet zákazníkov podľa krajiny
SELECT Country,
       COUNT(*) AS customers
FROM Customers
GROUP BY Country
ORDER BY customers DESC;

-- 2) Počet objednávok na zamestnanca
SELECT e.EmployeeID,
       e.FirstName || ' ' || e.LastName AS employee,
       COUNT(o.OrderID) AS orders_count
FROM Employees e
JOIN Orders o ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, employee
ORDER BY orders_count DESC;

-- 3) Celkové predané množstvo na produkt (len produkty s viac ako 500 ks)
SELECT p.ProductName,
       SUM(od.Quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od ON od.ProductID = p.ProductID
GROUP BY p.ProductName
HAVING SUM(od.Quantity) > 500
ORDER BY total_quantity DESC;

-- 4) Priemerná cena produktu podľa kategórie
SELECT cat.CategoryName,
       ROUND(AVG(p.Price), 2) AS avg_price,
       MIN(p.Price) AS min_price,
       MAX(p.Price) AS max_price
FROM Products p
JOIN Categories cat ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName
ORDER BY avg_price DESC;

-- 5) Objednávky podľa mesiaca vzniku
SELECT EXTRACT(YEAR FROM o.OrderDate)  AS year,
       EXTRACT(MONTH FROM o.OrderDate) AS month,
       COUNT(*) AS orders_count
FROM Orders o
GROUP BY year, month
ORDER BY year, month;