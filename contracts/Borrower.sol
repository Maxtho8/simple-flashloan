// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./Lender.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./MarketA.sol";
import "./MarketB.sol";

contract Borrower is IBorrower, Ownable {
    Lender private immutable lender;
    DealerA private immutable dealerA;
    DealerB private immutable dealerB;

    constructor(
        address _lender,
        address _dealerA,
        address _dealerB
    ) public {
        lender = Lender(_lender);
        dealerA = DealerA(_dealerA);
        dealerB = DealerB(_dealerB);
    }

    function allowDollarTransfer(address _address) internal {
        lender.token().approve(_address, type(uint256).max);
    }

    function allowCarsTransfer(address _address) internal {
        dealerA.cars().approve(_address, type(uint256).max);
    }

    function repay(address tokenAddress, uint256 _amount) external {
        require(0 == 1, "On passe ici");
        require(
            msg.sender == address(lender),
            "Only lender can call repay function"
        );
        require(
            IERC20(tokenAddress).transfer(address(lender), _amount),
            "Borrower: could not transfer tokens"
        );
    }

    function executeOperation() public {
        dealerA.buyCar();
    }

    // Execute flashLoan
    function executeFlashLoan(uint256 _amount) external onlyOwner {
        if (lender.token().allowance(address(this), address(lender)) == 0) {
            allowDollarTransfer(address(lender));
        } else if (
            lender.token().allowance(address(this), address(dealerA)) == 0
        ) {
            allowDollarTransfer(address(dealerA));
        } else if (
            dealerA.cars().allowance(address(this), address(dealerB)) == 0
        ) {
            allowDollarTransfer(address(dealerB));
        }
        lender.flashLoan(_amount);
    }
}
