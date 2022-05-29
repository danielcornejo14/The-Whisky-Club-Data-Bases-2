import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { FormsModule } from '@angular/forms';
import { HttpClientModule } from '@angular/common/http';


import { AppRoutingModule } from './app-routing.module';



import { AppComponent } from './app.component';
import { NavigationComponent } from './navigation/navigation.component';
import { LoginComponent } from './login/login.component';
import { AdminLoginComponent } from './login/admin-login/admin-login.component';
import { CustomerLoginComponent } from './login/customer-login/customer-login.component';
import { SignupComponent } from './signup/signup.component';
import { CustomerSignupComponent } from './signup/customer-signup/customer-signup.component';



@NgModule({
  declarations: [
    AppComponent,
    NavigationComponent,
    LoginComponent,
    AdminLoginComponent,
    CustomerLoginComponent,
    SignupComponent,
    CustomerSignupComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [authInterceptorProviders],
  bootstrap: [AppComponent]
})
export class AppModule { }
