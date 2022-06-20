CREATE OR ALTER PROCEDURE syncEmployeeReviewReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT COUNT(*)
                FROM mysql_server...employeereview A
                LEFT JOIN EmployeeReview B
                ON A.idEmployeeReview = B.idEmployeeReview
                WHERE B.idCustomer != A.idCustomer
                     OR B.idEmployee != A.idEmployee
                     OR B.comment != A.comment
                     OR B.evaluation != A.evaluation
                     OR B.date != A.date
                     OR B.resolved != A.resolved
                     OR B.administratorComment != A.administratorComment
                     OR B.status != A.status) > 0
            BEGIN
                UPDATE EmployeeReview
                SET idCustomer = (SELECT A.idCustomer
                                  FROM mysql_server...employeereview A
                                  WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET idEmployee = (SELECT A.idEmployee
                                  FROM mysql_server...employeereview A
                                  WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET comment = (SELECT A.comment
                               FROM mysql_server...employeereview A
                               WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET evaluation = (SELECT A.evaluation
                                  FROM mysql_server...employeereview A
                                  WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET date = (SELECT A.date
                            FROM mysql_server...employeereview A
                            WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET resolved = (SELECT A.resolved
                                FROM mysql_server...employeereview A
                                WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET administratorComment = (SELECT A.administratorComment
                                             FROM mysql_server...employeereview A
                                             WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
                UPDATE EmployeeReview
                SET status = (SELECT A.status
                              FROM mysql_server...employeereview A
                              WHERE EmployeeReview.idEmployeeReview = A.idEmployeeReview)
            END
            IF (SELECT COUNT(A.idEmployeeReview)
                FROM mysql_server...employeereview A
                LEFT JOIN EmployeeReview B
                ON A.idEmployeeReview = B.idEmployeeReview
                WHERE B.idEmployeeReview IS NULL AND
                      A.idEmployee IN (SELECT idEmployee FROM Employee)) > 0
            BEGIN
                --The new registers are inserted.
                INSERT INTO EmployeeReview (idEmployeeReview, idCustomer,
                                            idEmployee, comment, evaluation,
                                            date, resolved, administratorComment,
                                            status)
                SELECT A.idEmployeeReview, A.idCustomer,
                       A.idEmployee, A.comment, A.evaluation, A.date,
                       A.resolved, A.administratorComment, A.status
                FROM mysql_server...employeereview A
                LEFT JOIN EmployeeReview B
                ON A.idEmployeeReview = B.idEmployeeReview
                WHERE B.idEmployeeReview IS NULL AND
                      A.idEmployee IN (SELECT idEmployee FROM Employee)
            END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;