import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HttpClientModule, HttpClientJsonpModule } from '@angular/common/http';
import { GoogleMapsModule } from '@angular/google-maps';


import { AppRoutingModule } from './app-routing.module';


import { AppComponent } from './app.component';
import { NavigationComponent } from './navigation/navigation.component';
import { LoginComponent } from './login/login.component';
import { AdminLoginComponent } from './login/admin-login/admin-login.component';
import { CustomerLoginComponent } from './login/customer-login/customer-login.component';
import { SignupComponent } from './signup/signup.component';
import { AdminDashboardComponent } from './dashboard/admin-dashboard/admin-dashboard.component';
import { CatalogComponent } from './dashboard/admin-dashboard/catalog/catalog.component';
import { CatalogUpdateComponent } from './dashboard/admin-dashboard/catalog/catalog-update/catalog-update.component';
import { CatalogCreateComponent } from './dashboard/admin-dashboard/catalog/catalog-create/catalog-create.component';
import { CustomerDashboardComponent } from './dashboard/customer-dashboard/customer-dashboard.component';
import { EmployeeDashboardComponent } from './dashboard/employee-dashboard/employee-dashboard.component';


import { authInterceptorProviders } from './_helpers/auth.interceptor';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import {MatToolbarModule} from '@angular/material/toolbar';
import {MatButtonModule} from '@angular/material/button';
import {MatInputModule} from '@angular/material/input';
import {MatListModule} from '@angular/material/list';
import {MatDividerModule} from '@angular/material/divider';
import {MatDialogModule} from '@angular/material/dialog';
import {MatCheckboxModule} from "@angular/material/checkbox";
import {MatSelectModule} from "@angular/material/select";
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatTabsModule} from '@angular/material/tabs';
import {MatDatepickerModule} from '@angular/material/datepicker';
import {MatNativeDateModule} from '@angular/material/core';
import {MatIconModule} from '@angular/material/icon';
import { EmployeesComponent } from './dashboard/admin-dashboard/employees/employees.component';
import {MatCardModule} from '@angular/material/card';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { EmployeeUpdateComponent } from './dashboard/admin-dashboard/employees/employee-update/employee-update.component';
import { EmployeeReviewComponent } from './dashboard/admin-dashboard/employees/employee-review/employee-review.component';
import { CustomerCatalogComponent } from './dashboard/customer-dashboard/customer-catalog/customer-catalog.component';
import { CustomerOrdersComponent } from './dashboard/customer-dashboard/customer-orders/customer-orders.component';
import { CustomerCheckoutComponent } from './dashboard/customer-dashboard/customer-catalog/customer-checkout/customer-checkout.component';
import {MatStepperModule} from '@angular/material/stepper';

@NgModule({
  declarations: [
    AppComponent,
    NavigationComponent,
    LoginComponent,
    AdminLoginComponent,
    CustomerLoginComponent,
    SignupComponent,
    AdminDashboardComponent,
    CatalogComponent,
    CatalogUpdateComponent,
    CatalogCreateComponent,
    EmployeesComponent,
    CustomerDashboardComponent,
    EmployeeDashboardComponent,
    EmployeeUpdateComponent,
    EmployeeReviewComponent,
    CustomerCatalogComponent,
    CustomerOrdersComponent,
    CustomerCheckoutComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatToolbarModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    MatListModule,
    MatDividerModule,
    MatDialogModule,
    MatCheckboxModule,
    MatSelectModule,
    MatTabsModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatIconModule,
    GoogleMapsModule,
    HttpClientJsonpModule,
    MatCardModule,
    NgbModule,
    MatStepperModule

  ],
  providers: [authInterceptorProviders],
  bootstrap: [AppComponent]
})
export class AppModule { }
