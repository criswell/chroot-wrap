Chroot wrapper script
=====================

The chroot wrapper script (chw) is a *very* simple tool which wraps some of the
tedium of using a chroot in an automated way.

Why it exists...
----------------

My typical modus operandi when working on various development projects is to
isolate my development/build environments away from my host environment. I
realize this is nothing shocking, or amazing, or unique, and that most good
developers do this practice... but whatever...

Depending on what I'm working with, there's a variety of tools I can use to
isolate my work (e.g., virtualenv for Python). However, the "nuclear option"
for environment isolation is the classic chroot(8).

The big problem when working with chroot is the fact that, in order for your
chroots to be useful, you need to set up various things (like mounts) inside
of them. When you get busy with multiple chroots running, and multiple shells
into them, it can become kind of hard knowing *when* and *how* to dismantle
these setups when you're done with a given chroot. This is especially difficult
when you need to discard a chroot entirely (there are few things worse than
doing an "rm -fr" on a chroot that still has /dev, /sys, and /proc mounted).

The chroot wrapper (chw) attempts to solve these problems by wrapping the
enabling and disabling of chroots as you use them.

How do I use it?
----------------

Once you have a chroot built (chw will not build chroots for you, it assumes
you already have properly built chroots), you simply use it as root instead of
the "chroot" command:

       chw.sh /some/path/to/the/chroot

The path can be relative or absolute. It can cross filesystem boundaries, and
be any format normally usable by chroot.

Wrap every shell instance you want into your chroot with this command. When you
are done, just "exit" as usual and chw will clean things up for you once every
instance is finished.

The chw script will display logging information to stdout telling you what it
is doing. This can be used as a verification of when the chroot environment
has been setup and cleaned up (even when the cleaning happens after a
different chw instance).

What are the requirements?
--------------------------

You'll need the following things (they should be found on many modern *nixes,
Linux certainly, but possibly Mac OS, who knows? I'd rather fellate an angry
rhino than own a Mac- Yes, I realize that's a dickish thing to say, that was
my intent):

* bash
* mountpoint
* mount / umount
* cat
* shasum
* sed
* date
* sort
* chroot (do I really need to state the obvious?)
* etc...

(really standard stuff you'll find on many *nixes)

How do you install it?
----------------------

Crap, you people really are demanding, aren't you?

Copy the chw.sh script somewhere in your path. If I ever feel a need to make
an installer, I'll add it to the repo (and update this text). But that isn't
looking likely.

Is there any configuration or debugging?
----------------------------------------

Configuration? Nope. It's crazy stupid simple.

Debugging? Well, there's stuff can be found in /tmp/chw_work, but I wouldn't
recommend snooping there (and would advice against modifying anything in there)
unless you know what you're doing.

Frankly, I don't want to document how it works, so if you're curious, look at
the damned code.

Can this be used as a security tool?
------------------------------------

Sure it can. [Just like chroot.](https://lkml.org/lkml/2007/9/26/87)

But seriously, I just use it for development environments. Beyond that, I'd
recommend against using this or chroot for anything remotely resembling a
security purpose.

Are there other limitations?
----------------------------

Probably. There's no locking (and I have no intent to add it any time soon),
so be careful not to launch multiple chw's (or exit multiple ones) at the
**exact** same time. You can run multiple ones at once, of course (that's kind
of the point), but just be sure you stagger their execution a bit.

Honestly, the worst things that will happen if you don't stagger them a bit
will be chroots not properly setup or torn down, and chw work environment
artifacts (e.g., worst case scenario shouldn't be *too* bad, provided you don't
do something really stupid elsewhere).

Also, chw kind of assumes bash will be in the chroot (it adds crap to a
.bashrc in there). It probably would work without it, however, as it'll just
leave a file in there that wont be used.

Use at your own risk, and be smart about it. Obviously, there's no warranty or
protection against the user using the script incorrectly.
