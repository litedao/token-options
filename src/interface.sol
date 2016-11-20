pragma solidity ^0.4.4;

contract ERC20 { // TODO broken import
    function balanceOf(address) returns (uint);
    function transfer(address,uint) returns (bool);
    function transferFrom(address,address,uint) returns (bool);
}

contract OptionFactoryCallbackInterface {
    function reportExercised();
}
