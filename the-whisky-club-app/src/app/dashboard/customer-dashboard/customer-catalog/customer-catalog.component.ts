import { Component, OnInit} from '@angular/core';
import {ActivatedRoute} from "@angular/router";

import {MainframeService} from "../../../_services/mainframe-db/mainframe.service";

import {MatDialog} from "@angular/material/dialog";

import {Whisky} from "../../../_interfaces/Whiskey/Whisky";
import {WhiskyType} from "../../../_interfaces/Whiskey/WhiskyType";
import {Supplier} from "../../../_interfaces/Whiskey/Supplier";
import {Presentation} from "../../../_interfaces/Whiskey/Presentation";
import {Currency} from "../../../_interfaces/Whiskey/Currency";

import { DomSanitizer } from '@angular/platform-browser';
import { CartService } from 'src/app/_services/cart/cart.service';
import { CustomerCheckoutComponent } from './customer-checkout/customer-checkout.component';


@Component({
  selector: 'app-customer-catalog',
  templateUrl: './customer-catalog.component.html',
  styleUrls: ['./customer-catalog.component.scss']
})
export class CustomerCatalogComponent implements OnInit {

  constructor(
    private route: ActivatedRoute,
    private dialog: MatDialog,
    private sanitizer: DomSanitizer,
    private cartService: CartService
  ) { }

  WhiskyList: Whisky[] = []
  WhiskyTypeList: WhiskyType[] = []
  SupplierList: Supplier[] = []
  PresentationList: Presentation[] = []
  CurrencyList: Currency[] = []
  
  country = [{id: 1,name: "United States"},{id: 2,name: "Ireland"},{id:3,name: "Scotland"}]
  countrySelected = 1

  ngOnInit(): void {

    this.WhiskyList = this.route.snapshot.data['whiskey']
    this.WhiskyTypeList = this.route.snapshot.data['whiskeyType']
    this.SupplierList = this.route.snapshot.data['supplier']
    this.PresentationList = this.route.snapshot.data['presentation']
    this.CurrencyList = this.route.snapshot.data['currency']
  
  }


  findWhiskeyType(id: number): any{
    return this.WhiskyTypeList.find(whiskeyType => whiskeyType.idWhiskeyType === id)
  }
  findSupplier(id: number): any{
    return this.SupplierList.find(supplier => supplier.idSupplier === id)
  }
  findPresentation(id: number): any{
    return this.PresentationList.find(presentation => presentation.idPresentation === id)
  }
  findCurrency(id: number): any {
    return this.CurrencyList.find(currency => currency.idCurrency === id)
  }

  buildImage(data: string){
    return this.sanitizer.bypassSecurityTrustResourceUrl("data:image/png;base64, " +data) 
  }


  addToCart(item: Whisky): void{
    this.cartService.cartList.push(item)
  }

  checkOut(){
    const checkOut = this.dialog.open(CustomerCheckoutComponent, {
      width: '60%',
      height: '80%',
      data:{
        buyFrom: this.countrySelected,
      }
    })
  }

}
