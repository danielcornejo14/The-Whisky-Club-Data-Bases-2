import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-customer-dashboard',
  templateUrl: './customer-dashboard.component.html',
  styleUrls: ['./customer-dashboard.component.scss']
})
export class CustomerDashboardComponent implements OnInit {

  links=['catalog', 'orders']
  activeLink = this.links[0]

  constructor() { }

  ngOnInit(): void {
  }

}
