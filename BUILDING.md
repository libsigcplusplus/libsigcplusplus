Building
--------

You can choose to build this library either with `cmake` or `automake`.
The pre-requisite for compilations are:

- you should have cloned this repository with `git clone https://github.com/libsigcplusplus/libsigcplusplus.git`
- you should have a modern version of `cmake` or `automake` depending on your preference
- either GCC or Clang should be installed with a version that supports at least `C++17`

## CMake

To build `libsigc++` with `CMake` proceed as follows:

- `cd libsigcplusplus/build`
- `cmake ..`
- `make`

This will build the library including all it's test cases. If you wish to use different options consider `make help`

## automake
