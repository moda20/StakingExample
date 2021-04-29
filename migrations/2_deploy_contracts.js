const stackAbleToken = artifacts.require("stackableToken");
const rewardToken = artifacts.require("rewardToken");

module.exports = function(deployer, networks, accounts) {
  deployer.deploy(stackAbleToken, accounts[0], 200000).then((stackAbleTokenData)=>{
    deployer.link(stackAbleToken,rewardToken);
    return deployer.deploy(rewardToken, stackAbleTokenData.address, 200000).then((rewardTokenData)=>{
      rewardTokenData.transferOwnership(stackAbleTokenData.address);
      return stackAbleTokenData.setRewardToken(rewardTokenData.address);
    });
  });

};
