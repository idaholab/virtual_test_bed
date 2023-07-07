c-----------------------------------------------------------------------
      real function bulkavg(qty,vi,mask)

c calculate volumetric average qty in the range of x/y/z given by the points
c ptmin and ptmax along velocity componenty vi
      implicit none
      include 'SIZE'
      include 'TOTAL'

      real qty(lx1,ly1,lz1,lelt)
      real vi(lx1,ly1,lz1,lelt)
      real mask(lx1,ly1,lz1,lelt)

      integer i
      real volavg,lvol
      real glsum

      volavg = 0.0
      lvol = 0.0

      do i=1,lx1*ly1*lz1*nelt
       volavg = volavg + (qty(i,1,1,1)*
     $       bm1(i,1,1,1)*vi(i,1,1,1)*mask(i,1,1,1))
       lvol = lvol + bm1(i,1,1,1)*vi(i,1,1,1)*mask(i,1,1,1)
      enddo

      volavg = glsum(volavg,1)
      lvol = glsum(lvol,1)

      bulkavg = volavg/lvol

      return
      end
c-----------------------------------------------------------------------
      subroutine emap_sideset(emap,sslb,ssub)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      integer sslb,ssub

      integer ei, fi, ntot, emapctr, bid

      real one(lx1*ly1*lx1*lelt)
      real glsum,facint_v
      integer iglsum

      real roiar

      ntot = lx1*ly1*lz1*nelt

      call rone(one,ntot)
      call izero(emap,nelt)

      roiar = 0.0
      emapctr = 0

      if(nio.eq.0) write(*,*) "Finding all elements b/w sidesets:",
     $                       sslb,ssub

      do ei=1,nelt
        do fi=1,ndim*2
         bid = boundaryID(fi,ei)
         if((bid.ge.sslb).and.(bid.le.ssub)) then
           emap(ei) = fi
           roiar    = roiar + facint_v(one,area,fi,ei)
           emapctr  = emapctr + 1
         endif
        enddo
      enddo

      roiar = glsum(roiar,1)
      emapctr = iglsum(emapctr,1)

      if (roiar.eq.0.0) then
       if(nio.eq.0) then
        write(*,*) "No valid sideset provided in emap_bc.Exiting..."
       endif
       call exit(0)
      else
       if(nio.eq.0) then
        write(*,1) sslb,ssub
        write(*,2) emapctr
        write(*,3) roiar
       endif
      endif

1     format(i8,i8,': sideset map lower/upper bound')
2     format(i8,': sideset map element count')
3     format(1p1e16.8,': sideset map area')

      return
      end
c-----------------------------------------------------------------------
      subroutine find_nearest_face(f_near,f1,f2,coord,xyz1,xyz2)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer f_near, e, f1, f2
      real coord
      real xyz1,xyz2
      real fdist1, fdist2

      fdist1 = abs(xyz1-coord)
      fdist2 = abs(xyz2-coord)
      f_near = f1
      if (fdist2<fdist1) f_near = f2

      return
      end

c-----------------------------------------------------------------------
      real function dist_2d(x1,y1,x2,y2)

      implicit none
      real x1,y1,x2,y2

      dist_2d = (x1-x2)**2 + (y1-y2)**2
      if (dist_2d.gt.0) dist_2d = sqrt(dist_2d)

      return
      end
c-----------------------------------------------------------------------
      real function dist_3d(x1,y1,z1,x2,y2,z2)

      implicit none
      real x1,y1,z1,x2,y2,z2

      dist_3d = (x1-x2)**2 + (y1-y2)**2 + (z1-z2)**2
      if (dist_3d.gt.0) dist_3d = sqrt(dist_3d)

      return
      end
c-----------------------------------------------------------------------
      real function vecmag(vec,n)

      implicit none
      real vec(1)
      integer i,n

      real temp

      vecmag = 0.0
      do i = 1,n
        vecmag = vecmag + (vec(i)*vec(i))
      enddo

      if (vecmag.gt.0) vecmag = sqrt(vecmag)

      return
      end
c-----------------------------------------------------------------------
      real function plane_distance_to_point(pt,pt0,norm)

      implicit none
      real pt(3),pt0(3),norm(3)
      real num,denom

      num = norm(1)*(pt(1)-pt0(1)) +norm(2)*(pt(2)-pt0(2)) +
     $        norm(3)*(pt(3)-pt0(3))
      denom = (norm(1)**2) + (norm(2)**2) + (norm(3)**2)
      if (denom.gt.0.0) denom = sqrt(denom)
      if (denom.eq.0.0) then
        write(*,*) "Invalid normal in plane_distance_to_point. Abort.."
        call exit(0)
      endif

      plane_distance_to_point = num/denom

      return
      end
