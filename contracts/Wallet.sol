// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Wallet {
  event Deposit(address indexed sender, uint256 amount, uint256 balance);
  event SubmitTransaction(
    address indexed owner,
    address indexed to,
    uint256 value,
    uint256 indexed txIndex,
    bytes data
  );
  event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
  event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
  event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);
  
  address[] public owners;

  function submitTransaction() public {}

  function confirmTransaction() public {}

  function executeTransaction() public {}

  function revokeConfirmation() public {}
}
