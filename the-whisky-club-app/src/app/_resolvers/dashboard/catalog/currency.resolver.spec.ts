import { TestBed } from '@angular/core/testing';

import { CurrencyResolver } from './currency.resolver';

describe('CurrencyResolver', () => {
  let resolver: CurrencyResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(CurrencyResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
