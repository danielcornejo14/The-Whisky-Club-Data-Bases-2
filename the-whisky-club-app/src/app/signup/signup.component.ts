import { FormBuilder } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { MainframeService } from '../_services/mainframe-db/mainframe.service';

@Component({
  selector: 'app-signup',
  templateUrl: './signup.component.html',
  styleUrls: ['./signup.component.scss']
})
export class SignupComponent implements OnInit {

  apiLoaded: Observable<boolean>;

  constructor(
    httpClient: HttpClient,
    private formBuilder: FormBuilder,
    private mainframe: MainframeService
    ) {
    this.apiLoaded = httpClient.jsonp('https://maps.googleapis.com/maps/api/js?key=AIzaSyBiwqpFIEIjdkIjiS4ycPJVbrKWnZDUBDE', 'callback')
        .pipe(
          map(() => true),
          catchError(() => of(false)),
        );
  }

  customerSignup = this.formBuilder.group({
    name: [''],
    lastName1:[''],
    lastName2:[''],
    email: [''],
    phone: [''],
    username: [''],
    password: [''],
    location: ['']
  })

  center: google.maps.LatLngLiteral = {lat: 9.856060396098256, lng: -83.90951249096007};
  zoom = 15;
  markerOptions: google.maps.MarkerOptions = {draggable: false};
  markerPosition: google.maps.LatLngLiteral | undefined;

  ngOnInit(): void {

    this.customerSignup.get('name')?.setValue("Diego")
    this.customerSignup.get('lastName1')?.setValue("Cornejo")
    this.customerSignup.get('lastName2')?.setValue("Corrales")
    this.customerSignup.get('email')?.setValue("diego@gmail.com")
    this.customerSignup.get('phone')?.setValue(12345678)
    this.customerSignup.get('username')?.setValue("die")
    this.customerSignup.get('password')?.setValue("Die12378!")
  }

  openAlert(){
    window.alert(`
    1. The minimum length is 8 and maximum length is 64.
    2. The password must have a special character.
    3. The password must have a capital letter.
    4. The password must have a number.`)
  }



  addMarker(event: google.maps.MapMouseEvent) {
    this.markerPosition = event.latLng!.toJSON()
    console.log(this.markerPosition)
    this.customerSignup.get('location')?.setValue(this.markerPosition)
  }

  submitNewCustomer(){
    this.mainframe.createCustomer(this.customerSignup.value).subscribe(x => console.log(x))
  }

}
