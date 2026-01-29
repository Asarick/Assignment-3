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
FROM 
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6) AS a,
    (SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 
     UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10) AS b
LIMIT 60;

SELECT COUNT(*) AS tenants_created FROM Customers;

INSERT INTO Rentals (customer_id, status)
SELECT 
    c.customer_id,
    CASE 
        WHEN RAND() < 0.82 THEN 'Completed'
        WHEN RAND() < 0.92 THEN 'Active'
        ELSE 'Pending'
    END AS status
FROM Customers c
CROSS JOIN (
    SELECT 0  UNION SELECT 1  UNION SELECT 2  UNION SELECT 3  UNION SELECT 4
    UNION SELECT 5  UNION SELECT 6  UNION SELECT 7  UNION SELECT 8  UNION SELECT 9
    UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13
) AS multipliers
WHERE c.customer_id BETWEEN 1 AND 60
ORDER BY RAND()
LIMIT 800;

SELECT COUNT(*) AS total_rentals FROM Rentals;
SELECT COUNT(*) AS completed_rentals FROM Rentals WHERE status = 'Completed';

UPDATE Rentals
SET status = status
WHERE status = 'Completed';

SELECT 
    c.customer_id,
    c.name,
    COALESCE(cp.points, 0)           AS points_earned,
    COUNT(r.rental_id)               AS total_rentals,
    COUNT(CASE WHEN r.status = 'Completed' THEN 1 END) AS completed_rentals
FROM Customers c
LEFT JOIN CustomerPoints cp ON cp.customer_id = c.customer_id
LEFT JOIN Rentals r ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.name, cp.points
ORDER BY points_earned DESC, completed_rentals DESC
LIMIT 60;