c-----------------------------------------------------------------------
      subroutine face_normal(norm,e,f)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      real norm(3)
      integer e,f

      real ones(lx1,ly1,6,lelt)
      real facint_a
      call rone(ones,lx1*ly1*6*nelt)

      norm(1) = facint_a(unx,area,f,e)/facint_a(ones,area,f,e)
      norm(2) = facint_a(uny,area,f,e)/facint_a(ones,area,f,e)
      norm(3) = facint_a(unz,area,f,e)/facint_a(ones,area,f,e)

      return
      end
c-----------------------------------------------------------------------
      subroutine point_in_range(flag,pt,ptmin,ptmax)

      implicit none
      real pt(3),ptmin(3),ptmax(3)
      logical flag

      flag = .false.

      if((pt(1).ge.ptmin(1)).and.(pt(1).le.ptmax(1)).and.
     $ (pt(2).ge.ptmin(2)).and.(pt(2).le.ptmax(2)).and.
     $ (pt(3).ge.ptmin(3)).and.(pt(3).le.ptmax(3))) then
        flag = .true.
      endif

      return
      end
c-----------------------------------------------------------------------
      subroutine emap_centre(emapxyz,emap)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      real emapxyz(3)
      integer emap(lelt)

      integer e,f

      real xm,ym,zm,xx,yy,zz
      integer ctr
      real glsum
      integer iglsum

      xm = 0.0
      ym = 0.0
      zm = 0.0

      ctr = 0

      call rzero(emapxyz,3)

      do e=1,nelt
       do f=1,ndim*2
        if (emap(e).gt.0) then
           call get_face_m1centroid(xx,yy,zz,e,f)
           xm = xm + xx
           ym = ym + yy
           zm = zm + zz
           ctr = ctr + 1
        endif
       enddo
      enddo

      xm = glsum(xm,1)
      ym = glsum(ym,1)
      zm = glsum(zm,1)
      ctr = iglsum(ctr,1)

      emapxyz(1) = xm/ctr
      emapxyz(2) = ym/ctr
      emapxyz(3) = zm/ctr

      return
      end
c-----------------------------------------------------------------------
      subroutine emap_nsurf(emap,emapxyz,normal,ptmin,ptmax)
c     creates an element-face map/mask that stores for each local element
c     that has its centroid within the xyz min/max values specified by
c     `ptmin`, `ptmax`, the face ID that lies along the normal specified by
c     `normal`  `emap` stores 0 for elements that lie outside this range
c      and the face ID (between 1-6) for elements that don't. `emapxyz`
c      has the element map centroid. you can test which elements you
c      selected using the `test_emap` subroutine.

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      real emapxyz(3)
      real ptmin(3),ptmax(3)
      real normal(3)

      integer e,f,foi1,foi2,foi,ectr,ntot
      real emid(3)
      real one(lx1*ly1*lx1*lelt)
      real foix1,foiy1,foiz1
      real foix2,foiy2,foiz2
      real dist1, dist2
      real theta,maxtheta,mag1,mag2,dotprod,fnorm(3)
      logical eflag

      real glsum,vecmag
      integer iglsum

      ectr = 0
      foi = 99
      ntot = lx1*ly1*lz1*nelt
      call rone(one,ntot)
      call izero(emap,nelt)

      ectr = 0
      do e=1,nelt
       call get_elem_m1centroid(emid(1),emid(2),emid(3),e)
c      checking if the centroid is in the xyz range
       call point_in_range(eflag,emid,ptmin,ptmax)
       if (eflag) then
          maxtheta = 1.0e+10
          do f=1,ndim*2
            call face_normal(fnorm,e,f)
            dotprod = normal(1)*fnorm(1) +normal(2)*fnorm(2)
     $             +normal(3)*fnorm(3)
            mag1 = vecmag(normal,3)
            mag2 = vecmag(fnorm,3)
            theta = acos(dotprod/mag1/mag2)
           if (theta.le.maxtheta) then
             foi = f
             maxtheta = theta
           endif
          enddo
          emap(e) = foi
          ectr = ectr + 1
       endif

      enddo

      ectr = iglsum(ectr,1)

      if (ectr.eq.0) then
       write(*,*) "ERROR: No elements near given coordinate/tolerance"
       call exit(0)
      endif

      call emap_centre(emapxyz,emap)

      if (nio.eq.0) then
         write(*,3) emapxyz(1),emapxyz(2),emapxyz(3)
         write(*,4) maxtheta
         write(*,5) ectr
      endif

