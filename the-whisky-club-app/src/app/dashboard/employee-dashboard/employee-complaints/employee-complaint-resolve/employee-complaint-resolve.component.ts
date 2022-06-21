import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-employee-complaint-resolve',
  templateUrl: './employee-complaint-resolve.component.html',
  styleUrls: ['./employee-complaint-resolve.component.scss']
})
export class EmployeeComplaintResolveComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private fb: FormBuilder
  ) { }

  resolve = this.fb.group({
    idEmployeeReview: this.data.idEmployeeReview,
    comment: ''
  })

  ngOnInit(): void {
    console.log(this.data)
  }

}
