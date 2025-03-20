// Mock utilities for Clarity testing

export function mockClarityBlockInfo(mockClarity) {
	global.block = {
		height: () => mockClarity.blockHeight
	};
}

export function mockClarityBitcoin(mockClarity) {
	global.Bitcoin = {
		get_block_info: () => ({ value: {} })
	};
}

export function mockClarityTx(mockClarity) {
	global.tx = {
		sender: () => mockClarity.tx.sender
	};
}
