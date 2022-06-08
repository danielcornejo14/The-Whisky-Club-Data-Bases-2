import { Component, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {

  constructor(
    private formBuilder: FormBuilder,
  ) { }

  customerSignup = this.formBuilder.group({
    name: [''],
    lastName:[''],
    email: [''],
    phone: [''],
    username: [''],
    password: [''],
    //TODO #3 location
  })

  ngOnInit(): void {
    // this.customerSignup.get('name')?.setValue("Daniel")
    // this.customerSignup.get('lastName')?.setValue("Cornejo")
    // this.customerSignup.get('email')?.setValue("danicor14@hotmail.com")
    // this.customerSignup.get('phone')?.setValue(70117750)
    // this.customerSignup.get('username')?.setValue("Corne14")
    // this.customerSignup.get('password')?.setValue("Corne01214!")
  }


  test(): void{
    console.log(this.customerSignup.value)
  }

  openAlert(){
    window.alert(`
    1. The minimum length is 8 and maximum length is 64.
    2. The password must have a special character.
    3. The password must have a capital letter.
    4. The password must have a number.`)
  }

}
