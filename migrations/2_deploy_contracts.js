const stackAbleToken = artifacts.require("stackableToken");
const rewardToken = artifacts.require("rewardToken");
const stakeContract = artifacts.require("stakingFile");

module.exports = function(deployer, networks, accounts) {

  deployer.deploy(stakeContract, accounts[0]).then((mainContractDeployed)=>{
    deployer.link(stakeContract,rewardToken);
    deployer.link(stakeContract,stackAbleToken);
    return deployer.deploy(rewardToken, mainContractDeployed.address, 200000).then((rewardTokenDeployed)=>{
      return rewardTokenDeployed.transferOwnership(mainContractDeployed.address).then(()=>rewardTokenDeployed);
    }).then((rewardTokenDeployed)=>{
      return mainContractDeployed.setRewardToken(rewardTokenDeployed.address).then((d)=>{
        return mainContractDeployed
      });
    }).then((mainContractDeployed) => {
      return deployer.deploy(stackAbleToken, accounts[0], 200000).then((stakableTokenDeployed)=>{
        return stakableTokenDeployed.transferOwnership(mainContractDeployed.address).then(()=>stakableTokenDeployed)
      }).then((stakableTokenDeployed)=>{
        return mainContractDeployed.setStakeToken(stakableTokenDeployed.address)
      });
    });
  })
};
