import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SignupCustomerComponent } from './signup-customer.component';

describe('SignupCustomerComponent', () => {
  let component: SignupCustomerComponent;
  let fixture: ComponentFixture<SignupCustomerComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SignupCustomerComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SignupCustomerComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
