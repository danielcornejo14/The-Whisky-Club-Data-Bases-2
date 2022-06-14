CREATE PROCEDURE syncEmployeeReviewReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM EmployeeReview
            DBCC CHECKIDENT ('EmployeeReview', RESEED, 0)
            INSERT INTO EmployeeReview (idCustomer, idEmployee,
                                        comment, evaluation,
                                        date, status)
            SELECT idCustomer, idEmployee,
                    comment, evaluation,
                    date, status
            FROM mysql_server...employeereview --principal
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;