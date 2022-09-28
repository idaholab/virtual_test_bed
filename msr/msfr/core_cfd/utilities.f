c-----------------------------------------------------------------------
      real function planar_ave_m1(phi,norm,pt,eps)
      implicit none
C
C     Compute area average of phi() on the
C     plane defined by normal 'norm' and point 'pt'
C
      include 'SIZE'
      include 'TOTAL'

      real phi(1),norm(3),pt(3),eps
      real aa,bb,cc,dd,w1,w2,x0,y0,z0,r0,rr,del,glsum

      integer i,j,k,n

      n=nx1*ny1*nz1*nelv

      aa=norm(1)
      bb=norm(2) 
      cc=0.0
      if(if3d) cc=norm(3)
      dd=-1.0*(aa*pt(1)+bb*pt(2)+cc*pt(3))
      w1=0.0
      w2=0.0
      do i=1,n
        x0=xm1(i,1,1,1)
        y0=ym1(i,1,1,1)
        z0=zm1(i,1,1,1)
        r0=(aa*x0+bb*y0+cc*z0+dd)/sqrt(aa**2+bb**2+cc**2)
        rr=min(2.0,abs(r0)*2.0/eps)
        if(rr.gt.1.0) then
          del = 1.0/8.0*(5.0-2.0*rr-sqrt(-7.0+12.0*rr-4.0*rr**2))
        else 
          del = 1.0/8.0*(3.0-2.0*rr+sqrt( 1.0+ 4.0*rr-4.0*rr**2))
        endif
        w1=w1+phi(i)*bm1(i,1,1,1)*del
        w2=w2+bm1(i,1,1,1)*del
      enddo
      planar_ave_m1 = glsum(w1,1)/max(glsum(w2,1),1.0e-8)

      return
      end
C-----------------------------------------------------------------------
      real function planar_ave_m2(phi,norm,pt,eps)
      implicit none
C
C     Compute area average of phi() on the
C     plane defined by normal 'norm' and point 'pt'
C
      include 'SIZE'
      include 'TOTAL'

      real phi(1),norm(3),pt(3),eps
      real aa,bb,cc,dd,w1,w2,x0,y0,z0,r0,rr,del,glsum

      integer i,j,k,n

      n=lx2*ly2*lz2*nelv

      aa=norm(1)
      bb=norm(2) 
      cc=0.0
      if(if3d) cc=norm(3)
      dd=-1.0*(aa*pt(1)+bb*pt(2)+cc*pt(3))
      w1=0.0
      w2=0.0
      do i=1,n
        x0=xm2(i,1,1,1)
        y0=ym2(i,1,1,1)
        z0=zm2(i,1,1,1)
        r0=(aa*x0+bb*y0+cc*z0+dd)/sqrt(aa**2+bb**2+cc**2)
        rr=min(2.0,abs(r0)*2.0/eps)
        if(rr.gt.1.0) then
          del = 1.0/8.0*(5.0-2.0*rr-sqrt(-7.0+12.0*rr-4.0*rr**2))
        else 
          del = 1.0/8.0*(3.0-2.0*rr+sqrt( 1.0+ 4.0*rr-4.0*rr**2))
        endif
        w1=w1+phi(i)*bm2(i,1,1,1)*del
        w2=w2+bm2(i,1,1,1)*del
      enddo
      planar_ave_m2 = glsum(w1,1)/max(glsum(w2,1),1.0e-8)

      return
      end
