DELIMITER //
CREATE PROCEDURE insertEmployeeReview (
     IN pIdCustomer int,
     IN pIdEmployee int,
     IN pComment varchar(64),
     IN pEvaluation int
)
BEGIN
    IF pIdCustomer IS NOT NULL AND pIdEmployee IS NOT NULL
        AND pComment IS NOT NULL AND pEvaluation IS NOT NULL
    THEN
        IF ((SELECT COUNT(idEmployee) FROM employee WHERE idEmployee = pIdEmployee
                AND status = 1) > 0
            AND (SELECT COUNT(idCustomer) FROM customer WHERE idCustomer = pIdCustomer
                AND status = 1) > 0
            AND pEvaluation BETWEEN 1 AND 5
            AND (SELECT COUNT(comment) FROM employeereview WHERE comment = pComment) = 0)
        THEN
            START TRANSACTION;
            INSERT INTO employeereview(idCustomer, idEmployee, comment, evaluation, date, resolved, administratorComment)
            VALUES (pIdCustomer, pIdEmployee, pComment, pEvaluation, (SELECT CURDATE()),  IF(pEvaluation <= 2, 0, 1), IF(pEvaluation <= 2,'Unresolved', 'Resolved'));
            SELECT 'Employee review updated.';
            COMMIT;
        ELSE
            SELECT 'The ids must exist, the comment cannot be repeated and the evaluation must be a number between 1 and 5.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;