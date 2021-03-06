import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-catalog-create',
  templateUrl: './catalog-create.component.html',
  styleUrls: ['./catalog-create.component.scss']
})
export class CatalogCreateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<CatalogCreateComponent>,
    private formBuilder: FormBuilder
  ) { }

  updateItem = this.formBuilder.group({
    idSupplier: [''],
    idPresentation: [''],
    idWhiskeyType: [''],
    brand: [''],
    price: [''],
    alcoholContent: [''],
    productionDate: [''],
    dueDate: [''],
    millilitersQuantity: [''],
    whiskeyAging: [''],
    special: [false],
    addStock: 0
  })


  ngOnInit(): void {
  }

  onNoClick(){
    this.updateWindow.close();
  }

}