C-----------------------------------------------------------------------
      subroutine count_boundaries
      include 'SIZE'
      include 'TOTAL'

      integer lxyz,ielem,iside,n
      parameter(lxyz=lx1*ly1*lz1)
      character*3 uid(ldimt1)
      integer wcnt(ldimt1),symcnt(ldimt1),ocnt(ldimt1)
      integer tcnt(ldimt1),fcnt(ldimt1),axicnt(ldimt1)
      integer inscnt(ldimt1),pcnt(ldimt1),othcnt(ldimt1)
      integer vcnt(ldimt1),trcnt(ldimt1),ukncnt(ldimt1)
      integer mtrcnt(ldimt1),prcnt(ldimt1),intcnt(ldimt1)
      integer vreacnt(ldimt1),treacnt(ldimt1),convcnt(ldimt1)

      call izero(wcnt,ldimt1)
      call izero(trcnt,ldimt1)
      call izero(mtrcnt,ldimt1)
      call izero(vcnt,ldimt1)
      call izero(vreacnt,ldimt1)
      call izero(symcnt,ldimt1)
      call izero(ocnt,ldimt1)
      call izero(tcnt,ldimt1)
      call izero(treacnt,ldimt1)
      call izero(axicnt,ldimt1)
      call izero(inscnt,ldimt1)
      call izero(intcnt,ldimt1)
      call izero(fcnt,ldimt1)
      call izero(pcnt,ldimt1)
      call izero(prcnt,ldimt1)
      call izero(convcnt,ldimt1)
      call izero(othcnt,ldimt1)
      call izero(ukncnt,ldimt1)

      do ifld=1,nfield
        n=nelv
        if(iftmsh(ifld)) n=nelt
        do ielem=1,n
        do iside=1,2*ldim
          if(cbc(iside,ielem,ifld).eq.'W  ')then
            wcnt(ifld)=wcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'shl')then
            trcnt(ifld)=trcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'sml')then
            mtrcnt(ifld)=mtrcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'v  ')then
            vcnt(ifld)=vcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'V  ')then
            vreacnt(ifld)=vreacnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'t  ')then
            tcnt(ifld)=tcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'T  ')then
            treacnt(ifld)=treacnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'O  ')then
            ocnt(ifld)=ocnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'o  ')then
            prcnt(ifld)=prcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'P  ')then
            pcnt(ifld)=pcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'f  ')then 
            fcnt(ifld)=fcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'c  ')then 
            convcnt(ifld)=convcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'I  ')then
            inscnt(ifld)=inscnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'SYM')then
            symcnt(ifld)=symcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'A  ')then
            axicnt(ifld)=axicnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).eq.'int')then
            intcnt(ifld)=intcnt(ifld)+1
          elseif(cbc(iside,ielem,ifld).ne.'E  ')then
            if(ukncnt(ifld).eq.0) then  !handle one unknown BC
              uid(ifld)=cbc(iside,ielem,ifld)
              ukncnt(ifld)=1
            elseif(cbc(iside,ielem,ifld).eq.uid(ifld)) then
              ukncnt(ifld)=ukncnt(ifld)+1
            else
              othcnt(ifld)=othcnt(ifld)+1 !multiple unknown BCs 
            endif
          endif
        enddo
        enddo
        wcnt(ifld)=iglsum(wcnt(ifld),1)
        trcnt(ifld)=iglsum(trcnt(ifld),1)
        mtrcnt(ifld)=iglsum(mtrcnt(ifld),1)
        vcnt(ifld)=iglsum(vcnt(ifld),1)
        vreacnt(ifld)=iglsum(vreacnt(ifld),1)
        tcnt(ifld)=iglsum(tcnt(ifld),1)
        treacnt(ifld)=iglsum(treacnt(ifld),1)
        ocnt(ifld)=iglsum(ocnt(ifld),1)
        prcnt(ifld)=iglsum(prcnt(ifld),1)
        pcnt(ifld)=iglsum(pcnt(ifld),1)
        fcnt(ifld)=iglsum(fcnt(ifld),1)
        convcnt(ifld)=iglsum(convcnt(ifld),1)
        inscnt(ifld)=iglsum(inscnt(ifld),1)
        symcnt(ifld)=iglsum(symcnt(ifld),1)
        axicnt(ifld)=iglsum(axicnt(ifld),1)
        othcnt(ifld)=iglsum(othcnt(ifld),1)
        ukncnt(ifld)=iglsum(ukncnt(ifld),1)
      enddo

      if(nid.eq.0) then
        write(*,*)
        write(*,255) 'Found the following Boundary Conditions'
        write(*,*)
        do ifld=1,nfield
          write(*,254) 'for field',ifld,':'
          if(wcnt(ifld).gt.0)write(*,256)'Wall',wcnt(ifld)
          if(trcnt(ifld).gt.0)write(*,256)'Traction',trcnt(ifld)
          if(mtrcnt(ifld).gt.0)write(*,256)'Mixed Traction'
     &                                                   ,mtrcnt(ifld)
          if(vcnt(ifld).gt.0)write(*,256)'Velocity',vcnt(ifld)
          if(vreacnt(ifld).gt.0)write(*,256)'Velocity (REA)',
     &                                                   vreacnt(ifld)
          if(tcnt(ifld).gt.0)write(*,256)'Dirichlet',tcnt(ifld)
          if(treacnt(ifld).gt.0)write(*,256)'Dirichlet (REA)',
     &                                                   treacnt(ifld)
          if(pcnt(ifld).gt.0)write(*,256)'Periodic',pcnt(ifld)
          if(fcnt(ifld).gt.0)write(*,256)'Flux',fcnt(ifld)
          if(convcnt(ifld).gt.0)write(*,256)'Convection',convcnt(ifld)
          if(ocnt(ifld).gt.0)write(*,256)'Outlet',ocnt(ifld)
          if(prcnt(ifld).gt.0)write(*,256)'Pressure',prcnt(ifld)
          if(inscnt(ifld).gt.0)write(*,256)'Insulated',inscnt(ifld)
          if(intcnt(ifld).gt.0)write(*,256)'Interpolated',intcnt(ifld)
          if(symcnt(ifld).gt.0)write(*,256)'Symmetry',symcnt(ifld)
          if(axicnt(ifld).gt.0)write(*,256)
     &                                     'Axisymmetric',axicnt(ifld)
          if(ukncnt(ifld).gt.0)write(*,257)uid(ifld),ukncnt(ifld)
          if(othcnt(ifld).gt.0)write(*,256)'Other',othcnt(ifld)
          write(*,*)
        enddo
      endif

 254  format(5x,a,i2,a)
 255  format(2x,a)
 256  format(2x,a16,1x,i12)
 257  format(2x,'Unknown boundary of type: "',a,'" ',i9)

      return
      end
C-----------------------------------------------------------------------
      subroutine div_check(phi)

      real phi(1)

      if(phi(1).ne.phi(1)) call exitt
      return
      end
C-----------------------------------------------------------------------
      subroutine get_wall_distance(wd,itype)
      include 'SIZE'

      real wd(*)
      real w1(lx1*ly1*lz1*lelv)
      real w2(lx1*ly1*lz1*lelv)
      real w3(lx1*ly1*lz1*lelv)
      real w4(lx1*ly1*lz1*lelv)
      real w5(lx1*ly1*lz1*lelv)
      common /SCRNS/ w1,w2,w3,w4,w5

      if(itype.eq.1) then
        call cheap_dist(wd,1,'W  ')
      elseif(itype.eq.2) then
        call distf(wd,1,'W  ',w1,w2,w3,w4,w5)
      else
        if(nio.eq.0) write(*,*) 
     &           "Error in get_wall_distance, unsupported distance type"
      endif

      return
      end
C-----------------------------------------------------------------------
      real function get_nearest(loc,coord)
      include 'mpif.h'
      include 'SIZE'
      include 'TOTAL'

      integer ipoint,ierr
      real loc,coord(1),ds(2),dsg(2)

      ds(1)=1.0d30
      do ipoint=1,lx1*ly1*lz1*nelv
        if(abs(coord(ipoint)-loc).lt.ds(1)) then
          ds(1)=abs(coord(ipoint)-loc)
          ds(2)=coord(ipoint)
        endif
      enddo
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      get_nearest=dsg(2)
      return
      end
c-----------------------------------------------------------------------
      subroutine get_point3d(loc1,loc2,loc3,ix,iy,iz,eg)
      include 'mpif.h'
      include 'SIZE'
      include 'TOTAL'

      integer ipoint,ierr,dsi,ix,iy,iz,ie,eg,jx,jy,jz,je
      real loc1,loc2,loc3,ds(2),dsg(2),dist(2)

      dist(2)=1.0d30
      do je=1,nelv
      do jz=1,lz1
      do jy=1,ly1
      do jx=1,lx1
        dist(1)=sqrt((loc1-xm1(jx,jy,jz,je))**2
     &           +(loc2-ym1(jx,jy,jz,je))**2+(loc3-zm1(jx,jy,jz,je))**2)
        if(dist(1).lt.dist(2)) then
          dist(2)=dist(1)
          ix=jx
          iy=jy
          iz=jz
          ie=je
        endif
      enddo
      enddo
      enddo
      enddo

      eg=lglel(ie)

      ds(1)=dist(2)

      ds(2)=dble(ix)
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      ix=int(dsg(2))

      ds(2)=dble(iy)
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      iy=int(dsg(2))

      ds(2)=dble(iz)
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      iz=int(dsg(2))

      ds(2)=dble(eg)
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      eg=int(dsg(2))

      return
      end
