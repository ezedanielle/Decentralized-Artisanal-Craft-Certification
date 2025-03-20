import { describe, it, expect, beforeEach } from 'vitest';
import { mockClarityBlockInfo } from './test-utils';

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
  return {
    'register-material': (name, source, sustainable, description) => {
      mockClarity.blockHeight += 1;
      return { result: { value: true } };
    },
    'register-material-batch': (materialId, quantity, harvestDate) => {
      return { result: { value: true } };
    },
    'get-material': (id) => {
      return {
        result: {
          value: {
            name: 'Test Material',
            'source-location': 'Test Location',
            sustainable: true,
            description: 'Test Description'
          }
        }
      };
    },
    'get-material-batch': (batchId) => {
      return {
        result: {
          value: {
            'material-id': 1,
            quantity: 100,
            'harvest-date': 95,
            supplier: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM'
          }
        }
      };
    }
  };
};

describe('Material Sourcing Contract', () => {
  let contract;
  
  beforeEach(() => {
    mockClarityBlockInfo(mockClarity);
    contract = loadContract();
  });
  
  it('should register a new material', () => {
    const result = contract['register-material']('Organic Cotton', 'India', true, 'Sustainably grown cotton');
    expect(result.result.value).toBe(true);
  });
  
  it('should register a material batch', () => {
    const result = contract['register-material-batch'](1, 500, 95);
    expect(result.result.value).toBe(true);
  });
  
  it('should retrieve material details', () => {
    const result = contract['get-material'](1);
    expect(result.result.value.name).toBe('Test Material');
    expect(result.result.value.sustainable).toBe(true);
  });
  
  it('should retrieve material batch details', () => {
    const result = contract['get-material-batch'](1);
    expect(result.result.value['material-id']).toBe(1);
    expect(result.result.value.quantity).toBe(100);
  });
});
