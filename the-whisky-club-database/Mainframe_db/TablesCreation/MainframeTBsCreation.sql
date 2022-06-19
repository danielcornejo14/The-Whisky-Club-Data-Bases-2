--Mainframe_db tables creation
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
CREATE TABLE Administrator (
    idAdministrator int PRIMARY KEY IDENTITY (1,1),
    emailAddress varchar(64) NOT NULL,
    name varchar(64) NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    lastName1 varchar(64) NOT NULL,
    lastName2 varchar(64) NOT NULL,
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
CREATE TABLE PaymentMethod(
    idPaymentMethod int PRIMARY KEY IDENTITY (1,1),
    name varchar(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE WhiskeyReview(
    idWhiskeyReview int PRIMARY KEY IDENTITY (1,1),
    idCustomer int NOT NULL FOREIGN KEY REFERENCES Customer(idCustomer),
    idWhiskey int NOT NULL FOREIGN KEY REFERENCES Whiskey(idWhiskey),
    comment varchar(max) NOT NULL,
    evaluation int, --A score from 1 to 5.
    date date,
    status bit NOT NULL DEFAULT 1
)
CREATE TABLE Shop(
    idShop int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    idCountry int NOT NULL FOREIGN KEY REFERENCES Country(idCountry),
    name varchar(64) NOT NULL,
    phone varchar(8) NOT NULL,
    location geometry NOT NULL,
    status bit NOT NULL DEFAULT 1
)
--Vertical fragmentation of Customer
CREATE TABLE CustomerAccount(
    idCustomer int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)
--Vertical fragmentation of administrator
CREATE TABLE AdministratorAccount(
    idAdministrator int PRIMARY KEY IDENTITY(1,1) NOT NULL,
    userName varchar(64) NOT NULL,
    password binary(64) NOT NULL,
    status bit NOT NULL DEFAULT 1
)