c-----------------------------------------------------------------------
      real function get_nearest_face(loc,coord,norm)
      include 'mpif.h'
      include 'SIZE'
      include 'TOTAL'

      integer ielem,iside,i0,i1,j0,j1,k0,k1,i,j,k,ierr
      real loc,coord(1),ds(2),dsg(2),norm(3),fnorm(3),dp

      ds(1)=1.0d30
      do ielem=1,nelv
        do iside=1,ldim*2
          call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,iside)
          i=(i0+i1)/2
          j=(j0+j1)/2
          k=(k0+k1)/2
          ipoint=i+(j-1)*lx1+(k-1)*lx1*ly1+lx1*ly1*lz1*(ielem-1)
          call getSnormal(fnorm,i,j,k,iside,ielem)
          dp=fnorm(1)*norm(1)+fnorm(2)*norm(2)
          if(if3d) dp=dp+fnorm(3)*norm(3)
          if((1.0d0-abs(dp)).lt.1.0d-8)then
            if(abs(coord(ipoint)-loc).lt.ds(1)) then
              ds(1)=abs(coord(ipoint)-loc)
              ds(2)=coord(ipoint)
            endif
          endif
        enddo
      enddo
      call MPI_ALLREDUCE(ds,dsg,1,MPI_2DOUBLE_PRECISION,MPI_MINLOC
     &                                             ,MPI_COMM_WORLD,ierr)
      get_nearest_face=dsg(2)
      return
      end
C-----------------------------------------------------------------------
      subroutine weighted_average(phi,wrt,loc,coord,norm,phia)
C
C     Compute planar averages of phi() weighted by wrt() on the
C     plane normal to norm() with intercept coord = loc
C
      include 'SIZE'
      include 'TOTAL'

      integer ielem,iside,i,i0,i1,j,j0,j1,k,k0,k1
      real phi(1),wrt(1),loc,coord(1),norm(3),phia
      real fnorm(3),dp,a1,phia1

      loc=get_nearest_face(loc,coord,norm)

      phia=0.0
      phia1=0.0
      do ielem=1,nelv
        do iside=1,ndim*2
          call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,iside)
          i=(i0+i1)/2  !just use the point in the middle of the face
          j=(j0+j1)/2
          k=(k0+k1)/2
          ipoint=i+(j-1)*lx1+(k-1)*lx1*ly1+(ielem-1)*lx1*ly1*lz1
          if(abs(coord(ipoint)-loc).lt.1.0d-8)then 
            call getSnormal(fnorm,i,j,k,iside,ielem)
            dp=fnorm(1)*norm(1)+fnorm(2)*norm(2)
            if(if3d) dp=dp+fnorm(3)*norm(3)
            if(abs(1.0d0-dp).lt.1.0d-8) then
              do i=i0,i1
              do j=j0,j1
              do k=k0,k1
                ipoint=i+(j-1)*lx1+(k-1)*lx1*ly1+(ielem-1)*lx1*ly1*lz1
                if    ((iside.eq.1).or.(iside.eq.3)) then
                  a1=area(i,k,iside,ielem)
                elseif((iside.eq.2).or.(iside.eq.4)) then
                  a1=area(j,k,iside,ielem)
                else
                  a1=area(i,j,iside,ielem)
                endif
                phia=phia+phi(ipoint)*wrt(ipoint)*a1
                phia1=phia1+wrt(ipoint)*a1
              enddo
              enddo
              enddo
            endif
          endif
        enddo
      enddo

      phia=glsum(phia,1)
      phia1=glsum(phia1,1)
      phia=phia/phia1

      return
      end
C-----------------------------------------------------------------------
      subroutine planar_average_weighted(phia,phi,wrt,w1,w2)
      include 'SIZE'
      include 'GEOM'
      include 'PARALLEL'
      include 'WZ'
      include 'ZPER'

      real phi(nx1*ny1,nz1,nelv),wrt(nx1*ny1,nz1,nelv),phia(nz1,nelz)
      real w1(nz1,nelz),w2(nz1,nelz) !work arrays

      integer e,eg,ez,melxy,nz,i,k
      real zz,aa

      melxy=nelx*nely !number of elements in the plane
      nz=nz1*nelz !number of z-slices

      if(melxy.lt.1)then
        if(nio.eq.0)write(*,256)'nelx*nely'
        return
      elseif(nelz.lt.1) then
        if(nio.eq.0)write(*,256)'nelz'
        return
      elseif(melxy.gt.lelx*lely) then
        if(nio.eq.0)write(*,257)'nelx*nely','lelx*lely'
        return
      elseif(nelz.gt.lelz) then
        if(nio.eq.0)write(*,257)'nelz','lelz'
        return
      endif

 256  format(5x,'ERROR: ',a,' must be at least 1!')
 257  format(5x,'ERROR: ',a,' must be less than ',a,'!')

      call rzero(phia,nz)
      call rzero(w1,nz)

      do e=1,nelt
        eg=lglel(e)
        ez=1+(eg-1)/melxy !z-slice id
        do k=1,nz1
          do i=1,nx1*ny1
            zz=(1.0-zgm1(k,3))/2.0
            aa=zz*area(i,1,5,e)+(1.0-zz)*area(i,1,6,e)
            w1(k,ez)=w1(k,ez)+aa*wrt(i,k,e)
            phia(k,ez)=phia(k,ez)+aa*wrt(i,k,e)*phi(i,k,e)
          enddo
          if(abs(w1(k,ez)).lt.1.0d-10) w1(k,ez)=1.0d-10
        enddo
      enddo

      call gop(phia,w2,'+  ',nz)
      call gop(w1,w2,'+  ',nz)
      call invcol2(phia,w1,nz)

      return
      end
