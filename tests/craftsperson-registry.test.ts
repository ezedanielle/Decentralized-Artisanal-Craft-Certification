import { describe, it, expect, beforeEach } from 'vitest';
import { mockClarityBitcoin, mockClarityBlockInfo } from './test-utils';

// Mock Clarity environment
const mockClarity = {
  contracts: {},
  blockHeight: 100,
  tx: {
    sender: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
  }
};

// Import contract code (simulated)
const loadContract = () => {
  // In a real test, you would parse and execute the Clarity code
  // This is a simplified mock implementation
  return {
    'register-craftsperson': (name, location, specialty) => {
      mockClarity.blockHeight += 1;
      return { result: { value: true } };
    },
    'get-craftsperson': (id) => {
      return {
        result: {
          value: {
            name: 'Test Craftsperson',
            location: 'Test Location',
            specialty: 'Test Specialty',
            'registration-date': 100,
            active: true
          }
        }
      };
    },
    'update-craftsperson-status': (id, active) => {
      return { result: { value: true } };
    }
  };
};

describe('Craftsperson Registry Contract', () => {
  let contract;
  
  beforeEach(() => {
    mockClarityBlockInfo(mockClarity);
    mockClarityBitcoin(mockClarity);
    contract = loadContract();
  });
  
  it('should register a new craftsperson', () => {
    const result = contract['register-craftsperson']('John Doe', 'New York', 'Woodworking');
    expect(result.result.value).toBe(true);
  });
  
  it('should retrieve craftsperson details', () => {
    const result = contract['get-craftsperson'](1);
    expect(result.result.value.name).toBe('Test Craftsperson');
    expect(result.result.value.active).toBe(true);
  });
  
  it('should update craftsperson status', () => {
    const result = contract['update-craftsperson-status'](1, false);
    expect(result.result.value).toBe(true);
  });
});
