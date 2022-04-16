// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IBorrower {
    function repay(uint256 _amount) external;

    function executeOperation() external;
}

contract Lender {
    // The token that is being lent
    IERC20 public immutable token;

    event LenderCreated(address user);
    event LenderSuccess(address user);

    constructor(address tokenAddress) {
        // Initialize the token
        token = IERC20(tokenAddress);
    }

    function flashLoan(uint256 amount) external {
        // Check that the amount is not zero
        require(amount > 0, "Lender: amount must be greater than zero");

        uint256 balanceBeforeLoan = token.balanceOf(address(this));
        uint256 balanceBeforeBorrower = token.balanceOf(address(msg.sender));
        // Transfer the amount to the borrower
        token.transfer(msg.sender, amount);

        // check if borrower received the amount
        require(
            token.balanceOf(address(msg.sender)) ==
                balanceBeforeBorrower + amount,
            "Lender: borrower did not receive the amount"
        );

        emit LenderCreated(msg.sender);

        // Call borrower operations to execute
        IBorrower(msg.sender).executeOperation();

        // The lender calls the smart contract function of the receiver to recover the funds
        IBorrower(msg.sender).repay(amount);
        // amount + 5% fees
        require(
            token.balanceOf(address(this)) ==
                balanceBeforeLoan + ((amount * 5) / 100),
            "Lender: borrower did not repay"
        );

        emit LenderSuccess(msg.sender);
    }
}