C-----------------------------------------------------------------------
      subroutine x_planar_average(phia,phi,w1,w2)
      include 'SIZE'
      include 'GEOM'
      include 'PARALLEL'
      include 'WZ'
      include 'ZPER'

      real phi(nx1,ny1,nz1,nelv),wrt(nx1,ny1,nz1,nelv),phia(nx1,nelx)
      real w1(nx1,nelx),w2(nx1,nelx) !work arrays

      integer e,eg,ex,nx,i,j,estride
      real xx,aa

      if(ldim.gt.2) then
        write(*,'(5x,a)')
     &            "x-average routine only written for 2D genbox meshes!"
        return
      endif

      nx=nx1*nelx !number of z-slices

      call rzero(phia,nx)
      call rzero(w1,nx)

      do e=1,nelt
        eg=lglel(e)
        ex=mod(eg,nelx) !x-slice id
        if(ex.eq.0)ex=nelx
        do i=1,nx1
          do j=1,ny1
            xx=(1.0-zgm1(i,1))/2.0
            aa=zz*area(j,1,4,e)+(1.0-zz)*area(j,1,2,e)
            w1(i,ex)=w1(i,ex)+aa
            phia(i,ex)=phia(i,ex)+aa*phi(i,j,1,e)
          enddo
        enddo
      enddo

      call gop(phia,w2,'+  ',nx)
      call gop(w1,w2,'+  ',nx)
      call invcol2(phia,w1,nx)

      return
      end
C-----------------------------------------------------------------------
      subroutine x_average_weighted(phia,phi,wrt,w1,w2)
      include 'SIZE'
      include 'GEOM'
      include 'PARALLEL'
      include 'WZ'
      include 'ZPER'

      real phi(nx1,ny1,nz1,nelv),wrt(nx1,ny1,nz1,nelv),phia(nx1,nelx)
      real w1(nx1,nelx),w2(nx1,nelx) !work arrays

      integer e,eg,ex,nx,i,j,estride
      real xx,aa

      if(lz1.gt.1) then
        write(*,'(5x,a)')
     &                   "x-average routine only written for 2D meshes!"
        return
      endif

      nx=nx1*nelx !number of z-slices

      call rzero(phia,nx)
      call rzero(w1,nx)

      do e=1,nelt
        eg=lglel(e)
        ex=mod(eg,nelx) !x-slice id
        if(ex.eq.0)ex=nelx
        do i=1,nx1
          do j=1,ny1
            xx=(1.0-zgm1(i,1))/2.0
            aa=zz*area(j,1,4,e)+(1.0-zz)*area(j,1,2,e)
            w1(i,ex)=w1(i,ex)+aa*wrt(i,j,1,e)
            phia(i,ex)=phia(i,ex)+aa*wrt(i,j,1,e)*phi(i,j,1,e)
          enddo
          if(abs(w1(i,ex)).lt.1.0d-10) w1(i,ex)=1.0d-10
        enddo
      enddo

      call gop(phia,w2,'+  ',nx)
      call gop(w1,w2,'+  ',nx)
      call invcol2(phia,w1,nx)

      return
      end
C-----------------------------------------------------------------------
      real function q_vol_periodic(ix,iy,iz,ie,ifld)
      implicit none
      include 'SIZE'
      include 'TOTAL'
 
      integer ix,iy,iz,ie,ifld,n,e,f,dir

      logical ifdid(ldimt),ifprintNu(ldimt)
      common /printNu/ ifprintNu

      real dummy,sarea,tarea,time0(ldimt),tcorr
      real f_gm(ldimt),vel_avg,glsum,glsc2,glsc3

      data ifdid /ldimt*.false./
      data time0 /ldimt*-1.0/

      save ifdid,time0,vel_avg,f_gm,dir

      n=nx1*ny1*nz1*nelv

      if(.not.ifdid(ifld-1)) then
        dir=nint(abs(param(54))) !make sure this is an int, for my own sanity
        ifdid(ifld-1) = .true.
        tarea = 0.0
        do e=1,nelv
          do f=1,2*ndim
            if(cbc(f,e,ifld).eq.'f  ') then
              call surface_int(dummy,sarea,xm1,e,f)
              tarea=tarea+sarea
            endif
          enddo
        enddo
        tarea=glsum(tarea,1)
        f_gm(ifld-1)=abs(tarea/volvm1) !probably wrong for CHT
      endif

      ifprintNu(ifld-1)=.true.

      e=lglel(ie) !do nothing in solid region
      if(e.gt.nelgv) then
        q_vol_periodic = 0.0
        return
      endif

      if(time.ne.time0(ifld-1)) then
        time0(ifld-1)=time
        if(dir.eq.1) then
          vel_avg=glsc2(vx,bm1,n)/volvm1
          tcorr = -1.0*glsc3(t(1,1,1,1,ifld-1),vx,bm1,n)
        elseif(dir.eq.2) then
          vel_avg=glsc2(vy,bm1,n)/volvm1
          tcorr = -1.0*glsc3(t(1,1,1,1,ifld-1),vy,bm1,n)
        elseif(dir.eq.3) then
          vel_avg=glsc2(vz,bm1,n)/volvm1
          tcorr = -1.0*glsc3(t(1,1,1,1,ifld-1),vz,bm1,n)
        endif
        tcorr=tcorr/(vel_avg*volvm1)
        call cadd (t(1,1,1,1,ifld-1),tcorr,n)
      endif

      if(dir.eq.1) q_vol_periodic=-f_gm(ifld-1)*vx(ix,iy,iz,ie)/vel_avg
      if(dir.eq.2) q_vol_periodic=-f_gm(ifld-1)*vy(ix,iy,iz,ie)/vel_avg
      if(dir.eq.3) q_vol_periodic=-f_gm(ifld-1)*vz(ix,iy,iz,ie)/vel_avg

      return
      end
