--this will consult on the employees with the given filters
CREATE OR ALTER PROCEDURE employeesReport
	@departmentName varchar(50),
	@minimumAverageScore int,
	@maximumAverageScore int,
	@minimumLocalSalary float,
	@maximumLocalSalary float,
	@minimumDollarSalary float,
	@maximumDollarSalary float
WITH ENCRYPTION
AS
BEGIN
	SELECT idEmployee, employeeName, idDepartment, departmentName, localSalary, dollarSalary, employeeStatus, evaluationAverage
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
			(SELECT IFNULL(AVG(evaluation), 0) FROM employeereview ER WHERE ER.idEmployee =  E.idEmployee)  AS evaluationAverage
		FROM employee E
		INNER JOIN department D ON D.idDepartment = E.idDepartment
        GROUP BY idEmployee '
	)
	WHERE (@departmentName IS NULL OR @departmentName = departmentName) AND
		  (@minimumAverageScore IS NULL OR @minimumAverageScore < evaluationAverage) AND 
	      (@maximumAverageScore IS NULL OR evaluationAverage < @maximumAverageScore) AND
		  (@minimumLocalSalary IS NULL OR @minimumLocalSalary < localSalary) AND
		  (@maximumLocalSalary IS NULL OR localSalary < @maximumLocalSalary) AND
		  (@minimumDollarSalary IS NULL OR @minimumDollarSalary < dollarSalary) AND
		  (@maximumDollarSalary IS NULL OR dollarSalary < @maximumDollarSalary);
END;
go

EXEC employeesReport 'TI', NULL, 3, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, NULL, NULL, NULL, NULL, NULL, NULL;
EXEC employeesReport 'Logistics and Operations', NULL, NULL, NULL, NULL, NULL, NULL;
EXEC employeesReport 'Financial', NULL, NULL, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, 1, 3, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, NULL, 3, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, NULL, 1, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, 1, NULL, NULL, NULL, NULL, NULL;
EXEC employeesReport NULL, NULL, NULL, 1000, 2000, NULL, NULL;
EXEC employeesReport NULL, NULL, NULL, 1000, NULL, NULL, NULL;
EXEC employeesReport NULL, NULL, NULL, NULL, 3000, NULL, NULL;
EXEC employeesReport NULL, NULL, NULL, 2000, NULL, 2000, 3000;
EXEC employeesReport 'TI', NULL, NULL, 1000, NULL, 2000, 3000;
go
