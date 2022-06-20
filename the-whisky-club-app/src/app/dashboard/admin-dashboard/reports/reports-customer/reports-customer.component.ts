import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { Subscription } from 'src/app/_interfaces/Misc/Subscription';
import { CustomerReport } from 'src/app/_interfaces/Reports/CustomerReport';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';

@Component({
  selector: 'app-reports-customer',
  templateUrl: './reports-customer.component.html',
  styleUrls: ['./reports-customer.component.scss']
})
export class ReportsCustomerComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private mainframe: MainframeService
  ) { }

  
  countrys = [{id: 1,name: "United States"},{id: 2,name: "Ireland"},{id:3,name: "Scotland"}]
  subList: Subscription[] = []
  reportList: CustomerReport[] = []
  filter = this.fb.group({
    idSubscription: null,
    beforeDate: null,
    afterDate: null,
    idCountry: null,
  })


  ngOnInit(): void {
    this.mainframe.getSubscriptions().subscribe(subs => this.subList = subs)
    this.mainframe.queryCustomerReport(this.filter.value).subscribe(reports =>  this.reportList = reports)
  }

  clearFilter(){
    this.filter.reset()
  }
  applyFilter(){
    this.mainframe.queryCustomerReport(this.filter.value).subscribe(report =>  this.reportList = report)
    
  }

}