c-----------------------------------------------------------------------
      subroutine print_Nusselt
      include 'SIZE'
      include 'TOTAL'

      logical ifdo,ifprintNu(ldimt)
      real rNus(ldimt)

      common /printNu/ ifprintNu

      save ifdo
      data ifdo /.true./

      if(.not.ifdo) return
      if(istep.eq.0) then
        do i=1,ldimt
          ifprintNu(i)=.false.
        enddo 
      endif
      if(nsteps.eq.0) then
        do i=1,ldimt
          ifprintNu(i)=.true.
        enddo
      endif

      if(abs(param(54)).lt.0.1) then
        ifdo=.false.
        if(nio.eq.0) then
          write(*,'(a)') "******************************"
          write(*,'(a)')
     &       "print_Nusselt routine only compatible with forced flow"
          write(*,'(a)') "******************************"
        endif
        return
      endif

      n=nx1*ny1*nz1*nelv

      jfld=0
      do ifld=2,ldimt1
        if(ifprintNu(ifld-1)) then
          jfld=jfld+1
          tarea=0.0
          twall=0.0
          do ie=1,nelt
            do ifa=1,2*ndim
              if(cbc(ifa,ie,ifld).eq.'f  ') then
                call surface_int(swall,sarea,t(1,1,1,1,ifld-1),ie,ifa)
                twall=twall+swall
                tarea=tarea+sarea
              endif
            enddo
          enddo
          tarea=glsum(tarea,1)
          twall=glsum(twall,1)/tarea

          if(nint(abs(param(54))).eq.1) 
     &           tbulk=glsc3(t(1,1,1,1,ifld-1),vx,bm1,n)/glsc2(vx,bm1,n)
          if(nint(abs(param(54))).eq.2) 
     &           tbulk=glsc3(t(1,1,1,1,ifld-1),vy,bm1,n)/glsc2(vy,bm1,n)
          if(nint(abs(param(54))).eq.3) 
     &           tbulk=glsc3(t(1,1,1,1,ifld-1),vz,bm1,n)/glsc2(vz,bm1,n)
          rNus(jfld)=1.0/((twall-tbulk)*cpfld(ifld,1))
        endif
      enddo

      if(nio.eq.0) then
        write(*,'(a24,es15.7,10es15.7)') 
     &                           "time, Nusselt",time,(rNus(i),i=1,jfld)
      endif

      return
      end
c-----------------------------------------------------------------------
      real function bc_average(phi,bca,ifld)
      implicit none
      include 'SIZE'
      include 'INPUT'

      character*3 bca
      integer ifld
      real phi(lx1*ly1*lz1*lelv)

      integer f,e
      real phibc,Abc,dphi,dA
      real glsum

      phibc=0.0
      Abc=0.0

      do e=1,nelt
        do f=1,ndim*2
          if(cbc(f,e,ifld).eq.bca) then
            call surface_int(dphi,dA,phi,e,f)
            phibc=phibc+dphi
            Abc=Abc+dA
          endif
        enddo
      enddo
      Abc=glsum(Abc,1)
      phibc=glsum(phibc,1)/Abc

      bc_average = phibc

      return
      end
c-----------------------------------------------------------------------
      real function bc_area(bca,ifld)
      implicit none
      include 'SIZE'
      include 'INPUT'

      character*3 bca
      integer ifld

      integer f,e
      real Abc,dA
      real glsum

      Abc=0.0

      do 10 e=1,nelt
      do 10 f=1,ndim*2
        if(cbc(f,e,ifld).eq.bca) then
          call surface_area(dA,e,f)
          Abc=Abc+dA
        endif
 10   continue
      Abc=glsum(Abc,1)

      bc_area = Abc

      return
      end
c-----------------------------------------------------------------------
      real function bc_flux_average(phi,bca,ifld)
      implicit none
      include 'SIZE'
      include 'TOTAL'

      character*3 bca
      integer ifld
      real phi(lx1*ly1*lz1,lelv)

      integer f,e,lxyz
      parameter (lxyz=lx1*ly1*lz1)
      real phibc,AA,dphi,dAA,w(lxyz)
      real glsum

      phibc=0.0
      AA=0.0

      do e=1,nelt
        do f=1,ndim*2
          if(cbc(f,e,ifld).eq.bca) then
            call surface_flux2(dphi,phi,e,f)
            call surface_flux(dAA,vx,vy,vz,e,f,w)
            phibc=phibc+dphi
            AA=AA+dAA
          endif
        enddo
      enddo
      AA=glsum(AA,1)
      phibc=glsum(phibc,1)/AA

      bc_flux_average = phibc

      return
      end
c-----------------------------------------------------------------------
      real function bc_max(phi,bca,ifld)
      implicit none
      include 'SIZE'
      include 'INPUT'

      character*3 bca
      integer ifld
      real phi(lx1,ly1,lz1,1)

      real glmax

      integer f,e,i,i0,i1,j,j0,j1,k,k0,k1
      real bcmx

      do 10 e=1,nelt
      do 10 f=1,ndim*2
        if(cbc(f,e,ifld).eq.bca) then
          call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,f)
          do 20 k=k0,k1
          do 20 j=j0,j1
          do 20 i=i0,i1
            bcmx=max(bcmx,phi(i,j,k,e))
 20       continue
        endif
 10   continue

      bc_max = glmax(bcmx,1)

      return
      end
c-----------------------------------------------------------------------
      subroutine average_files(inbase,navg)
      implicit none
      include 'SIZE'
      include 'TOTAL'
      include 'AVG'

      character*(*) inbase
      character*8   ftail
      integer lbase,navg,n,n2,i,j
      logical ifxyo_s

      n=nx1*ny1*nz1*nelv
      n2=nx2*ny2*nz2*nelv

      if(navg.eq.0.or.nsteps.gt.0) return

      atime=0.0
      call rzero(uavg,n)
      call rzero(vavg,n)
      call rzero(wavg,n)
      call rzero(pavg,n2)
      do j=1,ldimt
        call rzero(tavg(1,1,1,1,j),n)
      enddo
      do i=1,navg
        if(i.lt.10) then
          write(ftail,'(a7,i1)')'0.f0000',i
        elseif(i.lt.100) then
          write(ftail,'(a6,i2)')'0.f000',i
        elseif(i.lt.1000) then
          write(ftail,'(a5,i3)')'0.f00',i
        endif
        call blank(initc(1),132)
        initc(1)=trim(inbase)//ftail

        call restart(1)

        atime=atime+time
        call add2s2(uavg,vx,time,n)
        call add2s2(vavg,vy,time,n)
        call add2s2(wavg,vz,time,n)
        call add2s2(pavg,pr,time,n2)
        do j=1,ldimt
          call add2s2(tavg(1,1,1,1,j),t(1,1,1,1,j),time,n)
        enddo
      enddo
      time=atime
      call cmult(uavg,1.0/atime,n)
      call cmult(vavg,1.0/atime,n)
      call cmult(wavg,1.0/atime,n)
      call cmult(pavg,1.0/atime,n2)
      do j=1,ldimt
        call cmult(tavg(1,1,1,1,j),1.0/atime,n)
      enddo

      call copy (vx,uavg,n)
      call copy (vy,vavg,n)
      call copy (vz,wavg,n)
      call copy (pr,pavg,n2)
      do j=1,ldimt
        call copy(t(1,1,1,1,j),tavg(1,1,1,1,j),n)
      enddo

      if(nio.eq.0) write(*,*) "  average data:"
      call print_limits !print out the average data

      ifxyo_s = ifxyo
      ifxyo=.true.

      call prepost (.true.,'AVG')

      ifxyo = ifxyo_s

      return
      end
