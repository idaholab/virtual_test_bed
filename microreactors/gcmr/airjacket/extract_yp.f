c-----------------------------------------------------------------------
      subroutine print_yplimits(ypout,walldist)
      include 'SIZE'
      include 'TOTAL'
 

      integer lxyze
      parameter(lxyze=lx1*ly1*lz1*lelv)
 
C     Primitive Variables
      real umin,umax,vmin,vmax,wmin,wmax,pmin,pmax
      real hmin,hmax,kmin,kmax,mmin,mmax
      real rmsu,rmsv,rmsw,rmsp,rmsh,rmsk,rmsm
      real du,dv,dw,dp,dh,dk,dm
 
C     other variables
      real vfmin,vfmax,tempmin,tempmax,mumin,mumax
      real ypmin,ypmax
      real ypout(lx1*ly1*lz1*lelv)
      real walldist(lx1,ly1,lz1,lelv)
 
      integer n
 
      n=nx1*ny1*nz1*nelv

      call rzero(walldist,n)
 
      call cheap_dist(walldist,1,'W  ')
      call y_p_lims(walldist,ypmin,ypmax,ypout)
 
      if(nid.eq.0) then
        write(*,255) 'y+ min/max:',ypmin,ypmax
      endif
 
 255  format(2x,a16,2es15.5)

      return
      end
c----------------------------------------------------------------------
      subroutine y_p_lims(wd,ypmin,ypmax,ypout)
      include 'SIZE'
      include 'TOTAL'

      integer lxyz,lxyze
      parameter(lxyz=lx1*ly1*lz1,lxyze=lxyz*lelv)
      integer e,i,i0,i1,j,j0,j1,k,k0,k1,iw,jw,kw,i2
      integer ipoint,wpoint
      real gradu(lxyze,3,3),dens(1),visc(1),wd(1)
      real tau(3),norm(3),rho,mu,vsca,tauw,yp,utau
      real n_points_wall,n_less_than_one,n_less_than_five
      real totalAA,singleAA
      real ypout(lxyze)


      call rzero(ypout,lxyz*nelv)
      totalAA = 0.0
      singleAA = 0.0

      n_points_wall = 0.0
      n_less_than_one = 0.0
      n_less_than_five = 0.0
 
      ypmin=1.0d30
      ypmax=-1.0d30
 
      call gradm1(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3),vx)
      call gradm1(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3),vy)
      call gradm1(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3),vz)
 
      call opcolv(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3),bm1)
      call opcolv(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3),bm1)
      call opcolv(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3),bm1)
 
      call opdssum(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3))
      call opdssum(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3))
      call opdssum(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3))
 
      call opcolv(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3),binvm1)
      call opcolv(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3),binvm1)
      call opcolv(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3),binvm1)
 
      do e=1,nelv
        do iside=1,2*ldim
          if(cbc(iside,e,1).eq.'W  ')then
            i0=1
            j0=1
            k0=1
            i1=lx1
            j1=ly1
            k1=lz1
            if(iside.eq.1) then
              j0=2
              j1=2
            elseif(iside.eq.2) then
              i0=lx1-1
              i1=lx1-1
            elseif(iside.eq.3) then
              j0=ly1-1
              j1=ly1-1
            elseif(iside.eq.4) then
              i0=2
              i1=2
            elseif(iside.eq.5) then
              k0=2
              k1=2
            elseif(iside.eq.6) then
              k0=lz1-1
              k1=lz1-1
            endif
            do i=i0,i1
              do j=j0,j1
              do k=k0,k1
                iw=i
                jw=j
                kw=k
                if    (iside.eq.1) then
                  jw=1
                  norm(1)=unx(iw,kw,iside,e)
                  norm(2)=uny(iw,kw,iside,e)
                  norm(3)=unz(iw,kw,iside,e)
                  singleAA = area(iw,kw,iside,e)
                elseif(iside.eq.2) then
                  iw=lx1
                  norm(1)=unx(jw,kw,iside,e)
                  norm(2)=uny(jw,kw,iside,e)
                  norm(3)=unz(jw,kw,iside,e)
                  singleAA = area(jw,kw,iside,e)
                elseif(iside.eq.3) then
                  jw=ly1
                  norm(1)=unx(iw,kw,iside,e)
                  norm(2)=uny(iw,kw,iside,e)
                  norm(3)=unz(iw,kw,iside,e)
                  singleAA = area(iw,kw,iside,e)
                elseif(iside.eq.4) then
                  iw=1
                  norm(1)=unx(jw,kw,iside,e)
                  norm(2)=uny(jw,kw,iside,e)
                  norm(3)=unz(jw,kw,iside,e)
                  singleAA = area(jw,kw,iside,e)
                elseif(iside.eq.5) then
                  kw=1
                  norm(1)=unx(iw,jw,iside,e)
                  norm(2)=uny(iw,jw,iside,e)
                  norm(3)=unz(iw,jw,iside,e)
                  singleAA = area(iw,jw,iside,e)
                else
                  kw=lx1
                  norm(1)=unx(iw,jw,iside,e)
                  norm(2)=uny(iw,jw,iside,e)
                  norm(3)=unz(iw,jw,iside,e)
                  singleAA = area(iw,jw,iside,e)
                endif
                  ipoint=i+(j-1)*lx1+(k-1)*lx1*ly1+(e-1)*lxyz
                  wpoint=iw+(jw-1)*lx1+(kw-1)*lx1*ly1+(e-1)*lxyz
