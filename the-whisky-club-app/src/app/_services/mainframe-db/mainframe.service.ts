import { Injectable } from '@angular/core';
import {HttpClient} from "@angular/common/http";
import {Whisky} from "../../_interfaces/Whisky";
import {environment} from "../../../environments/environment";
import {Presentation} from "../../_interfaces/Presentation";
import {WhiskyType} from "../../_interfaces/WhiskyType";
import {Supplier} from "../../_interfaces/Supplier";
import {Currency} from "../../_interfaces/Currency";
import { Customer } from 'src/app/_interfaces/Customer';

const MAIN_DB_URL = environment.apiUrl+'/main-db'

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
    return this.http.post(MAIN_DB_URL+'/insertWhiskey', whiskey)
  }

  createCustomer(customer: Customer){
    return this.http.post(MAIN_DB_URL+'/insertCustomer', customer)
  }

  // =================
  // ==== Select =====
  // =================
  getWhiskey(){
    return this.http.get<Whisky[]>(MAIN_DB_URL+'/selectWhiskey')
  }
  getPresentation(){
    return this.http.get<Presentation[]>(MAIN_DB_URL+'/selectPresentation')
  }
  getWhiskeyType(){
    return this.http.get<WhiskyType[]>(MAIN_DB_URL+'/selectWhiskeyType')
  }
  getSupplier(){
    return this.http.get<Supplier[]>(MAIN_DB_URL+'/selectSupplier')
  }
  getCurrency(){
    return this.http.get<Currency[]>(MAIN_DB_URL+'/selectCurrency')
  }

  // =================
  // ==== Updates ====
  // =================

  updateWhiskey(whiskey: Whisky){
    return this.http.post(MAIN_DB_URL+'/updateWhiskey', whiskey)
  }

  // =================
  // ==== Deletes ====
  // =================

  deleteWhiskey(whiskeyId: number){
    return this.http.post(MAIN_DB_URL+'/deleteWhiskey', {"id":whiskeyId})
  }

}
