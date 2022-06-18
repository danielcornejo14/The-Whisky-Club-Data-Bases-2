import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import {MAT_DIALOG_DATA, MatDialogRef} from "@angular/material/dialog";

@Component({
  selector: 'app-subscription-update',
  templateUrl: './subscription-update.component.html',
  styleUrls: ['./subscription-update.component.scss']
})
export class SubscriptionUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<SubscriptionUpdateComponent>,
    private formBuilder: FormBuilder
  ) { }

    updateItem = this.formBuilder.group({
      idSubscription: this.data.item.idSubscription,
      name: this.data.item.name,
      shoppingDiscount: this.data.item.shoppingDiscount,
      shippingDiscount: this.data.item.shippingDiscount
    })

  ngOnInit(): void {
  }

}
