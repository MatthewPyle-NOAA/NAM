MODULE MODULE_GOCART_SEASALT

CONTAINS
  subroutine gocart_seasalt_driver(ktau,dt,alt,t_phy,moist,u_phy,  &
         v_phy,chem,rho_phy,dz8w,u10,v10,p8w,                  &
         xland,xlat,xlong,area,g,emis_seas, &
         seashelp,num_emis_seas,num_moist,num_chem,  &
         ids,ide, jds,jde, kds,kde,                                        &
         ims,ime, jms,jme, kms,kme,                                        &
         its,ite, jts,jte, kts,kte                                         )
  USE module_initial_chem_namelists
! USE module_configure
! USE module_state_description
! USE module_model_constants, ONLY: mwdry
! IMPLICIT NONE
!  TYPE(grid_config_rec_type),  INTENT(IN   )    :: config_flags

   INTEGER,      INTENT(IN   ) :: ktau,num_emis_seas,num_moist,num_chem,   &
                                  ids,ide, jds,jde, kds,kde,               &
                                  ims,ime, jms,jme, kms,kme,               &
                                  its,ite, jts,jte, kts,kte
   REAL, DIMENSION( ims:ime, kms:kme, jms:jme, num_moist ),                &
         INTENT(IN ) ::                                   moist
   REAL, DIMENSION( ims:ime, kms:kme, jms:jme, num_chem ),                 &
         INTENT(INOUT ) ::                                   chem
   REAL, DIMENSION( ims:ime, 1, jms:jme,num_emis_seas),OPTIONAL,&
         INTENT(INOUT ) ::                                                 &
         emis_seas
   REAL,  DIMENSION( ims:ime , jms:jme )                   ,               &
          INTENT(IN   ) ::                                                 &
                                                     u10,                  &
                                                     v10,                  &
                                                     xland,                &
                                                     xlat,                 &
                                                     xlong,area
   REAL,  DIMENSION( ims:ime , jms:jme ),                        &
          INTENT(OUT   ) :: seashelp
   REAL,  DIMENSION( ims:ime , kms:kme , jms:jme ),                        &
          INTENT(IN   ) ::                                                 &
                                                        alt,               &
                                                      t_phy,               &
                                                     dz8w,p8w,             &
                                              u_phy,v_phy,rho_phy

  REAL, INTENT(IN   ) :: dt,g
!
! local variables
!
  integer :: ipr,nmx,i,j,k,ndt,imx,jmx,lmx
  integer,dimension (1,1) :: ilwi
  real*8, DIMENSION (4) :: tc,bems
  real*8, dimension (1,1) :: w10m,gwet,airden,airmas
  real*8, dimension (1) :: dxy
  real*8 conver,converi
  conver=1.d-9
  converi=1.d9
!
! number of dust bins
!
  imx=1
  jmx=1
  lmx=1
  nmx=4
  k=kts
! p_seas_1=1
! p_seas_2=2
! p_seas_3=3
! p_seas_4=4
!    write(6,*)'call seasalt'
  if(chem_opt == 304 .or. chem_opt == 316 .or. chem_opt == 317) then
  seashelp(:,:)=0.
  do j=jts,jte
  do i=its,ite
!
! don??? do dust over water!!!
!
     if(xland(i,j).lt.0.5)then
     ilwi(1,1)=0
     tc(1)=chem(i,kts,j,p_seas_1)*conver
     tc(2)=1.d-30
     tc(3)=chem(i,kts,j,p_seas_2)*conver
     tc(4)=1.d-30
     w10m(1,1)=sqrt(u10(i,j)*u10(i,j)+v10(i,j)*v10(i,j))
     airmas(1,1)=-(p8w(i,kts+1,j)-p8w(i,kts,j))*area(i,j)/g
!
! we don??? trust the u10,v10 values, is model layers are very thin near surface
!
     if(dz8w(i,kts,j).lt.12.)w10m=sqrt(u_phy(i,kts,j)*u_phy(i,kts,j)+v_phy(i,kts,j)*v_phy(i,kts,j))
