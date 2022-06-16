CREATE PROCEDURE selectAllPurchaseReviews
WITH ENCRYPTION
AS
BEGIN
    SELECT idPurchaseReview, idWhiskeyXCustomer, comment, date, status
    FROM PurchaseReview
    WHERE status = 1
END
GO