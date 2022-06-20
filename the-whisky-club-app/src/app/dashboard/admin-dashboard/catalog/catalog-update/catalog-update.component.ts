import {Component, Inject, OnInit} from '@angular/core';
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";

import {FormBuilder} from "@angular/forms";

@Component({
  selector: 'app-catalog-update',
  templateUrl: './catalog-update.component.html',
  styleUrls: ['./catalog-update.component.scss']
})
export class CatalogUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<CatalogUpdateComponent>,
    private formBuilder: FormBuilder
    ) { }

  updateItem = this.formBuilder.group({
    idWhiskey: this.data.item.idWhiskey,
    idSupplier:this.data.item.idSupplier,
    idPresentation:this.data.item.idPresentation,
    idWhiskeyType: this.data.item.idWhiskeyType,
    brand: this.data.item.brand,
    price: this.data.item.price,
    alcoholContent:this.data.item.alcoholContent,
    productionDate:this.data.item.productionDate,
    dueDate: this.data.item.dueDate,
    millilitersQuantity:this.data.item.millilitersQuantity,
    whiskeyAging: this.data.item.whiskeyAging,
    special: this.data.item.special,
    addStock: 0
  })

  ngOnInit(): void {
    console.log(this.data.item.idWhiskey)

  }

  onNoClick(){
    this.updateWindow.close();
  }

}
