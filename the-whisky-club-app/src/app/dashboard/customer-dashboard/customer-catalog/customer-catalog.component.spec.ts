import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CustomerCatalogComponent } from './customer-catalog.component';

describe('CustomerCatalogComponent', () => {
  let component: CustomerCatalogComponent;
  let fixture: ComponentFixture<CustomerCatalogComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CustomerCatalogComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CustomerCatalogComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
