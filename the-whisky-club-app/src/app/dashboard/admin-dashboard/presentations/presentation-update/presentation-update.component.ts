import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-presentation-update',
  templateUrl: './presentation-update.component.html',
  styleUrls: ['./presentation-update.component.scss']
})
export class PresentationUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<PresentationUpdateComponent>,
    private formBuilder: FormBuilder
  ) { }

  updateItem = this.formBuilder.group({
    idPresentation: this.data.item.idPresentation,
    description: this.data.item.description
  })

  ngOnInit(): void {
  }

}
