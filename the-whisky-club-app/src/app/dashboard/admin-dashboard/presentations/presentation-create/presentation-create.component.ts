import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-presentation-create',
  templateUrl: './presentation-create.component.html',
  styleUrls: ['./presentation-create.component.scss']
})
export class PresentationCreateComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder
  ) { }

  createItem = this.formBuilder.group({
    description: ['']
  })

  ngOnInit(): void {
  }

}
