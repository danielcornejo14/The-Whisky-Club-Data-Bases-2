import { Injectable } from '@angular/core';
import { Whisky } from 'src/app/_interfaces/Whiskey/Whisky';

@Injectable({
  providedIn: 'root'
})
export class CartService {

  cartList: Whisky[] = []

  constructor() { }


  insertSale(){
    console.log(this.cartList)
  }

  clearCart(){
    this.cartList =[]
  }

}
