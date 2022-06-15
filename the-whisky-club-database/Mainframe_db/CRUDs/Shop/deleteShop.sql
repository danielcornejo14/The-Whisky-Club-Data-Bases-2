CREATE PROCEDURE deleteShop @idShop int
WITH ENCRYPTION
AS
BEGIN
    IF @idShop IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idShop) FROM Shop WHERE idShop = @idShop
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Creation of a temporal table to store the department table
                    SELECT D.idDepartment, D.idShop, D.name, D.status
                    INTO #Department
                    FROM mysql_server...department D
                    --Delete department cursor
                    DECLARE @idDepartmentString varchar(5)
                    DECLARE @idDepartmentCursor int, @idShopCursor int
                    DECLARE departmentCursor CURSOR FOR SELECT
                    idDepartment, idShop FROM #Department
                    OPEN departmentCursor
                    FETCH NEXT FROM departmentCursor INTO @idDepartmentCursor, @idShopCursor
                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        IF @idShop = @idShopCursor
                            SET @idDepartmentString = CAST(@idDepartmentCursor as varchar(5))
                            EXEC('CALL deleteDepartment(' + @idDepartmentString + ')') AT MYSQL_SERVER
                        FETCH NEXT FROM departmentCursor INTO @idDepartmentCursor, @idShopCursor
                    END
                    CLOSE departmentCursor
                    DEALLOCATE departmentCursor
                    --Drop temporal table
                    DROP TABLE #Department
                    --------------------------
                    DECLARE @idCountry int
                    SET @idCountry = (SELECT(idCountry) FROM Shop WHERE idShop = @idShop)
                    IF @idCountry = 1 --1 is for USA.
                    BEGIN
                        --Delete whiskey x customer
                        UPDATE UnitedStates_db.dbo.WhiskeyXCustomer
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE UnitedStates_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete shop in the USA db
                        UPDATE UnitedStates_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @idShop
                    END
                    ELSE IF @idCountry = 2 --2 is for Ireland
                    BEGIN
                        --Delete whiskey x customer
                        UPDATE Ireland_db.dbo.WhiskeyXCustomer
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE Ireland_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete shop in the Ireland db
                        UPDATE Ireland_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @idShop
                    END
                    ELSE IF @idCountry = 3 --3 is for Scotland
                    BEGIN
                        --Delete whiskey x customer
                        UPDATE Scotland_db.dbo.WhiskeyXCustomer
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete whiskey x shop
                        UPDATE Scotland_db.dbo.WhiskeyXShop
                        SET status = 0
                        WHERE idShop = @idShop
                        --------------------------
                        --Delete shop in the Scotland db
                        UPDATE Scotland_db.dbo.Shop
                        SET status = 0
                        WHERE idShop = @idShop
                    END
                    --------------------------
                    --Delete shop in Mainframe
                    UPDATE Shop
                    SET status = 0
                    WHERE idShop = @idShop
                    --------------------------
                    --Delete country in employees db
                    DECLARE @idShopString varchar(5)
                    SET @idShopString = CAST(@idShop as varchar(5))
                    EXEC('CALL replicateDeleteShop(' + @idShopString + ')') AT MYSQL_SERVER
                    PRINT('Shop deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The Shop id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO