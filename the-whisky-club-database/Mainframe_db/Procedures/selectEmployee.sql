--this will consult on the employees with the given filters
CREATE OR ALTER PROCEDURE selectEmployees
	@department int,
	@minimumAverageScore int,
	@maximumAverageScore int,
	@minimumLocalSalary float,
	@maximumLocalSalary float,
	@minimumDollarSalary float,
	@maximumDollarSalary float
WITH ENCRYPTION
AS
BEGIN
	SELECT idEmployee, employeeName, departmentName, localSalary, dollarSalary, employeeStatus, evaluationAverage
	FROM OPENQUERY(
		MYSQL_SERVER,
		'SELECT
			E.idEmployee,
			E.name AS employeeName,
			D.name AS departmentName,
			D.idDepartment AS idDepartment,
			localSalary,
			dollarSalary,
			E.status AS employeeStatus,
			AVG(evaluation) AS evaluationAverage
		FROM employee E
		INNER JOIN department D ON D.idDepartment = E.idDepartment
		INNER JOIN employeereview ER ON ER.idEmployee = E.idEmployee'
	)
	WHERE (@department IS NULL OR @department = idDepartment) AND
		  (@minimumAverageScore IS NULL OR @minimumAverageScore < evaluationAverage) AND 
		  (@maximumAverageScore IS NULL OR evaluationAverage > @maximumAverageScore) AND
		  (@minimumLocalSalary IS NULL OR @minimumLocalSalary < localSalary) AND
		  (@maximumLocalSalary IS NULL OR localSalary > @maximumLocalSalary) AND
		  (@minimumDollarSalary IS NULL OR @minimumDollarSalary < dollarSalary) AND
		  (@maximumDollarSalary IS NULL OR dollarSalary > @maximumDollarSalary);
END;