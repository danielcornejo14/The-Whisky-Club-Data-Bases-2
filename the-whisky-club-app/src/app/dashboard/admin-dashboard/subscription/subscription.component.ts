import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Subscription } from 'src/app/_interfaces/Misc/Subscription';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { SubscriptionCreateComponent } from './subscription-create/subscription-create.component';
import { SubscriptionUpdateComponent } from './subscription-update/subscription-update.component';

@Component({
  selector: 'app-subscription',
  templateUrl: './subscription.component.html',
  styleUrls: ['./subscription.component.scss']
})
export class SubscriptionComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private dialog: MatDialog,
  ) { }

  subList: Subscription[] = []

  ngOnInit(): void {

    this.mainframe.getSubscriptions().subscribe(sub => this.subList = sub)

  }

  addSub(){
    const updateWindow = this.dialog.open(SubscriptionCreateComponent, {
      width: '35%'
    })
    updateWindow.afterClosed().subscribe((result: Subscription) => {
      if(result !== undefined){
        this.mainframe.createSub(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }

  updateSub(sub: Subscription){
    const updateWindow = this.dialog.open(SubscriptionUpdateComponent, {
      width: '35%',
      data: {
        item: sub
      }
    })
    updateWindow.afterClosed().subscribe((result: Subscription) => {
      if(result !== undefined){
        this.mainframe.updateSub(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }

  deleteSub(subId: number){
    this.mainframe.deleteSub(subId).subscribe(res => console.log(res))
    window.location.reload()
  }

}
