//Directive de compilation
pragma solidity >= 0.6.11;

//Import contrats OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

//Contrat ERC20Token
contract ERC20Token is ERC20 {
    
    //Constructeur
    constructor(uint256 initialSupply) public ERC20("ALYRA", "ALY") {
       _mint(msg.sender, initialSupply);
    }
   
}