c-----------------------------------------------------------------------
      subroutine get_face_m1centroid(xx,yy,zz,ie,iface)
      implicit none
      include 'SIZE'
      include 'GEOM'
      include 'MASS'

      integer ie,iface
      real xx,yy,zz

      integer i,i0,i1,j,j0,j1,k,k0,k1
      real bm0

      bm0=0.0
      xx=0.0
      yy=0.0
      zz=0.0
      call facind(i0,i1,k0,k1,j0,j1,nx1,ny1,nz1,iface)
      do 10 k=k0,k1
      do 10 j=j0,j1
      do 10 i=i0,i1
        bm0=bm0+bm1(i,j,k,ie)
        xx=xx+xm1(i,j,k,ie)*bm1(i,j,k,ie)
        yy=yy+ym1(i,j,k,ie)*bm1(i,j,k,ie)
        zz=zz+zm1(i,j,k,ie)*bm1(i,j,k,ie)
 10   continue

      xx=xx/bm0
      yy=yy/bm0
      zz=zz/bm0

      return
      end
c-----------------------------------------------------------------------
      subroutine get_elem_m1centroid(xx,yy,zz,ie)
      implicit none
      include 'SIZE'
      include 'GEOM'
      include 'MASS'

      integer ie
      real xx,yy,zz

      integer ipt
      real bb

      xx=0.0
      yy=0.0
      zz=0.0
      bb=0.0
      do ipt = 1,lx1*ly1*lz1
        xx=xx+xm1(ipt,1,1,ie)*bm1(ipt,1,1,ie)
        yy=yy+ym1(ipt,1,1,ie)*bm1(ipt,1,1,ie)
        zz=zz+zm1(ipt,1,1,ie)*bm1(ipt,1,1,ie)
        bb=bb+bm1(ipt,1,1,ie)
      enddo
      xx=xx/bb
      yy=yy/bb
      zz=zz/bb

      return
      end
c-----------------------------------------------------------------------
      subroutine rotate_point_2d(x1,y1,x0,y0,theta,xo,yo)
      implicit none

C     rotate point x1,y1 about point x0,y0 along the z-axis

      real x1,y1,x0,y0,theta,xo,yo

      xo=(x1-x0)*cos(theta)-(y1-y0)*sin(theta)+x0
      yo=(x1-x0)*sin(theta)+(y1-y0)*cos(theta)+y0

      return
      end
c-----------------------------------------------------------------------
      subroutine flag_bndry(bcc,ifld,phi)
      implicit none
      include 'SIZE'
      include 'INPUT'

      character*3 bcc 
      integer ifld
      real phi(lx1,ly1,lz1,1)

      integer ie,ifc,i,i0,i1,j,j0,j1,k,k0,k1,n
 
      n=lx1*ly1*lz1*nelv
      call rzero(phi,n)

      do 10 ie=1,nelt
      do 10 ifc=1,ndim*2
        if(cbc(ifc,ie,ifld).eq.bcc) then
          call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,ifc)
          do 20 k=k0,k1
          do 20 j=j0,j1
          do 20 i=i0,i1
            phi(i,j,k,ie)=1.0
 20       continue
        endif
 10   continue
 
      return
      end
c-----------------------------------------------------------------------
      subroutine walltime(tfin)
      implicit none 
C
C     ends the run and dumps a restart file if the wall time is greater 
C     than tfin (in seconds)
C     CALL BEFORE AVG_ALL
C
      include 'SIZE'
      include 'TOTAL'
      include 'CTIMER'

      real time0,timenow,tfin,glmax
      save time0
      data time0 /0.0/

      if(istep.eq.0) then
        time0=dnekclock()
        return
      elseif(istep.gt.0) then
        if(nid.eq.0) then
          timenow=dnekclock()-time0
          if(tfin.lt.timenow) then
            write(6,*)"at wall time limit, last time step..."
            lastep=1
          endif
        endif
        call bcast(lastep,isize)
        if(lastep.eq.1) ifoutfld=.true.
      endif

      return
      end
c-----------------------------------------------------------------------
      subroutine surface_flux2(dq,q,e,f)

      include 'SIZE'
      include 'TOTAL'
      parameter (l=lx1*ly1*lz1)

      real q(l,1),w(lx1,ly1,lz1)
      integer e,f

      call           faccl4  (w,vx(1,1,1,e),q(1,e),unx(1,1,f,e),f)
      call           faddcl4 (w,vy(1,1,1,e),q(1,e),uny(1,1,f,e),f)
      if (if3d) call faddcl4 (w,vz(1,1,1,e),q(1,e),unz(1,1,f,e),f)

      call dsset(lx1,ly1,lz1)
      iface  = eface1(f)
      js1    = skpdat(1,iface)
      jf1    = skpdat(2,iface)
      jskip1 = skpdat(3,iface)
      js2    = skpdat(4,iface)
      jf2    = skpdat(5,iface)
      jskip2 = skpdat(6,iface)

      dq = 0
      i  = 0
      do 100 j2=js2,jf2,jskip2
      do 100 j1=js1,jf1,jskip1
         i = i+1
         dq    = dq + area(i,1,f,e)*w(j1,j2,1)
  100 continue

      return
      end
