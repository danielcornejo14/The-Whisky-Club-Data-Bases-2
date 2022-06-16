DELIMITER //
CREATE PROCEDURE selectAllEmployeeReviews()
BEGIN
    SELECT idEmployeeReview, idCustomer, idEmployee, comment, evaluation, date
    FROM employeereview
    WHERE status = 1;
END //
DELIMITER ;