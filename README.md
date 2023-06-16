## Table of Contents
* [Description](https://github.com/alecksandr26/assert-fortran-git#assert-fortran-git)
* [Install](#Install)
  * [Installation-with-yay](#Installation-with-yay)
  * [Installation-from-source](#Installation-from-source)
* [Getting-Started](#Getting-Started)
* [Examples](#Examples)

# Assert Fortran(assert-fortran-git)
Assertion module for gfortran, It is a simple module which adds an assertion function, It works by enabling `-cpp` the [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives in the fortran compiler, many fotrans compilers have this functionality.
# To install
## Installation with yay
If you have yay installed, just run this command.
```
yay -S assert-fortran-git
```
## Installation from AUR
This is the [link](https://aur.archlinux.org/packages/assert-fortran-git) of the repo in AUR, then with git you can install the module, just run these two commands.
```
git clone https://aur.archlinux.org/assert-fortran-git.git
cd assert-fortran-git
makepkg -si
```
## Installation from source
Before installing make sure that you have these dependencies to be able to compile the project.
1. [ar](https://man.archlinux.org/man/ar.1.en)
2. [make](https://man.archlinux.org/man/make.1)
3. [ranlib](https://man.archlinux.org/man/ranlib.1)
4. [gfortran](https://man.archlinux.org/man/gfortran.1)

You can download the latest [realese](https://github.com/alecksandr26/Fortran-Assertion-Module/releases) of the project, then to install the dependency you only will need to run the makefile with these flags.
```
make install
```
The `.mod` file should be installed in `/usr/include/` and the `.a` file should be installed in
`/usr/lib/` and obviously, this operation will require sudo permission.
If you want to do it manually, you will find the `.mod` file and `.a` file in the `build/` directory.
# Getting-Started
As I said before this module works by enabling `-cpp` the [c preprocesor](https://gcc.gnu.org/onlinedocs/gfortran/Preprocessing-Options.html) directives,
then inside of the module where you want to make assertions, you only need to include the header file `assertf.h`, thats why you need the flag `-cpp`.
```
#include <assertf.h>
```
Then to compile the modules or the program, you need to set these flags.
```
gfortran -cpp your-program.f90 -I/usr/include -lassert
```
The `-lassert` refers to the `.a` library and the `-I/usr/include` is needed to be able to include the `assert` module and `assertf.h` header. 

# Examples
## Picture Example
This is an example of a failed assertion.

![image](https://user-images.githubusercontent.com/66882463/228629260-d76c09a4-b787-4b41-9295-ec9b098e66cf.png)

![image](https://user-images.githubusercontent.com/66882463/228629376-8e8fdd24-a885-4860-b306-9f0a86208804.png)
## Video Example

https://user-images.githubusercontent.com/66882463/228629987-9694fcaf-a9d1-42c1-b209-48696e1edfd9.mp4

