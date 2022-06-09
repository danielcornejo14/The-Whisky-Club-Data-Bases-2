DELIMITER //
CREATE PROCEDURE replicateInsertSubscription (
     IN pName varchar(64),
     IN pShoppingDiscount float,
     IN pShippingDiscount float
)
BEGIN
    IF pName IS NOT NULL AND pShoppingDiscount IS NOT NULL
        AND pShippingDiscount IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM Subscription WHERE name = pName) = 0
            AND pShoppingDiscount >= 0
            AND pShippingDiscount >= 0)
        THEN
            START TRANSACTION;
            INSERT INTO subscription(name, shoppingDiscount, shippingDiscount)
            VALUES(pName, pShoppingDiscount, pShippingDiscount);
            SELECT 'Subscription inserted.';
            COMMIT;
        ELSE
            SELECT 'The subscription name cannot be repeated, and the discounts must be 0 or greater.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;