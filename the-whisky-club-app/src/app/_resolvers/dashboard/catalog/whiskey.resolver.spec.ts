import { TestBed } from '@angular/core/testing';

import { WhiskeyResolver } from './whiskey.resolver';

describe('WhiskeyResolver', () => {
  let resolver: WhiskeyResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(WhiskeyResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
