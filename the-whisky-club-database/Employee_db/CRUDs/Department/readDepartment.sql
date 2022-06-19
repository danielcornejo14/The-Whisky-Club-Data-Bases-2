DELIMITER //
CREATE PROCEDURE readDepartment (
     IN pIdDepartment int
)
BEGIN
    IF pIdDepartment IS NOT NULL
    THEN
        IF (SELECT COUNT(idDepartment) FROM department WHERE idDepartment = pIdDepartment
            AND status = 1) > 0
        THEN
            SELECT idDepartment, name, status
            FROM department;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;