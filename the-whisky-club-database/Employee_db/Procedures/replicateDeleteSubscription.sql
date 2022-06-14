DELIMITER //
CREATE PROCEDURE replicateDeleteSubscription (
     IN pIdSubscription int
)
BEGIN
    IF pIdSubscription IS NOT NULL
    THEN
        IF (SELECT COUNT(idSubscription) FROM Subscription WHERE idSubscription = pIdSubscription AND status = 1) > 0
        THEN
            START TRANSACTION;
            UPDATE Subscription
            INNER JOIN customer ON subscription.idSubscription = customer.idSubscription
            INNER JOIN employeereview ON customer.idCustomer = employeereview.idCustomer
            SET Subscription.status = 0,
                customer.status = 0,
                employeereview.status = 0
            WHERE Subscription.idSubscription = pIdSubscription;
            COMMIT;
        ELSE
            SELECT 'The id Subscription must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;