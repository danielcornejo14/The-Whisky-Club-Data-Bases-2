CREATE PROCEDURE syncEmployeeReplication
WITH ENCRYPTION
AS
BEGIN
    BEGIN TRANSACTION
        BEGIN TRY
            IF (SELECT COUNT(*)
                FROM mysql_server...employee A
                LEFT JOIN Employee B
                ON A.idEmployee = B.idEmployee
                WHERE B.idDepartment != A.idDepartment
                      OR B.idEmployeeType != A.idEmployeeType
                      OR B.idShop != A.idShop
                      OR B.name != A.name
                      OR B.lastName1 != A.lastName1
                      OR B.lastName2 != A.lastName2
                      OR B.dollarSalary != A.dollarSalary
                      OR B.password != A.password
                      OR B.status != A.status) > 0
            BEGIN
                UPDATE Employee
                SET idDepartment = (SELECT A.idDepartment
                                    FROM mysql_server...employee A
                                    WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET idShop = (SELECT A.idShop
                              FROM mysql_server...employee A
                              WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET idEmployeeType = (SELECT A.idEmployeeType
                                      FROM mysql_server...employee A
                                      WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET name = (SELECT A.name
                            FROM mysql_server...employee A
                            WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET lastName1 = (SELECT A.lastName1
                                 FROM mysql_server...employee A
                                 WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET lastName2 = (SELECT A.lastName2
                                 FROM mysql_server...employee A
                                 WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET localSalary = (SELECT A.localSalary
                                   FROM mysql_server...employee A
                                   WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET dollarSalary = (SELECT A.dollarSalary
                                    FROM mysql_server...employee A
                                    WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET userName = (SELECT A.userName
                                FROM mysql_server...employee A
                                WHERE Employee.idEmployee = A.idEmployee)

                UPDATE Employee
                SET password = (SELECT A.password
                                FROM mysql_server...employee A
                                WHERE Employee.idEmployee = A.idEmployee)
                UPDATE Employee
                SET status = (SELECT A.status
                              FROM mysql_server...employee A
                              WHERE Employee.idEmployee = A.idEmployee)
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
            IF (SELECT COUNT(A.idEmployee)
                FROM mysql_server...employee A
                LEFT JOIN Employee B
                ON A.idEmployee = B.idEmployee
                WHERE B.idEmployee IS NULL AND A.idShop IN (SELECT idShop FROM Shop)) > 0
            BEGIN
                --The new registers are inserted.
                INSERT INTO Employee (idEmployee, idDepartment,
                                      idEmployeeType, idShop, name,
                                      lastName1, lastName2, localSalary,
                                      dollarSalary, userName, password)
                SELECT A.idEmployee, A.idDepartment,
                       A.idEmployeeType, A.idShop, A.name,
                       A.lastName1, A.lastName2, A.localSalary,
                       A.dollarSalary, A.userName, A.password
                FROM mysql_server...employee A
                LEFT JOIN Employee B
                ON A.idEmployee = B.idEmployee
                WHERE B.idEmployee IS NULL AND A.idShop IN (SELECT idShop FROM Shop)
            END
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION
            RAISERROR('An error has occurred in the database.', 11, 1)
        END CATCH
END;
GO