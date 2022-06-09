DELIMITER //
CREATE PROCEDURE replicateUpdateSubscription (
     IN pIdSubscription int,
     IN pName varchar(64),
     IN pShoppingDiscount float,
     IN pShippingDiscount float
)
BEGIN
    START TRANSACTION;
    UPDATE Subscription
    SET name = pName,
        shoppingDiscount = pShoppingDiscount,
        shippingDiscount = pShippingDiscount
    WHERE idSubscription = pIdSubscription;
    SELECT 'Subscription updated.';
    COMMIT;
END //
DELIMITER ;