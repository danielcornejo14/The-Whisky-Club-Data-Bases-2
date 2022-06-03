import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CatalogUpdateComponent } from './catalog-update.component';

describe('CatalogUpdateComponent', () => {
  let component: CatalogUpdateComponent;
  let fixture: ComponentFixture<CatalogUpdateComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CatalogUpdateComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CatalogUpdateComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
