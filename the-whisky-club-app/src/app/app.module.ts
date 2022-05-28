import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { NavigationComponent } from './navigation/navigation.component';
import { LoginComponent } from './login/login.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import {MatToolbarModule} from "@angular/material/toolbar";
import {MatButtonModule} from "@angular/material/button";
import { SignupComponent } from './signup/signup.component';
import { SignupAdminComponent } from './signup/signup-admin/signup-admin.component';
import { SignupCustomerComponent } from './signup/signup-customer/signup-customer.component';
import { LoginCustomerComponent } from './login/login-customer/login-customer.component';
import { LoginAdminComponent } from './login/login-admin/login-admin.component';


@NgModule({
  declarations: [
    AppComponent,
    NavigationComponent,
    LoginComponent,
    SignupComponent,
    SignupAdminComponent,
    SignupCustomerComponent,
    LoginCustomerComponent,
    LoginAdminComponent,
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MatToolbarModule,
    MatButtonModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
