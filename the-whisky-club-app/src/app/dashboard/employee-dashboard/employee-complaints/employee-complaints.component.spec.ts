import { ComponentFixture, TestBed } from '@angular/core/testing';

import { EmployeeComplaintsComponent } from './employee-complaints.component';

describe('CustomerComplaintsComponent', () => {
  let component: EmployeeComplaintsComponent;
  let fixture: ComponentFixture<EmployeeComplaintsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ EmployeeComplaintsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(EmployeeComplaintsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
