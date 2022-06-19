DELIMITER //
CREATE PROCEDURE insertDepartment (
     IN pName varchar(64)
)
BEGIN
    IF pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM department WHERE name = pName) = 0)
        THEN
            START TRANSACTION;
            INSERT INTO department(name)
            VALUES (pName);
            SELECT 'Department inserted.';
            COMMIT;
        ELSE
            SELECT 'The name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;