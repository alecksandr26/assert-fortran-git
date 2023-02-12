module assertf
    implicit none
    
contains
    subroutine assertion(cond, expr, file, line)
        implicit none
        
        logical, intent(in) :: cond
        character(len = *), intent(in) :: expr, file
        integer, intent(in) :: line

        if (.not. cond) then
            ! Print the information
            write (*, '(A, ":", I0, ": failed assertion `", A, "`")') file, line, expr
            call abort()       ! Abort the program if the assertion is not true
        end if
    end subroutine assertion
end module assertf
