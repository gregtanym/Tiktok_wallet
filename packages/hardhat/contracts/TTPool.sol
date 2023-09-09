// SPDX-License-Identifier: MIT
import "./TTT.sol";
pragma solidity ^0.8.9;

// buyers pay to TTWalletManager
contract TTWalletManager {

	uint256 public MINT_PRICE = 0.05 ether;
	uint256 public TOTAL_ETH_SUPPLY = 0;

	uint256 public rate;  // Number of tokens per ETH. For example, if 1 ETH = 100 tokens, then rate = 100.

	address owner;
	IERC20 private TTT;
	mapping(string => uint) idToBalance;
	mapping(string => address) idToAddress;

	constructor(IERC20 token, uint256 _rate) {
		owner = msg.sender;
		TTT = token;
		rate = _rate;
	}

	modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

	event Registered(string tiktokId, address userAddress);
	event Paid(string sender, string recipient, uint amt);

	// event BuyerDeposited(string sellerTiktokId, string buyerTiktokId);

	function setRate(uint256 _rate) external onlyOwner {
        rate = _rate;
    }

	function register(string memory tiktokId, address userAddress) external {
		require(msg.sender == owner);
		idToAddress[tiktokId] = userAddress;
		idToBalance[tiktokId] = 0;
		emit Registered(tiktokId, userAddress);
	}

	function pay(
		string memory sender,
		string memory recipient,
		uint amt
	) external payable {
		uint senderBal = idToBalance[sender];
		require(idToAddress[sender] != address(0));
		require(idToAddress[recipient] != address(0));
		require(senderBal >= amt, "Sender needs more TTT");
		address senderAdd = idToAddress[sender];
		address recipientAdd = idToAddress[recipient];
		idToBalance[sender] -= amt;
		idToBalance[recipient] += amt;
		TTT.transferFrom(senderAdd, recipientAdd, amt);
		emit Paid(sender, recipient, amt);
	}

	function getBalance() external view returns (uint) {
		return address(this).balance;
	}

	function deposit() external payable {
        require(msg.value > 0, "Must send ETH");

        uint256 tokensToMint = msg.value * rate;
        require(TTT.transferFrom(owner, msg.sender, tokensToMint), "Token transfer failed");
    }

	// function getSellers() external view returns (TTWallet[] memory) {
	// 	return sellers;
	// }

	function getUserBalance(string memory ttId) external view returns (uint) {
		return idToBalance[ttId];
	}
}
