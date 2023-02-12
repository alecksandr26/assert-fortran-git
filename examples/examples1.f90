! To compile the example just run the code like this 
! gfortran -cpp examples1.f90 -I/usr/include -lassert  
#include <assertf.h>

program test_assert
    use assert
    implicit none
    
    integer, parameter :: n1 = 1, n2 = 2
    integer :: res

    res = n1 + n2
    assert(res == 3)            ! Pass this assertion
end program test_assert
