import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-employee-review',
  templateUrl: './employee-review.component.html',
  styleUrls: ['./employee-review.component.scss']
})
export class EmployeeReviewComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<EmployeeReviewComponent>,
  ) { }

  ngOnInit(): void {
    console.log(this.data.reviews.comment)
  }


  onNoClick(){
    this.updateWindow.close();
  }

}
