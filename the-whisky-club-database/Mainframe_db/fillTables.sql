--Insert subscriptions in Subscription table.
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0
EXEC insertSubscription @name = 'Tier Gleincairn', @shoppingDiscount = 0.1, @shippingDiscount = 0.2
EXEC insertSubscription @name = 'Tier Master Distiller', @shoppingDiscount = 0.3, @shippingDiscount = 1
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0

--Insert customer in Customer Table.
DBCC CHECKIDENT ('Subscription', RESEED, 4)
DECLARE @point geometry;
SET @point = geometry::STPointFromText('POINT (100 100)', 0);
EXEC insertCustomer @emailAddress = 'diego@gmail.com', @name = 'Diego', @lastName1 = 'Cornejo',
                    @lastName2 = 'Corrales', @location = @point, @userName = 'die', @password = 'Die12378!'

--Insert administrator in Administrator Table.
EXEC insertAdministrator @emailAddress = 'correo@fakemail.com', @name = 'Alejandro',
                         @userName = 'alecor14', @password = 'Password124!',
                         @lastName1 = 'Cornejo', @lastName2 = 'Granados'
exec validateAdministrator @userName = 'alecor14', @password = 'Password124!'

--Insert payment methods
EXEC insertPaymentMethod @name = 'Credit card';
EXEC insertPaymentMethod @name = 'Cash';
EXEC insertPaymentMethod @name = 'Tranference';

--Insert shop
DECLARE @point geometry;
SET @point = geometry::STPointFromText('POINT (1 1)', 0);
--1) USA , 2)Ireland, 3) Scotland
exec insertShop @idCountry = 2, @name = 'IrelandShop1', @phone = 11112222, @location = @point

--Insert whiskey type
EXEC insertWhiskeyType @name = 'Single Malt'
EXEC insertWhiskeyType @name = 'Blended Scotch'
EXEC insertWhiskeyType @name = 'Irish'
EXEC insertWhiskeyType @name = 'Blended Malt'
EXEC insertWhiskeyType @name = 'Bourbon'
EXEC insertWhiskeyType @name = 'Tennessee'
EXEC insertWhiskeyType @name = 'Blended Canadian'
------------------------

--Insert presentation
INSERT INTO Presentation(description)
VALUES ('Glass bottle')
INSERT INTO Presentation(description)
VALUES ('Plastic bottle')
--------------------

--Insert supplier
INSERT INTO Supplier(name, emailAddress)
VALUES ('Natural State Distributing', 'fakeemail@email.com')
INSERT INTO Supplier(name, emailAddress)
VALUES ('Breakthru Beverage Group', 'fakeemail2@email.com')
INSERT INTO Supplier(name, emailAddress)
VALUES ('Republic National Distributing Co', 'fakeemail3@email.com')
INSERT INTO Supplier(name, emailAddress)
VALUES ('United Distributors', 'fakeemail4@email.com')
INSERT INTO Supplier(name, emailAddress)
VALUES ('Iowa Alcoholic Beverages Division', 'fakeemail5@email.com')
INSERT INTO Supplier(name, emailAddress)
VALUES ('Liquor Barn', 'fakeemail6@email.com')
--------------------
--Insert whiskey
EXEC insertWhiskey @idSupplier = 1, @idPresentation = 1, @idWhiskeyType = 2,
                   @brand = 'Buchanan''s', @price = 24.98, @alcoholContent = 0.40,
                   @productionDate = N'2020-05-04', @dueDate = N'2024-05-04', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 12, @special = 1
EXEC insertWhiskey @idSupplier = 2, @idPresentation = 1, @idWhiskeyType = 2,
                   @brand = 'Chivas Regal', @price = 29.73, @alcoholContent = 0.40,
                   @productionDate = N'2019-01-02', @dueDate = N'2022-01-02', @availability = 1,
                   @millilitersQuantity = 1000, @whiskeyAging = 12, @special = 1
EXEC insertWhiskey @idSupplier = 3, @idPresentation = 1, @idWhiskeyType = 6,
                   @brand = 'Jack Daniel''s', @price = 16.98, @alcoholContent = 0.40,
                   @productionDate = N'2017-10-10', @dueDate = N'2021-10-10', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 7, @special = 0
EXEC insertWhiskey @idSupplier = 4, @idPresentation = 1, @idWhiskeyType = 2,
                   @brand = 'Johnnie Walker', @price = 29.98, @alcoholContent = 0.40,
                   @productionDate = N'2020-08-11', @dueDate = '2023-08-11', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 12, @special = 1
EXEC insertWhiskey @idSupplier = 5, @idPresentation = 1, @idWhiskeyType = 7,
                   @brand = 'Crown Royal', @price = 19.98, @alcoholContent = 0.40,
                   @productionDate = N'2020-01-01', @dueDate = N'2025-01-01', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 9, @special = 1
EXEC insertWhiskey @idSupplier = 6, @idPresentation = 1, @idWhiskeyType = 3,
                   @brand = 'Jameson', @price = 22.48, @alcoholContent = 0.40,
                   @productionDate = N'2021-05-10', @dueDate = N'2026-05-10', @availability = 1,
                   @millilitersQuantity = 700, @whiskeyAging = 4, @special = 0
EXEC insertWhiskey @idSupplier = 1, @idPresentation = 1, @idWhiskeyType = 1,
                   @brand = 'The Glenlivet', @price = 33.98, @alcoholContent = 0.40,
                   @productionDate = N'2018-10-20', @dueDate = N'2020-10-20', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 12, @special = 0
EXEC insertWhiskey @idSupplier = 2, @idPresentation = 1, @idWhiskeyType = 5,
                   @brand = 'Buffalo Trace', @price = 25.98, @alcoholContent = 0.45,
                   @productionDate = N'2019-07-15', @dueDate = N'2022-07-15', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 5, @special = 0
EXEC insertWhiskey @idSupplier = 3, @idPresentation = 1, @idWhiskeyType = 5,
                   @brand = 'Woodford Reserve', @price = 31.98, @alcoholContent = 0.45,
                   @productionDate = N'2019-02-14', @dueDate = N'2026-02-14', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 8, @special = 1
EXEC insertWhiskey @idSupplier = 4, @idPresentation = 1, @idWhiskeyType = 3,
                   @brand = 'Proper No. Twelve', @price = 19.98, @alcoholContent = 0.40,
                   @productionDate = N'2020-11-02', @dueDate = N'2023-11-02', @availability = 1,
                   @millilitersQuantity = 750, @whiskeyAging = 4, @special = 0
--------------------

--Insert images in Whiskey table.
DECLARE @imageWhiskey varbinary(max)

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 1, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 1, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 2, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 2, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 3, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 3, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 4, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 4, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\CrownRoyal1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 5, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\CrownRoyal2.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 5, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Jameson1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 6, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Jameson2.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 6, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\TheGlenlivet1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 7, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\TheGlenlivet2.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 7, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\BuffaloTrace1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 8, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\BuffaloTrace2.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 8, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\WoodfordReserve1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 9, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\WoodfordReserve2.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 9, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ProperTwelve1.jpeg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 10, @image = @imageWhiskey