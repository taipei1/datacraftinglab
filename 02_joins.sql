-- ============================================================
-- Databázové technológie (FPVaI/KI/DT/22) | Týždeň 1
-- 02_joins.sql
-- Spájanie tabuliek (JOIN) nad databázou Northwind.
-- ============================================================

-- 1) Zoznam objednávok s menom zákazníka (INNER JOIN)
SELECT o.OrderID,
       o.OrderDate,
       c.CustomerName,
       c.Country
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
ORDER BY o.OrderDate;

-- 2) Objednávky spolu s menom zamestnanca a prepravcu (viacnásobný JOIN)
SELECT o.OrderID,
       o.OrderDate,
       e.FirstName || ' ' || e.LastName AS employee,
       s.ShipperName
FROM Orders o
JOIN Employees e ON e.EmployeeID = o.EmployeeID
JOIN Shippers  s ON s.ShipperID  = o.ShipperID
ORDER BY o.OrderID;

-- 3) Detaily objednávok s názvom produktu a kategóriou
SELECT od.OrderID,
       p.ProductName,
       cat.CategoryName,
       od.Quantity
FROM OrderDetails od
JOIN Products   p   ON p.ProductID   = od.ProductID
JOIN Categories cat ON cat.CategoryID = p.CategoryID
ORDER BY od.OrderID, p.ProductName;

-- 4) Zákazníci, ktorí nemajú žiadnu objednávku (LEFT JOIN + IS NULL)
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE o.OrderID IS NULL;

-- 5) Produkty vrátane tých, ktoré sa nepredávali (LEFT JOIN)
SELECT p.ProductName,
       COUNT(od.OrderID) AS times_ordered
FROM Products p
LEFT JOIN OrderDetails od ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY times_ordered, p.ProductName;