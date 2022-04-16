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

    bool isExecuted = false;

    constructor(
        address _lender,
        address _dealerA,
        address _dealerB
    ) public {
        lender = Lender(_lender);
        dealerA = DealerA(_dealerA);
        dealerB = DealerB(_dealerB);
    }

    //Execute one time for token allowance
    modifier oneTimeExecution() {
        if (!isExecuted) {
            allowDollarTransfer(address(lender));
            allowDollarTransfer(address(dealerA));
            allowCarsTransfer(address(dealerB));
            isExecuted = true;
        }
        _;
    }

    function allowDollarTransfer(address _address) internal {
        lender.token().approve(_address, 100000);
    }

    function allowCarsTransfer(address _address) internal {
        dealerA.cars().approve(_address, 100000);
    }

    function repay(uint256 _amount) external {
        require(
            msg.sender == address(lender),
            "Only lender can call repay function"
        );
        // Repay the amount with 5% fees
        require(
            lender.token().transfer(
                address(lender),
                _amount + (_amount * 5) / 100
            ),
            "Borrower: could not transfer tokens"
        );
    }

    function executeOperation() public {
        dealerA.buyCar();
        dealerB.sellCar();
    }

    // Execute flashLoan
    function executeFlashLoan(uint256 _amount)
        external
        oneTimeExecution
        onlyOwner
    {
        lender.flashLoan(_amount);
    }
}
