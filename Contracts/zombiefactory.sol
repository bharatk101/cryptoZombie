pragma solidity >=0.6.0 <0.9.0;

contract ZombieFactory {

    /**
    Events are a way for your contract to communicate that something happened on the
     blockchain to your app front-end, which can be 'listening'
      for certain events and take action when they happen.
     */

    event NewZombie(uint zombieId, string name, uint dna);
    // uint -> unsigned int, 256 bit, cannot have -ve int
    uint dnaDigits = 16;
    // ** -> power of 
    uint dnaModulus = 10 ** dnaDigits;

    // struct -> Defines a new type with two fields.
    struct Zombie{
        string name;
        uint dna;
    }

    //  array of structs which is public
    Zombie[] public zombies ;

    // functions in sol 
    /**This is a function named createZombie that takes 2 parameters: 
    a string and a uint. For now the body of the function is empty.
     Note that we're specifying the function visibility as public. 
     We're also providing instructions about where the _name variable should be stored- in memory. 

     Note: It's convention (but not required)
      to start function parameter variable names with an underscore (_) 
      in order to differentiate them from global variables
     */

    function _createZombie(string memory _name, uint _dna) private {
        //  adds zombie to the array
        uint id = zombies.push(Zombie(_name, _dna)) - 1;

        // fire an event to let the app know the function was called:
        emit NewZombie(id, _name, _dna);
    }

    /**
    To return a value from a function, the declaration looks like this:
    The function doesn't actually change state in Solidity — e.g. it doesn't change any values or write anything.
    So in this case we could declare it as a view function, meaning it's only viewing the data but not modifying it:

    OR

    Solidity also contains pure functions, which means you're not even accessing any data in the app.
     */

    function _generateRandomDna(string memory _str) private view returns(uint){
        // Ethereum has the hash function keccak256 built in, which is a version of SHA3.
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    /**
    We're close to being done with our random Zombie generator!
     Let's create a public function that ties everything together.
    We're going to create a public function that takes an input,
     the zombie's name, and uses the name to create a zombie with random DNA.
     */

    function createRandomZombie(string memory _name) public{
        uint randDan = _generateRandomDna(_name);
        _createZombie(_name, randDan);
    }

}
