C-----------------------------------------------------------------------
      subroutine get_limits(phi,phimin,phimax,phiave,dphi,phip,rmsphi,n)
      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer i,n,ntot,iglsum,n1,n2,nt
      real phi(1),phip(1),phimin,phimax,phiave,dphi,rmsphi
      real glmin,glmax,glsc2,glsum
      logical ifm2

      n1=lx1*ly1*lz1*nelv
      n2=lx2*ly2*lz2*nelv

      ifm2=.false.
      ntot=lx1*ly1*lz1*nelgv
      if(n.ne.n1) then
        ifm2=.true.
        ntot=lx2*ly2*lz2*nelgv
      endif

      rmsphi=0.0
      dphi=0.0
      if(istep.ge.1) then
        do i=1,n
          dphi=max(dphi,abs(phip(i)-phi(i)))
          rmsphi=rmsphi+(phip(i)-phi(i))**2
        enddo
        rmsphi=glsum(rmsphi,1)
        rmsphi=sqrt(rmsphi/real(ntot))/dt
      endif
      dphi=glmax(dphi,1)
      dphi=dphi/dt

      phimin=glmin(phi,n)
      phimax=glmax(phi,n)

      if(ifm2) then
        phiave=glsc2(phi,bm2,n2)/volvm2
      else
        phiave=glsc2(phi,bm1,n1)/volvm1 
      endif

      return
      end
C-----------------------------------------------------------------------
      subroutine get_limits_nodt(phi,phimin,phimax,phiave,n)
      implicit none
      include 'SIZE'
      include 'TOTAL'

      integer n
      real phi(1),phimin,phimax,phiave
      real glmin,glmax,glsc2

      phimin=glmin(phi,n)
      phimax=glmax(phi,n)
      phiave=glsc2(phi,bm1,n)/volvm1

      return
      end
c-----------------------------------------------------------------------
      subroutine max_y_p(wd)
      implicit none
      include 'SIZE'
      include 'TOTAL'

      real wd(nx1,ny1,nz1,nelv)
      integer e,isd,i,i0,i1,j,j0,j1,k,k0,k1
      integer n
      real msk(lx1,ly1,lz1,lelv)
      real dwmax,dwmin,glmin,glmax

      n=nx1*ny1*nz1*nelv

      dwmax=-1.0d30
      dwmin=1.0d30

      call rone(msk,nx1*ny1*nz1*nelv)
      do e=1,nelv
        do isd=1,2*ndim
          if(cbc(isd,e,1).eq.'W  ') then
            call backpts(i0,i1,j0,j1,k0,k1,isd)
            do k=k0,k1
            do j=j0,j1
            do i=i0,i1
              msk(i,j,k,e)=0.0
            enddo
            enddo
            enddo
          endif
        enddo
        do isd=1,2*ndim
          if(cbc(isd,e,1).eq.'W  ') then
            call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,isd)
            do k=k0,k1
            do j=j0,j1
            do i=i0,i1
              msk(i,j,k,e)=1.0
            enddo
            enddo
            enddo
          endif
        enddo
      enddo
      call dssum(msk,nx1,ny1,nz1) !for elements with edges but not faces along a wall

      do i=1,n
        if(msk(i,1,1,1).lt.0.5)then
          dwmax=max(dwmax,wd(i,1,1,1))
          dwmin=min(dwmin,wd(i,1,1,1))
        endif
      enddo

      dwmax=glmax(dwmax,1)
      dwmin=glmin(dwmin,1)
      if(nid.eq.0) then
        write(*,256) 'maximum y_p = ',dwmax
        write(*,256) 'minimum y_p = ',dwmin
        write(*,*)
      endif
 256  format(2x,a,es15.5)

      return
      end
C-----------------------------------------------------------------------
      subroutine y_p_limits(wd,ifdef)
      implicit none
      include 'SIZE'
      include 'TOTAL'
