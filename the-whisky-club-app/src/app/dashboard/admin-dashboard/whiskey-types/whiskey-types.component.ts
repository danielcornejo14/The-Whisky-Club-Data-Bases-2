import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { WhiskyType } from 'src/app/_interfaces/Whiskey/WhiskyType';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { TypeCreateComponent } from './type-create/type-create.component';
import { TypeUpdateComponent } from './type-update/type-update.component';

@Component({
  selector: 'app-whiskey-types',
  templateUrl: './whiskey-types.component.html',
  styleUrls: ['./whiskey-types.component.scss']
})
export class WhiskeyTypesComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private dialog: MatDialog
  ) { }

  typeList: WhiskyType[] = [] 

  ngOnInit(): void {

    this.mainframe.getWhiskeyType().subscribe(types => this.typeList = types)

  }

  //TODO


  addType(){
    const updateWindow = this.dialog.open(TypeCreateComponent, {
      width: '35%',
    })
    updateWindow.afterClosed().subscribe((result: WhiskyType) => {
      if(result !== undefined){
        this.mainframe.createType(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  updateType(type: WhiskyType){
    const updateWindow = this.dialog.open(TypeUpdateComponent, {
      width: '35%',
      data: {
        item: type
      }
    })
    updateWindow.afterClosed().subscribe((result: WhiskyType) => {
      if(result !== undefined){
        this.mainframe.updateType(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  deleteType(typeId: number){
    this.mainframe.deleteType(typeId).subscribe(res => console.log(res))
    window.location.reload()
  }

}
