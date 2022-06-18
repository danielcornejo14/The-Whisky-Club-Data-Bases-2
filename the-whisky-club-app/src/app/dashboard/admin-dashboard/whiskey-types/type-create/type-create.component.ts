import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-type-create',
  templateUrl: './type-create.component.html',
  styleUrls: ['./type-create.component.scss']
})
export class TypeCreateComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder
  ) { }

  createItem = this.formBuilder.group({
    name: ['']
  })


  ngOnInit(): void {
  }

}
