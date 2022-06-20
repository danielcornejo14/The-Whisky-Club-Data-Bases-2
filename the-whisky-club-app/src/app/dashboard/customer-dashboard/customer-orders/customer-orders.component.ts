import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Order } from 'src/app/_interfaces/Customer/Order';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';
import { EmployeesdbService } from 'src/app/_services/employees-db/employeesdb.service';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { CustomerReportComponent } from './customer-report/customer-report.component';

@Component({
  selector: 'app-customer-orders',
  templateUrl: './customer-orders.component.html',
  styleUrls: ['./customer-orders.component.scss']
})
export class CustomerOrdersComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private storage: TokenStorageService,
    private dialog: MatDialog,
    private employees: EmployeesdbService
  ) { }

  orderList: Order[] = []

  ngOnInit(): void {
    this.mainframe.getSales(this.storage.getUser()).subscribe(orders => this.orderList = orders)
  }

  openReport(data: Order){
    const report = this.dialog.open(CustomerReportComponent, {
      data:{
        order: data
      }
    })

    report.afterClosed().subscribe((report: any) =>{
      if(report!== undefined){
        this.employees.createEmployeeReview(report).subscribe(err => console.log(err))
      }

    })
  }

  test(){
    console.log(this.orderList)
  }
}
