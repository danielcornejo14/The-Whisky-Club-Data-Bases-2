import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Presentation } from 'src/app/_interfaces/Whiskey/Presentation';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { PresentationCreateComponent } from './presentation-create/presentation-create.component';
import { PresentationUpdateComponent } from './presentation-update/presentation-update.component';

@Component({
  selector: 'app-presentations',
  templateUrl: './presentations.component.html',
  styleUrls: ['./presentations.component.scss']
})
export class PresentationsComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private dialog: MatDialog
  ) { }

  presentationList: Presentation[] = []

  ngOnInit(): void {
    this.mainframe.getPresentation().subscribe(presentations => this.presentationList = presentations)
  }


  addPresentation(){
    const updateWindow = this.dialog.open(PresentationCreateComponent, {
      width: '35%',
    })
    updateWindow.afterClosed().subscribe((result: Presentation) => {
      if(result !== undefined){
        this.mainframe.createPresentation(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  updatePresentation(presentation: Presentation){
    const updateWindow = this.dialog.open(PresentationUpdateComponent, {
      width: '35%',
      data: {
        item: presentation
      }
    })
    updateWindow.afterClosed().subscribe((result: Presentation) => {
      if(result !== undefined){
        this.mainframe.updatePresentation(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  deletePresentation(presentationId: number){
    this.mainframe.deletePresentation(presentationId).subscribe(res => console.log(res))
    window.location.reload()
  }


}
