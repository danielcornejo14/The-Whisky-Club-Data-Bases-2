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
    IF pIdCountry IS NOT NULL AND pName IS NOT NULL AND pPhone IS NOT NULL
       AND pPoint IS NOT NULL AND pLocation IS NOT NULL AND pIdShop IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM Shop WHERE name = pName) = 0
            AND (SELECT COUNT(idCountry) FROM Country WHERE idCountry = pIdCountry
                AND status = 1) > 0
            AND (SELECT COUNT(location) FROM Shop WHERE (ST_Equals(location, pLocation) = 1)) = 0
            AND (SELECT COUNT(idShop) FROM shop WHERE idShop = pIdShop AND status = 1) > 0)
        THEN
            IF pPhone REGEXP '[0-9]{8}'
            THEN
                IF (SELECT COUNT(phone) FROM Shop WHERE phone = pPhone) = 0
                THEN
                    UPDATE Shop
                    SET idCountry = pIdCountry,
                        name = pName,
                        phone = pPhone,
                        location = pLocation
                    WHERE idShop = pIdShop;
                ELSE
                    SELECT 'The phone number cannot be repeated.';
                END IF;
            ELSE
                SELECT 'The phone number must be 8 digits.';
            END IF;
        ELSE
            SELECT 'The shop name and the location cannot be repeated, the id must exist.';
        END IF;
    ELSE
        SELECT 'Null data is not allowed.';
    END IF;
END //
DELIMITER ;