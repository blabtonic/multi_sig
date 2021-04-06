const Wallet = artifacts.require("Wallet");
const TestContract = artifacts.require("TestContract");

// Remix says that address needs to be an array
/**
 * ["0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB",
 * "0xdD870fA1b7C4700F2BD7f44238821C26f7392148"],"1"
 * Multiple addresses needed for confirmation
 * */
module.exports = function (deployer) {
  deployer.deploy(
    Wallet,
    [
      "0x4D78C7c9091Ef1235c17638255E2C174C04F3f08",
      "0xCE3F6d7D2E7D6fb3c8DBe62bE85b4800e71D5B45",
    ],
    1
  );
  deployer.deploy(TestContract);
};
