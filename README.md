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
you already have properly built chroots), you simply use it instead of the
"chroot" command:

       chw.sh /some/path/to/the/chroot

The path can be relative or absolute. It can cross filesystem boundaries, and
be any format normally usable by chroot.

Wrap every shell instance you want into your chroot with this command. When you
are done, just "exit" as usual and chw will clean things up for you once every
instance is finished.
