!==============================================================================
program main

use param

!------------------------------------------------------------------------------|
!------------------variable declarations---------------------------------------|
!------------------------------------------------------------------------------|

  implicit none
  
  character*80        :: phifile
  character*80        :: xsffile
  integer             :: ifile, n, i
       
  !----------------------------------------------------
  !              The Cuba integration parameters
  !----------------------------------------------------
  integer, parameter  :: ndim=6
  integer, parameter  :: ncomp=1
  
  external   integrand

  real*8              :: integral(ncomp), error(ncomp), prob(ncomp)
  integer             :: nregions, fail
  integer*8           :: neval
  
  !-----------------------------------------------------------------------!
  !                                                                       !
  !-----------------------------------------------------------------------!

  integer             :: time0, time1, corate
  integer             :: tot_time, minutes, seconds
  
  integer             :: step, ii, jj, kk
  real*8              :: x(6), res

!------------------------------------------------------------------------------|
!------------------ MAIN PROGRAM ----------------------------------------------|
!------------------------------------------------------------------------------|

  call read_input(phifile,xsffile)
  call read_phi(phifile)

  call read_xsf(xsffile)
  
! since the integration runs only over "scaled" space x~[0,1]
! one needs to unscale back the integral value
  const=(2.0*nrx+1.0)*(2.0*nry+1.0)*(2.0*nrz+1.0)*volume*volume

! Start time measuring
  call SYSTEM_CLOCK(count=time0, count_rate=corate)

  
!-----------------------
! the main execution block (lldivonne is the Cuba library's routine)

!  call lldivonne(ndim, ncomp, integrand,     &
!    epsrel, epsabs, flags, mineval, maxeval, &
!    key1, key2, key3, maxpass,               &
!    border, maxchisq, mindeviation,          &
!    ngiven, ldxgiven, 0., nextra, 0.,        &
!    nregions, neval, fail, integral, error, prob)

  call lldivonne(ndim, ncomp, integrand, userdata, &
    epsrel, epsabs, flags, seed, mineval, maxeval, &
    key1, key2, key3, maxpass,                     &
    border, maxchisq, mindeviation,                &
    ngiven, ldxgiven, 0., nextra, 0.,              &
    nregions, neval, fail, integral, error, prob)

!-----------------------  

  call SYSTEM_CLOCK(count=time1)

  write(*,*)
  write(*,*) '   ====== RESULTS OF INTEGRATION ======'
  write(*,*) '   nregions =          ', nregions
  write(*,*) '   neval    =          ',    neval
  write(*,*) '   fail     =          ',     fail
  
  write(*,*)
  write(* ,30) integral(1), error, prob
  30 format('   E_nl=',f17.8,'   error=',f14.8,'   p=',f10.3)

! Full integration time
  tot_time = int((time1-time0)/corate)
  minutes = int(tot_time/60.0d0)
  seconds=int(tot_time-minutes*60.0d0)
  write(*,*)
  write(*,*) '  Execution time: ', minutes, ' min', seconds, 'sec'
  write(*,*)
  
  call delete_arrays()

!------------------------------------------------------------------------------|   
end program
!------------------------------------------------------------------------------|
