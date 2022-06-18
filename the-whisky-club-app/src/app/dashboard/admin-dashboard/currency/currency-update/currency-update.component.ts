import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-currency-update',
  templateUrl: './currency-update.component.html',
  styleUrls: ['./currency-update.component.scss']
})
export class CurrencyUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<CurrencyUpdateComponent>,
    private formBuilder: FormBuilder
  ) { }

  updateItem = this.formBuilder.group({
    idCurrency: this.data.item.idCurrency,
    name: this.data.item.name
  })

  ngOnInit(): void {
  }

}
