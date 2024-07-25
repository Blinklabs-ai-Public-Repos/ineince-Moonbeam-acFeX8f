// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

/**
 * @title Ineince
 * @dev ERC20 token with multisend capability, burnable, and multicall functionality
 */
contract Ineince is ERC20, ERC20Burnable, Multicall {
    uint256 private immutable _maxSupply;

    /**
     * @dev Constructor that sets the name, symbol, and max supply of the token
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     * @param maxSupply_ The maximum supply of the token
     */
    constructor(string memory name_, string memory symbol_, uint256 maxSupply_) ERC20(name_, symbol_) {
        _maxSupply = maxSupply_;
        _mint(msg.sender, maxSupply_);
    }

    /**
     * @dev Returns the maximum supply of the token
     * @return The maximum supply
     */
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    /**
     * @dev Multisend function to send tokens to multiple addresses in one transaction
     * @param recipients Array of recipient addresses
     * @param amounts Array of amounts to send to each recipient
     */
    function multisend(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Recipients and amounts arrays must have the same length");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], amounts[i]);
        }
    }

    /**
     * @dev Override of the _mint function to enforce the max supply limit
     * @param account The account to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function _mint(address account, uint256 amount) internal virtual override {
        require(totalSupply() + amount <= _maxSupply, "ERC20: mint amount exceeds max supply");
        super._mint(account, amount);
    }
}