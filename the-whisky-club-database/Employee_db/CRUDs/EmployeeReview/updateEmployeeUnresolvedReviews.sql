DELIMITER //
CREATE PROCEDURE updateEmployeeUnresolvedReviews (
	pIdEmployeeReview int,
    pNewComment VARCHAR(200)
)
BEGIN
	IF NOT EXISTS(SELECT * FROM employeereview WHERE idEmployeeReview = pIdEmployeeReview)
    THEN
		SELECT 'The employee review id must exist';
	ELSE IF EXISTS(SELECT * FROM employeereview WHERE idEmployeeReview = pIdEmployeeReview AND resolved = 1)
		THEN
			SELECT 'An unresolved review must be selected';
		ELSE
			UPDATE employeereview
			SET resolved = 1, administratorComment = pNewComment
			WHERE idEmployeeReview = pIdEmployeeReview;
			SELECT 'Review updated successfully';
			COMMIT;
		END IF;
    END IF;
END //
DELIMITER ;