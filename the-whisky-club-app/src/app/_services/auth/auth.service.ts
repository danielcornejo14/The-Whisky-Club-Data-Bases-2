import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';
const AUTH_API = 'http://localhost:8080/api/auth'
const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'aplication/json'
  })
}
@Injectable({
  providedIn: 'root'
})

export class AuthService {

  constructor(
    private http: HttpClient
  ) { }

  login(username: string, password: string): Observable<any> {
    return this.http.post(AUTH_API+'login', {
      username,
      password
    }, httpOptions)
  }

  register(username: string, email: string, password: string): Observable<any>{
    return this.http.post(AUTH_API+'signup', {
      username,
      password,
      email
    }, httpOptions)
  }

}
