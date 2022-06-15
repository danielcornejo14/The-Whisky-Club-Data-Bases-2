import { Component, OnInit } from '@angular/core';
import { Department } from 'src/app/_interfaces/Employees/Department';
import { Employee } from 'src/app/_interfaces/Employees/Employee';
import { EmployeeType } from 'src/app/_interfaces/Employees/EmployeeType';
import { EmployeesdbService } from 'src/app/_services/employees-db/employeesdb.service';

@Component({
  selector: 'app-employees',
  templateUrl: './employees.component.html',
  styleUrls: ['./employees.component.scss']
})
export class EmployeesComponent implements OnInit {

  constructor(
    private employeeService: EmployeesdbService
  ) { }

  employees: Employee[] = []
  departments: Department[] = []
  employeeTypes: EmployeeType[] =[]

  ngOnInit(): void {
    this.employeeService.getEmployees().subscribe(employees => this.employees = employees)
    // this.employeeService.getDepartment().subscribe(departments => this.departments = departments)
    // this.employeeService.getEmployeeType().subscribe(employeeTypes => this.employeeTypes = employeeTypes)
  }

  findDepartment(departmentId: number){
    return this.departments.find(department => department.idDepartment === departmentId)

  }
  findType(typeId: number){
    return this.employeeTypes.find(type => type.idEmployeeType === typeId)

  }

}
