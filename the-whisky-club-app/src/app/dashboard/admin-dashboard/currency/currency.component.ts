import { Component, OnInit } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { Currency } from 'src/app/_interfaces/Whiskey/Currency';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';
import { CurrencyCreateComponent } from './currency-create/currency-create.component';
import { CurrencyUpdateComponent } from './currency-update/currency-update.component';

@Component({
  selector: 'app-currency',
  templateUrl: './currency.component.html',
  styleUrls: ['./currency.component.scss']
})
export class CurrencyComponent implements OnInit {

  constructor(
    private mainframe: MainframeService,
    private dialog: MatDialog
  ) { }

  currencyList: Currency[] = []

  ngOnInit(): void {
    this.mainframe.getCurrency().subscribe(currencys => this.currencyList = currencys)
  }

  addCurrency(){
    const updateWindow = this.dialog.open(CurrencyCreateComponent, {
      width: '35%',
    })
    updateWindow.afterClosed().subscribe((result: Currency) => {
      if(result !== undefined){
        this.mainframe.createCurrency(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  updateCurrency(currency: Currency){
    const updateWindow = this.dialog.open(CurrencyUpdateComponent, {
      width: '35%',
      data: {
        item: currency
      }
    })
    updateWindow.afterClosed().subscribe((result: Currency) => {
      if(result !== undefined){
        this.mainframe.updateCurrency(result).subscribe(res => console.log(res))
        window.location.reload()
      }
    })
  }
  deleteCurrency(CurrencyId: number){
    this.mainframe.deleteCurrency(CurrencyId).subscribe(res => console.log(res))
    window.location.reload()
  }

}
