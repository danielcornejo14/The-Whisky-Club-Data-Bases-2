import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import {LoginComponent} from "./login/login.component";
import {LoginAdminComponent} from "./login/login-admin/login-admin.component";
import {LoginCustomerComponent} from "./login/login-customer/login-customer.component";
import {SignupComponent} from "./signup/signup.component";
import {SignupAdminComponent} from "./signup/signup-admin/signup-admin.component";
import {SignupCustomerComponent} from "./signup/signup-customer/signup-customer.component";

const routes: Routes = [
  {path: 'login', component: LoginComponent, children: [
      {path: 'admin', redirectTo: '/login-admin', pathMatch: 'full'},
      {path: 'customer', redirectTo: '/login-customer', pathMatch: 'full'}
    ]
  },
  {path: 'login-admin', component: LoginAdminComponent},
  {path: 'login-customer', component: LoginCustomerComponent},

  {path: 'signup', component: SignupComponent, children:[
      {path: 'admin', redirectTo: '/signup-admin', pathMatch: 'full'},
      {path: 'customer', redirectTo: '/signup-customer', pathMatch: 'full'}
    ]},
  {path: 'signup-admin', component: SignupAdminComponent},
  {path: 'signup-customer', component: SignupCustomerComponent},
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
