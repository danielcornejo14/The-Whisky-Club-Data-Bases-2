import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { Department } from 'src/app/_interfaces/Employees/Department';
import { EmployeeReport } from 'src/app/_interfaces/Reports/EmployeeReport';
import { WhiskyType } from 'src/app/_interfaces/Whiskey/WhiskyType';
import { EmployeesdbService } from 'src/app/_services/employees-db/employeesdb.service';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';

@Component({
  selector: 'app-reports-employee',
  templateUrl: './reports-employee.component.html',
  styleUrls: ['./reports-employee.component.scss']
})
export class ReportsEmployeeComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private employees: EmployeesdbService,
    private mainframe: MainframeService
  ) { }

  countrys = [{id: 1,name: "United States"},{id: 2,name: "Ireland"},{id:3,name: "Scotland"}]
  deptList: Department[] = []
  reportList: EmployeeReport[] = []
  filter = this.fb.group({
    departmentName: null,
    minimumAverageScore: null,
    maximumAverageScore: null,
    minimumLocalSalary: null,
    maximumLocalSalary: null,
    minimumDollarSalary: null,
    maximumDollarSalary: null
  })

  ngOnInit(): void {
    this.employees.getDepartment().subscribe(dep => this.deptList = dep)
    this.mainframe.queryEmployeeReport(this.filter.value).subscribe(reports =>  {this.reportList = reports; console.log(reports)})
  }

  findDepartment(departmentId: number){
    return this.deptList.find(department => department.idDepartment === departmentId)
  }

  clearFilter(){
    this.filter.reset()
  }
  applyFilter(){
    this.mainframe.queryEmployeeReport(this.filter.value).subscribe(report =>  this.reportList = report)
  }

}
