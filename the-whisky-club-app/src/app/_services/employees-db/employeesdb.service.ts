import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Department } from 'src/app/_interfaces/Employees/Department';
import { Employee } from 'src/app/_interfaces/Employees/Employee';
import { EmployeeReview } from 'src/app/_interfaces/Employees/EmployeeReview';
import { EmployeeType } from 'src/app/_interfaces/Employees/EmployeeType';
import { environment } from 'src/environments/environment';


const DB_URL = environment.apiUrl+'/employee-db'

@Injectable({
  providedIn: 'root'
})
export class EmployeesdbService {

  constructor(
    private http: HttpClient
  ) { }


  // =================
  // ==== Insert =====
  // =================

  createEmployee(employee: Employee){
    return this.http.post(DB_URL+'/insertEmployee', employee)
  }

  createEmployeeReview(review: any){
    return this.http.post(DB_URL+'/insertReport', review)
  }

  // =================
  // ==== Select =====
  // =================
  getDepartment(){
    return this.http.get<Department[]>(DB_URL+'/selectDepartment')
  }

  getEmployees(){
    return this.http.get<Employee[]>(DB_URL+'/selectEmployees')
  }

  getEmployeeReview(){
    return this.http.get<EmployeeReview[]>(DB_URL+'/selectEmployeeReview')
  }

  getEmployeeType(){
    return this.http.get<EmployeeType[]>(DB_URL+'/selectEmployeeType')
  }

  // =================
  // ==== Update =====
  // =================

  updateEmployee(employee: Employee){
    return this.http.post(DB_URL+'/updateEmployee', employee)
  }

  
  updateReview(resolve: any){
    return this.http.post(DB_URL+'/updateReview', resolve)
  }

  // =================
  // ==== Delete =====
  // =================

  deleteEmployee(employeeId: number){
    return this.http.post(DB_URL+'/deleteEmployee', {"id": employeeId})
  }

  // =================
  // ====   SP   =====
  // =================



}