C
C     NOTE: min value should work if domain has internal corners
C
      logical ifdef,ifut,iftl,ifpsp(ldimt-1)
      common /y_p_print/ ifut,iftl,ifpsp

      character*15 pname
      integer e,i,i0,i1,j,j0,j1,k,k0,k1,iw,jw,kw,i2,j2
      integer ipt,wpt,estrd,isd,ifld
      real msk(lx1,ly1,lz1,lelv)
      real gradu(lx1*ly1*lz1,3,3),wd(1)
      real tau(3),norm(3),vsca,tauw
      real utau,rho,mu,lambda,cp,Pra,yp,tl,psp,Sc(ldimt-1)
      real ypmin,ypmax,ypave,vol,utmin,utmax,utave,tlmin,tlmax,tlave
      real spmin(ldimt-1),spmax(ldimt-1),spave(ldimt-1)
      real glmin,glmax,glsum
      logical ifgrad, ifdid

      data ifdid /.false./
      save ifdid, msk

C     do some initializations once
      if(.not.ifdid)then

C       set flags for values to calculate and print
        ifdid=.true.
        if(ifdef)then
          ifut=.true.
          if(if3d) ifut=.false.
          iftl=.false.
          if(ifheat.and.(idpss(1).ge.0))iftl=.true.
          do i=1,ldimt-1
            ifpsp(i)=.false.
          enddo
        endif

C       build the mask  (this mask ignores some points which maybe important... 
        call rone(msk,nx1*ny1*nz1*nelv)    ! need to look at it more closely)
        do e=1,nelv
          do isd=1,2*ndim
            if(cbc(isd,e,1).eq.'W  ') then
              call backpts(i0,i1,j0,j1,k0,k1,isd)
              do k=k0,k1
              do j=j0,j1
              do i=i0,i1
                msk(i,j,k,e)=0.0
              enddo
              enddo
              enddo
            endif
          enddo
          do isd=1,2*ndim
            if(cbc(isd,e,1).eq.'W  ') then
              call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,isd)
              do k=k0,k1
              do j=j0,j1
              do i=i0,i1
                msk(i,j,k,e)=1.0
              enddo
              enddo
              enddo
            endif
          enddo
        enddo
        call dssum(msk,nx1,ny1,nz1) !for elements with edges but not faces along a wall
      endif

C     initialize the variables AFTER the flags are set
      ypmin=1.0d30
      ypmax=-1.0d30
      ypave=0.0
      utmin=1.0d30
      utmax=-1.0d30
      utave=0.0
      tlmin=1.0e30
      tlmax=-1.0e30
      tlave=0.0
      do ifld=1,ldimt-1
        if(ifpsp(ifld))then
          spmin(ifld)=1.0e30
          spmax(ifld)=-1.0e30
          spave(ifld)=0.0
        endif
      enddo
      vol=0.0

