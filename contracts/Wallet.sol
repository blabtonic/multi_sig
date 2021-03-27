// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Wallet {
  event Deposit(address indexed sender, uint256 amount, uint256 balance);
  event SubmitTransaction(
    address indexed owner,
    address indexed to,
    uint256 amount,
    uint256 indexed txIndex,
    bytes data
  );
  event ConfirmTransaction(address indexed owner, uint256 indexed txIndex);
  event RevokeConfirmation(address indexed owner, uint256 indexed txIndex);
  event ExecuteTransaction(address indexed owner, uint256 indexed txIndex);
  
  address[] public owners;
  // Number of confirmations needed for transaction to go through
  uint256 public Confirmations;
  
  struct Transaction {
    uint256 amount;
    address to;
    bytes data;
    bool executed;
    mapping(address => bool) isConfirmed;
    uint256 numConfirmations;
  }

  Transaction[] public transactions;
  
  constructor(address[] memory _owners, uint256 _numConfirmationsRequired) public {
    require(_owners.length > 0, "owners required");
    require(
      _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, 
      "invalid number of required confirmations"
    );

    for (uint256 i = 0; i < _owners.length; i++) {
      address owner = _owners[i];

      require(owner != address(0), "invalid owner");
      // Error check for unique owners to approve
      //require(!isOwner[owner], "owner not unique");
      
      //isOwner[owner] = true;
      owners.push(owner);
    }
    
    _numConfirmationsRequired = _numConfirmationsRequired;
  }

  function submitTransaction() public {}

  function confirmTransaction() public {}

  function executeTransaction() public {}

  function revokeConfirmation() public {}
}
