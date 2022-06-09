import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AdminLoginComponent } from './login/admin-login/admin-login.component';
import { CustomerLoginComponent } from './login/customer-login/customer-login.component';
import { LoginComponent } from './login/login.component';
import {SignupComponent} from "./signup/signup.component";
import {AdminDashboardComponent} from "./dashboard/admin-dashboard/admin-dashboard.component";
import {CatalogComponent} from "./dashboard/admin-dashboard/catalog/catalog.component";
import {WhiskeyResolver} from "./_resolvers/dashboard/catalog/whiskey.resolver";
import {WhiskeyTypeResolver} from "./_resolvers/dashboard/catalog/whiskey-type.resolver";
import {SupplierResolver} from "./_resolvers/dashboard/catalog/supplier.resolver";
import {PresentationResolver} from "./_resolvers/dashboard/catalog/presentation.resolver";
import {CurrencyResolver} from "./_resolvers/dashboard/catalog/currency.resolver";
import { EmployeesComponent } from './dashboard/admin-dashboard/employees/employees.component';

const routes: Routes = [
  //logIn
  {path:'login', component: LoginComponent, children: [
    {path: 'admin', redirectTo: '/login-admin', pathMatch: 'full'},
    {path: 'customer', redirectTo: '/login-customer', pathMatch: 'full'}
  ]},
  {path: 'login-admin', component: AdminLoginComponent},
  {path: 'login-customer', component: CustomerLoginComponent},

  //SignUp
  {path:'signup', component: SignupComponent},

  //dashboard
  {path: 'admin-dashboard', component: AdminDashboardComponent, children:[
      {path: 'catalog', component: CatalogComponent, resolve:
          {
            whiskey: WhiskeyResolver,
            whiskeyType: WhiskeyTypeResolver,
            supplier: SupplierResolver,
            presentation: PresentationResolver,
            currency: CurrencyResolver
          }
      },
      {path: 'employees', component: EmployeesComponent}
    ]
  }

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