3     format(1p3e16.8,': sideset map xyz coordinates')
4     format(1p1e16.8,': maxtheta')
5     format(i8,': sideset map element count')

      return
      end

c-----------------------------------------------------------------------
      real function emap_avg(qty,emap)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      real qty(lx1,ly1,lz1,lelt)
      real maparea, qtyintegral
      real one(lx1*ly1*lz1*lelt)
      integer e
      real glsum,facint_v

      maparea = 0.0
      qtyintegral = 0.0
      call rone(one,lx1*ly1*lz1*nelt)

      do e=1,nelt
       if (emap(e).gt.0) then
         qtyintegral = qtyintegral  + facint_v(qty,area,emap(e),e)
         maparea = maparea + facint_v(one,area,emap(e),e)
       endif
      enddo

      qtyintegral= glsum(qtyintegral,1)
      maparea = glsum(maparea,1)

      emap_avg = qtyintegral/maparea

      return
      end
c-----------------------------------------------------------------------
      real function emap_area(emap)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      real one(lx1,ly1,lz1,lelt)
      real maparea
      integer e
      real glsum,facint_v

      maparea = 0.0
      call rone(one,lx1*ly1*lz1*nelt)

      do e=1,nelt
       if (emap(e).gt.0) then
         maparea = maparea + facint_v(one,area,emap(e),e)
       endif
      enddo

      maparea = glsum(maparea,1)

      emap_area = maparea

      return
      end
c-----------------------------------------------------------------------
      real function emap_scalar_avg(qty,vi,emap,divopt)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      real qty(lx1,ly1,lz1,lelt)
      real vi(lx1,ly1,lz1,lelt)
      integer divopt
      real denom, qintegral
      integer e,ia
      integer js1,js2,jf1,jf2,jskip1,jskip2,j1,j2
      real glsum,facint_v

      denom = 0.0
      qintegral = 0.0

      do e=1,nelt
       if (emap(e).gt.0) then
         call facind2(js1,jf1,jskip1,js2,jf2,jskip2,emap(e))
         ia = 0
         do j2 = js2,jf2,jskip2
         do j1 = js1,jf1,jskip1
           ia = ia + 1
           qintegral = qintegral + ( qty(j1,j2,1,e) * vi(j1,j2,1,e)
     $                     * area(ia,1,emap(e),e) )
         enddo
         enddo
         denom = denom + facint_v(vi,area,emap(e),e)
       endif
      enddo

      qintegral= glsum(qintegral,1)
      denom = glsum(denom,1)

      emap_scalar_avg = qintegral
      if(divopt.gt.0) emap_scalar_avg = qintegral/denom

      return
      end
c-----------------------------------------------------------------------
      subroutine test_emap(emap,label)

c  Writes ones at GLL points indicated by emap & fid to vx array
c  to a file map<casename>0.f00001

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      character label(3)
      integer e,js1,jf1,jskip1,js2,jf2,jskip2,ia,j1,j2

      call rzero(vx,lx1*ly1*lz1*nelt)

      do e = 1,nelt
       if (emap(e).gt.0) then
        call facind2(js1,jf1,jskip1,js2,jf2,jskip2,emap(e))
        ia = 0
        do j2=js2,jf2,jskip2
        do j1=js1,jf1,jskip1
          ia = ia + 1
          vx(j1,j2,1,e) = 1.0
        enddo
        enddo
       endif
      enddo

      call outpost(vx,vy,vz,pr,t,label)

      return
      end
c-----------------------------------------------------------------------

      subroutine sideset_centre(ssid,xxc,yyc,zzc)  ! finds centre of sideset with ID ssid

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer ssid,ntot,bid,ei,fi
      real xxc, yyc, zzc, ssar
      real ones(lx1,ly1,lz1,lelt)
      real glsum,facint_v

      ntot = lx1*ly1*lz1*nelt
      call rone(ones,ntot)

      xxc = 0.0
      yyc = 0.0
      zzc = 0.0
      ssar = 0.0

      do ei = 1,nelt
        do fi = 1,2*ndim
          bid = boundaryID(fi,ei)
          if (bid.eq.ssid) then
             xxc = xxc + facint_v(xm1,area,fi,ei)
             yyc = yyc + facint_v(ym1,area,fi,ei)
             zzc = zzc + facint_v(zm1,area,fi,ei)
             ssar = ssar + facint_v(ones,area,fi,ei)
           endif
        enddo
      enddo

      xxc = glsum(xxc,1)
      yyc = glsum(yyc,1)
      zzc = glsum(zzc,1)
      ssar = glsum(ssar,1)

      xxc = xxc/ssar
      yyc = yyc/ssar
      zzc = zzc/ssar

      return
      end