!
     dxy(1)=area(i,j)
       ipr=0

!    if(j.eq.2478)write(6,*)'call seasalt ',w10m(1,1),airmas(1,1),tc(1),tc(2)
    call source_ss( imx,jmx,lmx,nmx, dt, tc,ilwi, dxy, w10m, airmas, bems,ipr)
!    if(j.eq.2558)write(6,*)'call seasalt after',tc(1),tc(2),bems(1)
!    write(6,*)'call seasalt after',tc(1),tc(2),bems(1)
     chem(i,kts,j,p_seas_1)=(tc(1)+.75*tc(2))*converi
     chem(i,kts,j,p_seas_2)=(tc(3)+.25*tc(2))*converi
     seashelp(i,j)=tc(2)*converi
! for output diagnostics
!    emis_seas(i,1,j,p_seas_1)=bems(1)
!    emis_seas(i,1,j,p_seas_2)=bems(2)
!    emis_seas(i,1,j,p_seas_3)=bems(3)
     endif
  enddo
  enddo
  else
  do j=jts,jte
  do i=its,ite
!
! don??? do dust over water!!!
!
     if(xland(i,j).lt.0.5)then
     ilwi(1,1)=0
     tc(1)=chem(i,kts,j,p_seas_1)*conver
     tc(2)=chem(i,kts,j,p_seas_2)*conver
     tc(3)=chem(i,kts,j,p_seas_3)*conver
     tc(4)=chem(i,kts,j,p_seas_4)*conver
     w10m(1,1)=sqrt(u10(i,j)*u10(i,j)+v10(i,j)*v10(i,j))
     airmas(1,1)=-(p8w(i,kts+1,j)-p8w(i,kts,j))*area(i,j)/g
!
! we don??? trust the u10,v10 values, is model layers are very thin near surface
!
     if(dz8w(i,kts,j).lt.12.)w10m=sqrt(u_phy(i,kts,j)*u_phy(i,kts,j)+v_phy(i,kts,j)*v_phy(i,kts,j))
!
     dxy(1)=area(i,j)
       ipr=0

!    if(j.eq.2478)write(6,*)'call seasalt ',w10m(1,1),airmas(1,1),tc(1),tc(2)
    call source_ss( imx,jmx,lmx,nmx, dt, tc,ilwi, dxy, w10m, airmas, bems,ipr)
!    if(j.eq.2558)write(6,*)'call seasalt after',tc(1),tc(2),bems(1)
!    write(6,*)'call seasalt after',tc(1),tc(2),bems(1)
     chem(i,kts,j,p_seas_1)=tc(1)*converi
     chem(i,kts,j,p_seas_2)=tc(2)*converi
     chem(i,kts,j,p_seas_3)=tc(3)*converi
     chem(i,kts,j,p_seas_4)=tc(4)*converi
! for output diagnostics
!    emis_seas(i,1,j,p_edust1)=bems(1)
!    emis_seas(i,1,j,p_edust2)=bems(2)
!    emis_seas(i,1,j,p_edust3)=bems(3)
!    emis_seas(i,1,j,p_edust4)=bems(4)
     endif
  enddo
  enddo
  endif
!

end subroutine gocart_seasalt_driver
!
SUBROUTINE source_ss(imx,jmx,lmx,nmx, dt1, tc, &
                     ilwi, dxy, w10m, airmas, &
                     bems,ipr)

