
! To make it easy to use assert is necessary to create a macro function
#define assert(cond) call assertion(cond, "cond", __FILE__, __LINE__)

program test_assert
    use assert
    implicit none
    
    integer, parameter :: n1 = 1, n2 = 2
    integer :: res

    res = n1 + n2
    assert(res == 3)            ! Pass this assertion
end program test_assert

    

    
