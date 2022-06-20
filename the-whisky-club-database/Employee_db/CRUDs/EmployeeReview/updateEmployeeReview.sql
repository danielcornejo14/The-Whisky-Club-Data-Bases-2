DELIMITER //
CREATE PROCEDURE updateEmployeeReview (
     IN pIdEmployeeReview int,
     IN pUserName int,
     IN pIdEmployee int,
     IN pComment varchar(64),
     IN pEvaluation int
)
BEGIN
    IF pUserName IS NOT NULL AND pIdEmployee IS NOT NULL
        AND pComment IS NOT NULL AND pEvaluation IS NOT NULL
        AND pIdEmployeeReview IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployee) FROM employee WHERE idEmployee = pIdEmployee
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM customer WHERE userName = pUserName
                AND status = 1) > 0
            AND (SELECT COUNT(idEmployeeReview) FROM employeereview WHERE idEmployeeReview = pIdEmployeeReview
                AND status = 1) > 0
            AND pEvaluation BETWEEN 1 AND 5
            AND (SELECT COUNT(comment) FROM employeereview WHERE comment = pComment) = 0)
        THEN
            START TRANSACTION;
            UPDATE employeereview
            SET idCustomer = (SELECT idCustomer FROM customer WHERE userName = pUserName),
                idEmployee = pIdEmployee,
                comment = pComment,
                evaluation = pEvaluation,
                date = (SELECT CURDATE())
            WHERE idEmployeeReview = pIdEmployeeReview;
            SELECT 'Employee review updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist and the evaluation must be a number between 1 and 5.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;