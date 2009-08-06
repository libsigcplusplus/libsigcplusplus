#! /bin/sh -e
test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

mm-common-prepare --force --copy "$srcdir"
autoreconf --force --install "$srcdir"
test -n "$NOCONFIGURE" || "$srcdir/configure" --enable-maintainer-mode "$@"
