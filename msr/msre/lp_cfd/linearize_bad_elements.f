      subroutine linearize_bad_elements(niter_corr)   ! This routine to modify element vertices

c      implicit none

      include 'SIZE'
      include 'TOTAL'

      include "BAD_ELEMENTS"

      integer iter, niter_corr

      minJac = 0.0

      do iter =1,niter_corr
      
	  if (nid.eq.0) write(6,*) 'linearize bad elements, iter: ', iter

      call pre_check_jacobian() 

      call get_bad_element_list()
	  
       do ie = 1,nelt
      
        if (bad_list(ie).gt.0) then
		
         call v8_to_e12(xc(1,ie),yc(1,ie),zc(1,ie),e12)
         do ed = 1,12  ! copy linearized mid-edge point
           curve(1,ed,ie) = e12(1,ed)
           curve(2,ed,ie) = e12(2,ed)
           curve(3,ed,ie) = e12(3,ed)
         enddo

        endif
       enddo
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine linearize_low_jacobian_elements(niter_corr,
     & minScaleJacobian)   ! This routine to modify element vertices

c      implicit none

      include 'SIZE'
      include 'TOTAL'

      include "BAD_ELEMENTS"

      integer iter, niter_corr

      minJac = minScaleJacobian

      do iter =1,niter_corr
      
	  if (nid.eq.0) write(6,*) 'linearize bad elements, iter: ', iter

      call pre_check_jacobian() 

      call get_bad_element_list()
	  
       do ie = 1,nelt
      
        if (bad_list(ie).gt.0) then
		
         call v8_to_e12(xc(1,ie),yc(1,ie),zc(1,ie),e12)
         do ed = 1,12  ! copy linearized mid-edge point
           curve(1,ed,ie) = e12(1,ed)
           curve(2,ed,ie) = e12(2,ed)
           curve(3,ed,ie) = e12(3,ed)
         enddo

        endif
       enddo
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine pre_check_jacobian() 
c 
c 
c      implicit none
      include 'SIZE'
      include 'TOTAL'

      COMMON /SCRUZ/ XM3 (LX3,LY3,LZ3,LELT)
     $ ,             YM3 (LX3,LY3,LZ3,LELT)
     $ ,             ZM3 (LX3,LY3,LZ3,LELT)


       CALL LAGMASS
       CALL GENCOOR (XM3,YM3,ZM3)
       call fix_geom_pre_check() ! ?
       CALL geom1_chk_jac(XM3,YM3,ZM3)

      return
      end
c -----------------------------------------------------------------------
      subroutine geom1_chk_jac (xm3,ym3,zm3)
C
C     Routine to generate all elemental geometric data for mesh 1.
C
C     Velocity formulation : global-to-local mapping based on mesh 3
C     Stress   formulation : global-to-local mapping based on mesh 1
C
C-----------------------------------------------------------------------
      INCLUDE 'SIZE'
      INCLUDE 'GEOM'
      INCLUDE 'INPUT'
      INCLUDE 'TSTEP'
C
C     Note : XM3,YM3,ZM3 should come from COMMON /SCRUZ/.
C
      DIMENSION XM3(LX3,LY3,LZ3,1)
     $        , YM3(LX3,LY3,LZ3,1)
     $        , ZM3(LX3,LY3,LZ3,1)
C

      CALL glmapm1_chk_jac()

      RETURN
      END
c------------------------------------------------------------------------
      subroutine glmapm1_chk_jac()
c
C     Routine to generate mapping data based on mesh 1
C     (Gauss-Legendre Lobatto meshes).
C
C         XRM1,  YRM1,  ZRM1   -   dx/dr, dy/dr, dz/dr
C         XSM1,  YSM1,  ZSM1   -   dx/ds, dy/ds, dz/ds
C         XTM1,  YTM1,  ZTM1   -   dx/dt, dy/dt, dz/dt
C         RXM1,  RYM1,  RZM1   -   dr/dx, dr/dy, dr/dz
C         SXM1,  SYM1,  SZM1   -   ds/dx, ds/dy, ds/dz
C         TXM1,  TYM1,  TZM1   -   dt/dx, dt/dy, dt/dz
C         JACM1                -   Jacobian
C
C-----------------------------------------------------------------------
      INCLUDE 'SIZE'
      INCLUDE 'GEOM'
      INCLUDE 'INPUT'
      INCLUDE 'SOLN'
      include 'PARALLEL'

      include "BAD_ELEMENTS"
	
      integer kerr
      real jacmin,jacmax,dratio
	  
