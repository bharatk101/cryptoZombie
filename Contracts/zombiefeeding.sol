// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.6.0;

// import 
import "./zombiefactory.sol";

/**
For our contract to talk to another contract on the blockchain that we don't own, 
first we need to define an interface.

Notice that this looks like defining a contract, with a few differences. For one, we're only declaring the functions we want to interact with — in this case getNum — and we don't mention any of the other functions or state variables.

Secondly, we're not defining the function bodies. Instead of curly braces ({ and }), we're simply ending the function declaration with a semi-colon (;).

So it kind of looks like a contract skeleton. This is how the compiler knows it's an interface.

 */
contract KittyInterface{
    function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
);
}

// contract ZombieFeeding is inherited from ZombieFactory
contract ZombieFeeding is ZombieFactory{
    
    // Initialize kittyContract here using `ckAddress` from above
    KittyInterface kittyContract;

    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // 1. Define `_triggerCooldown` function here
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    // 2. Define `_isReady` function here
    function _isReady(Zombie storage _zombie) internal view returns(bool){
        return (_zombie.readyTime <= now);
    }


    function feedAndMultiply(uint _zombieId, uint _targetDna, string memory _species) internal {
        // require statement to verify that msg.sender is equal to this zombie's owner 
        require(msg.sender == zombieToOwner[_zombieId]);
        require(_isReady(my));
        // a local Zombie named myZombie. Set this variable to be equal to index _zombieId in our zombies array.
        Zombie storage myZombie = zombies[_zombieId];
        //  making sure _targetDna is 16 digits
        _targetDna = _targetDna % dnaModulus;
        // new zombie's DNA is simple: the average between the feeding zombie's DNA and the target's DNA. 
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // Add an if statement here
        if (keccak256(abi.encodePacked(_species)) == keccak256(abi.encodePacked("kitty"))){
            newDna = newDna - newDna % 100 + 99;
        }
        // calling createZombie function with name as noName
        _createZombie("NoName", newDna);
  }

    function feedOnKitty(uint _zombieId, uint _kittyId) public{
      uint kittyDna;
      // getKitty returs multiple values and we just care about genes so add commas for the not required ones
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}