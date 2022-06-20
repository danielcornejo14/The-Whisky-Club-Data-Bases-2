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
import { EmployeeDashboardComponent } from './dashboard/employee-dashboard/employee-dashboard.component';
import { CustomerDashboardComponent } from './dashboard/customer-dashboard/customer-dashboard.component';
import { CustomerCatalogComponent } from './dashboard/customer-dashboard/customer-catalog/customer-catalog.component';
import { CustomerOrdersComponent } from './dashboard/customer-dashboard/customer-orders/customer-orders.component';
import { SubscriptionComponent } from './dashboard/admin-dashboard/subscription/subscription.component';
import { WhiskeyTypesComponent } from './dashboard/admin-dashboard/whiskey-types/whiskey-types.component';
import { PresentationsComponent } from './dashboard/admin-dashboard/presentations/presentations.component';
import { CurrencyComponent } from './dashboard/admin-dashboard/currency/currency.component';
import { ComplaintsComponent } from './dashboard/admin-dashboard/complaints/complaints.component';
import { ReportsComponent } from './dashboard/admin-dashboard/reports/reports.component';
import { ReportsEmployeeComponent } from './dashboard/admin-dashboard/reports/reports-employee/reports-employee.component';
import { ReportsCustomerComponent } from './dashboard/admin-dashboard/reports/reports-customer/reports-customer.component';
import { ReportsSalesComponent } from './dashboard/admin-dashboard/reports/reports-sales/reports-sales.component';

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
      {path: 'employees', component: EmployeesComponent},
      {path: 'subscriptions', component: SubscriptionComponent},
      {path: 'whiskeyTypes', component: WhiskeyTypesComponent},
      {path: 'presentations', component: PresentationsComponent},
      {path: 'currency', component: CurrencyComponent},
      {path: 'complaints', component: ComplaintsComponent},
      {path: 'reports', component: ReportsComponent, children: [
        {path: 'employeeReports', component: ReportsEmployeeComponent},
        {path: 'customerReports', component: ReportsCustomerComponent},
        {path: 'salesReports', component: ReportsSalesComponent}
      ]}
    ]
  },
  {path: 'employee-dashboard', component: EmployeeDashboardComponent},
  {path: 'customer-dashboard', component: CustomerDashboardComponent, children:[
    {path: 'catalog', component: CustomerCatalogComponent, resolve:
    {
      whiskey: WhiskeyResolver,
      whiskeyType: WhiskeyTypeResolver,
      supplier: SupplierResolver,
      presentation: PresentationResolver,
      currency: CurrencyResolver
    }},
    {path: 'orders', component: CustomerOrdersComponent}

  ]},

];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
