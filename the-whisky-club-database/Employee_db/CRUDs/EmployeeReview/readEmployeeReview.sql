DELIMITER //
CREATE PROCEDURE readEmployeeReview (
     IN pIdEmployeeReview int
)
BEGIN
    IF pIdEmployeeReview IS NOT NULL
    THEN
        IF (SELECT COUNT(idEmployeeReview) FROM EmployeeReview WHERE idEmployeeReview = pIdEmployeeReview
            AND status = 1) > 0
        THEN
            SELECT idEmployeeReview, idCustomer, idEmployee,
                   comment, evaluation, date, status,
                   resolved, administratorComment
            FROM EmployeeReview;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;