const stakingFile = artifacts.require("stakingFile");

module.exports = async done => {
    try {
        const accounts = await web3.eth.getAccounts();
        const stakesToRemove = 200;
        const stakingFileInstance = await stakingFile.deployed();
        console.log(`Will remove ${stakesToRemove} value from stake 1`)
        await stakingFileInstance.removeStake(1, stakesToRemove);
        const newStakes = await stakingFileInstance.stakeValueOf(accounts[0], 1);
        console.log(`new stake value is : ${newStakes}`)
    } catch(e) {
        console.log("Error when running test");
        console.log(e);
    }
    done();
};
