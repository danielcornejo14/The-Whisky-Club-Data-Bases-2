import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WhiskeyTypesComponent } from './whiskey-types.component';

describe('WhiskeyTypesComponent', () => {
  let component: WhiskeyTypesComponent;
  let fixture: ComponentFixture<WhiskeyTypesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ WhiskeyTypesComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(WhiskeyTypesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
