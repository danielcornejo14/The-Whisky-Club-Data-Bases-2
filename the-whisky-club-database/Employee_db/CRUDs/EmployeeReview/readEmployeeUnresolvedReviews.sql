DELIMITER //
CREATE PROCEDURE readEmployeeUnresolvedReviews (
)
BEGIN
    SELECT * FROM employeereview WHERE resolved = 0;
END //
DELIMITER ;