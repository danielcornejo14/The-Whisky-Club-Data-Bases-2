DELIMITER //
CREATE PROCEDURE deleteEmployeeReview (
     IN pIdEmployeeReview int
)
BEGIN
    IF pIdEmployeeReview IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployeeReview) FROM employeereview WHERE idEmployeeReview = pIdEmployeeReview
            AND status = 1) > 0)
        THEN
            START TRANSACTION;
            UPDATE employeereview
            SET status = 0
            WHERE idEmployeeReview = pIdEmployeeReview;
            SELECT 'Employee review updated.';
            COMMIT;
        ELSE
            SELECT 'The id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;