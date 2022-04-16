const Lender = artifacts.require("Lender");
const MarketA = artifacts.require("DealerA");
const MarketB = artifacts.require("DealerB");
const Borrower = artifacts.require("Borrower");
const Dollar = artifacts.require("Dollar");
const Cars = artifacts.require("Cars");

module.exports = async function (deployer,network,accounts) {
  await deployer.deploy(Dollar);
  await deployer.deploy(Cars);
  await deployer.deploy(MarketA, Cars.address, Dollar.address);
  await deployer.deploy(MarketB, Cars.address, Dollar.address);
  let carsInstance = await Cars.deployed(); 
  let dollarInstance = await Dollar.deployed();
  await carsInstance.approve(accounts[0],1)
  await dollarInstance.approve(accounts[0],21000)
  await carsInstance.transferFrom(accounts[0],MarketA.address,1)
  await dollarInstance.transferFrom(accounts[0],MarketB.address,11000)
  await deployer.deploy(Lender, Dollar.address);
  await dollarInstance.transferFrom(accounts[0],Lender.address,10000)
  await deployer.deploy(Borrower, Lender.address,MarketA.address,MarketB.address);
};
