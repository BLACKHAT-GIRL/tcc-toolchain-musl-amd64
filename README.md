# TCC Portable musl amd64 Toolchain

This repository contains a portable Tiny C Compiler toolchain for Linux
amd64 systems. It includes the TCC compiler, the musl C runtime and the
headers and runtime objects required to build standalone C programs.

## Features

- x86_64/amd64 Linux target
- Static musl binaries with no ELF interpreter
- Dynamic shared objects with `-fPIC -shared`
- No system-wide installation required
- Optional installation through the included `Makefile`

## Usage without installation

From the toolchain directory:

```sh
./bin/tcc -static -o hello hello.c
./hello
```

To compile a shared object:

```sh
./bin/tcc -fPIC -shared -o libexample.so example.c
```

## Installation

```sh
make install
source ~/.bashrc
```

The default installation directory is `/opt/tcc-toolchain-amd64`. To remove
it and its PATH entry:

```sh
make uninstall
```

This is a compiler toolchain for standalone C programs; it is not intended to
replace a complete GCC/LLVM system toolchain or provide a complete Linux
sysroot.

## Credits

Maintained and packaged by Michele Corrêa.

Contact: michele@blackhat.lat
