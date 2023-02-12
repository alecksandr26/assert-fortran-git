#ifndef __ASSERT_FORTRAN_H__
#define __ASSERT_FORTRAN_H__

#define assert(cond) call assertion(cond, "cond", __FILE__, __LINE__)

#endif
