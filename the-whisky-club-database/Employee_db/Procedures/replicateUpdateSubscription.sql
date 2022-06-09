DELIMITER //
CREATE PROCEDURE replicateUpdateSubscription (
     IN pIdSubscription int,
     IN pName varchar(64),
     IN pShoppingDiscount float,
     IN pShippingDiscount float
)
BEGIN
    IF pName IS NOT NULL AND pShoppingDiscount IS NOT NULL
        AND pShippingDiscount IS NOT NULL AND pIdSubscription IS NOT NULL
    THEN
        IF ((SELECT COUNT(idSubscription) FROM subscription WHERE idSubscription = pIdSubscription
            AND status = 1) > 0
            AND (SELECT COUNT(name) FROM Subscription WHERE name = pName) = 0
            AND pShoppingDiscount >= 0
            AND pShippingDiscount >= 0)
        THEN
            START TRANSACTION;
            UPDATE Subscription
            SET name = pName,
                shoppingDiscount = pShoppingDiscount,
                shippingDiscount = pShippingDiscount
            WHERE idSubscription = pIdSubscription;
            SELECT 'Subscription updated.';
            COMMIT;
        ELSE
            SELECT 'The subscription name cannot be repeated, the discounts must be 0 or greater, and the id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;