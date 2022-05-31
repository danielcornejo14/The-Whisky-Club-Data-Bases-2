import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

const AUTH_API = 'http://localhost:8080/'

@Injectable({
  providedIn: 'root'
})

export class AuthService {

  constructor(
    private http: HttpClient
  ) { }

  login(username: string, password: string): Observable<any> {
    return this.http.post(AUTH_API+'getToken', {
      username,
      password
    })
  }

  register(username: string, email: string, password: string): Observable<any>{
    return this.http.post(AUTH_API+'signup', {
      username,
      password,
      email
    })
  }

}
