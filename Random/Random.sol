pragma solidity 0.6.11;

/*
Votre smart contract doit s'appeler “Random”. 
Votre smart contract doit utiliser la version 0.6.11 du compilateur.
Votre smart contract doit définir uint appelé “nonce” de visibilité private, et fixez-le à 0.
Votre smart contract doit définir une fonction “random” qui retourne un nombre aléatoire entre 0 et 100. “random” doit utiliser la fonction de hachage keccak256. 
Enfin, elle doit (en une ligne de code) calculer le typecast uint du hash keccak256 des paramètres suivants : block.timestamp, msg.sender, nonce. 
*/


//Random Contract
contract Random{
    
    uint private nonce  = 0;
    
    function random () public returns (uint256){
        //TODO
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100;
        nonce++;
    }
    
}