import { TestBed } from '@angular/core/testing';

import { EmployeesdbService } from './employeesdb.service';

describe('EmployeesdbService', () => {
  let service: EmployeesdbService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(EmployeesdbService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
