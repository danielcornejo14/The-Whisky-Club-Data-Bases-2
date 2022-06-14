DELIMITER //
CREATE PROCEDURE updateDepartment (
     IN pIdDepartment int,
     IN pIdShop int,
     IN pName varchar(64)
)
BEGIN
    IF pIdShop IS NOT NULL AND pName IS NOT NULL
        AND pIdDepartment IS NOT NULL
    THEN
        IF ((SELECT COUNT(idShop) FROM Shop WHERE idShop = pIdShop AND status = 1) > 0
            AND (SELECT COUNT(name) FROM shop WHERE name = pName) = 0
            AND (SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment
                AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE department
            SET idShop = pIdShop,
                name = pName
            WHERE idDepartment = pIdDepartment;
            SELECT 'Department updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist and the name cannot be repeated.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;