C
C     Note: Subroutines GLMAPM1, GEODAT1, AREA2, SETWGTR and AREA3 
C           share the same array structure in Scratch Common /SCRNS/.
C
      COMMON /SCRNS/ XRM1(LX1,LY1,LZ1,LELT)
     $ ,             YRM1(LX1,LY1,LZ1,LELT)
     $ ,             XSM1(LX1,LY1,LZ1,LELT)
     $ ,             YSM1(LX1,LY1,LZ1,LELT)
     $ ,             XTM1(LX1,LY1,LZ1,LELT)
     $ ,             YTM1(LX1,LY1,LZ1,LELT)
     $ ,             ZRM1(LX1,LY1,LZ1,LELT)
      COMMON /CTMP1/ ZSM1(LX1,LY1,LZ1,LELT)
     $ ,             ZTM1(LX1,LY1,LZ1,LELT)
C
      NXY1  = lx1*ly1
      NYZ1  = ly1*lz1
      NXYZ1 = lx1*ly1*lz1
      NTOT1 = NXYZ1*NELT
C
      CALL XYZRST (XRM1,YRM1,ZRM1,XSM1,YSM1,ZSM1,XTM1,YTM1,ZTM1,
     $             IFAXIS)
C

      IF (ldim.EQ.2) THEN
         CALL RZERO   (JACM1,NTOT1)
         CALL ADDCOL3 (JACM1,XRM1,YSM1,NTOT1)
         CALL SUBCOL3 (JACM1,XSM1,YRM1,NTOT1)
         CALL COPY    (RXM1,YSM1,NTOT1)
         CALL COPY    (RYM1,XSM1,NTOT1)
         CALL CHSIGN  (RYM1,NTOT1)
         CALL COPY    (SXM1,YRM1,NTOT1)
         CALL CHSIGN  (SXM1,NTOT1)
         CALL COPY    (SYM1,XRM1,NTOT1)
         CALL RZERO   (RZM1,NTOT1)
         CALL RZERO   (SZM1,NTOT1)
         CALL RONE    (TZM1,NTOT1)
      ELSE
         CALL RZERO   (JACM1,NTOT1)
         CALL ADDCOL4 (JACM1,XRM1,YSM1,ZTM1,NTOT1)
         CALL ADDCOL4 (JACM1,XTM1,YRM1,ZSM1,NTOT1)
         CALL ADDCOL4 (JACM1,XSM1,YTM1,ZRM1,NTOT1)
         CALL SUBCOL4 (JACM1,XRM1,YTM1,ZSM1,NTOT1)
         CALL SUBCOL4 (JACM1,XSM1,YRM1,ZTM1,NTOT1)
         CALL SUBCOL4 (JACM1,XTM1,YSM1,ZRM1,NTOT1)
         CALL ASCOL5  (RXM1,YSM1,ZTM1,YTM1,ZSM1,NTOT1)
         CALL ASCOL5  (RYM1,XTM1,ZSM1,XSM1,ZTM1,NTOT1)
         CALL ASCOL5  (RZM1,XSM1,YTM1,XTM1,YSM1,NTOT1)
         CALL ASCOL5  (SXM1,YTM1,ZRM1,YRM1,ZTM1,NTOT1)
         CALL ASCOL5  (SYM1,XRM1,ZTM1,XTM1,ZRM1,NTOT1)
         CALL ASCOL5  (SZM1,XTM1,YRM1,XRM1,YTM1,NTOT1)
         CALL ASCOL5  (TXM1,YRM1,ZSM1,YSM1,ZRM1,NTOT1)
         CALL ASCOL5  (TYM1,XSM1,ZRM1,XRM1,ZSM1,NTOT1)
         CALL ASCOL5  (TZM1,XRM1,YSM1,XSM1,YRM1,NTOT1)
      ENDIF
