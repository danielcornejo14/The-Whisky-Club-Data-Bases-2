DELIMITER //
CREATE PROCEDURE replicateInsertShop (
     IN pIdCountry int,
     IN pName varchar(64),
     IN pPhone int,
     IN pPoint varchar(64)
)
BEGIN
    DECLARE pLocation geometry;
    SET pLocation = ST_GeomFromText(pPoint);
    START TRANSACTION;
    INSERT INTO shop(idCountry, name, phone, location)
    VALUES(pIdCountry, pName, pPhone, pLocation);
    SELECT 'Shop inserted.';
    COMMIT;
END //
DELIMITER ;