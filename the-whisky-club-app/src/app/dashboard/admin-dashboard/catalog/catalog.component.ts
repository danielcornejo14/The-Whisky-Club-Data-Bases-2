import { Component, OnInit } from '@angular/core';
import {ActivatedRoute} from "@angular/router";

import {MainframeService} from "../../../_services/mainframe-db/mainframe.service";

import {MatDialog} from "@angular/material/dialog";

import {Whisky} from "../../../_interfaces/Whiskey/Whisky";
import {WhiskyType} from "../../../_interfaces/Whiskey/WhiskyType";
import {Supplier} from "../../../_interfaces/Whiskey/Supplier";
import {Presentation} from "../../../_interfaces/Whiskey/Presentation";
import {Currency} from "../../../_interfaces/Whiskey/Currency";
import {CatalogUpdateComponent} from "./catalog-update/catalog-update.component";
import {CatalogCreateComponent} from "./catalog-create/catalog-create.component";
import { DomSanitizer } from '@angular/platform-browser';


@Component({
  selector: 'app-catalog',
  templateUrl: './catalog.component.html',
  styleUrls: ['./catalog.component.scss']
})
export class CatalogComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private route: ActivatedRoute,
    private dialog: MatDialog,
    private sanitizer: DomSanitizer
  ) { }

  WhiskyList: Whisky[] = []
  WhiskyTypeList: WhiskyType[] = []
  SupplierList: Supplier[] = []
  PresentationList: Presentation[] = []
  CurrencyList: Currency[] = []

  ngOnInit(): void {

    this.WhiskyList = this.route.snapshot.data['whiskey']
    this.WhiskyTypeList = this.route.snapshot.data['whiskeyType']
    this.SupplierList = this.route.snapshot.data['supplier']
    this.PresentationList = this.route.snapshot.data['presentation']
    this.CurrencyList = this.route.snapshot.data['currency']

    console.log(this.WhiskyList[0])
  
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

  updateWhiskey(whisky: Whisky){
    const updateWindow = this.dialog.open(CatalogUpdateComponent, {
      width: '35%',
      data: {
        item: whisky,
        typeList: this.WhiskyTypeList,
        supplier: this.SupplierList,
        presentation: this.PresentationList,
        currency: this.CurrencyList
      }
    })
    updateWindow.afterClosed().subscribe((result: Whisky) => {
      if(result !== undefined){
        this.mainframe.createWhiskey(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }

  addWhiskey(){
    const addWindow = this.dialog.open(CatalogCreateComponent, {
      width: '35%',
      data: {
        typeList: this.WhiskyTypeList,
        supplier: this.SupplierList,
        presentation: this.PresentationList,
        currency: this.CurrencyList
      }
    })

    addWindow.afterClosed().subscribe((result: Whisky) => {
      if(result !== undefined){
        this.mainframe.createWhiskey(result).subscribe(res => console.log(res))
        window.location.reload()
      }

    })

  }

  deleteWhiskey(whiskeyId: number){
    this.mainframe.deleteWhiskey(whiskeyId).subscribe(res => console.log(res))
    window.location.reload()
  }



  testDbService(){
    console.log(this.WhiskyList. length)
  }

  buildImage(data: string){
    return this.sanitizer.bypassSecurityTrustResourceUrl("data:image/png;base64, " +data) 
  }

}
