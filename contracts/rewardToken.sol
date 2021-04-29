
pragma solidity ^0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";

contract rewardToken is ERC20, Ownable{
    using SafeMath for uint256;

    mapping(address => uint256) internal rewards;

    address[] internal stakeholders;

    constructor(address _owner, uint256 _supply)
    ERC20("RewardToken", "RTX")
    public {
        _mint(_owner, _supply);
    }

    function withdrawReward(address _to, uint256 amount) public onlyOwner{
        _mint(_to, amount);
    }
}
