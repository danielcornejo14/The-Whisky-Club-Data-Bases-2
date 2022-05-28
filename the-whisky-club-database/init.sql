-- Create the stored procedure in the specified schema
CREATE PROCEDURE Mainframe.consultarVentas
    @fecha int = NULL,
    @producto int = NULL,
    @Supermercado int = NULL,
AS
    SET NOCOUNT ON
    IF(@fecha IS NOT NULL AND
        @producto IS NOT NULL AND
        @Supermercado IS NOT NULL)
    BEGIN
        IF(Supermercado = 0)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto AND Supermercado_0.Venta.fecha = @fecha
        END
        ELSE IF(Supermercado = 1)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto AND Supermercado_0.Venta.fecha = @fecha
        END
        ELSE IF(Supermercado = 2)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto AND Supermercado_0.Venta.fecha = @fecha
        END
        ELSE
        BEGIN
            PRINT('NO EXISTE EL NODO')
        END
    END
    ELSE IF(@fecha IS NOT NULL AND @producto IS NOT NULL)
    BEGIN
        SELECT  idventa, total from Supermercado_0.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
        WHERE Supermercado_0.Venta.fecha = @fecha
        UNION
        SELECT  idventa, total from Supermercado_1.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_1.ProductoXVenta.idVenta
        WHERE Supermercado_1.Venta.fecha = @fecha
        UNION
        SELECT  idventa, total from Supermercado_2.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_2.ProductoXVenta.idVenta
        WHERE Supermercado_2.Venta.fecha = @fecha
    END

    ELSE IF(@Supermercado is not null and @fecha is not null)
    BEGIN
        IF(Supermercado = 0)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.Venta.fecha = @fecha
        END
        ELSE IF(Supermercado = 1)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.Venta.fecha = @fecha
        END
        ELSE IF(Supermercado = 2)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.Venta.fecha = @fecha
        END
        ELSE
        BEGIN
            PRINT('NO EXISTE EL NODO')
        END
    END
    ELSE IF (@Supermercado is not null and @producto is not null)
    BEGIN
            IF(Supermercado = 0)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto
        END
        ELSE IF(Supermercado = 1)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto
        END
        ELSE IF(Supermercado = 2)
        BEGIN
            SELECT idVenta, total from Supermercado_0.Venta
            INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
            WHERE Supermercado_0.ProductoXVenta.idProducto = @producto
        END
    END
    ELSE
    BEGIN
        SELECT  idventa, total from Supermercado_0.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_0.ProductoXVenta.idVenta
        UNION
        SELECT  idventa, total from Supermercado_1.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_1.ProductoXVenta.idVenta
        UNION
        SELECT  idventa, total from Supermercado_2.Venta
        INNER JOIN Supermercado_0.ProductoXVenta ON Supermercado_0.Venta.idVenta = Supermercado_2.ProductoXVenta.idVenta
   END
GO
-- example to execute the stored procedure we just created
EXECUTE SchemaName.StoredProcedureName 1 /*value_for_param1*/, 2 /*value_for_param2*/
GO