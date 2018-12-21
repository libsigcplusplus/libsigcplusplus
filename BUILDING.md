Building
--------

You can choose to build this library either with `autotools` or `cmake`.
The pre-requisite for compilations are:

- you should have cloned this repository with `git clone https://github.com/libsigcplusplus/libsigcplusplus.git`
- you should have a modern version of `autotools` (>= 2.59) or `cmake` (>= 3.0.2) depending on your preference

## autotools

When using the `autotools` option also make sure that you have [mm-common](https://github.com/GNOME/mm-common) installed.

To build `libsigc++` with `autotools` proceed as follows:

- `cd libsigcpluscplus`
- `./autogen.sh`
- `./configure`
- `make`

This will build the library including test cases. If you wish to use different options consider `./configure --help`

## CMake

To build `libsigc++` with `CMake` proceed as follows:

- `mkdir libsigcplusplus/build`
- `cd libsigcplusplus/build`
- `cmake ..`
- `make`

This will build the library including all its test cases. If you wish to use different options consider `make help`
