import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ReportsCustomerComponent } from './reports-customer.component';

describe('ReportsCustomerComponent', () => {
  let component: ReportsCustomerComponent;
  let fixture: ComponentFixture<ReportsCustomerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ReportsCustomerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ReportsCustomerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
