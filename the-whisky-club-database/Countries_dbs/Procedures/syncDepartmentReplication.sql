CREATE PROCEDURE syncDepartmentReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM Department
            INSERT INTO Department(idDepartment, idShop, name, status)
            SELECT idDepartment, idShop, name, status
            FROM mysql_server...department --main
            WHERE idShop IN (SELECT idShop FROM Shop)
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO