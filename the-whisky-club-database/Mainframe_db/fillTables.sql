--Insert images in Whiskey table.
INSERT INTO Image(idWhiskey, image)
VALUES (1, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker1.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (1, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JohnnieWalker2.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (2, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels1.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (2, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\JackDaniels2.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (3, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal1.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (3, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\ChivasRegal2.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (4, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s1.jpg', SINGLE_BLOB) as T1))
INSERT INTO Image(idWhiskey, image)
VALUES (4, (SELECT * FROM OPENROWSET(BULK N'C:\Users\GabrielPC\Documents\The-Whisky-Club-Data-Bases-2\the-whisky-club-database\Mainframe_db\Images\Buchanan''s2.jpg', SINGLE_BLOB) as T1))

--Insert subscriptions in Subscription table.
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0
EXEC insertSubscription @name = 'Tier Gleincairn', @shoppingDiscount = 0.1, @shippingDiscount = 0.2
EXEC insertSubscription @name = 'Tier Master Distiller', @shoppingDiscount = 0.3, @shippingDiscount = 1
EXEC insertSubscription @name = 'Tier Short Glass', @shoppingDiscount = 0.05, @shippingDiscount = 0