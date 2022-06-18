CREATE PROCEDURE syncEmployeeReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM Employee
            INSERT INTO Employee (idEmployee, idDepartment,
                                  idEmployeeType, name, lastName1,
                                  lastName2, localSalary, dollarSalary,
                                  userName, password, status)
            SELECT idEmployee, idDepartment,
                   idEmployeeType, name, lastName1,
                   lastName2, localSalary, dollarSalary,
                   userName, password, status
            FROM mysql_server...employee --main
            WHERE idDepartment IN (SELECT idDepartment FROM Department)
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO