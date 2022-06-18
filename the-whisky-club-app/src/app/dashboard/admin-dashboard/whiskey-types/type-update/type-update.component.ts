import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-type-update',
  templateUrl: './type-update.component.html',
  styleUrls: ['./type-update.component.scss']
})
export class TypeUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<TypeUpdateComponent>,
    private formBuilder: FormBuilder

  ) { }

    updateItem = this.formBuilder.group({
      idWhiskeyType: this.data.item.idWhiskeyType,
      name: this.data.item.name
    })

  ngOnInit(): void {
  }

}
