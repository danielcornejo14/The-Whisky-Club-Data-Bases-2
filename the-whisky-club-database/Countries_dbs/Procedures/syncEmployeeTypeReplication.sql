CREATE PROCEDURE syncEmployeeTypeReplication
WITH ENCRYPTION
AS
BEGIN
    INSERT INTO dbo.EmployeeType(name, status)
    SELECT A.name, A.status
    FROM mysql_server...employeetype A
    LEFT JOIN dbo.EmployeeType B
    ON A.idEmployeeType = B.idEmployeeType
    WHERE B.idEmployeeType IS NULL
END;