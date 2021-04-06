const Wallet = artifacts.require("Wallet");
const TestContract = artifacts.require("TestContract");

// Remix says that address needs to be an array
/**
 * ["0x7873...",
 * "0xdD87..."],"1"
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
