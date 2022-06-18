import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-subscription-create',
  templateUrl: './subscription-create.component.html',
  styleUrls: ['./subscription-create.component.scss']
})
export class SubscriptionCreateComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder
  ) { }

  createItem = this.formBuilder.group({
    idSubscription: [''],
    name: [''],
    shoppingDiscount: [''],
    shippingDiscount: ['']
  })

  ngOnInit(): void {
  }

}
