--Insert images in Whiskey table.
DECLARE @imageWhiskey varbinary(max)
SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 1, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 1, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 2, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 2, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 3, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 3, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s1.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 4, @image = @imageWhiskey

SET @imageWhiskey = (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s2.jpg', SINGLE_BLOB) as T1)
EXEC insertImage @idWhiskey = 4, @image = @imageWhiskey

--Insert subscriptions in Subscription table.
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0
EXEC insertSubscription @name = 'Tier Gleincairn', @shoppingDiscount = 0.1, @shippingDiscount = 0.2
EXEC insertSubscription @name = 'Tier Master Distiller', @shoppingDiscount = 0.3, @shippingDiscount = 1
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0

--Insert customer in Customer Table.
DBCC CHECKIDENT ('Administrator', RESEED, 0)
DECLARE @point geometry;
SET @point = geometry::STPointFromText('POINT (100 100)', 0);
EXEC insertCustomer @emailAddress = 'diego@gmail.com', @name = 'Diego', @lastName1 = 'Cornejo',
                    @lastName2 = 'Corrales', @location = @point, @userName = 'die', @password = 'Die12378!'

--Insert administrator in Administrator Table.
EXEC insertAdministrator @emailAddress = 'correo@fakemail.com', @name = 'Alejandro',
                         @userName = 'alecor14', @password = 'Password124!',
                         @lastName1 = 'Cornejo', @lastName2 = 'Granados'
exec validateAdministrator @userName = 'alecor14', @password = 'Password124!'