c-----------------------------------------------------------------------
      subroutine faccl4(a,b,c,d,iface1)
C
C     Collocate B with A on the surface IFACE1 of element IE.
C
C         A, B, and C are (NX,NY,NZ) data structures
C         D is a (NX,NY,IFACE) data structure
C         IFACE1 is in the preprocessor notation
C         IFACE  is the dssum notation.
C
      include 'SIZE'
      include 'TOPOL'
      DIMENSION A(LX1,LY1,LZ1),B(LX1,LY1,LZ1),C(LX1,LY1,LZ1),D(LX1,LY1)
C
C     Set up counters
C
      CALL DSSET(lx1,ly1,lz1)
      IFACE  = EFACE1(IFACE1)
      JS1    = SKPDAT(1,IFACE)
      JF1    = SKPDAT(2,IFACE)
      JSKIP1 = SKPDAT(3,IFACE)
      JS2    = SKPDAT(4,IFACE)
      JF2    = SKPDAT(5,IFACE)
      JSKIP2 = SKPDAT(6,IFACE)
C
      I = 0
      DO 100 J2=JS2,JF2,JSKIP2
      DO 100 J1=JS1,JF1,JSKIP1
         I = I+1
         A(J1,J2,1) = B(J1,J2,1)*C(J1,J2,1)*D(I,1)
  100 CONTINUE
C
      return
      end
c-----------------------------------------------------------------------
      subroutine faddcl4(a,b,c,d,iface1)
C
C     Collocate B with C and add to A on the surface IFACE1 of element
C     IE.
C
C         A is a (NX,NY,NZ) data structure
C         B is a (NX,NY,NZ) data structure
C         C is a (NX,NY,NZ) data structure
C         D is a (NX,NY,IFACE) data structure
C         IFACE1 is in the preprocessor notation
C         IFACE  is the dssum notation.
C         29 Jan 1990 18:00 PST   PFF
C
      include 'SIZE'
      include 'TOPOL'
      DIMENSION A(LX1,LY1,LZ1),B(LX1,LY1,LZ1),C(LX1,LY1,LZ1),D(LX1,LY1)
C
C     Set up counters
C
      CALL DSSET(lx1,ly1,lz1)
      IFACE  = EFACE1(IFACE1)
      JS1    = SKPDAT(1,IFACE)
      JF1    = SKPDAT(2,IFACE)
      JSKIP1 = SKPDAT(3,IFACE)
      JS2    = SKPDAT(4,IFACE)
      JF2    = SKPDAT(5,IFACE)
      JSKIP2 = SKPDAT(6,IFACE)
C
      I = 0
      DO 100 J2=JS2,JF2,JSKIP2
      DO 100 J1=JS1,JF1,JSKIP1
         I = I+1
         A(J1,J2,1) = A(J1,J2,1) + B(J1,J2,1)*C(J1,J2,1)*D(I,1)
  100 CONTINUE
C
      return
      end
c-----------------------------------------------------------------------
      subroutine loadmesh(string)
      implicit none
      include 'SIZE'
      include 'INPUT'
      include 'TSTEP'
      include 'RESTART'
    
      integer l,ltrunc
      real t_s
      character string*(*)
      character*132 initc_sav

      l=ltrunc(string,len(string))
      if(l.gt.130) call exitti('invalid string length$',l)

      initc_sav=initc(1)
      t_s=time
      call blank(initc(1),132)
      initc(1)=trim(string)//' X'
      call restart(1)
      initc(1)=initc_sav
      time=t_s
 
      return
      end
c-----------------------------------------------------------------------
      subroutine loadfld2(string)
      implicit none
      include 'SIZE'
      include 'INPUT'
      include 'TSTEP'
      include 'RESTART'
    
      integer l,ltrunc
      real t_s
      character string*(*)
      character*132 initc_sav

      l=ltrunc(string,len(string))
      if(l.gt.132) call exitti('invalid string length$',l)

      initc_sav=initc(1)
      t_s=time
      call blank(initc(1),132)
      initc(1)=trim(string)
      call restart(1)
      initc(1)=initc_sav
      time=t_s
 
      return
      end
c-----------------------------------------------------------------------
      subroutine dumpmesh

      implicit none

      include 'SIZE'
      include 'TOTAL'

      logical ifxyo_s,ifpo_s,ifvo_s,ifto_s,ifpsco_s(ldimt1)

      integer i

      ifxyo_s = ifxyo
      ifpo_s = ifpo
      ifvo_s = ifvo
      ifto_s = ifto
      do i=1,ldimt1
        ifpsco_s(i)=ifpsco(i)
      enddo

      ifxyo=.true.
      ifpo=.false.
      ifvo=.false.
      ifto=.false.
      do i=1,ldimt1
        ifpsco(i)=.false.
      enddo

      call prepost (.true.,'msh')

      ifxyo = ifxyo_s
      ifpo = ifpo_s
      ifvo = ifvo_s
      ifto = ifto_s
      do i=1,ldimt1
        ifpsco(i)=ifpsco_s(i)
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine dumpcfl

      implicit none

      include 'SIZE'
      include 'TOTAL'

      real DVC,DV1,DV2,DFC
      COMMON /SCRNS/ DVC  (LX1,LY1,LZ1,LELV),
     $               DV1  (LX1,LY1,LZ1,LELV),
     $               DV2  (LX1,LY1,LZ1,LELV),
     $               DFC  (LX1,LY1,LZ1,LELV)

      logical ifxyo_s,ifpo_s,ifvo_s,ifto_s,ifpsco_s(ldimt1)

      integer i,n
      real tsv(lx1,ly1,lz1,lelv),cdum,psv(lx2,ly2,lz2,lelv)

      n = lx1*ly1*lz1*nelv

      ifxyo_s = ifxyo
      ifpo_s = ifpo
      ifvo_s = ifvo
      ifto_s = ifto
      do i=1,ldimt1
        ifpsco_s(i)=ifpsco(i)
      enddo

      ifxyo=.true.
      ifpo=.false.
      ifvo=.false.
      ifto=.true.
      do i=1,ldimt1
        ifpsco(i)=.false.
      enddo

      if(ifsplit) then
        ifpo=.true.
        call copy(psv,pr,n)

