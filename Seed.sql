TRUNCATE TABLE CustomerPoints;
TRUNCATE TABLE Rentals;
DELETE FROM Customers;

INSERT INTO Customers (name)
SELECT CONCAT(
    ELT(1 + FLOOR(RAND() * 20),
        'James', 'Mary', 'John', 'Patricia', 'Robert', 'Jennifer', 'Michael', 'Linda',
        'William', 'Elizabeth', 'David', 'Barbara', 'Richard', 'Susan', 'Joseph', 'Jessica',
        'Thomas', 'Sarah', 'Charles', 'Karen'
    ),
    ' ',
    ELT(1 + FLOOR(RAND() * 20),
        'Ochieng', 'Wanjiku', 'Otieno', 'Achieng', 'Kamau', 'Mutai', 'Kiptoo', 'Wambui',
        'Mwangi', 'Njeri', 'Kibet', 'Chebet', 'Maina', 'Wanjiru', 'Kariuki', 'Atieno',
        'Njoroge', 'Odhiambo', 'Akinyi', 'Kosgei'
    )
)
FROM (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) a
CROSS JOIN (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) b
LIMIT 60;


SELECT COUNT(*) AS tenants_created FROM Customers; 
