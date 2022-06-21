import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EmployeeComplaintResolveComponent } from './employee-complaint-resolve.component';

describe('EmployeeComplaintResolveComponent', () => {
  let component: EmployeeComplaintResolveComponent;
  let fixture: ComponentFixture<EmployeeComplaintResolveComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EmployeeComplaintResolveComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EmployeeComplaintResolveComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
