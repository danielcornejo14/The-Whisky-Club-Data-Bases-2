export interface Whisky{
  idWhiskey: number,
  idSupplier: number,
  idPresentation: number,
  idWhiskeyType: number,
  brand: string,
  price: number,
  alcoholContent: number,
  productionDate: string,
  dueDate: string,
  millilitersQuantity: number,
  whiskeyAging: number,
  special: boolean,
  images: Array<string>
}

