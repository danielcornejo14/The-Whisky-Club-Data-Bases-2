import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Whisky } from 'src/app/_interfaces/Whiskey/Whisky';
import { environment } from 'src/environments/environment';
import { TokenStorageService } from '../auth/token-storage.service';


const US_DB_URL = environment.apiUrl+'/us-db'
const IR_DB_URL = environment.apiUrl+'/ir-db'
const SC_DB_URL = environment.apiUrl+'/sc-db'


@Injectable({
  providedIn: 'root'
})
export class CountriesDbService {

  constructor(
    private http: HttpClient,
  ) { }

// US

  getUsPrice(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(US_DB_URL+'/selectTotal', order)
  }

  processUsSale(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(US_DB_URL+'/insertSale', order)
  }

  filterUsWhiskeys(filter: any){
    return this.http.post<Whisky[]>(US_DB_URL+'/filterWhiskey', filter)
  }

// IR

  getIrPrice(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(IR_DB_URL+'/selectTotal', order)
  }

  processIrSale(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(IR_DB_URL+'/insertSale', order)
  }

  filterIrWhiskeys(filter: any){
    return this.http.post<Whisky[]>(IR_DB_URL+'/filterWhiskey', filter)
  }

// SC

  getScPrice(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(SC_DB_URL+'/selectTotal', order)
  }

  processScSale(order: any){
    let productIndex: number[] = []
    order.cart.forEach((x: any) => productIndex.push(x.idWhiskey))
    order.cart = productIndex
    return this.http.post(SC_DB_URL+'/insertSale', order)
  }

  filterScWhiskeys(filter: any){
    return this.http.post<Whisky[]>(SC_DB_URL+'/filterWhiskey', filter)
  }
  
}

