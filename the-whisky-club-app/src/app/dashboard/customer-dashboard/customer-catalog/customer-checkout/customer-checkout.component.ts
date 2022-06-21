import { HttpClient } from '@angular/common/http';
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { DomSanitizer } from '@angular/platform-browser';
import { CartService } from 'src/app/_services/cart/cart.service';
import { CountriesDbService } from 'src/app/_services/countries-db/countries-db.service';

import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { PaymentMethod } from 'src/app/_interfaces/Customer/PaymentMethod';

@Component({
  selector: 'app-customer-checkout',
  templateUrl: './customer-checkout.component.html',
  styleUrls: ['./customer-checkout.component.scss']
})
export class CustomerCheckoutComponent implements OnInit {

  apiLoaded: Observable<boolean>;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<CustomerCheckoutComponent>,
    public cartService: CartService,
    private countryService: CountriesDbService,
    private mainframeService: MainframeService,
    private storageService: TokenStorageService,
    private sanitizer: DomSanitizer,
    public httpClient: HttpClient

  ) {
    this.apiLoaded = httpClient.jsonp('https://maps.googleapis.com/maps/api/js?key=AIzaSyBiwqpFIEIjdkIjiS4ycPJVbrKWnZDUBDE', 'callback')
        .pipe(
          map(() => true),
          catchError(() => of(false)),
        );
  }

  //MAPS API
  center: google.maps.LatLngLiteral = {lat: 9.856060396098256, lng: -83.90951249096007};
  zoom = 15;
  markerOptions: google.maps.MarkerOptions = {draggable: false};
  markerPosition: google.maps.LatLngLiteral | undefined;

  //Component Variables
  paymentMethods: PaymentMethod[] = []
  selectedMethod = 1
  saleInfo: any = {}
  saleFlag: number = 0

  ngOnInit(): void {
    this.mainframeService.getPaymentMethods().subscribe(methods => this.paymentMethods = methods)
  }

  buildImage(data: string){
    return this.sanitizer.bypassSecurityTrustResourceUrl("data:image/png;base64, " +data) 
  }

  getTotal(){
    let order = {
      username: this.storageService.getUser(),
      cart: this.cartService.cartList,
      method: this.selectedMethod,
      location: {
        lng: this.markerPosition?.lng,
        lat: this.markerPosition?.lat
      }
    }
    switch(this.data.buyFrom){
      case 1:
        //US
        this.countryService.getUsPrice(order).subscribe((info: any )=> {
          if(info.CODE == '00'){
            this.saleFlag = 1
          }
          else{
            this.saleFlag = 2
            this.saleInfo = info
          }
        })
        break;
      case 2:
        //IR
        this.countryService.getIrPrice(order).subscribe((info: any )=> {
          if(info.CODE == '00'){
            this.saleFlag = 1
          }
          else{
            this.saleFlag = 2
            this.saleInfo = info
          }
        })
        break;
      case 3:
        //SC
        this.countryService.getScPrice(order).subscribe((info: any )=> {
          if(info.CODE == '00'){
            this.saleFlag = 1
          }
          else{
            this.saleFlag = 2
            this.saleInfo = info
          }
        })
        break;
    }
  }

  checkOut(){
    let order = {
      username: this.storageService.getUser(),
      cart: this.cartService.cartList,
      method: this.selectedMethod,
      location: {
        lng: this.markerPosition?.lng,
        lat: this.markerPosition?.lat
      }
    }
    console.log(order)
    switch(this.data.buyFrom){
      case 1:
        //US
        this.countryService.processUsSale(order).subscribe(info => console.log(info))
        break;
      case 2:
        //IR
        this.countryService.processIrSale(order).subscribe(info => console.log(info))
        break;
      case 3:
        //SC
        this.countryService.processScSale(order).subscribe(info => console.log(info))
        break;
    }
  }

  clearCart(){
    this.cartService.clearCart()
  }

  addMarker(event: google.maps.MapMouseEvent) {
    this.markerPosition = event.latLng!.toJSON()
  }

  saveLocation(){
    console.log(this.markerPosition)
  }
}
