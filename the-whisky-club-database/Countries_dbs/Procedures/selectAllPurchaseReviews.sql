CREATE PROCEDURE selectAllPurchaseReviews
WITH ENCRYPTION
AS
BEGIN
    SELECT idPurchaseReview, idSale, comment, date, status
    FROM PurchaseReview
    WHERE status = 1
END
GO