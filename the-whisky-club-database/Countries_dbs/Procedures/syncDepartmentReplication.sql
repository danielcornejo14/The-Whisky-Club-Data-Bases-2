CREATE PROCEDURE syncDepartmentReplication
WITH ENCRYPTION
AS
BEGIN
    INSERT INTO dbo.Department(idShop, name, status)
    SELECT A.idShop, A.name, A.status
    FROM mysql_server...department A
    LEFT JOIN dbo.Department B
    ON A.idDepartment = B.idDepartment
    WHERE B.idDepartment IS NULL
END;