#!/bin/bash

# Compile each header file, one at a time.
# The compiler will notice if a header file does not include all other header
# files that it depends on.

# Compiler, default: CXX=g++
if test "x$CXX" = x
then
  CXX=g++
fi

# Extra compiler flags, default: CXXFLAGS=-std=c++17
if test "x$CXXFLAGS" = x
then
  CXXFLAGS=-std=c++17
fi

# Directories to include in CFLAGS.
idirs="-I."

# Package name
pkg=sigc++-3.0

CFLAGS="$idirs `pkg-config --cflags $pkg`"
if [ $? -ne 0 ]
then
  echo "pkg-config failed"
  exit 1
fi
echo CXX=$CXX, CXXFLAGS=$CXXFLAGS
echo CFLAGS=$CFLAGS

# Compile the header files
for headerfile in sigc++/*.h sigc++/*/*.h
do
  echo "=== $headerfile"
  $CXX -c -x c++ $CXXFLAGS -o /dev/null $headerfile $CFLAGS
done
