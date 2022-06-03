import { Component, OnInit } from '@angular/core';
import {TokenStorageService} from "../_services/auth/token-storage.service";
import {Router} from "@angular/router";

@Component({
  selector: 'app-navigation',
  templateUrl: './navigation.component.html',
  styleUrls: ['./navigation.component.scss']
})
export class NavigationComponent implements OnInit {

  constructor(
    public storage: TokenStorageService,
    private router: Router
  ) { }
  ngOnInit(): void {

  }

  logOut(): void {
    this.storage.logOut()
    this.router.navigate(['/'])
  }

}
