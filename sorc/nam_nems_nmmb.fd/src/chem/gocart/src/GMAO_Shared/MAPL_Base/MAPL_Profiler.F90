
!  $Id: MAPL_Profiler.F90,v 1.7.12.2 2013-05-30 17:57:31 atrayano Exp $ 

#include "MAPL_ErrLog.h"

!BOP

! !MODULE: MAPL_Profiler -- A Module to instrument codes for profiling


! !INTERFACE:

  module MAPL_ProfMod

! !USES:

  use ESMF
  use MAPL_BaseMod
  use MAPL_IOMod
#ifdef _CUDA
  use cudafor
#endif

  implicit none
  private

! !PUBLIC TYPES:

  type, public :: MAPL_Prof
    private
    character(len=ESMF_MAXSTR) :: NAME=""
    integer        :: START_TIME
    real  (kind=8) :: CUMM_TIME   
  end type MAPL_Prof

! !PUBLIC MEMBER FUNCTIONS:

  public MAPL_ProfClockOn
  public MAPL_ProfClockOff
  public MAPL_ProfSet
  public MAPL_ProfDisable
  public MAPL_ProfEnable
  public MAPL_ProfWrite
  public MAPL_ProfIsDisabled

!EOP

  type(ESMF_VM), save :: VM
  integer,       save :: COUNT_MAX, COUNT_RATE
  real(kind=8),  save :: CRI
  logical,       save :: FIRSTTIME = .true.
  logical,       save :: DISABLED  = .false.

  contains

!********************************************************
    logical function MAPL_ProfIsDisabled()
      MAPL_ProfIsDisabled = DISABLED

    end function MAPL_ProfIsDisabled

!********************************************************

    subroutine MAPL_ProfClockOn(TIMES, NAME, RC)
      type (MAPL_Prof),  intent(INOUT) :: TIMES(:)
      character(len=*),  intent(IN   ) :: NAME      
      integer, optional, intent(OUT  ) :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfClockOn"

      type(ESMF_VM) :: VMC
      integer :: I, NN
      integer :: status

      if(.not.DISABLED) then

         NN = size(TIMES)

         I=1
         do while (I<=NN)
            if(TIMES(I)%NAME==NAME) then
               exit
            endif
            I=I+1
         enddo

         if(I==NN+1) then
            print *, NAME
            RETURN_(ESMF_FAILURE)
         end if
     
#ifdef _CUDA
         status = cudaDeviceSynchronize()
#endif

#ifdef NEMS
          call ESMF_VMGetCurrent(VMC, rc=STATUS)
          call ESMF_VMBarrier(VMC, rc=status)
#else
         call ESMF_VMBarrier(VM, rc=status)
#endif

         call SYSTEM_CLOCK(TIMES(I)%START_TIME)  

      end if

      RETURN_(ESMF_SUCCESS)
    
    end subroutine MAPL_ProfClockOn

!********************************************************

    subroutine MAPL_ProfClockOff(TIMES, NAME, RC)
      type (MAPL_Prof),  intent(INOUT) :: TIMES(:)
      character(len=*),  intent(IN   ) :: NAME
      integer, optional, intent(OUT  ) :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfClockOff"

      type(ESMF_VM) :: VMC
      integer :: COUNTS
      integer :: I, NN
      integer :: status

      if(.not.DISABLED) then

         NN = size(TIMES)

         I=1
         do while (I<=NN)
            if(TIMES(I)%NAME==NAME) then
               exit
            endif
            I=I+1
         enddo

         if(I>NN) then
            print *, NAME
            RETURN_(ESMF_FAILURE)
         end if

#ifdef _CUDA
         status = cudaDeviceSynchronize()
#endif

#ifdef NEMS
         call ESMF_VMGetCurrent(VMC, rc=STATUS)
         call ESMF_VMBarrier(VMC, rc=status)
#else
         call ESMF_VMBarrier(VM, rc=status)
#endif
         call SYSTEM_CLOCK(COUNTS)

         COUNTS = COUNTS-TIMES(I)%START_TIME

         if(COUNTS<0) then
            COUNTS = COUNTS + COUNT_MAX
         endif

         TIMES(I)%CUMM_TIME = TIMES(I)%CUMM_TIME + real(COUNTS,kind=8)*CRI

      end if

      RETURN_(ESMF_SUCCESS)

      
    end subroutine MAPL_ProfClockOff

!********************************************************

    subroutine MAPL_ProfSet(TIMES, NAME, RC)
      type (MAPL_Prof),  pointer       :: TIMES(:)
      character(len=*),  intent(IN   ) :: NAME
      integer, optional, intent(OUT  ) :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfSet"
      type (MAPL_Prof), pointer :: TMP(:)
      integer :: I, STATUS
      integer :: ndes

      if (FIRSTTIME) then
         FIRSTTIME = .false.
#ifdef NEMS
         call ESMF_VMGetCurrent(VM, rc=STATUS)
         call ESMF_VmGet(VM, petCount=ndes, rc=status)
#else
         call ESMF_VMGetGlobal(VM, rc=STATUS)
#endif
         VERIFY_(STATUS)
         call SYSTEM_CLOCK(COUNT_RATE=COUNT_RATE,COUNT_MAX=COUNT_MAX)
         CRI = 1._8/real(COUNT_RATE,kind=8)
      end if

      if (.not.associated(TIMES)) then
         I = 0
      else
         I = size(TIMES)
      endif

      allocate(TMP(I+1))
      if(associated(TIMES)) then
         TMP(1:I) = TIMES
         deallocate(TIMES)
      endif
      TMP(I+1) = MAPL_Prof(trim(NAME),0,0.D0)
      TIMES => TMP

      RETURN_(ESMF_SUCCESS)
      
    end subroutine MAPL_ProfSet

!********************************************************

    subroutine MAPL_ProfWrite(TIMES, RC)
      type (MAPL_Prof),  pointer       :: TIMES(:)
      integer, optional, intent(OUT)   :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfWrite"
      integer :: I

      if (associated(TIMES)) then
         do I=1,size(TIMES)
            if(trim(TIMES(I)%name)=='TOTAL') then
               call WRITE_PARALLEL(TIMES(I)%CUMM_TIME,format='("'//TIMES(I)%NAME(1:24)//':",F12.3)')
               exit
            end if
         enddo
         do I=1,size(TIMES)
            if(trim(TIMES(I)%name)=='TOTAL') then
               cycle
            else
               call WRITE_PARALLEL(TIMES(I)%CUMM_TIME,format='("'//TIMES(I)%NAME(1:24)//':",F12.3)')
            end if
         enddo
      end if

      RETURN_(ESMF_SUCCESS)
      
    end subroutine MAPL_ProfWrite

!********************************************************

    subroutine MAPL_ProfDisable(RC)
      integer, optional, intent(OUT)   :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfDisable"

      DISABLED = .true.

      RETURN_(ESMF_SUCCESS)
      
    end subroutine MAPL_ProfDisable

!********************************************************

    subroutine MAPL_ProfEnable(RC)
      integer, optional, intent(OUT)   :: RC

      character(len=ESMF_MAXSTR), parameter :: IAm="MAPL_ProfEnable"

      DISABLED = .false.

      RETURN_(ESMF_SUCCESS)
      
    end subroutine MAPL_ProfEnable

!********************************************************


  end module MAPL_ProfMod

