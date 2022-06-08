CREATE PROCEDURE syncEmployeeReviewReplication
WITH ENCRYPTION
AS
BEGIN
    INSERT INTO dbo.EmployeeReview(idCustomer, idEmployee,
                                   comment, evaluation,
                                   date, status)
    SELECT A.idCustomer, A.idEmployee, A.comment,
           A.evaluation, A.date, A.status
    FROM mysql_server...employeereview A
    LEFT JOIN dbo.EmployeeReview B
    ON A.idEmployeeReview = B.idEmployeeReview
    WHERE B.idEmployeeReview IS NULL
END;