C     Now do the thing
      do e=1,nelv
        ifgrad=.true.
        do isd=1,2*ndim
          if(cbc(isd,e,1).eq.'W  ')then
            estrd=(e-1)*nx1*ny1*nz1
            if(ifgrad)then
              call gradm11(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3),vx,e)
              call gradm11(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3),vy,e)
              if(if3d)
     &         call gradm11(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3),vz,e)
              ifgrad=.false.
            endif
            call backpts(i0,i1,j0,j1,k0,k1,isd)
            do k=k0,k1
            do j=j0,j1
            do i=i0,i1
              if(msk(i,j,k,e).lt.0.5) then
                iw=i
                jw=j
                kw=k
                if    (isd.eq.1) then
                  jw=1
                elseif(isd.eq.2) then
                  iw=nx1
                elseif(isd.eq.3) then
                  jw=ny1
                elseif(isd.eq.4) then
                  iw=1
                elseif(isd.eq.5) then
                  kw=1
                else
                  kw=nx1
                endif
                call getSnormal(norm,iw,jw,kw,isd,e)
                ipt=i +(j -1)*nx1+(k -1)*nx1*ny1
                wpt=iw+(jw-1)*nx1+(kw-1)*nx1*ny1

                mu=vdiff(iw,jw,kw,e,1)
                rho=vtrans(iw,jw,kw,e,1)
                Pra=1.0
                if(iftl) then
                  lambda=vdiff(iw,jw,kw,e,2)
                  cp=vtrans(iw,jw,kw,e,2)/rho
                  Pra=cp*mu/lambda
                endif
                do ifld=3,ldimt+1
                  if(ifpsp(ifld-2))then
                    Sc(ifld-2)=vtrans(iw,jw,kw,e,ifld)*mu/(rho*
     &                                           vdiff(iw,jw,kw,e,ifld))
                  endif
                enddo

                do i2=1,ldim
                tau(i2)=0.0
                  do j2=1,ldim
                    tau(i2)=tau(i2)+
     &                   mu*(gradu(wpt,i2,j2)+gradu(wpt,j2,i2))*norm(j2)
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
                yp=wd(ipt+estrd)*utau*rho/mu
                ypmin=min(ypmin,yp)
                ypmax=max(ypmax,yp)
                ypave=ypave+yp*bm1(i,j,k,e)
                vol=vol+bm1(i,j,k,e)
                if(ifut)then
                  utmin=min(utau,utmin)
                  utmax=max(utau,utmax)
                  utave=utave+utau*bm1(i,j,k,e)
                endif
                if(iftl)then
                  tl=yp*Pra
                  tlmin=min(tlmin,tl)
                  tlmax=max(tlmax,tl)
                  tlave=tlave+tl*bm1(i,j,k,e)
                endif
                do ifld=1,ldimt-1
                  if(ifpsp(ifld))then
                    psp=yp*Sc(ifld)
                    spmin(ifld)=min(spmin(ifld),psp)
                    spmax(ifld)=max(spmax(ifld),psp)
                    spave(ifld)=spave(ifld)+psp*bm1(i,j,k,e)
                  endif
                enddo
              endif
            enddo
            enddo
            enddo
          endif
        enddo
      enddo

      ypmin=glmin(ypmin,1)
      ypmax=glmax(ypmax,1)
      ypave=glsum(ypave,1)
      vol=glsum(vol,1)
      ypave=ypave/vol
      if(ifut)then
        utmin=glmin(utmin,1)
        utmax=glmax(utmax,1)
        utave=glsum(utave,1)
        utave=utave/vol 
      endif
      if(iftl)then
        tlmin=glmin(tlmin,1)
        tlmax=glmax(tlmax,1)
        tlave=glsum(tlave,1)
        tlave=tlave/vol
      endif
      do ifld=1,ldimt-1
        if(ifpsp(ifld))then
          spmin(ifld)=glmin(spmin(ifld),1)
          spmax(ifld)=glmax(spmax(ifld),1)
          spave(ifld)=glsum(spave(ifld),1)
          spave(ifld)=spave(ifld)/vol
        endif
      enddo

      if(nio.eq.0)then
        write(*,255) 'y_p+',ypmin,ypmax,ypave
        if(.not.if3d) write(*,255) 'u tau',utmin,utmax,utave
        if(iftl) write(*,255)'T_p+',tlmin,tlmax,tlave
        do ifld=1,ldimt-1
          if(ifpsp(ifld)) then
            write(pname,'(a14,i1)') "PS_p+ ",ifld 
            write(*,255) pname,spmin(ifld),spmax(ifld),spave(ifld)
          endif
        enddo
        write(*,*)
      endif

 255  format(a15,5es13.4)

      return
      end
c-----------------------------------------------------------------------
      subroutine backpts(i0,i1,j0,j1,k0,k1,isd)
      implicit none
      include 'SIZE'

      integer i0,i1,j0,j1,k0,k1,isd

      i0=1
      j0=1
      k0=1
      i1=nx1
      j1=ny1
      k1=nz1
      if(isd.eq.1) then
        j0=2
        j1=2
      elseif(isd.eq.2) then
        i0=nx1-1
        i1=nx1-1
      elseif(isd.eq.3) then
        j0=ny1-1
        j1=ny1-1
      elseif(isd.eq.4) then
        i0=2
        i1=2
      elseif(isd.eq.5) then
        k0=2
        k1=2
      elseif(isd.eq.6) then
        k0=nz1-1
        k1=nz1-1
      endif

      return
      end
