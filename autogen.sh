#! /bin/sh

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="sigc++"

echo "Adding libtools."
libtoolize --automake --copy --force

echo "Building macros."
aclocal  -I "$srcdir/scripts" $ACLOCAL_FLAGS

#echo "Building config header."
#autoheader

echo "Building makefiles."
automake --add-missing --copy

echo "Building configure."
autoconf

rm -f config.cache

if test -z "$AUTOGEN_SUBDIR_MODE"; then

    echo "Running configure."
    ./configure --enable-maintainer-mode "$@"
    echo
    echo 'run "make"'
    echo
else
    echo
    echo 'run "./configure ; make"'
    echo
fi

