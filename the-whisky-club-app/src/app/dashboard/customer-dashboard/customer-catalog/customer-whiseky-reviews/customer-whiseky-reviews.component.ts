import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { WhiskeyReview } from 'src/app/_interfaces/Whiskey/WhiskeyReview';
import { TokenStorageService } from 'src/app/_services/auth/token-storage.service';
import { MainframeService } from 'src/app/_services/mainframe-db/mainframe.service';

@Component({
  selector: 'app-customer-whiseky-reviews',
  templateUrl: './customer-whiseky-reviews.component.html',
  styleUrls: ['./customer-whiseky-reviews.component.scss']
})
export class CustomerWhisekyReviewsComponent implements OnInit {

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    private fb: FormBuilder,
    private mainframe: MainframeService,
    private storage: TokenStorageService
  ) { }

  reviewList: WhiskeyReview[] = []

  review = this.fb.group({
    username: this.storage.getUser(),
    idWhiskey: this.data.id,
    comment: '',
    evaluation: 1,
  })

  ngOnInit(): void {
    this.mainframe.getWhiskeyReview(this.data.id).subscribe(reviews => this.reviewList = reviews)
  }

}
