// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DealerB {
    // The token that represent cars
    IERC20 public cars;
    IERC20 public dollar;

    constructor(IERC20 _cars, IERC20 _dollar) {
        cars = _cars;
        dollar = _dollar;
    }

    function buyCar() public {
        //Check that the price is good
        dollar.transferFrom(msg.sender, address(this), 11000);
        cars.transfer(msg.sender, 1);
    }

    function sellCar() public {
        //Check that the price is good
        require(
            cars.balanceOf(address(msg.sender)) >= 1,
            "You don't have any car to sell"
        );
        cars.transferFrom(msg.sender, address(this), 1);
        dollar.transfer(msg.sender, 11000 ether);
    }
}
