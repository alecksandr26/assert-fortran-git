
#include "../../include/assertf.h"

program test_assert
    use assertf
    implicit none
    
    integer, parameter :: n1 = 1, n2 = 2
    integer :: res

    res = n1 + n2
    assert(res == 3)            ! Pass this assertion
end program test_assert
    
