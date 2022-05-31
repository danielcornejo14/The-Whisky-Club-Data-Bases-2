import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { AuthService } from 'src/app/_services/auth/auth.service';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';


@Component({
  selector: 'app-admin-login',
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.scss']
})
export class AdminLoginComponent implements OnInit {

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private storage: TokenStorageService
  ) { }

  adminLogInForm = this.fb.group({
    userName: [''],
    password: ['']
  })

  ngOnInit(): void {

  }

  submitLogin(): void{
    let user = {
      username: this.adminLogInForm.get('userName')?.value,
      password: this.adminLogInForm.get('password')?.value
    }

    this.auth.login(user.username, user.password).subscribe(x => {
      this.storage.saveToken(x.jwt)
      console.log(this.storage.getToken())
      console.log(x.jwt)
    })

  }

}