C

	  call rzero(bad_eg_list,lelg)
	  call rzero(work_array2,lelg)

      kerr = 0
	  inje_rank = 0
      DO 500 ie=1,NELT
	  
	     if (minJac.eq.0.0) then
	  
         CALL pre_chkjac(JACM1(1,1,1,ie),NXYZ1,ie,xm1(1,1,1,ie),
     $ ym1(1,1,1,ie),zm1(1,1,1,ie),ldim,ierr)
         if (ierr.ne.0) kerr = kerr+1
		 
         endif
		 
	     if (minJac.gt.0.0) then

         dratio = vlmin(JACM1(1,1,1,ie),NXYZ1)/
     $            vlmax(JACM1(1,1,1,ie),NXYZ1)
        if (dratio.le.minJac) then
        
            ieg = lglel(ie)  ! ieg is the nje global id. need to store it.
            inje_rank = inje_rank + 1
			
			if (inje_rank.gt.nbad_max)  then
      write(6,*) 'please increase nbad_max to ',inje_rank
      write(6,*) ' in BAD_ELEMENTS and recompile'
            endif

            bad_eg_list(ieg) = 1.0

         endif
		
         endif
		 
  500 CONTINUE
      kerr = iglsum(kerr,1)
      nnje_rank = inje_rank
	  nnje_rank = iglsum(nnje_rank,1)

			if (nnje_rank.gt.nbad_max)  then
      write(6,*) 'please increase nbad_max to ',nnje_rank
      write(6,*) ' in BAD_ELEMENTS and recompile'
            endif

c inje_rank is the bad element number in this rank
c nnje_rank is the bad elmenet number in all ranks

      if (kerr.gt.0) then
c         ifxyo = .true.
c         ifvo  = .false.
c         ifpo  = .false.
c         ifto  = .false.
c         param(66) = 4
c         call outpost(vx,vy,vz,pr,t,'xyz')
         if (nid.eq.0) write(6,*) 
     &  'precheck: Jac error 1 in ',kerr,' elements'
         ! call exitt
      endif

      call gop(bad_eg_list,work_array2,'+  ',lelg)

c      call invers2(jacmi,jacm1,ntot1)

      RETURN
      END
c-----------------------------------------------------------------------
      subroutine fix_geom_pre_check ! fix up geometry irregularities
c
      include 'SIZE'
      include 'TOTAL'
      parameter (lt = lx1*ly1*lz1)
      common /scrns/ xb(lt,lelt),yb(lt,lelt),zb(lt,lelt)
      common /scruz/ tmsk(lt,lelt),tmlt(lt,lelt),w1(lt),w2(lt)
      integer e,f
      character*3 cb
      n      = lx1*ly1*lz1*nelt
      nxyz   = lx1*ly1*lz1
      nfaces = 2*ldim
      ifield = 1 ! velocity field
      if (nelgv.ne.nelgt .or. .not.ifflow) ifield = 2 ! temperature field
      call rone  (tmlt,n)
      call dssum (tmlt,lx1,ly1,lz1)  ! denominator
      call rone  (tmsk,n)
      do e=1,nelt                ! fill mask where bc is periodic
      do f=1,nfaces              ! so we don't translate periodic bcs (z only)
         cb =cbc(f,e,ifield)
         if (cb.eq.'P  ') call facev (tmsk,e,f,0.0,lx1,ly1,lz1)
      enddo
      enddo
      call dsop(tmsk,'*  ',lx1,ly1,lz1)
      call dsop(tmsk,'*  ',lx1,ly1,lz1)
      call dsop(tmsk,'*  ',lx1,ly1,lz1)

      do kpass = 1,ldim+1   ! This doesn't work for 2D, yet.
                            ! Extra pass is just to test convergence
c        call opcopy (xb,yb,zb,xm1,ym1,zm1) ! Must use WHOLE field,
c        call opdssum(xb,yb,zb)             ! not just fluid domain.
         call copy   (xb,xm1,n)
         call copy   (yb,ym1,n)
         call copy   (zb,zm1,n)
         call dssum  (xb,lx1,ly1,lz1)
         call dssum  (yb,lx1,ly1,lz1)
         call dssum  (zb,lx1,ly1,lz1)
         xm = 0.
         ym = 0.
         zm = 0.
         do e=1,nelt
            do i=1,nxyz                       ! compute averages of geometry
               s     = 1./tmlt(i,e)
               xb(i,e) = s*xb(i,e)
               yb(i,e) = s*yb(i,e)
               zb(i,e) = s*zb(i,e)
               xb(i,e) = xb(i,e) - xm1(i,1,1,e)   ! local displacements
               yb(i,e) = yb(i,e) - ym1(i,1,1,e)
               zb(i,e) = zb(i,e) - zm1(i,1,1,e)
               xb(i,e) = xb(i,e)*tmsk(i,e)
               yb(i,e) = yb(i,e)*tmsk(i,e)
               zb(i,e) = zb(i,e)*tmsk(i,e)
               xm = max(xm,abs(xb(i,e)))
               ym = max(ym,abs(yb(i,e)))
               zm = max(zm,abs(zb(i,e)))
            enddo
            if (kpass.le.ldim) then
               call gh_face_extend(xb(1,e),zgm1,lx1,kpass,w1,w2)
               call gh_face_extend(yb(1,e),zgm1,lx1,kpass,w1,w2)
               call gh_face_extend(zb(1,e),zgm1,lx1,kpass,w1,w2)
            endif
         enddo
         if (kpass.le.ldim) then
            call add2(xm1,xb,n)
            call add2(ym1,yb,n)
            call add2(zm1,zb,n)
         endif
         
         xx = glamax(xb,n)
         yx = glamax(yb,n)
         zx = glamax(zb,n)
         xm = glmax(xm,1)
         ym = glmax(ym,1)
         zm = glmax(zm,1)
         if (nio.eq.0) write(6,1) xm,ym,zm,xx,yx,zx,kpass
    1    format(1p6e12.4,' xyz repair',i2)
      enddo
      param(59) = 1.       ! ifdef = .true.

