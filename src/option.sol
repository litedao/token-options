pragma solidity ^0.4.4;

import 'ds-base/base.sol';
// import 'erc20/erc20.sol;'    TODO import is broken - alias in interface.sol
import "./interface.sol";



// Create a `ManagedOption is Option` via OptionFactory to register your option and
// optionally use a helper that pulls your tokens
contract Option is DSBase {
    address public loser;   // loser is locked in until expiration, but starts as chooser
    address public chooser;   // chooser gets to pick at any time
    ERC20 public atoken;
    ERC20 public btoken;
    uint40 public expiration;
    // @note Tokens don't actually need to be full ERC20, just need `transfer`.
    function Option(address _creator, ERC20 _a, ERC20 _b, uint40 _expiration)
    {
        loser = _creator;
        chooser = _creator;
        atoken = _a;
        btoken = _b;
        expiration = _expiration;
    }
    function setLoser(address who) {
        assert(msg.sender == loser);
        loser = who;
    }
    function setChooser(address who) {
        assert(msg.sender == chooser);
        chooser = who;
    }
    // If you're canceling as `loser`, be sure to specify the token you *don't* want
    function exercise(ERC20 which_for_chooser)
    {
        if( getTime() < expiration ) {
            assert(msg.sender == chooser);
        } else {
            assert(msg.sender == chooser || msg.sender == loser);
        }
        if( which_for_chooser == atoken ) {
            assert( atoken.transfer(chooser, atoken.balanceOf(this)) );
            assert( btoken.transfer(loser, btoken.balanceOf(this)) );
        } else if( which_for_chooser == btoken ) {
            assert( atoken.transfer(loser, atoken.balanceOf(this)) );
            assert( btoken.transfer(chooser, btoken.balanceOf(this)) );
        } else {
            throw;
        }
        selfdestruct(msg.sender);
    }
}

contract TrackedOption is Option {
    OptionFactoryCallbackInterface public factory;
    function TrackedOption( OptionFactoryCallbackInterface _factory
                          , address _creator
                          , ERC20 _a, ERC20 _b, uint40 _expiration )
             Option(_creator, _a, _b, _expiration)
    {
        factory = _factory;
    }
    function exercise(ERC20 which_for_chooser) {
        factory.reportExercised();
        super.exercise(which_for_chooser);
    }
}
