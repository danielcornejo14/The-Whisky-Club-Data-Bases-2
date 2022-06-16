import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Whisky} from "../../_interfaces/Whiskey/Whisky";
import {environment} from "../../../environments/environment";
import {Presentation} from "../../_interfaces/Whiskey/Presentation";
import {WhiskyType} from "../../_interfaces/Whiskey/WhiskyType";
import {Supplier} from "../../_interfaces/Whiskey/Supplier";
import {Currency} from "../../_interfaces/Whiskey/Currency";
import { Customer } from 'src/app/_interfaces/Customer/Customer';
import { PaymentMethod } from 'src/app/_interfaces/Customer/PaymentMethod';

const DB_URL = environment.apiUrl+'/main-db'

@Injectable({
  providedIn: 'root'
})
export class MainframeService {

  constructor(
    private http: HttpClient
  ) { }


  // =================
  // ==== Insert =====
  // =================

  createWhiskey(whiskey: Whisky){
    return this.http.post(DB_URL+'/insertWhiskey', whiskey)
  }

  createCustomer(customer: Customer){
    return this.http.post(DB_URL+'/insertCustomer', customer)
  }

  // =================
  // ==== Select =====
  // =================
  getWhiskey(){
    return this.http.get<Whisky[]>(DB_URL+'/selectWhiskey')
  }
  getPresentation(){
    return this.http.get<Presentation[]>(DB_URL+'/selectPresentation')
  }
  getWhiskeyType(){
    return this.http.get<WhiskyType[]>(DB_URL+'/selectWhiskeyType')
  }
  getSupplier(){
    return this.http.get<Supplier[]>(DB_URL+'/selectSupplier')
  }
  getCurrency(){
    return this.http.get<Currency[]>(DB_URL+'/selectCurrency')
  }
  getPaymentMethods(){
    return this.http.get<PaymentMethod[]>(DB_URL+'/selectPaymentMethod')
  }

  // =================
  // ==== Updates ====
  // =================

  updateWhiskey(whiskey: Whisky){
    return this.http.post(DB_URL+'/updateWhiskey', whiskey)
  }

  // =================
  // ==== Deletes ====
  // =================

  deleteWhiskey(whiskeyId: number){
    return this.http.post(DB_URL+'/deleteWhiskey', {"id":whiskeyId})
  }

}
