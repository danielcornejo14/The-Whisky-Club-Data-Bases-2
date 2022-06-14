DELIMITER //
CREATE PROCEDURE replicateDeleteShop (
     IN pIdShop int
)
BEGIN
    IF pIdShop IS NOT NULL
    THEN
        IF (SELECT COUNT(idShop) FROM shop WHERE idShop = pIdShop AND status = 1) > 0
        THEN
            START TRANSACTION;
            UPDATE department
            INNER JOIN employee ON department.idDepartment = employee.idDepartment
            INNER JOIN employeereview ON employee.idEmployee = employeereview.idEmployee
            SET department.status = 0,
                employee.status = 0,
                employeereview.status = 0
            WHERE department.idShop = pIdShop;
            UPDATE Shop
            SET status = 0
            WHERE idShop = pIdShop;
            SELECT 'Shop deleted.';
            COMMIT;
        ELSE
            SELECT 'The id shop must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;