! ****************************************************************************
! *  Evaluate the source of each seasalt particles size classes  (kg/m3) 
! *  by soil emission.
! *  Input:
! *         SSALTDEN  Sea salt density                               (kg/m3)
! *         DXY       Surface of each grid cell                     (m2)
! *         NDT1      Time step                                     (s)
! *         W10m      Velocity at the anemometer level (10meters)   (m/s)
! *      
! *  Output:
! *         DSRC      Source of each sea salt bins       (kg/timestep/cell) 
! *
! *
! * Number flux density: Original formula by Monahan et al. (1986) adapted
! * by Sunling Gong (JGR 1997 (old) and GBC 2003 (new)).  The new version is
! * to better represent emission of sub-micron sea salt particles.
!
! * dFn/dr = c1*u10**c2/(r**A) * (1+c3*r**c4)*10**(c5*exp(-B**2))
! * where B = (b1 -log(r))/b2
! * see c_old, c_new, b_old, b_new below for the constants.
! * number fluxes are at 80% RH.
! *
! * To calculate the flux:
! * 1) Calculate dFn based on Monahan et al. (1986) and Gong (2003)
! * 2) Assume that wet radius r at 80% RH = dry radius r_d *frh
! * 3) Convert particles flux to mass flux :
! *    dFM/dr_d = 4/3*pi*rho_d*r_d^3 *(dr/dr_d) * dFn/dr
! *             = 4/3*pi*rho_d*r_d^3 * frh * dFn/dr
! *               where rho_p is particle density [kg/m3]
! *    The factor 1.e-18 is to convert in micro-meter r_d^3
! ****************************************************************************
 

  USE module_data_gocart_seas

  IMPLICIT NONE

  INTEGER, INTENT(IN)    :: nmx,imx,jmx,lmx,ipr
  INTEGER, INTENT(IN)    :: ilwi(imx,jmx)
  REAL*8,    INTENT(IN)    :: dxy(jmx), w10m(imx,jmx)
  REAL*8,    INTENT(IN)    :: airmas(imx,jmx,lmx)
  REAL*8,    INTENT(INOUT) :: tc(imx,jmx,lmx,nmx)
  REAL*8,    INTENT(OUT)   :: bems(imx,jmx,nmx)

  REAL*8 :: c0(5), b0(2)
!  REAL*8, PARAMETER :: c_old(5)=(/1.373, 3.41, 0.057, 1.05, 1.190/) 
!  REAL*8, PARAMETER :: c_new(5)=(/1.373, 3.41, 0.057, 3.45, 1.607/)
  ! Change suggested by MC
  REAL*8, PARAMETER :: c_old(5)=(/1.373, 3.2, 0.057, 1.05, 1.190/) 
  REAL*8, PARAMETER :: c_new(5)=(/1.373, 3.2, 0.057, 3.45, 1.607/)
  REAL*8, PARAMETER :: b_old(2)=(/0.380, 0.650/)
  REAL*8, PARAMETER :: b_new(2)=(/0.433, 0.433/)
  REAL*8, PARAMETER :: dr=5.0D-2 ! um   
  REAL*8, PARAMETER :: theta=30.0
  ! Swelling coefficient frh (d rwet / d rd)
!!!  REAL*8,    PARAMETER :: frh = 1.65
  REAL*8,    PARAMETER :: frh = 2.d0
  LOGICAL, PARAMETER :: old=.TRUE., new=.FALSE.
  REAL*8 :: rho_d, r0, r1, r, r_w, a, b, dfn, r_d, dfm, src
  INTEGER :: i, j, n, nr, ir
  REAL :: dt1,fudge_fac


  REAL*8                  :: tcmw(nmx), ar(nmx), tcvv(nmx)
  REAL*8                  :: ar_wetdep(nmx), kc(nmx)
  CHARACTER(LEN=20)     :: tcname(nmx), tcunits(nmx)
  LOGICAL               :: aerosol(nmx)


  REAL*8 :: tc1(imx,jmx,lmx,nmx)
  REAL*8, TARGET :: tcms(imx,jmx,lmx,nmx) ! tracer mass (kg; kgS for sulfur case)
  REAL*8, TARGET :: tcgm(imx,jmx,lmx,nmx) ! g/m3

  !-----------------------------------------------------------------------  
  ! sea salt specific
  !-----------------------------------------------------------------------  
! REAL*8, DIMENSION(nmx) :: ra, rb
! REAL*8 :: ch_ss(nmx,12)

  !-----------------------------------------------------------------------  
  ! emissions (input)
  !-----------------------------------------------------------------------  
  REAL*8 :: e_an(imx,jmx,2,nmx), e_bb(imx,jmx,nmx), &
          e_ac(imx,jmx,lmx,nmx)

  !-----------------------------------------------------------------------  
  ! diagnostics (budget)
  !-----------------------------------------------------------------------
