import { TestBed } from '@angular/core/testing';

import { SupplierResolver } from './supplier.resolver';

describe('SupplierResolver', () => {
  let resolver: SupplierResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(SupplierResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
