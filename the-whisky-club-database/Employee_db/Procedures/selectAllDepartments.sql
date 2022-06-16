DELIMITER //
CREATE PROCEDURE selectAllDepartments ()
BEGIN
    SELECT idDepartment, idShop, name, status
    FROM department
    WHERE status = 1;
END //
DELIMITER ;