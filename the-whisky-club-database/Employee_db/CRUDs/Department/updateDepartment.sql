DELIMITER //
CREATE PROCEDURE updateDepartment (
     IN pIdDepartment int,
     IN pName varchar(64)
)
BEGIN
    IF pName IS NOT NULL AND pIdDepartment IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM department WHERE name = pName) = 0
            AND (SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment
                AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE department
            SET name = pName
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