const stakingFile = artifacts.require("stakingFile");

module.exports = async done => {
    try {
        const accounts = await web3.eth.getAccounts();
        console.log(accounts);
        const stakingFileInstance = await stakingFile.deployed();
        const totalStakes = await stakingFileInstance.totalStakes();
        console.log(`All Stakes amount : ${totalStakes}`)
        const stakeholders = await stakingFileInstance.getAllStakeHolders();
        console.log(`We have ${stakeholders?.length} stakeholders`);
        const totalREwards = await stakingFileInstance.totalRewards();
        console.log(`Web have ${totalREwards} of unclaimed or unclaimable reward tokens`);
    } catch(e) {
        console.log("Error when running test");
        console.log(e);
    }
    done();
};
