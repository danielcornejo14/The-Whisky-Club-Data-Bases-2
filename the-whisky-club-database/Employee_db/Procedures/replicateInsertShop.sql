DELIMITER //
CREATE PROCEDURE replicateInsertShop (
     IN pIdCountry int,
     IN pName varchar(64),
     IN pPhone int,
     IN pPoint varchar(64)
)
BEGIN
    IF pIdCountry IS NOT NULL AND pName IS NOT NULL AND pPhone IS NOT NULL
       AND pPoint IS NOT NULL
    THEN
        IF ((SELECT COUNT(name) FROM Shop WHERE name = pName) = 0
            AND (SELECT COUNT(idCountry) FROM Country WHERE idCountry = pIdCountry
                AND status = 1) > 0
            AND (SELECT COUNT(location) FROM Shop WHERE (ST_Equals(location, ST_GeomFromText(pPoint)) = 1)) = 0)
        THEN
            IF pPhone REGEXP '[0-9]{8}'
            THEN
                IF (SELECT COUNT(phone) FROM Shop WHERE phone = pPhone) = 0
                THEN
                    START TRANSACTION;
                    INSERT INTO shop(idCountry, name, phone, location)
                    VALUES(pIdCountry, pName, pPhone, ST_GeomFromText(pPoint));
                    SELECT 'Shop inserted.';
                    COMMIT;
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