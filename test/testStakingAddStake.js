const stakingFile = artifacts.require("stakingFile");

module.exports = async done => {
    try {
        const accounts = await web3.eth.getAccounts();
        console.log(accounts);
        const stakingAmount = 300;
        const stakingFileInstance = await stakingFile.deployed();
        await stakingFileInstance.createStake(stakingAmount, {from:accounts[0]});
        console.log(`Staking of ${stakingAmount} was successful`);
        const stakes = await stakingFileInstance.stakeOf(accounts[0], {from:accounts[0]})
        console.log(`Stake Amount queried from the contract : ${stakes.toString()}`)
    } catch(e) {
        console.log("Error when running test");
        console.log(e);
    }
    done();
};