c      call geom_reset(1)   ! reset metrics, etc.
      
      return
      end
c-----------------------------------------------------------------------

      subroutine pre_chkjac(jac,n,iel,X,Y,Z,ND,IERR)
c
      include 'SIZE'
      include 'PARALLEL'
  
      include "BAD_ELEMENTS"
C
C     Check the array JAC for a change in sign.
C
      REAL JAC(N),x(1),y(1),z(1)
c
      ierr = 1
      SIGN = JAC(1)
      DO 100 I=2,N
         IF (SIGN*JAC(I).LE.0.0) THEN
            ieg = lglel(iel)  ! ieg is the nje global id. need to store it.
            inje_rank = inje_rank + 1
			
			if (inje_rank.gt.nbad_max)  then
      write(6,*) 'please increase nbad_max to ',inje_rank
      write(6,*) ' in BAD_ELEMENTS and recompile'
            endif
		
            bad_eg_list(ieg) = 1.0

c print error infomation.
C            WRITE(6,101) nid,I,ieg
C            write(6,*) jac(i-1),jac(i)
            if (ldim.eq.3) then
               write(6,7) nid,x(i-1),y(i-1),z(i-1)
               write(6,7) nid,x(i),y(i),z(i)
            else
               write(6,7) nid,x(i-1),y(i-1)
               write(6,7) nid,x(i),y(i)
            endif
    7       format(i5,' xyz:',1p3e14.5)
c           if (np.eq.1) call out_xyz_el(x,y,z,iel)
c           ierr=0
            return
         ENDIF
  100 CONTINUE
  101 FORMAT(//,i5,2x
     $ ,'ERROR:  Vanishing Jacobian near',i7,'th node of element'
     $ ,I10,'.')
c
c
      ierr = 0
      RETURN
      END
c-----------------------------------------------------------------------
      subroutine get_bad_element_list() 
c read bad_elements.data file
c but also identify all elements that are close to bad_elements.
c linear nearby elements as well. 
c 
c      implicit none
      include 'SIZE'
      include 'TOTAL'
  
      include "BAD_ELEMENTS"
      real dist
      integer nbe

      call rzero(bad_list,nelt)	  
      call rzero(bad_xyzr,4*nbad_max)
      call izero(sbad_eg_list,nbad_max)
