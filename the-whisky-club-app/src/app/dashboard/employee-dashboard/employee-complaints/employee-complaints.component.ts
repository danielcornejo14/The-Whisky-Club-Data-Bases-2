import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { EmployeeReview } from 'src/app/_interfaces/Employees/EmployeeReview';
import { EmployeesdbService } from 'src/app/_services/employees-db/employeesdb.service';
import { EmployeeComplaintResolveComponent } from './employee-complaint-resolve/employee-complaint-resolve.component';

@Component({
  selector: 'app-employee-complaints',
  templateUrl: './employee-complaints.component.html',
  styleUrls: ['./employee-complaints.component.scss']
})
export class EmployeeComplaintsComponent implements OnInit {

  constructor(
    private employeedb: EmployeesdbService,
    private dialog: MatDialog
  ) { }

  complaintList: EmployeeReview[] = []

  ngOnInit(): void {
    this.employeedb.getEmployeeReview().subscribe(reviews => this.complaintList = reviews)
  }

  resolveReport(report: any){
    const resolve = this.dialog.open(EmployeeComplaintResolveComponent,{
      data: report
    })
    resolve.afterClosed().subscribe(resolve => {
      if(resolve !== undefined){
        console.log(resolve)
        this.employeedb.updateReview(resolve).subscribe(err => console.log(err))
        window.location.reload()
      }
    })
    
  }

}
