DELIMITER //
CREATE PROCEDURE readEmployeeUnresolvedReviews (
)
BEGIN
    SELECT idEmployeeReview, idCustomer,
           idEmployee, comment, evaluation,
           date, status, resolved,
           administratorComment
    FROM employeereview
    WHERE resolved = 0;
END //
DELIMITER ;