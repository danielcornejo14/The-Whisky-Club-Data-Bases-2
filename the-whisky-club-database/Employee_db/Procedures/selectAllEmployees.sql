DELIMITER //
CREATE PROCEDURE selectAllEmployees ()
BEGIN
    SELECT idEmployee, idDepartment, idEmployeeType, name, lastName1, lastName2, localSalary, dollarSalary
    FROM Employee
    WHERE status = 1;
END //
DELIMITER ;