// SPDX-License-Identifier: MIT

pragma solidity >=0.8.9 <0.9.0;

import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';

contract HolderRoyaltiesClaim is Ownable, ReentrancyGuard {

    mapping(address => uint) public walletBalance;
    address[] public claimed;

    bool public paused;

    function setWallets(address[] calldata addresses, uint[] calldata balances) external onlyOwner{
        require(addresses.length == balances.length, "Invalid array length");
        for(uint i = 0; i < addresses.length; i++){
            walletBalance[addresses[i]] = balances[i];
        }
    }

    function addWallets(address[] calldata addresses, uint[] calldata balances) external onlyOwner{
        require(addresses.length == balances.length, "Invalid array length");
        for(uint i = 0; i < addresses.length; i++){
            walletBalance[addresses[i]] += balances[i];
        }
    }

    function claim() public nonReentrant {
        require(!paused, "Claim is paused!");
        require(walletBalance[_msgSender()] > 0, "No balance available for withdraw.");
        (bool success, ) = payable(_msgSender()).call{value: walletBalance[_msgSender()]}('');
        require(success);
        walletBalance[_msgSender()] = 0;
        claimed.push(_msgSender());
    }

    function withdraw() public onlyOwner nonReentrant {

        (bool success, ) = payable(owner()).call{value: address(this).balance}('');
        require(success);
    }

    function setPause(bool _state) external onlyOwner{
        paused = _state;
    }

    receive() external payable{}

    fallback() external payable{}

}