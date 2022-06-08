# Employee_dbs tables creation
CREATE TABLE Currency(
    idCurrency int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1 #1 active and 0 inactive (deleted)
);
CREATE TABLE Country(
    idCountry int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idCurrency int NOT NULL,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1, #1 active and 0 inactive (deleted)
    FOREIGN KEY (idCurrency) REFERENCES Currency(idCurrency)
);
CREATE TABLE Shop(
    idShop int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idCountry int NOT NULL,
    name varchar(64) NOT NULL,
    phone varchar(8) NOT NULL,
    location geometry NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idCountry) REFERENCES Country(idCountry)
);
CREATE TABLE Department (
    idDepartment int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idShop int NOT NULL,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idShop) REFERENCES Shop(idShop)
);
CREATE TABLE EmployeeType (
    idEmployeeType int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
);
CREATE TABLE Subscription(
    idSubscription int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    name varchar(64) NOT NULL,
    shoppingDiscount float NOT NULL,
    shippingDiscount float NOT NULL,
    status bit NOT NULL DEFAULT 1
);
CREATE TABLE Customer(
    idCustomer int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idSubscription int NOT NULL,
    emailAddress varchar(64) NOT NULL,
    name varchar(64) NOT NULL,
    lastName1 varchar(64) NOT NULL,
    lastName2 varchar(64) NOT NULL,
    location geometry NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idSubscription) REFERENCES Subscription(idSubscription)
);
CREATE TABLE Employee(
    idEmployee int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idDepartment int NOT NULL,
    idEmployeeType int NOT NULL,
    name varchar(64) NOT NULL,
    lastName1 varchar(64) NOT NULL,
    lastName2 varchar(64) NOT NULL,
    localSalary decimal(15,4) NOT NULL,
    dollarSalary decimal(15,4) NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idDepartment) REFERENCES Department(idDepartment),
    FOREIGN KEY (idEmployeeType) REFERENCES EmployeeType(idEmployeeType)
);
CREATE TABLE EmployeeReview(
    idEmployeeReview int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    idCustomer int NOT NULL,
    idEmployee int NOT NULL,
    comment varchar(64) NOT NULL,
    evaluation int NOT NULL,
    date date NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idCustomer) REFERENCES Customer(idCustomer),
    FOREIGN KEY (idEmployee) REFERENCES Employee(idEmployee)
);