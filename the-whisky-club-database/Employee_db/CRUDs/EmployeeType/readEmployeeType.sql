DELIMITER //
CREATE PROCEDURE readEmployeeType (
     IN pIdEmployeeType int
)
BEGIN
    IF pIdEmployeeType IS NOT NULL
    THEN
        IF (SELECT COUNT(idEmployeeType) FROM EmployeeType WHERE idEmployeeType = pIdEmployeeType
            AND status = 1) > 0
        THEN
            SELECT idEmployeeType, name, status
            FROM EmployeeType;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;