! bad_eg_list convets to sbad_eg_list
! 
!      
      igb = 0
      do ieg = 1,lelg 
         if (bad_eg_list(ieg).gt.0.5) then
	   	 igb=igb+1
         sbad_eg_list(igb) = ieg
         endif
      enddo
		 
      nbe = nnje_rank 

      do i =1,nbe

       gbe = sbad_eg_list(i)

       do ie = 1,nelt
	   eg = lglel(ie) ! return global element number from local element number
       if(eg.eq.gbe) then  ! if this eg is bad element
         bad_list(ie) = 1.0
         ! get center xyz of this element
		 ! and r (length scale) of this element 
        call v8center(xc(1,ie),yc(1,ie),zc(1,ie),ecenter)
        call v8length(xc(1,ie),yc(1,ie),zc(1,ie),elength)

         bad_xyzr(1,i) = ecenter(1)
         bad_xyzr(2,i) = ecenter(2)
         bad_xyzr(3,i) = ecenter(3)

         bad_xyzr(4,i) = elength 

       endif
       enddo

      enddo

      ! call glsum(bad_xyzr,4*nbad_max) ! broadcast to all mpi ranks, this is wrong.
      call gop(bad_xyzr,work_array,'+  ',4*nbad_max)

       do ie = 1,nelt
      
        if (bad_list(ie).eq.0) then
	
        call v8center(xc(1,ie),yc(1,ie),zc(1,ie),ecenter)
        call v8length(xc(1,ie),yc(1,ie),zc(1,ie),elength)

         do i =1,nbe 		 
           call distance(ecenter,bad_xyzr(1,i),dist)
           if (dist.lt.(4.0*bad_xyzr(4,i))) then        
            bad_list(ie) = 1.0
           endif
	     enddo

        endif
       enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine v8_to_e12(v8x,v8y,v8z,e12)
      real v8x(8),v8y(8),v8z(8)
      real e12(3,12)

      do i = 1,4
        i1 = i
		i2 = i+1
		if (i2 > 4) i2 = 1
        e12(1,i) = (v8x(i1) + v8x(i2))/2.0
        e12(2,i) = (v8y(i1) + v8y(i2))/2.0
        e12(3,i) = (v8z(i1) + v8z(i2))/2.0
      enddo

      do i = 5,8
        i1 = i
		i2 = i+1
		if (i2 > 8) i2 = 5
        e12(1,i) = (v8x(i1) + v8x(i2))/2.0
        e12(2,i) = (v8y(i1) + v8y(i2))/2.0
        e12(3,i) = (v8z(i1) + v8z(i2))/2.0
      enddo
	  
	  
      do i = 1,4
        i1 = i
		i2 = i+4
        e12(1,i+8) = (v8x(i1) + v8x(i2))/2.0
        e12(2,i+8) = (v8y(i1) + v8y(i2))/2.0
        e12(3,i+8) = (v8z(i1) + v8z(i2))/2.0
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine v8center(v8x,v8y,v8z,center)
      real v8x(8),v8y(8),v8z(8)
      real center(3)
	  
      center(1) = 0.0
      center(2) = 0.0
      center(3) = 0.0
       do i = 1,8
       center(1) =  center(1) + v8x(i)
       center(2) =  center(2) + v8y(i)
       center(3) =  center(3) + v8z(i)
       enddo
      center(1) = center(1) / 8.0
      center(2) = center(2) / 8.0
      center(3) = center(3) / 8.0

      return
      end
c-----------------------------------------------------------------------
      subroutine v8length(v8x,v8y,v8z,length)
      real v8x(8),v8y(8),v8z(8)
      real v1xyz(3),v2xyz(3)
      real length,dist
	  
      length = 1.0
      do i = 1,4
        i1 = i
		i2 = i+1
		if (i2 > 4) i2 = 1
        v1xyz(1) = v8x(i1)
        v1xyz(2) = v8y(i1)
        v1xyz(3) = v8z(i1)

        v2xyz(1) = v8x(i2)
        v2xyz(2) = v8y(i2)
        v2xyz(3) = v8z(i2)
		
        call distance(v1xyz,v2xyz,dist)
        length = length*dist

      enddo

      do i = 5,8
        i1 = i
		i2 = i+1
		if (i2 > 8) i2 = 5
        v1xyz(1) = v8x(i1)
        v1xyz(2) = v8y(i1)
        v1xyz(3) = v8z(i1)

        v2xyz(1) = v8x(i2)
        v2xyz(2) = v8y(i2)
        v2xyz(3) = v8z(i2)
		
        call distance(v1xyz,v2xyz,dist)
        length = length*dist
      enddo
	  
	  
      do i = 1,4
        i1 = i
		i2 = i+4
        v1xyz(1) = v8x(i1)
        v1xyz(2) = v8y(i1)
        v1xyz(3) = v8z(i1)

        v2xyz(1) = v8x(i2)
        v2xyz(2) = v8y(i2)
        v2xyz(3) = v8z(i2)
		
        call distance(v1xyz,v2xyz,dist)
        length = length*dist
      enddo

       length = length**(1.0/12.0)

      return
      end
!----------------------------------------------------------------
      subroutine distance(a,b,d)
      real d,a(3),b(3)
      d = sqrt((a(1)-b(1))**2.0+(a(2)-b(2))**2.0+(a(3)-b(3))**2.0)
      return
      end
!---------
