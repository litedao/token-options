pragma solidity ^0.4.4;

import 'ds-base/base.sol';
import 'erc20/erc20.sol;'

// Create this via OptionFactory to register your option and
// optionally use a helper that pulls your tokens
contract Option {
    address public creator;   // Creator is locked in until expiration
    address public owner;     // Owner gets to pick at any time
    ERC20 public atoken;
    ERC20 public btoken;
    uint40 public expiration;
    // @note Tokens don't actually need to be full ERC20, just need `transfer`.
    function Option(address _creator, ERC20 _a, ERC20 _b, uint40 _expiration)
    {
        creator = _creator;
        owner = _creator;
        atoken = _a;
        btoken = _b;
        expiration = _expiration;
    }
    function transfer(uint id, address new_owner) {
        var o = options[id];
        assert(msg.sender == o.owner);
        options[id].owner = new_owner;
    }
    function exercise(uint id, ERC20 which_for_owner)
    {
        if( getTime() < expiration ) {
            assert(msg.sender == owner);
        } else {
            assert(msg.sender == owner || msg.sender == creator);
        }
        if( which_for_owner == atoken ) {
            assert( atoken.transfer(owner, atoken.balanceOf(this)) );
            assert( btoken.transfer(creator, btoken.balanceOf(this)) );
        } else if( which_for_owner == btoken ) {
            assert( atoken.transfer(creator, atoken.balanceOf(this)) );
            assert( btoken.transfer(owner, btoken.balanceOf(this)) );
        } else {
            throw;
        }
        selfdestruct(msg.sender);
    }
}