c-----------------------------------------------------------------------
      subroutine print_limits
      implicit none
      include 'SIZE'
      include 'TOTAL'

      real vol,glsum,glmin,glmax,glsc2
      real tmp(lx1*ly1*lz1*lelv)
      integer i,n1,n2,nt,nf

C     Primitive Variables
      real uxmin,uxmax,uxave,uymin,uymax,uyave,uzmin,uzmax,uzave
      real prmin,prmax,prave
      real thmin(ldimt),thmax(ldimt),thave(ldimt)
      real rmsux,rmsuy,rmsuz,rmspr,rmsth(ldimt),glrms
      real dux,duy,duz,dpr,dth(ldimt)
      character*15 tname

      n1=lx1*ly1*lz1*nelv
      n2=lx2*ly2*lz2*nelv
      nt=lx1*ly1*lz1*nelt

      if(ifflow) then
        call get_limits(vx,uxmin,uxmax,uxave,dux,vxlag,rmsux,n1)
        call get_limits(vy,uymin,uymax,uyave,duy,vylag,rmsuy,n1)
       if(if3d) call get_limits(vz,uzmin,uzmax,uzave,duz,vzlag,rmsuz,n1)
        call get_limits(pr,prmin,prmax,prave,dpr,prlag,rmspr,n2)
      endif
      if(ifheat) then
        do i=1,npscal+1
          nf=n1
          if(iftmsh(i+1))nf=nt
          if(idpss(i).eq.0) call get_limits(t(1,1,1,1,i),thmin(i) !Helmholtz solver
     &          ,thmax(i),thave(i),dth(i),tlag(1,1,1,1,1,i),rmsth(i),nf)
          if(idpss(i).eq.1) call get_limits_nodt(t(1,1,1,1,i) !CVODE solver
     &                                   ,thmin(i),thmax(i),thave(i),nf)
        enddo
      endif

      if(nio.eq.0) then
        write(*,*)
        write(*,254) 'limits','min','max','ave','max d/dt','rms d/dt'
        if(ifflow) then
          write(*,255) 'u velocity',uxmin,uxmax,uxave,dux,rmsux
          write(*,255) 'v velocity',uymin,uymax,uyave,duy,rmsuy
          if(if3d) write(*,255) 'w velocity',uzmin,uzmax,uzave,duz,rmsuz
          write(*,255) 'pressure',prmin,prmax,prave,dpr,rmspr
        endif
        if(ifheat) then
          do i=1,npscal+1
            if(i.eq.1) write(tname,'(a15)') "temperature"
            if(i.gt.1) write(tname,'(a14,i1)') "PS ",i-1
            if(idpss(i).eq.0)write(*,255)
     &               tname,thmin(i),thmax(i),thave(i),dth(i),rmsth(i)
            if(idpss(i).eq.1)write(*,256)
     &               tname,thmin(i),thmax(i),thave(i),'--','--'
          enddo
        endif
        write(*,*)
      endif

c     if(.not.ifsplit) call copy(prlag,pr,n2) !doesn't get done for PN/PN-2 

 254  format(a15,5a13)
 255  format(a15,5es13.4)
 256  format(a15,3es13.4,2a13)

      return
      end
c-----------------------------------------------------------------------
      subroutine scalar_limit(phi,tname)
      implicit none
      include 'SIZE'
      include 'TOTAL'

      character*(*) tname
      real phi(lx1*ly1*lz1*lelt),phimin,phimax,phiave
      integer n

      n=lx1*ly1*lz1*nelt

      call get_limits_nodt(phi,phimin,phimax,phiave,n)

      if(nio.eq.0) then 
        write(*,256) tname,phimin,phimax,phiave
        write(*,*)
      endif

 256  format(a15,3es13.4,2a13)
      return
      end
C-----------------------------------------------------------------------
      subroutine get_y_p(wd,phi,ifelem)
      implicit none
      include 'SIZE'
      include 'TOTAL'
C
C     NOTE: min value should work if domain has internal corners
C
      logical ifelem

      real wd(lx1,ly1,lz1,*),phi(lx1,ly1,lz1,*)

      integer e,i,i0,i1,j,j0,j1,k,k0,k1,ib,jb,kb,i2,j2
      integer ipt,isd
