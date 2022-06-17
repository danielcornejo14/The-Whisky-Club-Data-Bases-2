CREATE PROCEDURE deletePaymentMethod @pIdPaymentMethod int
WITH ENCRYPTION
AS
BEGIN
    IF @pIdPaymentMethod IS NOT NULL
    BEGIN
        IF (SELECT COUNT(idPaymentMethod) FROM PaymentMethod WHERE idPaymentMethod = @pIdPaymentMethod
            AND status = 1) > 0
        BEGIN
            BEGIN TRANSACTION
                BEGIN TRY
                    --Delete sale in USA
                    EXEC [UnitedStates_db].[dbo].[deleteSaleByIdPaymentMethod] @idPaymentMethod = @pIdPaymentMethod
                    ---------------------------------------
                    --Delete sale in Ireland
                    EXEC [Ireland_db].[dbo].[deleteSaleByIdPaymentMethod] @idPaymentMethod = @pIdPaymentMethod
                    ---------------------------------------
                    --Delete sale in Scotland
                    EXEC [Scotland_db].[dbo].[deleteSaleByIdPaymentMethod] @idPaymentMethod = @pIdPaymentMethod
                    ---------------------------------------
                    --Delete payment method in mainframe
                    UPDATE PaymentMethod
                    SET status = 0
                    WHERE idPaymentMethod = @pIdPaymentMethod
                    ---------------------------------
                    --Delete payment method replication in countries
                    UPDATE UnitedStates_db.dbo.PaymentMethod
                    SET status = 0
                    WHERE idPaymentMethod = @pIdPaymentMethod
                    UPDATE Scotland_db.dbo.PaymentMethod
                    SET status = 0
                    WHERE idPaymentMethod = @pIdPaymentMethod
                    UPDATE Ireland_db.dbo.PaymentMethod
                    SET status = 0
                    WHERE idPaymentMethod = @pIdPaymentMethod
                    ---------------------------------
                    PRINT('PaymentMethod deleted.')
                    COMMIT TRANSACTION
                END TRY
                BEGIN CATCH
                    ROLLBACK TRANSACTION
                    RAISERROR('An error has occurred in the database.', 11, 1)
                END CATCH
        END
        ELSE
        BEGIN
            RAISERROR('The payment method id must exist.', 11, 1)
        END
    END
    ELSE
    BEGIN
        RAISERROR('Null data is not allowed.', 11, 1)
    END
END
GO