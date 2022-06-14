DELIMITER //
CREATE PROCEDURE replicateDeleteCurrency (
     IN pidCurrency int
)
BEGIN
    IF pidCurrency IS NOT NULL
    THEN
        IF (SELECT COUNT(idCurrency) FROM currency WHERE idCurrency = pidCurrency AND status = 1) > 0
        THEN
            START TRANSACTION;
            UPDATE country
            INNER JOIN shop ON country.idCountry = shop.idCountry
            INNER JOIN department ON shop.idShop = department.idShop
            INNER JOIN employee ON department.idDepartment = employee.idDepartment
            INNER JOIN employeereview ON employee.idEmployee = employeereview.idEmployee
            SET country.status = 0,
                shop.status = 0,
                department.status = 0,
                employee.status = 0,
                employeereview.status = 0
            WHERE country.idCurrency = pIdCurrency;
            UPDATE currency
            SET status = 0
            WHERE idCurrency = pIdCurrency;
            SELECT 'Currency deleted.';
            COMMIT;
        ELSE
            SELECT 'The currency id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;