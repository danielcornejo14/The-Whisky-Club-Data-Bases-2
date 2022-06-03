import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { AuthService } from 'src/app/_services/auth/auth.service';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';
import {Router} from "@angular/router";


@Component({
  selector: 'app-admin-login',
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.scss']
})
export class AdminLoginComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private storage: TokenStorageService,
    private router: Router
  ) { }

  adminLogInForm = this.fb.group({
    username: [''],
    password: ['']
  })

  ngOnInit(): void {

  }

  submitLogin(): void{
    let user = {
      username: this.adminLogInForm.get('username')?.value,
      password: this.adminLogInForm.get('password')?.value
    }

    this.auth.adminLogin(user.username, user.password).subscribe(res => {
      this.storage.saveToken(res.token)
      this.router.navigate(['/admin-dashboard'])
      console.log(this.storage.getToken())
      console.log(res.token)
      }
    )



  }

}

// res => {

// },
// err => {
//   window.alert(err)
// }
