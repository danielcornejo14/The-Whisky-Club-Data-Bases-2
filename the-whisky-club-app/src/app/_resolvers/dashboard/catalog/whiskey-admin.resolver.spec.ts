import { TestBed } from '@angular/core/testing';

import { WhiskeyAdminResolver } from './whiskey-admin.resolver';

describe('WhiskeyAdminResolver', () => {
  let resolver: WhiskeyAdminResolver;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    resolver = TestBed.inject(WhiskeyAdminResolver);
  });

  it('should be created', () => {
    expect(resolver).toBeTruthy();
  });
});