c     real msk(lx1,ly1,lz1,lelv)
      real gradu(lx1*ly1*lz1,3,3)
      real tau(3),norm(3),vsca,tauw,dist
      real utau,rho,mu,yp,vol
      real glmin,glmax,glsum
      logical ifgrad, ifdid

c     data ifdid /.false./
c     save ifdid, msk

C     do some initializations once
c     if(.not.ifdid)then
c       ifdid=.true.
C       build the mask  (this mask ignores some points which maybe important... 
c       call rzero(msk,lx1*ly1*lz1*nelv)    ! need to look at it more closely)
c       do 10 e=1,nelv                      ! the mask should be right, it's the algorithm that's wrong (see below)
c       do 10 isd=1,2*ldim
c         if(cbc(isd,e,1).eq.'W  ') then
c           call backpts(i0,i1,j0,j1,k0,k1,isd)
c           do 20 k=k0,k1
c           do 20 j=j0,j1
c           do 20 i=i0,i1
c             msk(i,j,k,e)=1.0
c 20        continue
c         endif
c 10    continue
c       call dssum(msk,lx1,ly1,lz1) !for elements with edges, but not faces along a wall
c       do 30 e=1,nelv
c       do 30 isd=1,2*ndim
c         if(cbc(isd,e,1).eq.'W  ') then
c           call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,isd)
c           do 40 k=k0,k1
c           do 40 j=j0,j1
c           do 40 i=i0,i1
c             msk(i,j,k,e)=0.0
c 40        continue
c           endif
c 30    continue
c     endif
c
c     call copy(phi,msk,lx1*ly1*lz1*nelv)
c     return

C     Now do the thing
      call rzero(phi,lx1*ly1*lz1*nelv)
      do e=1,nelv
        yp=0.0
        vol=1.0e-20
        ifgrad=.true.
        do isd=1,2*ndim
          if(cbc(isd,e,1).eq.'W  ')then
            if(ifgrad)then
              call gradm11(gradu(1,1,1),gradu(1,1,2),gradu(1,1,3),vx,e)
              call gradm11(gradu(1,2,1),gradu(1,2,2),gradu(1,2,3),vy,e)
              if(if3d)
     &         call gradm11(gradu(1,3,1),gradu(1,3,2),gradu(1,3,3),vz,e)
              ifgrad=.false.
            endif
            call facind(i0,i1,j0,j1,k0,k1,lx1,ly1,lz1,isd)
            do 50 k=k0,k1
            do 50 j=j0,j1
            do 50 i=i0,i1
              kb=k
              jb=j
              ib=i
              if    (isd.eq.1) then
                jb=2
              elseif(isd.eq.2) then
                ib=lx1-1
              elseif(isd.eq.3) then
                jb=ly1-1
              elseif(isd.eq.4) then
                ib=2
              elseif(isd.eq.5) then
                kb=2
              else
                kb=lz1-1
              endif
              dist=wd(ib,jb,kb,e)
              if(dist.gt.1.0e-12) then
                ipt=i+(j-1)*lx1+(k-1)*lx1*ly1
                call getSnormal(norm,i,j,k,isd,e)
                mu=vdiff(i,j,k,e,1)
                rho=vtrans(i,j,k,e,1)

                do i2=1,ldim
                tau(i2)=0.0
                  do j2=1,ldim
                    tau(i2)=tau(i2)+
     &                   mu*(gradu(ipt,i2,j2)+gradu(ipt,j2,i2))*norm(j2)
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
                if(tauw.gt.0.0) then
                  tauw=sqrt(tauw)
                  utau=sqrt(tauw/rho)
                else
                  tauw=0.0
                  utau=0.0
                endif
                yp=yp+dist*utau*rho/mu*bm1(i,j,k,e)
                phi(i,j,k,e)=yp
                vol=vol+bm1(i,j,k,e)
              endif
  50        continue
          endif
        enddo
        if(ifelem) call cfill(phi(1,1,1,e),yp/vol,lx1*ly1*lz1)
      enddo

      return
      end
C-----------------------------------------------------------------------

