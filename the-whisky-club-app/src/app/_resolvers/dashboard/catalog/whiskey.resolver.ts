import { Injectable } from '@angular/core';
import {
  Router, Resolve,
  RouterStateSnapshot,
  ActivatedRouteSnapshot
} from '@angular/router';
import { Observable, of } from 'rxjs';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';
import {MainframeService} from "../../../_services/mainframe-db/mainframe.service";

@Injectable({
  providedIn: 'root'
})
export class WhiskeyResolver implements Resolve<boolean> {

  constructor(
    private mainframe: MainframeService,
    private storage: TokenStorageService) {}

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> {
    return this.mainframe.getWhiskey(this.storage.getUser());
  }

}
