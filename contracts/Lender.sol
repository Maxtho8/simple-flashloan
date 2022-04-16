// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IBorrower {
    function repay(address tokenAddress, uint256 _amount) external;

    function executeOperation() external;
}

contract Lender {
    // The token that is being lent
    IERC20 public immutable token;

    event LenderCreated(address user);

    constructor(address tokenAddress) {
        // Initialize the token
        token = IERC20(tokenAddress);
    }

    function flashLoan(uint256 amount) external {
        // Check that the amount is not zero
        require(amount > 0, "Lender: amount must be greater than zero");

        uint256 balanceBeforeLoan = token.balanceOf(address(this));
        // Transfer the amount to the borrower
        token.transfer(msg.sender, 10000);

        emit LenderCreated(msg.sender);

        // Call borrower operations to execute
        IBorrower(msg.sender).executeOperation();

        // The lender calls the smart contract function of the receiver to recover the funds
        IBorrower(msg.sender).repay(address(token), amount);
        require(
            token.balanceOf(address(this)) == balanceBeforeLoan,
            "Lender: borrower did not repay"
        );
    }
}
