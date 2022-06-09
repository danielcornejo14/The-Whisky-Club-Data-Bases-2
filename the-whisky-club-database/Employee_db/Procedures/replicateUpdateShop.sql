DELIMITER //
CREATE PROCEDURE replicateUpdateShop (
     IN pIdShop int,
     IN pIdCountry int,
     IN pName varchar(64),
     IN pPhone int,
     IN pPoint varchar(64)
)
BEGIN
    DECLARE pLocation geometry;
    SET pLocation = ST_GeomFromText(pPoint);
    START TRANSACTION;
    UPDATE Shop
    SET idCountry = pIdCountry,
        name = pName,
        phone = pPhone,
        location = pLocation
    WHERE idShop = pIdShop;
    COMMIT;
END //
DELIMITER ;