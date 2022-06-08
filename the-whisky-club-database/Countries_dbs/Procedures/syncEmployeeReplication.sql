CREATE PROCEDURE syncEmployeeReplication
WITH ENCRYPTION
AS
BEGIN
    INSERT INTO dbo.Employee(idDepartment, idEmployeeType,
                             name, lastName1, lastName2,
                             localSalary, dollarSalary,
                             userName, password, status)
    SELECT A.idDepartment, A.idEmployeeType,
           A.name, A.lastName1, A.lastName2, A.localSalary,
           A.dollarSalary, A.userName, A.password,
           A.status
    FROM mysql_server...employee A
    LEFT JOIN dbo.Employee B
    ON A.idEmployee = B.idEmployee
    WHERE B.idEmployee IS NULL
END;