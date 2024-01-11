const DutchAuction = artifacts.require("DutchAuction");

module.exports = function (deployer) {
  deployer.deploy(DutchAuction);
};
