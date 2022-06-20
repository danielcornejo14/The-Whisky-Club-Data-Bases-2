CREATE PROCEDURE syncEmployeeTypeReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT COUNT(*)
                FROM mysql_server...employeetype A
                LEFT JOIN EmployeeType B
                ON A.idEmployeeType = B.idEmployeeType
                WHERE  B.name != A.name OR B.status != A.status) > 0
            BEGIN
                UPDATE EmployeeType
                SET name = (SELECT A.name
                            FROM mysql_server...employeetype A
                            WHERE EmployeeType.idEmployeeType = A.idEmployeeType)
                UPDATE EmployeeType
                SET status = (SELECT A.status
                              FROM mysql_server...employeetype A
                              WHERE EmployeeType.idEmployeeType = A.idEmployeeType)
                UPDATE Employee
                SET status = 0
                FROM Employee
                INNER JOIN EmployeeType ON Employee.idEmployeeType = EmployeeType.idEmployeeType
                WHERE EmployeeType.status = 0
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
            IF (SELECT COUNT(A.idEmployeeType)
                FROM mysql_server...employeetype A
                LEFT JOIN EmployeeType B
                ON A.idEmployeeType = B.idEmployeeType
                WHERE B.idEmployeeType IS NULL) > 0
            BEGIN
                --The new registers are inserted.
                INSERT INTO EmployeeType (name)
                SELECT A.name
                FROM mysql_server...employeetype A
                LEFT JOIN EmployeeType B
                ON A.idEmployeeType = B.idEmployeeType
                WHERE B.idEmployeeType IS NULL
            END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;