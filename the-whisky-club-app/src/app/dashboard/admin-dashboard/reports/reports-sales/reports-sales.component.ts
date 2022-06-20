import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { SalesReport } from 'src/app/_interfaces/Reports/SalesReport';
import { WhiskyType } from 'src/app/_interfaces/Whiskey/WhiskyType';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';

@Component({
  selector: 'app-reports-sales',
  templateUrl: './reports-sales.component.html',
  styleUrls: ['./reports-sales.component.scss']
})
export class ReportsSalesComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private mainframe: MainframeService
  ) { }

      
  countrys = [{id: 1,name: "United States"},{id: 2,name: "Ireland"},{id:3,name: "Scotland"}]
  typeList: WhiskyType[] = []
  reportList: SalesReport[] = []
  filter = this.fb.group({
    idWhiskeyType: null,
    countryId: null,
    beforeDate: null,
    afterDate: null
  })


  ngOnInit(): void {
    this.mainframe.getWhiskeyType().subscribe(types => this.typeList = types)
    this.mainframe.querySalesReport(this.filter.value).subscribe(reps => this.reportList = reps)
  }

  findWhiskeyType(id: number): any{
    return this.typeList.find(whiskeyType => whiskeyType.idWhiskeyType === id)
  }

  clearFilter(){
    this.filter.reset()
  }
  applyFilter(){
    this.mainframe.querySalesReport(this.filter.value).subscribe(report =>  this.reportList = report)
  }


}
