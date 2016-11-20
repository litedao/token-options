pragma solidity ^0.4.4;

import 'ds-base/base.sol';

contract OptionFactory is DSBase
{
    mapping(address=>bool) public isOption;
    // For use with tokens that don't have `transferFrom`
    function createEmptyOption( ERC20 a, ERC20 b
                              , uint40 expiration)
        returns (Option)
    {
        return new Option(msg.sender, a, b, expiration);
    }
    function createOption( ERC20 a, uint amount
                         , ERC20 b, uint bmount
                         , uint40 expiration)
        returns (Option)
    {
        var o = createEmptyOption(a, b, expiration);
        assert( a.transferFrom(msg.sender, o, amount) );
        assert( b.transferFrom(msg.sender, o, bmount) );
        return o;
    }
}
