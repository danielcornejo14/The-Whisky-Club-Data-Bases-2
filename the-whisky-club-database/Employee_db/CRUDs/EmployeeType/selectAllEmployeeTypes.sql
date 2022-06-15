DELIMITER //
CREATE PROCEDURE selectAllEmployeeTypes()
BEGIN
    SELECT idEmployeeType, name
    FROM employeetype
    WHERE status = 1;
END //
DELIMITER ;