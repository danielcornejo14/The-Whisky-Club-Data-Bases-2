CREATE PROCEDURE syncEmployeeReviewReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            DELETE FROM EmployeeReview
            INSERT INTO EmployeeReview (idEmployeeReview, idCustomer,
                                        idEmployee, comment, evaluation,
                                        date)
            SELECT idEmployeeReview, idCustomer,
                   idEmployee, comment, evaluation,
                   date
            FROM mysql_server...employeereview --main
            WHERE idEmployee IN (SELECT idEmployee FROM Employee)
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;