c       call qthermal  !something wrong here
c       call add2 (qtl,usrdiv,n)
        call rzero(qtl,n)

        CALL OPDIV   (DVC,VX,VY,VZ)
        CALL DSSUM   (DVC,lx1,ly1,lz1)
        CALL COL2    (DVC,BINVM1,n)

        CALL SUB3    (DFC,DVC,QTL,n)
        CALL COL3    (pr,DFC,DFC,n)
      endif

      call copy(tsv,t,n)
      call compute_cfl(cdum,vx,vy,vz,dt)
      call copy(t,cflf,n)
      call prepost (.true.,'cfl')
      call copy(t,tsv,n)
      if(ifsplit) call copy(pr,psv,n)

      ifxyo = ifxyo_s
      ifpo = ifpo_s
      ifvo = ifvo_s
      ifto = ifto_s
      do i=1,ldimt1
        ifpsco(i)=ifpsco_s(i)
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine dumpmetrics

      implicit none

      include 'SIZE'
      include 'TOTAL'

      real DVC,DV1,DV2,DFC
      COMMON /SCRNS/ DVC  (LX1,LY1,LZ1,LELV),
     $               DV1  (LX1,LY1,LZ1,LELV),
     $               DV2  (LX1,LY1,LZ1,LELV),
     $               DFC  (LX1,LY1,LZ1,LELV)

      logical ifxyo_s,ifpo_s,ifvo_s,ifto_s,ifpsco_s(ldimt1)

      integer i,n
      real tsv(lx1*ly1*lz1*lelv,ldimt),cdum,psv(lx2,ly2,lz2,lelv)
      real wd(lx1*ly1*lz1*lelv)

      n = lx1*ly1*lz1*nelv

      ifxyo_s = ifxyo
      ifpo_s = ifpo
      ifvo_s = ifvo
      ifto_s = ifto
      do i=1,ldimt1
        ifpsco_s(i)=ifpsco(i)
      enddo

      ifxyo=.true.
      ifpo=.false.
      ifvo=.false.
      ifto=.true.
      ifpsco(1)=.true.
      do i=2,ldimt1
        ifpsco(i)=.false.
      enddo

      if(ifsplit) then
        ifpo=.true.
        call copy(psv,pr,n)

c       call qthermal  !something wrong here
c       call add2 (qtl,usrdiv,n)
        call rzero(qtl,n)

        CALL OPDIV   (DVC,VX,VY,VZ)
        CALL DSSUM   (DVC,lx1,ly1,lz1)
        CALL COL2    (DVC,BINVM1,n)

        CALL SUB3    (DFC,DVC,QTL,n)
        CALL COL3    (pr,DFC,DFC,n)
      endif

      call copy(tsv(1,1),t,n)
      call compute_cfl(cdum,vx,vy,vz,dt)
      call copy(t,cflf,n)

      call copy(tsv(1,2),t(1,1,1,1,2),n)
      call get_wall_distance(wd,2)
      call get_y_p(wd,t(1,1,1,1,2),.true.)
      
      call prepost (.true.,'mtr')
      call copy(t,tsv,n)
      call copy(t(1,1,1,1,2),tsv(1,2),n)
      if(ifsplit) call copy(pr,psv,n)

      ifxyo = ifxyo_s
      ifpo = ifpo_s
      ifvo = ifvo_s
      ifto = ifto_s
      do i=1,ldimt1
        ifpsco(i)=ifpsco_s(i)
      enddo

      return
      end
c-----------------------------------------------------------------------
      subroutine surface_area(sarea,e,f)

      include 'SIZE'
      include 'GEOM'
      include 'PARALLEL'
      include 'TOPOL'

      integer e,f

      call dsset(lx1,ly1,lz1)

      iface  = eface1(f)
      js1    = skpdat(1,iface)
      jf1    = skpdat(2,iface)
      jskip1 = skpdat(3,iface)
      js2    = skpdat(4,iface)
      jf2    = skpdat(5,iface)
      jskip2 = skpdat(6,iface)

      sarea = 0.
      i     = 0

      do 100 j2=js2,jf2,jskip2
      do 100 j1=js1,jf1,jskip1
         i = i+1
         sarea = sarea+area(i,1,f,e)
  100 continue

      return
      end
c-----------------------------------------------------------------------
      subroutine store_solution
      include 'SIZE'
      include 'INPUT'
      include 'SOLN'
      include 'TSTEP'

      real w1,w2,w3,w4,w5,tsv
      common /STORE/ w1(lx1*ly1*lz1*lelv)
     &              ,w2(lx1*ly1*lz1*lelv)
     &              ,w3(lx1*ly1*lz1*lelv)
     &              ,w4(lx2*ly2*lz2*lelv)
     &              ,w5(lx1*ly1*lz1*lelv,ldimt)
     &              ,tsv

      n1=lx1*ly1*lz1*nelv
      n2=lx2*ly2*lz2*nelv
      nt=lx1*ly1*lz1*nelt

      call copy(w1,vx,n1)
      call copy(w2,vy,n1)
      if(if3d) call copy(w3,vz,n1)
      call copy(w4,pr,n2)
      do i=1,ldimt
        call copy(w5(1,i),t(1,1,1,1,i),nt)
      enddo
      tsv=time

      return
      end
c-----------------------------------------------------------------------
      subroutine reload_solution
      include 'SIZE'
      include 'INPUT'
      include 'SOLN'
      include 'TSTEP'

      real w1,w2,w3,w4,w5,tsv
      common /STORE/ w1(lx1*ly1*lz1*lelv)
     &              ,w2(lx1*ly1*lz1*lelv)
     &              ,w3(lx1*ly1*lz1*lelv)
     &              ,w4(lx2*ly2*lz2*lelv)
     &              ,w5(lx1*ly1*lz1*lelv,ldimt)
     &              ,tsv

      n1=lx1*ly1*lz1*nelv
      n2=lx2*ly2*lz2*nelv
      nt=lx1*ly1*lz1*nelt

      call copy(vx,w1,n1)
      call copy(vy,w2,n1)
      if(if3d) call copy(vz,w3,n1)
      call copy(pr,w4,n2)
      do i=1,ldimt
        call copy(t(1,1,1,1,i),w5(1,i),nt)
      enddo
      time=tsv

      return
      end
c-----------------------------------------------------------------------
