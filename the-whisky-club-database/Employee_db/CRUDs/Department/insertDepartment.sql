DELIMITER //
CREATE PROCEDURE insertDepartment (
     IN pIdShop int,
     IN pName varchar(64)
)
BEGIN
    IF pIdShop IS NOT NULL AND pName IS NOT NULL
    THEN
        IF ((SELECT COUNT(idShop) FROM Shop WHERE idShop = pIdShop AND status = 1) > 0
            AND (SELECT COUNT(name) FROM shop WHERE name = pName) = 0)
        THEN
            START TRANSACTION;
            INSERT INTO department(idShop, name)
            VALUES (pIdShop, pName);
            SELECT 'Department inserted.';
            COMMIT;
        ELSE
            SELECT 'The id must exist and the name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;