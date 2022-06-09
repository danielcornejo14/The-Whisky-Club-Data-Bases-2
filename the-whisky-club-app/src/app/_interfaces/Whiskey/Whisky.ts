export interface Whisky{
  idWhiskey: number,
  idSupplier: number,
  idPresentation: number,
  idCurrency: number,
  idWhiskeyType: number,
  brand: string,
  price: number,
  alcoholContent: number,
  productionDate: string,
  dueDate: string,
  availability: boolean,
  millilitersQuantity: number,
  whiskeyAging: number,
  special: boolean,
  images: Array<string>
}

