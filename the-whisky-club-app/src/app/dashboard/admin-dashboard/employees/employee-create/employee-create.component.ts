import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Department } from 'src/app/_interfaces/Employees/Department';
import { EmployeeType } from 'src/app/_interfaces/Employees/EmployeeType';

@Component({
  selector: 'app-employee-create',
  templateUrl: './employee-create.component.html',
  styleUrls: ['./employee-create.component.scss']
})
export class EmployeeCreateComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public updateWindow: MatDialogRef<EmployeeCreateComponent>,
    private formBuilder: FormBuilder
  ) { }

    createItem = this.formBuilder.group({
      idDepartment: [''],
      idEmployeeType: [''],
      name: [''],
      lastName1: [''],
      lastName2: [''],
      localSalary: [''],
      dollarSalary: [''],
      username: [''],
      password: ['']
    })

    departments: Department[] = []
    employeeTypes: EmployeeType[] = []

  ngOnInit(): void {
  }


}
