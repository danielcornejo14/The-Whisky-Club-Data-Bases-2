DELIMITER //
CREATE PROCEDURE replicateInsertCustomer (
    IN pIdSubscription int,
    IN pEmailAddress varchar(64),
    IN pName varchar(64),
    IN pLastName1 varchar(64),
    IN pLastName2 varchar(64),
    IN pPoint varchar(64),
    IN pUserName varchar(64),
    IN pPassword varchar(64)
)
BEGIN
    IF pIdSubscription IS NOT NULL AND pEmailAddress IS NOT NULL
        AND pName IS NOT NULL AND pLastName1 IS NOT NULL
        AND pLastName2 IS NOT NULL AND pPoint IS NOT NULL
        AND pUserName IS NOT NULL AND pPassword IS NOT NULL
    THEN
        START TRANSACTION;
        INSERT INTO customer(idSubscription, emailAddress,
                             name, lastName1, lastName2,
                             location, userName, password)
        VALUES(pIdSubscription, pEmailAddress,
               pName, pLastName1, pLastName2,
               ST_GeomFromText(pPoint), pUserName, SHA2(pPassword, 256));
        SELECT 'Customer inserted.';
        COMMIT;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;