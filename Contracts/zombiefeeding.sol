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

    function feedAndMultiply(uint _zombieId, uint _targetDna) public {
        // require statement to verify that msg.sender is equal to this zombie's owner 
        require(msg.sender == zombieToOwner[_zombieId]);
        // a local Zombie named myZombie. Set this variable to be equal to index _zombieId in our zombies array.
        Zombie storage myZombie = zombies[_zombieId];
        //  making sure _targetDna is 16 digits
        _targetDna = _targetDna % dnaModulus;
        // new zombie's DNA is simple: the average between the feeding zombie's DNA and the target's DNA. 
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // calling createZombie function with name as noName
        _createZombie("NoName", newDna);
  }

}