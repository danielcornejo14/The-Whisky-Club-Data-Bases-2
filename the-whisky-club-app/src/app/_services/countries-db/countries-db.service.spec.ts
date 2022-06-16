import { TestBed } from '@angular/core/testing';

import { CountriesDbService } from './countries-db.service';

describe('CountriesDbService', () => {
  let service: CountriesDbService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CountriesDbService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
