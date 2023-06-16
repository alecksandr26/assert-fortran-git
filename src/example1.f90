#include "../include/assertf.h"

program example
  use assertf

  integer :: sum = 0, i

  do concurrent (i = 1:100)
     sum = i + sum
  end do

  assert(sum == 5050)
end program example

  
