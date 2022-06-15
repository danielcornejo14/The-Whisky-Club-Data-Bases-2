DELIMITER //
CREATE PROCEDURE insertEmployeeType (
    IN pName varchar(64)
)
BEGIN
    IF pName IS NOT NULL
    THEN
        IF (SELECT COUNT(name) FROM employeetype WHERE name = pName) = 0
        THEN
            START TRANSACTION;
            INSERT INTO employeetype(name)
            VALUES (pName);
            SELECT 'Employee type inserted.';
            COMMIT;
        ELSE
            SELECT 'The name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;