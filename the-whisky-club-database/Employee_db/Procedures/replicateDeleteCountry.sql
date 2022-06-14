DELIMITER //
CREATE PROCEDURE replicateDeleteCountry (
     IN pIdCountry int
)
BEGIN
    IF pIdCountry IS NOT NULL
    THEN
        IF (SELECT COUNT(idCountry) FROM country WHERE idCountry = pIdCountry AND status = 1) > 0
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
            WHERE Country.idCountry = pIdCountry;
            SELECT 'Country deleted.';
            COMMIT;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;