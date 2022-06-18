import { FormBuilder } from '@angular/forms';
import { Component, OnInit } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { MainframeService } from '../_services/mainframe-db/mainframe.service';
import { Subscription } from '../_interfaces/Misc/Subscription';
import { Router } from '@angular/router';

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
    private mainframe: MainframeService,
    private router: Router
    ) {
    this.apiLoaded = httpClient.jsonp('https://maps.googleapis.com/maps/api/js?key=AIzaSyBiwqpFIEIjdkIjiS4ycPJVbrKWnZDUBDE', 'callback')
        .pipe(
          map(() => true),
          catchError(() => of(false)),
        );
  }

  subList: Subscription[] = []

  customerSignup = this.formBuilder.group({
    name: [''],
    lastName1:[''],
    lastName2:[''],
    email: [''],
    username: [''],
    password: [''],
    location: [''],
    subscription: ['']
  })

  center: google.maps.LatLngLiteral = {lat: 9.856060396098256, lng: -83.90951249096007};
  zoom = 15;
  markerOptions: google.maps.MarkerOptions = {draggable: false};
  markerPosition: google.maps.LatLngLiteral | undefined;

  ngOnInit(): void {
    this.mainframe.getSubscriptions().subscribe(subs => this.subList = subs)
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
    this.mainframe.createCustomer(this.customerSignup.value).subscribe(x => {console.log(x)})
    this.router.navigate(['/customer-dashboard']) 
  }

}
