import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-currency-create',
  templateUrl: './currency-create.component.html',
  styleUrls: ['./currency-create.component.scss']
})
export class CurrencyCreateComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder
  ) { }

  createItem = this.formBuilder.group({
    name: ['']
  })

  ngOnInit(): void {
  }

}
