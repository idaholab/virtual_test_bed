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
      real aa,bb,cc,dd,w1,w2,x0,y0,z0,r0,rr,del,xsa,glsum

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
        IF(y0.lt.0.8) THEN !Here we consider only the MCRE core region
        r0=(aa*x0+bb*y0+cc*z0+dd)/sqrt(aa**2+bb**2+cc**2)
        rr=min(2.0,abs(r0)*2.0/eps)
        if(rr.gt.1.0) then
          del = 1.0/8.0*(5.0-2.0*rr-sqrt(-7.0+12.0*rr-4.0*rr**2))
        else
          del = 1.0/8.0*(3.0-2.0*rr+sqrt( 1.0+ 4.0*rr-4.0*rr**2))
        endif
        w1=w1+phi(i)*bm1(i,1,1,1)*del
        w2=w2+bm1(i,1,1,1)*del
        ENDIF

      enddo
      xsa=glsum(w2,1)
      planar_ave_m1 = glsum(w1,1)/max(xsa,1.0e-8)
      xsa=2.0*xsa/eps  !cross sectional area

      return
      end
C-----------------------------------------------------------------------
