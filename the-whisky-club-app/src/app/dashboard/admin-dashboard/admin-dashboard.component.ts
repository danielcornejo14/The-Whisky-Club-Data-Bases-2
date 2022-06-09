import { Component, OnInit } from '@angular/core';


@Component({
  selector: 'app-admin-dashboard',
  templateUrl: './admin-dashboard.component.html',
  styleUrls: ['./admin-dashboard.component.scss']
})
export class AdminDashboardComponent implements OnInit {

  links = ['catalog', 'employees']
  activeLink = this.links[0];


  constructor(

  ) { }


  ngOnInit(): void {
  }


  addLink() {
    this.links.push(`Link ${this.links.length + 1}`);
  }

}
