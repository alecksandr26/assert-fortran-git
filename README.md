## Table of Contents
* [Description](#assert-fortranassert-fortran-git)
* [To install](#to-install)
  * [Installation with yay](#installation-with-yay)
  * [Installation from AUR](#installation-from-aur)
  * [Installation from source](#installation-from-source)
* [Getting Started](#getting-started)
* [Examples](#examples)

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
```shell
git clone https://aur.archlinux.org/assert-fortran-git.git
cd assert-fortran-git
makepkg -si
```
## Installation from source
Before installing make sure that you have these dependencies to be able to compile the project:
1. [ar](https://man.archlinux.org/man/ar.1.en)
2. [make](https://man.archlinux.org/man/make.1)
3. [ranlib](https://man.archlinux.org/man/ranlib.1)
4. [gfortran](https://man.archlinux.org/man/gfortran.1)

You can download the latest [realese](https://github.com/alecksandr26/assert-fortran-git/releases) of the project, then you can build a linux pacakge with souce code locally, by running:
```shell
make pkg
```
Then the library is packaged and ready to be install, depending on your distro of linux and your pacakge manager you maybe will need to execute another commands but in arch:
```shell
sudo pacamn -U assert-fortran-git-.x.y.z-a.x86_64.pkg.tar.zst
```

# Getting Started
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

