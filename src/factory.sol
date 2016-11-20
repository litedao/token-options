pragma solidity ^0.4.4;

import 'ds-base/base.sol';

import './option.sol';
import "./interface.sol";
// import 'erc20/erc20.sol;'    TODO import is broken

contract OptionFactory is DSBase, OptionFactoryCallbackInterface
{
    struct OptionStatus {
        bool built_here;
        bool is_exercised;
    }
    mapping(address=>OptionStatus) _status;
    function isLiveOption(address what) returns (bool) {
        var s = _status[what];
        return (s.built_here && !s.is_exercised);
    }
    // For use with tokens that don't have `transferFrom`
    function createEmptyOption( ERC20 a, ERC20 b
                              , uint40 expiration)
        returns (TrackedOption)
    {
        var o = new TrackedOption(this, msg.sender, a, b, expiration);
        _status[o].built_here = true;
        return o;
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
    function reportExercised() {
        var o = _status[msg.sender];
        assert(o.built_here);
        o.is_exercised = true;
    }
}
