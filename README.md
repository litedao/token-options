Options are contracts that contain 2 token balances, and expiration, and 2 users: the `loser` and the `chooser`.

The `chooser` can pick either of the two balances any time before the `expiration`. The `loser` can act as `chooser` when the option expires.

The `loser` starts out being the `chooser` as well. The idea is that the `loser` will sell the `chooser` role.

Both the `loser` and `choser` can update their own addresses (transfer ownership).

Usage:

```
OptionFactory factory = OptionFactory(env.get("factory"));
Token a; Token b;

# Make empty option and fill up manually
Option o = factory.createEmptyOption(this, a, b, now + 12 hours);
a.transfer(o, 100);
b.transfer(o, 200);

# or use `approve` based workflow
a.approve(o, 1000000);
b.approve(o, 1000000);
Option o = factory.createOption(this, a, 100, b, 200, now + 12 hours);

# Note the factory tracks live auctions:
assert( factory.isLiveAuction(o) );

# set the chooser
o.setChooser(0xb0b);

# can also transfer `lower`
o.setLoser(this);

# if you are the chooser, or loser and option expired
# WARNING: the argument is the token that the `chooser` receives, EVEN IF YOU
# ARE "CANCELING" (calling as lower)
o.exercise(a);

# factory tracks when options close
assertFalse( factory.isLiveOption(o) );
```

