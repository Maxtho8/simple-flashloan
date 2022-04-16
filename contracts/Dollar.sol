// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Dollar is ERC20 {
    constructor() ERC20("Dollar", "$") {
        // Initialize the token
        _mint(msg.sender, 21000);
    }
}
