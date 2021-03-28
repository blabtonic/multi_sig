// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Wallet {
  /** EVENT LIST **/
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

  // Always set an owner for contract
  address[] public owners;
  mapping(address => bool) isOwner;
  uint256 public numConfirmationsRequired;

  // Number of confirmations needed for transaction to go through
  uint256 public Confirmations;

  struct Transaction {
    uint256 amount;
    address to;
    bytes data;
    bool executed;
    uint256 numConfirmations;
  }

  // Tx index => owner => bool
  mapping(uint256 => mapping(address => bool)) public isConfirmed;

  Transaction[] public transactions;

  constructor(address[] memory _owners, uint256 _numConfirmationsRequired) {
    require(_owners.length > 0, 'owners required');
    require(
      _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
      'invalid number of required confirmations'
    );

    for (uint256 i = 0; i < _owners.length; i++) {
      address owner = _owners[i];

      require(owner != address(0), 'invalid owner');
      // Error check for unique owners to approve
      require(!isOwner[owner], 'owner not unique');

      isOwner[owner] = true;
      owners.push(owner);
    }

    _numConfirmationsRequired = _numConfirmationsRequired;
  }

  /** MODIFIER LIST **/

  modifier onlyOwner() {
    require(isOwner[msg.sender], 'not owner');
    _;
  }

  modifier notConfirmed(uint256 _txIndex) {
    require(!isConfirmed[_txIndex][msg.sender], 'transaction already confirmed');
    _;
  }

  modifier txExists(uint256 _txIndex) {
    require(_txIndex < transactions.length, 'transaction does not exist');
    _;
  }

  modifier notExecuted(uint256 _txIndex) {
    require(!transactions[_txIndex].executed, 'transaction already executed');
    _;
  }

  // Submits Transcation only after it has been confirmed
  function submitTransaction(
    address _to,
    uint256 _amount,
    bytes memory _data
  ) public onlyOwner {
    uint256 txIndex = transactions.length;

    transactions.push(
      Transaction({
        to: _to,
        amount: _amount,
        data: _data,
        executed: false,
        numConfirmations: 0
      })
    );

    emit SubmitTransaction(msg.sender, _to, _amount, txIndex, _data);
  }

  // Confirms transactions when value is entered
  function confirmTransaction(uint256 _txIndex)
    public
    onlyOwner
    notConfirmed(_txIndex)
    txExists(_txIndex)
    notExecuted(_txIndex)
  {
    Transaction storage transaction = transactions[_txIndex];
    transaction.numConfirmations += 1;
    isConfirmed[_txIndex][msg.sender] = true;

    emit ConfirmTransaction(msg.sender, _txIndex);
  }

  // Executes a new transaction
  function executeTransaction(uint256 _txIndex)
    public
    onlyOwner
    notConfirmed(_txIndex)
    txExists(_txIndex)
    notExecuted(_txIndex)
  {
    Transaction storage transaction = transactions[_txIndex];

    require(
      transaction.numConfirmations >= numConfirmationsRequired,
      'cannot execute transaction'
    );

    transaction.executed = true;

    // Mapping?
    (bool success, ) = transaction.to.call{value: transaction.amount}(transaction.data);
    require(success, 'transaction failed');

    emit ExecuteTransaction(msg.sender, _txIndex);
  }

  function revokeConfirmation(uint256 _txIndex)
    public
    onlyOwner
    notConfirmed(_txIndex)
    txExists(_txIndex)
    notExecuted(_txIndex)
  {
    Transaction storage transaction = transactions[_txIndex];

    require(isConfirmed[_txIndex][msg.sender], 'transaction not confirmed');

    transaction.numConfirmations -= 1;
    isConfirmed[_txIndex][msg.sender] = false;

    emit RevokeConfirmation(msg.sender, _txIndex);
  }
}
