/*ESERCIZIO ESAME SQL DI LEONARDO OLIVERI ORIOLES
 - Product:
 ProductID (PK)
 ProductName
 Category
 Price
 
 - Region:
 RegionID (PK)
 RegionName
 
 -Sales
 SaleID (PK)
 ProductID (FK)
 RegionID (FK)
 SaleDate
 Quantity
 */
 
 CREATE SCHEMA toys_group;
 USE toys_group;
 CREATE TABLE Product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(25),
    Category VARCHAR(25),
    Price DECIMAL
);

CREATE TABLE Region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(25)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    RegionID INT,
    SaleDate DATE,
    Quantity INT,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO Product (ProductID, ProductName, Category, Price) VALUES
(1, 'Action Figure', 'Toys', 13),
(2, 'Barbie Doll', 'Dolls', 10),
(3, 'LEGO Set', 'Building Blocks', 30),
(4, 'Remote Control Car', 'Toys', 25),
(5, 'Board Game', 'Games', 20),
(6, 'Puzzle', 'Games', 15),
(7, 'Stuffed Animal', 'Toys', 9),
(8, 'Play-Doh Set', 'Creative', 8);

INSERT INTO Region (RegionID, RegionName) VALUES
(1, 'North America'),
(2, 'Europe'),
(3, 'Asia'),
(4, 'South America'),
(5, 'Africa'),
(6, 'Oceania');

INSERT INTO Sales (SaleID, ProductID, RegionID, SaleDate, Quantity) VALUES
(1, 1, 1, '2024-05-01', 10),
(2, 2, 2, '2024-05-02', 15),
(3, 3, 3, '2024-05-03', 20),
(4, 4, 1, '2024-05-04', 8),
(5, 5, 2, '2024-05-05', 12),
(6, 6, 3, '2024-05-06', 18),
(7, 7, 4, '2024-05-07', 6),
(8, 8, 5, '2024-05-08', 9),
(9, 1, 1, '2024-05-09', 14),
(10, 2, 2, '2024-05-10', 20),
(11, 3, 3, '2024-05-11', 25),
(12, 4, 4, '2024-05-12', 11),
(13, 5, 5, '2024-05-13', 16);

/* ES 1: Verificare che i campi definiti come PK siano univoci */
SELECT p.productID, COUNT(*)
FROM product as p
GROUP BY p.productID
HAVING COUNT(*) > 1;

SELECT r.regionID, COUNT(*)
FROM region as r
GROUP BY r.regionID
HAVING COUNT(*) > 1;

SELECT s.saleID, COUNT(*)
FROM sales as s
GROUP BY s.saleID
HAVING COUNT(*) > 1;

/* ES 2: Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno */
SELECT p.ProductID, p.ProductName, YEAR(s.SaleDate) AS YEAR, SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales AS s JOIN Product AS p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, YEAR(s.SaleDate)
ORDER BY p.ProductID, YEAR;

/* ES 3: Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente */
SELECT r.RegionName, YEAR(s.SaleDate) AS Year, SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales AS s
JOIN Product AS p ON s.ProductID = p.ProductID
JOIN  Region AS r ON s.RegionID = r.RegionID
GROUP BY r.RegionName, YEAR(s.SaleDate)
ORDER BY Year, TotalRevenue DESC;

/* ES 4: Rispondere alla seguente domanda: qual è la categoria di articoli maggiormente richiesta dal mercato? */
SELECT MAX(s.quantity) AS Quantity, p.Category
FROM Sales AS s JOIN Product AS p ON s.ProductID = p.ProductID
GROUP BY p.Category
ORDER BY Quantity DESC
LIMIT 1;

/* ES 5: Rispondere alla seguente domanda: quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti */
SELECT p.ProductID, p.ProductName, p.Category
FROM Product AS p
WHERE p.ProductID NOT IN (SELECT DISTINCT s.ProductID FROM Sales AS s);

SELECT p.ProductID, p.ProductName, p.Category
FROM Product AS p LEFT JOIN Sales AS s ON p.ProductID = s.ProductID
WHERE s.ProductID IS NULL;

/* ES 6: Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente) */
SELECT p.ProductID, p.ProductName, MAX(s.SaleDate) AS LastSaleDate
FROM Sales AS s JOIN Product AS p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;