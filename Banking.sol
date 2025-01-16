//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Banking {
    //State Variables
    mapping(address => uint256) public balances;
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    //Functions
    function deposit() public payable {
        require(msg.value >= 0, "Deposit amount must be greater than 0.");
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "You are not authorized to withdraw");
        require(amount > 0, "Withdrawal amount must be greater than 0.");
        require(balances[msg.sender] <= amount, "Insufficient funds");
        payable(msg.sender).transfer(amount);
        balances[msg.sender] -= amount;
    }

    function transfer(address payable recipient, uint256 amount) public {
        require(
            msg.sender == owner,
            "You are not authorized to make transfers"
        );
        require(amount >= 0, "Transfer amount must be greater than zero");
        require(
            amount <= balances[msg.sender],
            "Insufficient funds to transfer"
        );
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    function getBlance(address payable user) public view returns (uint256) {
        return (balances[user]);
    }

    function grantAccess(address payable user) public {
        require(msg.sender == owner, "You are not authorized to grant access");
        owner = user;
    }

    function revokeAccess(address payable user) public {
        require(msg.sender == owner, "You are not authorized to revoke access");
        require(user != owner, "Cannot revoke access for the current owner");
        owner = payable(msg.sender);
    }

    function destroy() public {
        require(
            msg.sender == owner,
            "You are not authorized to destroy the contract"
        );
        selfdestruct(owner);
    }
}
