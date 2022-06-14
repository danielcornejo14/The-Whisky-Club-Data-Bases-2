CREATE PROCEDURE syncEmployeeReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM Employee
            DBCC CHECKIDENT ('Employee', RESEED, 0)
            INSERT INTO Employee (idDepartment, idEmployeeType,
                                  name, lastName1, lastName2,
                                  localSalary, dollarSalary,
                                  userName, password, status)
            SELECT idDepartment, idEmployeeType,
                   name, lastName1, lastName2,
                   localSalary, dollarSalary,
                   userName, password, status
            FROM mysql_server...employee --principal
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO