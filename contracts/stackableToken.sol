pragma solidity ^0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";
import "./rewardToken.sol";



contract stackableToken is ERC20, Ownable{
    struct stakeStructure {
        uint256 value;
        uint time;
        uint id;
    }

    using SafeMath for uint256;

    address[] internal stakeholders;




    mapping(address => stakeStructure[]) internal stakes;

    mapping(address => uint256) internal rewards;

    address rewardTokenAddress;

    constructor(address _owner, uint256 _supply)
    ERC20("StakeableToken", "STX")
    public {
        _mint(_owner, _supply);
    }


    function setRewardToken(address _rewardTokenAddress) public onlyOwner{
        rewardTokenAddress = _rewardTokenAddress;
    }



    // ---------- STAKES ----------

    /**
     * @notice A method for a stakeholder to create a stake.
     * @param _stake The size of the stake to be created.
     */
    function createStake(uint256 _stake)
    public
    {
        _burn(msg.sender, _stake);
        if(stakes[msg.sender].length == 0) addStakeholder(msg.sender);
        stakes[msg.sender].push(stakeStructure(_stake, block.timestamp, stakes[msg.sender].length));
    }

    /**
     * @notice A method for a stakeholder to remove a stake.
     * @param _stake The size of the stake to be removed.
     * @param _id the id of the stake to remove from.
     */
    function removeStake(uint _id, uint256 _stake)
    public
    {
        if(stakes[msg.sender][_id].value >= _stake) stakes[msg.sender][_id].value = stakes[msg.sender][_id].value.sub(_stake);
        if(stakes[msg.sender][_id].value < _stake) {
            stakes[msg.sender][_id].value = 0;
            delete stakes[msg.sender][_id];
        }
        if(stakes[msg.sender].length == 0) removeStakeholder(msg.sender);
        _mint(msg.sender, _stake);
    }

    /**
     * @notice A method to retrieve the stake for a stakeholder.
     * @param _stakeholder The stakeholder to retrieve the stake for.
     * @return uint256 The amount of wei staked for all the stakes.
     */
    function stakeOf(address _stakeholder)
    public
    view
    returns(uint256)
    {
        uint256 stakeSize;
        for (uint256 s = 0; s < stakes[_stakeholder].length; s += 1){
            stakeSize = stakeSize.add(stakes[_stakeholder][s].value);
        }
        return stakeSize;
    }

    /**
     * @notice A method to the aggregated stakes from all stakeholders.
     * @return uint256 The aggregated stakes from all stakeholders.
     */
    function totalStakes()
    public
    view
    returns(uint256)
    {
        uint256 _totalStakes = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalStakes = _totalStakes.add(stakeOf(stakeholders[s]));
        }
        return _totalStakes;
    }

    // ---------- STAKEHOLDERS ----------

    /**
     * @notice A method to check if an address is a stakeholder.
     * @param _address The address to verify.
     * @return bool, uint256 Whether the address is a stakeholder,
     * and if so its position in the stakeholders array.
     */
    function isStakeholder(address _address)
    public
    view
    returns(bool, uint256)
    {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
        }
        return (false, 0);
    }

    /**
     * @notice A method to add a stakeholder.
     * @param _stakeholder The stakeholder to add.
     */
    function addStakeholder(address _stakeholder)
    public
    {
        (bool _isStakeholder, ) = isStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
    }

    /**
     * @notice A method to remove a stakeholder.
     * @param _stakeholder The stakeholder to remove.
     */
    function removeStakeholder(address _stakeholder)
    public
    {
        (bool _isStakeholder, uint256 s) = isStakeholder(_stakeholder);
        if(_isStakeholder){
            stakeholders[s] = stakeholders[stakeholders.length - 1];
            stakeholders.pop();
        }
    }

    // ---------- REWARDS ----------

    /**
     * @notice A method to allow a stakeholder to check his rewards.
     * @param _stakeholder The stakeholder to check rewards for.
     */
    function rewardOf(address _stakeholder) public view returns(uint256){
        return rewards[_stakeholder];
    }

    function myReward() public view returns(uint256){
        return rewards[msg.sender];
    }
    /**
     * @notice A method to the aggregated rewards from all stakeholders.
     * @return uint256 The aggregated rewards from all stakeholders.
     */
    function totalRewards() public view returns(uint256){
        uint256 _totalRewards = 0;
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            _totalRewards = _totalRewards.add(rewards[stakeholders[s]]);
        }
        return _totalRewards;
    }

    /**
     * @notice A simple method that calculates the rewards for each stakeholder.
     * @param _stakeholder The stakeholder to calculate rewards for.
     */
    function calculateReward(address _stakeholder)
    public
    view
    returns(uint256)
    {
        uint256 _finalReward;

        for (uint256 s = 0; s < stakes[_stakeholder].length; s += 1){
            if((block.timestamp - stakes[_stakeholder][s].time) > 1 days){
                if(stakes[_stakeholder][s].value > 100){
                    _finalReward = _finalReward.add(((block.timestamp - stakes[_stakeholder][s].time) / 1 days) * 10);
                }
                if(stakes[_stakeholder][s].value > 1000){
                    _finalReward = _finalReward.add(((block.timestamp - stakes[_stakeholder][s].time) / 1 days) * 20);
                }
                if(stakes[_stakeholder][s].value > 10000){
                    _finalReward = _finalReward.add(((block.timestamp - stakes[_stakeholder][s].time) / 1 days) * 30);
                }
            }
        }
        return _finalReward ;
    }

    /**
     * @notice A method to distribute rewards to all stakeholders.
     */
    function distributeRewards() public onlyOwner {
        for (uint256 s = 0; s < stakeholders.length; s += 1){
            address stakeholder = stakeholders[s];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
    }

    /**
     * Will allow or disallow the withdraw by checking the allowed timing
     */
    modifier canWithdraw() {
        bool canWithdraw = false;
        for (uint256 s = 0; s < stakes[msg.sender].length; s += 1){
            if(block.timestamp > (stakes[msg.sender][s].time + 30 days)){
                canWithdraw = true;
            }
        }
        require(
            canWithdraw == true,
            "You need to wait for at least 30 days to withdraw"
        );
        _;
    }

    /**
     * @notice A method to allow a stakeholder to withdraw his rewards.
     */
    function withdrawReward()
    public
    canWithdraw
    {
        (bool _isStakeholder, ) = isStakeholder(msg.sender);
        if(_isStakeholder){
            uint256 reward = rewards[msg.sender];
            if(reward == 0) {
                reward = calculateReward(msg.sender);
            }
            rewards[msg.sender] = 0;
            rewardToken(rewardTokenAddress).withdrawReward(msg.sender, reward);
            _mint(msg.sender, reward);
        }
    }
}
