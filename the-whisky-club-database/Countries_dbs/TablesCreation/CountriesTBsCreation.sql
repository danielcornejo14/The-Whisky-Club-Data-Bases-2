--Countries_dbs tables creation
CREATE TABLE Currency(
    idCurrency int PRIMARY KEY IDENTITY (1,1) NOT NULL,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1--1 active and 0 inactive (deleted)
)
CREATE TABLE Country(
    idCountry int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    idCurrency int NOT NULL FOREIGN KEY REFERENCES Currency(idCurrency),
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1--1 active and 0 inactive (deleted)
)
CREATE TABLE Shop(
    idShop int PRIMARY KEY NOT NULL,
    idCountry int NOT NULL FOREIGN KEY REFERENCES Country(idCountry),
    name varchar(64) NOT NULL,
    phone varchar(8) NOT NULL,
    location geometry NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Presentation(
    idPresentation int PRIMARY KEY IDENTITY (1,1),
    description varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Supplier(
    idSupplier int PRIMARY KEY IDENTITY (1,1),
    name varchar(64) NOT NULL,
    emailAddress varchar(64) NOT NULL,
    status varchar(64) NOT NULL DEFAULT 1
)
CREATE TABLE WhiskeyType(
    idWhiskeyType int PRIMARY KEY IDENTITY (1,1),
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Whiskey(
    idWhiskey int PRIMARY KEY IDENTITY (1,1),
    idSupplier int NOT NULL FOREIGN KEY REFERENCES Supplier(idSupplier),
    idPresentation int NOT NULL FOREIGN KEY REFERENCES Presentation(idPresentation),
    idWhiskeyType int NOT NULL FOREIGN KEY REFERENCES WhiskeyType(idWhiskeyType),
    brand varchar(64) NOT NULL,
    price money NOT NULL,
    alcoholContent float NOT NULL,
    productionDate date NOT NULL,
    dueDate date NOT NULL,
    availability bit NOT NULL, --0 is not available and 1 is available.
    millilitersQuantity float NOT NULL,
    whiskeyAging int NOT NULL, --It is measured in years.
    special bit NOT NULL, --0 indicates that is not a special whiskey and 1 when it is.
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Image(
    idImage int PRIMARY KEY IDENTITY (1,1),
    idWhiskey int NOT NULL FOREIGN KEY REFERENCES Whiskey(idWhiskey),
    image VARBINARY(MAX) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE WhiskeyXShop (
    idWhiskeyXShop int PRIMARY KEY IDENTITY(1,1),
    idShop int NOT NULL FOREIGN KEY REFERENCES Shop(idShop),
    idWhiskey int NOT NULL FOREIGN KEY REFERENCES Whiskey(idWhiskey),
    currentStock int NOT NULL,
    availability bit NOT NULL, --0 is not available and 1 is available.
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE PaymentMethod(
    idPaymentMethod int PRIMARY KEY IDENTITY(1,1),
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Subscription(
    idSubscription int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    name varchar(64) NOT NULL,
    shoppingDiscount float NOT NULL,
    shippingDiscount float NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Customer(
    idCustomer int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    idSubscription int NOT NULL FOREIGN KEY REFERENCES Subscription(idSubscription),
    emailAddress varchar(64) NOT NULL,
    name varchar(64) NOT NULL,
    lastName1 varchar(64) NOT NULL,
    lastName2 varchar(64) NOT NULL,
    location geometry NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE WhiskeyReview(
    idWhiskeyReview int PRIMARY KEY IDENTITY(1,1),
    idCustomer int FOREIGN KEY REFERENCES Customer(idCustomer),
    idWhiskey int NOT NULL FOREIGN KEY REFERENCES Whiskey(idWhiskey),
    comment varchar(max) NOT NULL,
    evaluation int NOT NULL,
    date date NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE EmployeeType (
    idEmployeeType int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Department (
    idDepartment int PRIMARY KEY NOT NULL,
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Employee(
    idEmployee int PRIMARY KEY NOT NULL,
    idDepartment int NOT NULL,
    idEmployeeType int NOT NULL,
    idShop int NOT NULL,
    name varchar(64) NOT NULL,
    lastName1 varchar(64) NOT NULL,
    lastName2 varchar(64) NOT NULL,
    localSalary decimal(15,4) NOT NULL,
    dollarSalary decimal(15,4) NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idDepartment) REFERENCES Department(idDepartment),
    FOREIGN KEY (idEmployeeType) REFERENCES EmployeeType(idEmployeeType),
    FOREIGN KEY (idShop) REFERENCES Shop(idShop)
)
CREATE TABLE EmployeeReview(
    idEmployeeReview int PRIMARY KEY NOT NULL,
    idCustomer int NOT NULL,
    idEmployee int NOT NULL,
    comment varchar(64) NOT NULL,
    evaluation int NOT NULL,
    date date NOT NULL,
    resolved bit NOT NULL,
    administratorComment varchar(200) NOT NULL,
    status bit NOT NULL DEFAULT 1,
    FOREIGN KEY (idCustomer) REFERENCES Customer(idCustomer),
    FOREIGN KEY (idEmployee) REFERENCES Employee(idEmployee)
)
CREATE TABLE Sale(
    idSale int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    idPaymentMethod int NOT NULL FOREIGN KEY REFERENCES PaymentMethod(idPaymentMethod),
    idCashier int NOT NULL FOREIGN KEY REFERENCES Employee(idEmployee),
    idCourier int NOT NULL FOREIGN KEY REFERENCES Employee(idEmployee),
    idShop int NOT NULL FOREIGN KEY REFERENCES Shop(idShop),
    idCustomer int NOT NULL FOREIGN KEY REFERENCES Customer(idCustomer),
    shippingCost money NOT NULL,
    saleDiscount money NOT NULL,
    subTotal money NOT NULL,
    total money NOT NULL,
    date date NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE PurchaseReview (
    idPurchaseReview int PRIMARY KEY IDENTITY (1,1),
    idSale int NOT NULL FOREIGN KEY REFERENCES Sale(idSale),
    comment varchar(64) NOT NULL,
    date date NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE WhiskeyXSale(
    idWhiskeyXSale int PRIMARY KEY IDENTITY (1,1),
    idSale int NOT NULL FOREIGN KEY REFERENCES Sale(idSale),
    idWhiskey int NOT NULL FOREIGN KEY REFERENCES Whiskey(idWhiskey),
    quantity int NOT NULL,
    status bit NOT NULL DEFAULT 1
)