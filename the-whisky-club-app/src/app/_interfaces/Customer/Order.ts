export interface Order{
    idSale: number,
    idPaymentMethod: number,
    idCashier: number,
    idCourier: number,
    idShop: number, 
    idCustomer: number,
    shippingCost:  number,
    saleDiscount: number,
    subTotal: number,
    total: number,
    date: string
}