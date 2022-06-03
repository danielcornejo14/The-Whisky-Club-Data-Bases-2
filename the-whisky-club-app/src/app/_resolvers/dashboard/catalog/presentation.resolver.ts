import { Injectable } from '@angular/core';
import {
  Router, Resolve,
  RouterStateSnapshot,
  ActivatedRouteSnapshot
} from '@angular/router';
import { Observable, of } from 'rxjs';
import {MainframeService} from "../../../_services/mainframe-db/mainframe.service";

@Injectable({
  providedIn: 'root'
})
export class PresentationResolver implements Resolve<boolean> {

  constructor(private mainframe: MainframeService) {
  }

  resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): Observable<any> {
    return this.mainframe.getPresentation();
  }
}
