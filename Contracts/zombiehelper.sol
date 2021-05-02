// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.6.0;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

  // 1. Define levelUpFee here
  uint levelUpFee = 0.001 ether;

  modifier aboveLevel(uint _level, uint _zombieId){
    require(zombies[_zombieId].level >= _level);
    _;
  }

  function withdraw() external onlyOwner{
    address payable _owner = address(uint160(owner()));
    _owner.transfer(address(this).balance);
  }

  //  Create setLevelUpFee function here
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  //  Insert levelUp function here
  function levelUp(uint _zombieId) external payable{
    require(msg.value== levelUpFee);
    zombies[_zombieId].level++;
  }
  function changeName(uint _zombieId, string calldata _newName) external aboveLevel(2, _zombieId) ownerOf(_zombieId){
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].name = _newName;  
  }

  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) ownerOf(_zombieId){
    require(msg.sender == zombieToOwner[_zombieId]);
    zombies[_zombieId].dna = _newDna;  
  }
    
function getZombiesByOwner(address _owner) external view returns(uint[] memory){
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for (uint i =0; i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner){
        result[counter] = i;
        counter++;
      }
    }
    return result;
    
  }
  
}