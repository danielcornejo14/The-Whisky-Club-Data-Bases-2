import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PresentationUpdateComponent } from './presentation-update.component';

describe('PresentationUpdateComponent', () => {
  let component: PresentationUpdateComponent;
  let fixture: ComponentFixture<PresentationUpdateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ PresentationUpdateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(PresentationUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
