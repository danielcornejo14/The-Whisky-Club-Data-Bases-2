import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TypeUpdateComponent } from './type-update.component';

describe('TypeUpdateComponent', () => {
  let component: TypeUpdateComponent;
  let fixture: ComponentFixture<TypeUpdateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TypeUpdateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TypeUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
