import { TestBed } from '@angular/core/testing';

import { WhiskeyTypeResolver } from './whiskey-type.resolver';

describe('WhiskeyTypeResolver', () => {
  let resolver: WhiskeyTypeResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(WhiskeyTypeResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