!  ! tendencies per time step and process
!  REAL*8, TARGET :: bems(imx,jmx,nmx), bdry(imx,jmx,nmx), bstl(imx,jmx,nmx)
!  REAL*8, TARGET :: bwet(imx,jmx,nmx), bcnv(imx,jmx,nmx)!

!  ! integrated tendencies per process
!  REAL*8, TARGET :: tems(imx,jmx,nmx), tstl(imx,jmx,nmx)
!  REAL*8, TARGET :: tdry(imx,jmx,nmx), twet(imx,jmx,nmx), tcnv(imx,jmx,nmx)

  ! global mass balance per time step 
  REAL*8 :: tmas0(nmx), tmas1(nmx)
  REAL*8 :: dtems(nmx), dttrp(nmx), dtdif(nmx), dtcnv(nmx)
  REAL*8 :: dtwet(nmx), dtdry(nmx), dtstl(nmx)
  REAL*8 :: dtems2(nmx), dttrp2(nmx), dtdif2(nmx), dtcnv2(nmx)
  REAL*8 :: dtwet2(nmx), dtdry2(nmx), dtstl2(nmx)

  ! detailed integrated budgets for individual emissions
  REAL*8, TARGET :: ems_an(imx,jmx,nmx),    ems_bb(imx,jmx,nmx), ems_tp(imx,jmx)
  REAL*8, TARGET :: ems_ac(imx,jmx,lmx,nmx)
  REAL*8, TARGET :: ems_co(imx,jmx,nmx)


  ! executable statements
! decrease seasalt emissions (Colarco et al. 2010)
!
  fudge_fac= 1. !.5
!
  DO n = 1,nmx
!    if(ipr.eq.1)write(0,*)'in seasalt',n,ipr,ilwi
     bems(:,:,n) = 0.0
     rho_d = den_seas(n)
     r0 = ra(n)*frh
     r1 = rb(n)*frh
     r = r0
     nr = INT((r1-r0)/dr+.001)
!    if(ipr.eq.1.and.n.eq.1)write(0,*)'in seasalt',nr,r1,r0,dr,rho_d
     DO ir = 1,nr
        r_w = r + dr*0.5
        r = r + dr
        IF (new) THEN
           a = 4.7*(1.0 + theta*r_w)**(-0.017*r_w**(-1.44))
           c0 = c_new
           b0 = b_new
        ELSE
           a = 3.0
           c0 = c_old
           b0 = b_old
        END IF
        !
        b = (b0(1) - LOG10(r_w))/b0(2)
        dfn = (c0(1)/r_w**a)*(1.0 + c0(3)*r_w**c0(4))* &
             10**(c0(5)*EXP(-(b**2)))
        
        r_d = r_w/frh*1.0D-6  ! um -> m
        dfm = 4.0/3.0*pi*r_d**3*rho_d*frh*dfn*dr*dt1 ! 3600 !dt1
        DO i = 1,imx
           DO j = 1,jmx
!              IF (water(i,j) > 0.0) THEN
              IF (ilwi(i,j) == 0) THEN
!                 src = dfm*dxy(j)*water(i,j)*w10m(i,j)**c0(2)
                 src = dfm*dxy(j)*w10m(i,j)**c0(2)
!                 src = ch_ss(n,dt(1)%mn)*dfm*dxy(j)*w10m(i,j)**c0(2)
                 tc(i,j,1,n) = tc(i,j,1,n) + fudge_fac*src/airmas(i,j,1)
!                if(ipr.eq.1)write(0,*)n,dfm,c0(2),dxy(j),w10m(i,j),src,airmas(i,j,1)
              ELSE
                 src = 0.0
              END IF
              bems(i,j,n) = bems(i,j,n) + src*fudge_fac
           END DO  ! i
        END DO ! j
     END DO ! ir
  END DO ! n

END SUBROUTINE source_ss
END MODULE MODULE_GOCART_SEASALT
