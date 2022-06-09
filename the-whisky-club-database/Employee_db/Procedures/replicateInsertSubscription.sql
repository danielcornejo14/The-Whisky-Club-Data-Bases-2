DELIMITER //
CREATE PROCEDURE replicateInsertSubscription (
     IN pName varchar(64),
     IN pShoppingDiscount float,
     IN pShippingDiscount float
)
BEGIN
    START TRANSACTION;
    INSERT INTO subscription(name, shoppingDiscount, shippingDiscount)
    VALUES(pName, pShoppingDiscount, pShippingDiscount);
    SELECT 'Subscription inserted.';
    COMMIT;
END //
DELIMITER ;