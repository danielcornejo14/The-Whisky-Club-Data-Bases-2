import { Component, OnInit } from '@angular/core';
import { Department } from 'src/app/_interfaces/Employees/Department';
import { Employee } from 'src/app/_interfaces/Employees/Employee';
import { EmployeeType } from 'src/app/_interfaces/Employees/EmployeeType';
import { EmployeesdbService } from 'src/app/_services/employees-db/employeesdb.service';

import {MatDialog} from "@angular/material/dialog";
import { EmployeeUpdateComponent } from './employee-update/employee-update.component';
import { EmployeeReview } from 'src/app/_interfaces/Employees/EmployeeReview';
import { EmployeeReviewComponent } from './employee-review/employee-review.component';

@Component({
  selector: 'app-employees',
  templateUrl: './employees.component.html',
  styleUrls: ['./employees.component.scss']
})
export class EmployeesComponent implements OnInit {

  constructor(
    private employeeService: EmployeesdbService,
    private dialog: MatDialog,
  ) { }

  employees: Employee[] = []
  departments: Department[] = []
  employeeTypes: EmployeeType[] =[]
  employeeReviews: EmployeeReview[] = []

  ngOnInit(): void {
    this.employeeService.getEmployees().subscribe(employees => this.employees = employees)
    this.employeeService.getDepartment().subscribe(departments => this.departments = departments)
    this.employeeService.getEmployeeType().subscribe(employeeTypes => this.employeeTypes = employeeTypes)
    this.employeeService.getEmployeeReview().subscribe(reviews => this.employeeReviews = reviews)
  }

  findDepartment(departmentId: number){
    return this.departments.find(department => department.idDepartment === departmentId)

  }
  findType(typeId: number){
    return this.employeeTypes.find(type => type.idEmployeeType === typeId)
  }

  filterReview(employeeId: number){
    const filter = this.employeeReviews.filter((review) => {return review.idEmployee === employeeId})
    console.log(filter)
    return filter
  }

  updateEmployee(employee: Employee){
    const updateWindow = this.dialog.open(EmployeeUpdateComponent, {
      width: '35%',
      data: {
        item: employee,
        types: this.employeeTypes
      }
    })
    updateWindow.afterClosed().subscribe((result: Employee) => {
      if(result !== undefined){
        this.employeeService.updateEmployee(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }

  openReviews(id: number){
    const updateWindow = this.dialog.open(EmployeeReviewComponent, {
      width: '35%',
      data: {
        reviews: this.filterReview(id)
      }
    })
  }

}