c                 if(iflomach) then
c                   mu=visc(wpoint)
c                   rho=dens(wpoint)
c                 else
                    mu=param(2)
                    rho=param(1)
c                endif
 
                 do i2=1,ldim
                   tau(i2)=0.0
                 do j2=1,ldim
                   tau(i2)=tau(i2)+
     &             mu*(gradu(wpoint,i2,j2)+gradu(wpoint,j2,i2))*norm(j2)
                 enddo
               enddo
 
               vsca=0.0
               do i2=1,ldim
                 vsca=vsca+tau(i2)*norm(i2)
               enddo
 
               tauw=0.0
               do i2=1,ldim
                 tauw=tauw+(tau(i2)-vsca*norm(i2))**2
               enddo
               tauw=sqrt(tauw)
               utau=sqrt(tauw/rho)
               yp=wd(ipoint)*utau*rho/mu
               ypout(ipoint) = yp

c             STORES YPLUS IN YPOUT FIELD
c               do iix=1,lx1
c                 do iiy=1,lx1
c                   do iiz=1,lx1
c                     ypout(iw,jw,kw,e)=yp
c                   enddo
c                 enddo
c               enddo

              if(yp.gt.0) ypmin=min(ypmin,yp)
              ypmax=max(ypmax,yp)
 
              n_points_wall = n_points_wall + 1.0
              if(yp.le.1.0) n_less_than_one = n_less_than_one + 1.0
              if(yp.le.5.0) n_less_than_five= n_less_than_five+ 1.0
 
              totalAA = totalAA + singleAA
            enddo
            enddo
            enddo
          endif
        enddo
      enddo
      ypmin=glmin(ypmin,1)
      ypmax=glmax(ypmax,1)
 
      n_points_wall = glsum(n_points_wall,1)
      n_less_than_one = glsum(n_less_than_one,1)
      n_less_than_five = glsum(n_less_than_five,1)
      totalAA = glsum(totalAA,1)
 
      if (nid.eq.0) write(6,*) "n_points_wall is :",n_points_wall
      if (nid.eq.0) write(6,*) "n_less_than_one is :",n_less_than_one
      if (nid.eq.0) write(6,*) "n_less_than_five is :",n_less_than_five
 
      ratio = n_less_than_one/n_points_wall
      if (nid.eq.0) write(6,*) "ratio less than 1.0 is :",ratio
      ratio = n_less_than_five/n_points_wall
      if (nid.eq.0) write(6,*) "ratio less than 5.0 is :",ratio
 
      if (nid.eq.0) write(6,*) "total wetted area is: ", totalAA
 
      return
      end
 
c-----------------------------------------------------------------------
