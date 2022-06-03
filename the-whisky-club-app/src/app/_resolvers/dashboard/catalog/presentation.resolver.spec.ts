import { TestBed } from '@angular/core/testing';

import { PresentationResolver } from './presentation.resolver';

describe('PresentationResolver', () => {
  let resolver: PresentationResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(PresentationResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
