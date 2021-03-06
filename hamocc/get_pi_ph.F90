      SUBROUTINE GET_PI_PH(kpie,kpje,kpke,omask,path)
!**********************************************************************

      USE mo_carbch
      USE mo_control_bgc
      use mo_param1_bgc 
      use netcdf
      USE mod_xc 

      implicit none
      INTEGER :: kpie,kpje,kpke,i,j,k,l
  
      REAL ::omask(kpie,kpje)
      character*(*) path

! define the fields

      REAL :: pi_ph_in(kpie,kpje,12)

      INTEGER ncid,ncstat,ncvarid
!
! Open netCDF data file
!      
       IF(mnproc==1) THEN
        ncstat = NF90_OPEN(trim(path)//'MONTHLY_PI_PH.nc',   &
     &                   NF90_NOWRITE, ncid)
        write(io_stdo_bgc,*) 'HAMOCC: opening MONTHLY_PI_PH file'
        IF (ncstat.NE.NF90_NOERR ) THEN
         CALL xchalt('(get_pi_ph: Problem with netCDF1)')
                stop '(get_pi_ph: Problem with netCDF1)'
        END IF
       END IF
!
! Read  data
       call read_netcdf_var(ncid,'pH',pi_ph_in(1,1,1),12,0,0)

!
! Close file
       IF(mnproc==1) THEN
        ncstat = NF90_CLOSE(ncid)
        IF ( ncstat .NE. NF90_NOERR ) THEN
         CALL xchalt('(get_pi_ph: Problem with netCDF200)')
                stop '(get_pi_ph: Problem with netCDF200)'
        END IF
       END IF

! set missings over land
      do l=1,12
        do j=1,kpje
          do i=1,kpie
            if(omask(i,j).gt.0.5) then 
              pi_ph(i,j,l) = pi_ph_in(i,j,l)
            else 
              pi_ph(i,j,l) = 0.
            endif    
          enddo
         enddo
      enddo

      RETURN
      END
