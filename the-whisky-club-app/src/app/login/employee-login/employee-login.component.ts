import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from 'src/app/_services/auth/auth.service';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';

@Component({
  selector: 'app-employee-login',
  templateUrl: './employee-login.component.html',
  styleUrls: ['./employee-login.component.scss']
})
export class EmployeeLoginComponent implements OnInit {
  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private storage: TokenStorageService,
    private router: Router
  ) { }


  employeeLogInForm = this.fb.group({
    username: [''],
    password: ['']
  })


  ngOnInit(): void {
  }


  submitLogin(): void{
    let user = {
      username: this.employeeLogInForm.get('username')?.value,
      password: this.employeeLogInForm.get('password')?.value
    }

    this.auth.employeeLogin(user.username, user.password).subscribe(res => {
      this.storage.saveToken(res.token)
      this.storage.saveUser(user.username)
      this.router.navigate(['/employee-dashboard'])
      console.log(this.storage.getToken())
      console.log(res.token)
      }
    )
  }
}
