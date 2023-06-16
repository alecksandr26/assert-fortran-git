! To compile this example just run the code like this 
! gfortran -cpp installed.f90 -I/usr/include -lassertf
#include <assertf.h>

program installed
  use assertf
  implicit none

  integer :: n1 = 1, n2 = 2
  integer :: res

  res = n1 + n2
  assert(res == 4)            ! Pass this assertion
end program installed

