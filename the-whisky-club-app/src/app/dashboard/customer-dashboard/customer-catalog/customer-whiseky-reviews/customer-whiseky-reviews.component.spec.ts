import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CustomerWhisekyReviewsComponent } from './customer-whiseky-reviews.component';

describe('CustomerWhisekyReviewsComponent', () => {
  let component: CustomerWhisekyReviewsComponent;
  let fixture: ComponentFixture<CustomerWhisekyReviewsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CustomerWhisekyReviewsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CustomerWhisekyReviewsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
