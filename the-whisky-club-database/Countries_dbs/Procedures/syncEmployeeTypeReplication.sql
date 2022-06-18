CREATE PROCEDURE syncEmployeeTypeReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM EmployeeType
            DBCC CHECKIDENT ('EmployeeType', RESEED, 0)
            INSERT INTO EmployeeType (name, status)
            SELECT name, status
            FROM mysql_server...employeetype --main
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;