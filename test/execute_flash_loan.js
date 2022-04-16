const Lender = artifacts.require("Lender");
const MarketA = artifacts.require("DealerA");
const MarketB = artifacts.require("DealerB");
const Borrower = artifacts.require("Borrower");
const Dollar = artifacts.require("Dollar");
const Cars = artifacts.require("Cars");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("executeFlashLoan", function (accounts) {
  it("dealerA should have received 1 car , dealer B 11k dollar and lender 10K", async function () {
    // check that the car was transferred to the dealerA
    let carInstance = await Cars.deployed();
    assert.equal(await carInstance.balanceOf(MarketA.address), 1);
    // check that the dollar was transferred to the dealerB
    let dollarInstance = await Dollar.deployed();
    assert.equal(await dollarInstance.balanceOf(MarketB.address), 11000);
    assert.equal(await dollarInstance.balanceOf(Lender.address), 10000);
  });
  it("flash", async function () {
    let dollarInstance = await Dollar.deployed();
    let borrowerInstance = await Borrower.deployed();
    let balanceBefore = await dollarInstance.balanceOf(Borrower.address);
    console.log(balanceBefore.toString())
    await borrowerInstance.executeFlashLoan(10000);
    let balanceAfter = await dollarInstance.balanceOf(Borrower.address);
    console.log(balanceAfter.toString());
  });
});
