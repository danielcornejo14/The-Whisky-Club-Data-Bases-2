import { HTTP_INTERCEPTORS, HttpEvent } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { HttpInterceptor, HttpHandler, HttpRequest } from "@angular/common/http";
import { TokenStorageService } from "../_services/auth/token-storage.service";
import { Observable } from "rxjs";

const TOKEN_HANDLER_KEY='Authorization'

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
    constructor (private token: TokenStorageService){}

    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
        let authReq = req;
        const token = this.token.getToken();
        if(token != null){
            authReq = req.clone({headers: req.headers.set(TOKEN_HANDLER_KEY, 'Bearer'+token)})
        }
        return next.handle(authReq);
    }
}

export const authInterceptorProviders = [
    {provide: HTTP_INTERCEPTORS, useClass: AuthInterceptor, multi: true}
]