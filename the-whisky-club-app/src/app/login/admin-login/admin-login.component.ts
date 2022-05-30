import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';


@Component({
  selector: 'app-admin-login',
  templateUrl: './admin-login.component.html',
  styleUrls: ['./admin-login.component.scss']
})
export class AdminLoginComponent implements OnInit {

  constructor(private fb: FormBuilder) { }

  adminLogInForm = this.fb.group({
    userName: [''],
    password: ['']
  })

  ngOnInit(): void {
    this.adminLogInForm.get('userName')?.setValue('Daniel')
    this.adminLogInForm.get('password')?.setValue('Cornejo')
  }

}
