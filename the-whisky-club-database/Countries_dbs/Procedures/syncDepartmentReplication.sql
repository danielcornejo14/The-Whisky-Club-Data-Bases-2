CREATE OR ALTER PROCEDURE syncDepartmentReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT COUNT(*)
                FROM mysql_server...department A
                LEFT JOIN Department B
                ON A.idDepartment = B.idDepartment
                WHERE B.name != A.name OR B.status != A.status) > 0
            BEGIN
                UPDATE Department
                SET name = (SELECT A.name
                            FROM mysql_server...department A
                            WHERE Department.idDepartment = A.idDepartment)
                UPDATE Department
                SET status = (SELECT A.status
                              FROM mysql_server...department A
                              WHERE Department.idDepartment = A.idDepartment)
                UPDATE Employee
                SET status = 0
                FROM Employee
                INNER JOIN Department ON Employee.idDepartment = Department.idDepartment
                WHERE Department.status = 0
                UPDATE Sale
                SET status = 0
                FROM Sale
                INNER JOIN Employee ON Sale.idCashier = Employee.idEmployee
                WHERE Employee.status = 0
                UPDATE WhiskeyXSale
                SET status = 0
                FROM WhiskeyXSale
                INNER JOIN Sale ON WhiskeyXSale.idSale = Sale.idSale
                WHERE Sale.status = 0
                UPDATE PurchaseReview
                SET status = 0
                FROM PurchaseReview
                INNER JOIN Sale ON PurchaseReview.idSale = Sale.idSale
                WHERE Sale.status = 0
            END
            IF (SELECT COUNT(A.idDepartment)
                FROM mysql_server...department A
                LEFT JOIN Department B
                ON A.idDepartment = B.idDepartment
                WHERE B.idDepartment IS NULL) > 0
            BEGIN
                --The new registers are inserted.
                INSERT INTO Department (idDepartment, name)
                SELECT A.idDepartment, A.name
                FROM mysql_server...department A
                LEFT JOIN Department B
                ON A.idDepartment = B.idDepartment
                WHERE B.idDepartment IS NULL
            END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO