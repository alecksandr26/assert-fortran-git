# Fortran Assertion Module
Assertion module for gfortran, It is a simple module which adds an assertion function, It works by enabling the [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives in the fortran compiler, many fotrans compilers have this functionality.
# Install
Before installing make sure that you have these dependencies to be able to compile the project.
1. [ar](https://man.archlinux.org/man/ar.1.en)
2. [make](https://man.archlinux.org/man/make.1)
3. [ranlib](https://man.archlinux.org/man/ranlib.1)
4. [gfortran](https://man.archlinux.org/man/gfortran.1)
Now to install the dependency you only will need to run the makefile like this.
```
make install -B
```
The `-B` flag is needed to be able to re compile everything.
# Getting started
