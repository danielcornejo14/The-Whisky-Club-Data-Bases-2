DELIMITER //
CREATE PROCEDURE validateEmployee (
     IN pUserName varchar(64),
     IN pPassword varchar(64)
)
BEGIN
    IF (SELECT COUNT(idEmployee) FROM EmployeeAccount WHERE userName = pUserName
        AND status = 1 AND password = SHA2(pPassword, 256)) > 0
    THEN
        select '00' as message; #The idAdmin or password are correct.
    ELSE
        select '01' as message; #The idAdmin and password are incorrect.
    END IF;
END //
DELIMITER ;