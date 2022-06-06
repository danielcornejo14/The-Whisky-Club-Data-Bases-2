import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/_services/auth/auth.service';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';

@Component({
  selector: 'app-customer-login',
  templateUrl: './customer-login.component.html',
  styleUrls: ['./customer-login.component.scss']
})
export class CustomerLoginComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private storage: TokenStorageService,
    private router: Router
  ) { }


  customerLogInForm = this.fb.group({
    username: [''],
    password: ['']
  })


  ngOnInit(): void {
  }


  submitLogin(): void{
    let user = {
      username: this.customerLogInForm.get('username')?.value,
      password: this.customerLogInForm.get('password')?.value
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