c-----------------------------------------------------------------------

      subroutine emap_bounds(ptmin,ptmax,emap)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer emap(lelt)
      real ptmin(3),ptmax(3)
      real xmin,xmax,ymin,ymax,zmin,zmax
      integer j1,j2,js1,js2,jf1,jf2,jskip1,jskip2,ei
      real xx,yy,zz

      real glmin,glmax
      call rzero(ptmin,3)
      call rzero(ptmax,3)

      call domain_size(xmax,xmin,ymax,ymin,zmax,zmin)  ! flipped max, min locations
      xmin = xmin + 10.0
      ymin = ymin + 10.0
      zmin = zmin + 10.0
      xmax = xmax - 10.0
      ymax = ymax - 10.0
      zmax = zmax - 10.0

      do ei = 1,nelt
      if(emap(ei).gt.0) then
       call facind2 (js1,jf1,jskip1,js2,jf2,jskip2,emap(ei))
       do j2=js2,jf2,jskip2
       do j1=js1,jf1,jskip1
        xx=xm1(j1,j2,1,ei)
        yy=ym1(j1,j2,1,ei)
        zz=zm1(j1,j2,1,ei)
        if(xx.lt.xmin) xmin = xx
        if(xx.gt.xmax) xmax = xx
        if(yy.lt.ymin) ymin = yy
        if(yy.gt.ymax) ymax = yy
        if(zz.lt.zmin) zmin = zz
        if(zz.gt.zmax) zmax = zz
       enddo
       enddo
      endif
      enddo

      ptmin(1) = glmin(xmin,1)
      ptmin(2) = glmin(ymin,1)
      if(ndim.eq.3) ptmin(3) = glmin(zmin,1)

      ptmax(1) = glmax(xmax,1)
      ptmax(2) = glmax(ymax,1)
      if(ndim.eq.3) ptmax(3) = glmax(zmax,1)

      return
      end
c-----------------------------------------------------------------------
      subroutine create_mask(mask,ptmin,ptmax)

      implicit none
      include 'SIZE'
      include 'TOTAL'

      real mask(lx1,ly1,lz1,lelt)
      real ptmin(3),ptmax(3)
      integer i,ntot
      real xx,yy,zz

      ntot = lx1*ly1*lz1*nelt
      call rzero(mask,ntot)

      do i = 1,ntot
      xx = xm1(i,1,1,1)
      yy = ym1(i,1,1,1)
      zz = zm1(i,1,1,1)
       if(xx.le.ptmax(1).and.xx.ge.ptmin(1)) then
       if(yy.le.ptmax(2).and.yy.ge.ptmin(2)) then
       if(zz.le.ptmax(3).and.zz.ge.ptmin(3)) then
        mask(i,1,1,1) = 1.0
       endif
       endif
       endif
      enddo

      return
      end
c-----------------------------------------------------------------------
      real function calc_dh()

      include 'SIZE'
      include 'TOTAL'

      real wetp,wetarea,ones(lx1,ly1,lz1,lelv)
      integer n,iel,ifc,id_face

      n = lx1*ly1*lz1*nelv

      wetp = 0.0
      wetarea = 0.0
      call rone(ones,n)

      do iel=1,nelv
      do ifc=1,2*ndim
        if(cbc(ifc,iel,1).eq.'W  ') then
          wetp = wetp + facint_v(ones,area,ifc,iel)
         endif
      enddo
      enddo

      wetp = glsum(wetp,1)
      wetarea = glsum(bm1,n)

      Dh = wetarea/wetp

      if (nio.eq.0) write(*,*) "WETP:",wetp
      if (nio.eq.0) write(*,*) "WETAREA:",wetarea
      if (nio.eq.0) write(*,*) "HYDRAULIC DIA:",Dh

      calc_dh = Dh

      return
      end
C-----------------------------------------------------------------------
