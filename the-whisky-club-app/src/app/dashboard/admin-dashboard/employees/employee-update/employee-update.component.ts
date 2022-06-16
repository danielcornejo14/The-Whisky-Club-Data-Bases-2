import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';

@Component({
  selector: 'app-employee-update',
  templateUrl: './employee-update.component.html',
  styleUrls: ['./employee-update.component.scss']
})
export class EmployeeUpdateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<EmployeeUpdateComponent>,
    private formBuilder: FormBuilder
  ) { }


  updateItem = this.formBuilder.group({
    idEmployee: this.data.item.idEmployee,
    idDepartment: this.data.item.idDepartment,
    idEmployeeType: this.data.item.idEmployeeType,
    name: this.data.item.name,
    lastName1: this.data.item.lastName1,
    lastName2: this.data.item.lastName2,
    localSalary: this.data.item.localSalary,
    dollarSalary: this.data.item.dollarSalary
  })

  ngOnInit(): void {
  }


  onNoClick(){
    this.updateWindow.close();
  }

}
