# Table of Contents
1. [Description](#Description)
2. [Install](#Install)
3. [Getting-Started](#Getting-Started)
4. [Examples](#Examples)

# Description
Assertion module for gfortran, It is a simple module which adds an assertion function, It works by enabling `-cpp` the [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives in the fortran compiler, many fotrans compilers have this functionality.
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
The `-B` flag is needed to be able to re compile everything, the `.mod` file should be installed in `/usr/include/` and the `.a` file should be installed in
`/usr/lib/` and obviously, this operation will require sudo permission.
If you want to do it manually, you will find the `.mod` file and `.a` file in the `build/` directory.
# Getting-started
As I said before this module works by enabling `-cpp` the [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives,
then inside of the module where you want to make assertions, you only need to write this macro function.
```
#define assert(cond) call assertion(cond, "cond", __FILE__, __LINE__)
```
As you can see it is going to call a subrutine called `assertion`, and with the `-cpp` [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives information, we can have a complete assertion.

Then to compile the modules or the program, you need to set these flags.
```
gfortran -cpp test_assert.f90 -I/usr/include -lassert
```
The `-lassert` refers to the `.a` library and the `-I/usr/include` is needed to be able to include the `assert` module. 

# Examples
## Picture Example
This is an example of a failed assertion.
![image](https://user-images.githubusercontent.com/66882463/208545832-dc47fd2a-bf13-46d5-ad0c-589f57ecf5cd.png)

![image](https://user-images.githubusercontent.com/66882463/208545605-669cbd4d-d686-487b-8cdc-53bbf2d8ef0a.png)
## Video Example
https://user-images.githubusercontent.com/66882463/208544892-f658eb38-eddf-4ec5-88f9-fedc046c41bc.mp4

