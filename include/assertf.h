#ifndef ASSERT_FORTRAN_INCLUDED
#define ASSERT_FORTRAN_INCLUDED

#define assert(cond) call assertion(cond, "cond", __FILE__, __LINE__)

#endif
