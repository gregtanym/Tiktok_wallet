// SPDX-License-Identifier: MIT
import "./TTT.sol";
pragma solidity ^0.8.9;

// buyers pay to TTWalletManager
contract TTWalletManager {
	address owner;

	mapping(string => uint) idToBalance;
	mapping(string => address) idToAddress;

	constructor() {
		owner = msg.sender;
	}

	event Registered(string tiktokId, address userAddress);

	// event BuyerDeposited(string sellerTiktokId, string buyerTiktokId);

	function register(string memory tiktokId, address userAddress) external {
		require(msg.sender == owner);
		idToBalance[tiktokId] = userAddress;
		emit SellerRegistered(tiktokId, sellerAddress);
	}

	function buyerDeposit(
		string memory sellerTiktokId,
		string memory buyerTiktokId
	) external payable {
		userToWallet[buyerTiktokId] = msg.sender;
		payable(userToWallet[sellerTiktokId]).transfer(msg.value);
		emit BuyerDeposited(sellerTiktokId, buyerTiktokId);
	}

	function getBalance() external view returns (uint) {
		return address(this).balance;
	}

	// function getSellers() external view returns (TTWallet[] memory) {
	// 	return sellers;
	// }

	function getUserBalance(
		string memory ttId
	) external view returns (address) {
		return idToBalance[ttId];
	}
}
