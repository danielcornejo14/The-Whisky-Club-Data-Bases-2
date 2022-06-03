import { Injectable } from '@angular/core';
import {HttpClient, HttpErrorResponse} from '@angular/common/http';
import {catchError, Observable, throwError} from 'rxjs';
import {environment} from "../../../environments/environment";

const AUTH_API = environment.apiUrl+'/user'

@Injectable({
  providedIn: 'root'
})

export class AuthService {

  constructor(
    private http: HttpClient
  ) { }

  adminLogin(username: string, password: string): Observable<any> {
    return this.http.post(AUTH_API+'/authAdmin', {
      username,
      password
    }).pipe(catchError(this.handleError))
  }
  customerLogin(username: string, password: string): Observable<any>{
    return this.http.post(AUTH_API+'authCustomer', {
      username,
      password
    }).pipe(catchError(this.handleError))
  }

  customerSignup(username: string, email: string, password: string): Observable<any>{
    return this.http.post(AUTH_API+'signup', {
      username,
      password,
      email
    }).pipe(catchError(this.handleError))
  }

  private handleError(error: HttpErrorResponse) {
    if (error.status === 0) {
      // A client-side or network error occurred. Handle it accordingly.
      console.error('An error occurred:', error.error);
      window.alert(`An error occurred: ${error.error}`)
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong.
      console.error(
        `Backend returned code ${error.status}, body was: `, error.error);
      window.alert(`Backend returned code ${error.error}`)
    }
    // Return an observable with a user-facing error message.
    return throwError(() => new Error('Something bad happened; please try again later.'));
  }

}
