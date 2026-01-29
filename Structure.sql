CREATE DATABASE Customer Points;
DROP TABLE IF EXISTS CustomerPoints;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE CustomerPoints (
    customer_id INT PRIMARY KEY,
    points INT DEFAULT 0,
    last_updated TIMESTAMP 
        DEFAULT CURRENT_TIMESTAMP 
        ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

DELIMITER $$

CREATE TRIGGER trg_award_loyalty_points
AFTER UPDATE ON Rentals
FOR EACH ROW
BEGIN
    DECLARE earned_points INT;

    IF OLD.status <> 'Completed' AND NEW.status = 'Completed' THEN
        SET earned_points = FLOOR(
            (DAY(LAST_DAY(CURDATE())) - DAY(CURDATE())) / 8
        );

        INSERT INTO CustomerPoints (customer_id, points)
        VALUES (NEW.customer_id, earned_points)
        ON DUPLICATE KEY UPDATE
            points = points + earned_points;
    END IF;
END$$

DELIMITER ;
