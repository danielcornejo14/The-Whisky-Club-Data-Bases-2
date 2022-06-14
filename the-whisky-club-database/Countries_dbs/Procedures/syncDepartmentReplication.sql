CREATE PROCEDURE syncDepartmentReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM Department
            DBCC CHECKIDENT ('Department', RESEED, 0)
            INSERT INTO Department (idShop, name, status)
            SELECT idShop, name, status
            FROM mysql_server...department --principal
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO