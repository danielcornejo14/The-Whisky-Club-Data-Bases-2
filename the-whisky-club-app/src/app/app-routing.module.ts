import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdminLoginComponent } from './login/admin-login/admin-login.component';
import { CustomerLoginComponent } from './login/customer-login/customer-login.component';
import { LoginComponent } from './login/login.component';

const routes: Routes = [
  {path:'login', component: LoginComponent, children: [
    {path: 'admin', redirectTo: '/login-admin', pathMatch: 'full'},
    {path: 'customer', redirectTo: '/login-customer', pathMatch: 'full'}
  ]},
  {path: 'login-admin', component: AdminLoginComponent},
  {path: 'login-customer', component: CustomerLoginComponent}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
