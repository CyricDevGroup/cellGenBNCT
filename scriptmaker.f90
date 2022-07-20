subroutine scriptmaker(ncell,lcell,tcell,lnuc,tbuffer,airad,maxcas,maxbch,e0,r0,emode,cytob,omp)
implicit none
integer :: ncell
real*4 :: lcell
real*4 :: tcell
real*4 :: lnuc
integer :: maxbch
integer :: maxcas
real*4 :: e0
character(256) :: title
logical :: there
character(len=8) :: fmt
character(256) :: name
character(256) :: x1
character(256) :: gg
integer :: num
character(400) :: outfile
character(256) :: proj
character(256) :: matchar
character(400) :: productitle
character(400) :: enchar
character(400) :: enchar2
character(400) :: enchar3
character(400) :: enchar4
character(400) :: enchar5
character(400) :: meshtitle
character(400) :: doseout
character(400) :: productout
character(400) :: productout2
character(400) :: productout3
integer :: icntl
integer :: ih2o
real*4 :: emin
real*4 :: dmax
integer :: stype
integer :: emode
real*4 :: dir
real*4 :: r0
real*4 :: z0
real*4 :: z1
integer :: i
real*4 :: HF1
real*4 :: HF2
real*4 :: HF3
real*4 :: OF1
real*4 :: OF2
real*4 :: OF3
real*4 :: CF2
real*4 :: CF3
real*4 :: NF2
real*4 :: NF3
real*4 :: PF2
real*4 :: PF3
real*4 :: BF
real*4 :: rhon
real*4 :: rhoc
real*4 :: tbuffer
real*4 :: airad
real*4 :: lzc0
real*4 :: lzc1
real*4 :: lzn0
real*4 :: lzn1
real*4 :: lxcn
real*4 :: lxcp
real*4 :: lycn
real*4 :: lycp
real*4 :: ltot
real*4 :: ltoth
integer :: ycheck
real*4 :: lxnn
real*4 :: lxnp
real*4 :: lynn
real*4 :: lynp
integer :: nnc
integer :: ncc
character(len=20) str
integer :: nair
integer :: nsub
integer :: itep
integer :: cytob
integer :: omp
real*4 :: gama
integer, dimension(ncell) :: signarr
integer :: k
real*4 :: rhoc1
real*4 :: rhoc2
integer :: nr1
integer :: nr2
integer :: n 
integer :: clock
integer, dimension(:), allocatable :: seed
integer :: borcheck
!integer :: values(1:ncell)


!conversion from micron to cm
lcell = lcell/10000.

tcell = tcell/10000.

lnuc = lnuc/10000.

!buffer conversion to micron
tbuffer = tbuffer/10000.

!conversion from mm to cm
r0 =r0/10.

rhon= -1.27

rhoc= -1.27 !density of tissue eq. plastic !2.34


!allocate(signarr(ncell))


name = '_code.inp'

fmt = '(I5.5)'

num=1

do i=1,1000

write(x1,fmt) num

gg = trim(x1) // trim(name)

inquire(file=gg,exist=there)

if(there)then

num=num+1

end if
end do

write(x1,fmt) num

!name = num,'.stl'

gg = trim(x1) // trim(name)

!inquire(file=gg,exist=there)
!if(there)then
!num=num+1
!write(x1,fmt) num
!gg = trim(x1) // trim(name)

open(10,file=gg)


!open(10,file='code.inp')
open(333,file='runphits.bat')

write(333,'(A,X,A)') 'phits', trim(gg)
!print*, "enter title of code: "
!read*, title

close(333)

open(334,file='mceditsct.sh')

write(334,'(A,X,A)') './mcedit.exe', trim(gg)
!print*, "enter title of code: "
!read*, title

close(334)


title=adjustl(trim("generated by BNCT cellgen program developed cyric"))

!*********************************
!open(111,file="script.dat")
!n=0
!do
!if(io==-1)then
!exit
!end if
!n = n + 1 !'(A,F5.3)'
!READ(111,'(A)',iostat=io) dummy
!READ(111,'(F10.0)',iostat=io) dummyval
!IF (io/=0) then
!write(*,*) "Error reading file."
!stop
!endif
!if(io==-1)then
!exit
!end if
!end do

!close(111)

!open(111,file="script.dat")

!print*, n

!n = n - 1

!allocate(inp(n))
!allocate(val(n))
 
!n = 0
!do i=1,n !'(A)''(A,F5.3)'
!READ(111,'(A)',iostat=io) inp(i)
!READ(111,'(F10.0)',iostat=io) val(i)
!  IF (io/=0) then
!    write(*,*) "Error reading file."
!    stop
!  endif
!exit             8
!print*, inp,  val

!end do

!print*, inp(1), val(1)

!allocate(inp(n))

!these inputs kept fixed
!if you want user defined, comment these
!and uncomment those in the do loop
icntl = 0

!maxbch = int(val15) !10

dir = -1.0

emin = 0.5

dmax = 0.6

ih2o = 69

stype = 1

!check source location properly
!this needs to change for this case


z0 = tbuffer + 0.001 !-25.0

z1 = tbuffer + 0.001   !-25.0

!check these *************

!Need to define material

matchar="cell"

!maybe cell or nucleus


proj = 'neutron'

write(enchar3,'(I4,A,A,A)') int(e0),'MeV_',trim(matchar),'_phits.out'

outfile= trim(enchar3)

meshtitle= 'Energy deposition in r-z mesh'

write(enchar2,'(I4,A,A,A)') int(e0),'MeV_Dose_deposit_',trim(matchar),'.out'

doseout= trim(enchar2)

productitle='Particle production in xyz mesh'

!enchar=char(int(e0))

write(enchar,'(I4,A,A,A)') int(e0),'MeV_N13_product_',trim(matchar),'.out'

productout= trim(enchar)


write(enchar4,'(I4,A,A,A)') int(e0),'MeV_C11_product_',trim(matchar),'.out'

productout2= trim(enchar4)

write(enchar5,'(I4,A,A,A)') int(e0),'MeV_O15_product_',trim(matchar),'.out'

productout3= trim(enchar5)

if(omp==1)then

write(10,155) adjustl(trim("$OMP=15"))

155 format(A)

end if 

!call random_seed(size=ncell)

!allocate(seed(1:ncell))

!seed(:) = values(ncell)

!call random_seed(put=seed)

CALL RANDOM_SEED 

!CALL RANDOM_INIT (REPEATABLE=.FALSE., IMAGE_DISTINCT=.FALSE.)

call random_seed(size=n)

allocate(seed(n))

call system_clock(count=clock)

seed = clock * 37 * (/ (i-1,i=1,n)/)

call random_seed(put=seed)


!do i=1,13
!call random_number(gama)
!end do

do i=1,ncell
!state = 20180815
!call random_seed(state)
!call random_init(repeatable=.true., image_distinct=.true.)

call random_number(gama)

if(gama<0.5)then

signarr(i) = 0

else

signarr(i) = 1

end if

!print*, signarr(i)
!pause
end do


call term(ncell,signarr,cytob)

write(10,1) adjustl(trim("[ T i t l e ]"))
1 format(A)

write(10,*) trim(title) !adjustl(trim(title))
!2 format(A)

write(10,*) " "

write(10,3) adjustl(trim("[ P a r a m e t e r s ]"))
3 format(A)

write(10,4) "icntl   =",icntl
4 format(2X,A,4X,I2)
  
write(10,5) "maxcas   =",maxcas
5 format(X,A,4X,I10)

write(10,6) "maxbch   =",maxbch
6 format(X,A,4X,I10)

write(10,7) "e-mode   =",emode
7 format(5X,A,4X,I4)

!write(10,*) " "

write(10,8) "file(6)  = ",trim(outfile)
8 format(X,A,X,A)

!write(10,9) "emin(14)   =",emin
!9 format(X,A,X,F4.3)

!write(10,10) "dmax(14)   =",dmax
!10 format(X,A,X,F4.3)

write(10,*) " "

write(10,11) adjustl(trim("[ S o u r c e ]"))
11 format(A)

write(10,12) "s-type   =",stype
12 format(3X,A,X,I2)

write(10,13) "proj   =",trim(proj)
13 format(4X,A,X,A)

write(10,14) "dir   =",dir
14 format(5X,A,2X,F8.3)

write(10,15) "r0   =",r0
15 format(6X,A,2X,F8.3)

write(10,16) "z0   =",z0
16 format(6X,A,2X,F8.3)

write(10,17) "z1   =",z1
17 format(6X,A,2X,F8.3)

write(10,18) "e0   =",e0
18 format(6X,A,2X,F11.7)



write(10,*) " "


write(10,19) adjustl(trim("[ M a t e r i a l ]"))
19 format(A)

write(10,20) "mat[1]"
20 format(A)

!write(10,21) "mat[1]"
!21 format(A)

!itep=1
!water for buffer layer
HF1= 11.1

OF1= 88.9

write(10,93) "H",-1*HF1
93 format(5X,A,3X,F9.4)

write(10,94) "O",-1*OF1
94 format(5X,A,3X,F9.4)

write(10,120) "mat[2]"
120 format(A)

!write(10,21) "mat[1]"
!21 format(A)

!itep=1
!cell nucleus
HF2=10.64

OF2=74.5

CF2=9.04

NF2=3.21

PF2=2.61


write(10,193) "H",-1*HF2
193 format(5X,A,3X,F9.4)

write(10,194) "O",-1*OF2
194 format(5X,A,3X,F9.4)

write(10,195) "C",-1*CF2
195 format(5X,A,3X,F9.4)

write(10,196) "N",-1*NF2
196 format(5X,A,3X,F9.4)

write(10,197) "P",-1*PF2
197 format(5X,A,3X,F9.4)

!write(10,21) "mat[1]"
!21 format(A)

if(cytob==0)then

print*, "Cells with normal cytoplasm [o]:", ncell


!itep=1
!cell cytoplasm
HF3=59.6

OF3=24.24

CF3=11.11

NF3=4.04

PF3=1.01

write(10,220) "mat[3]"
220 format(A)

write(10,293) "H",-1*HF3
293 format(5X,A,3X,F9.4)

write(10,294) "O",-1*OF3
294 format(5X,A,3X,F9.4)

write(10,295) "C",-1*CF3
295 format(5X,A,3X,F9.4)

write(10,296) "N",-1*NF3
296 format(5X,A,3X,F9.4)

write(10,297) "P",-1*PF3
297 format(5X,A,3X,F9.4)

else if(cytob==1)then

print*, "Cells with boron  cytoplasm [*]:", ncell

write(10,222) "mat[3]"
222 format(A)

BF=100.0

write(10,393) "10B",-1*BF
393 format(5X,A,3X,F9.4)

rhoc = -2.34


else if(cytob==2)then
!random assignment of boron region
!somehting like a randomizer

write(10,223) "mat[3]"
223 format(A)

HF3=59.6

OF3=24.24

CF3=11.11

NF3=4.04

PF3=1.01

write(10,593) "H",-1*HF3
593 format(5X,A,3X,F9.4)

write(10,594) "O",-1*OF3
594 format(5X,A,3X,F9.4)

write(10,595) "C",-1*CF3
595 format(5X,A,3X,F9.4)

write(10,596) "N",-1*NF3
596 format(5X,A,3X,F9.4)

write(10,597) "P",-1*PF3
597 format(5X,A,3X,F9.4)


write(10,622) "mat[4]"
622 format(A)

BF=100.0

write(10,793) "10B",-1*BF
793 format(5X,A,3X,F9.4)

end if

write(10,*) " "

write(10,28) adjustl(trim("[ S u r f a c e ]"))
28 format(A)

write(10,29) "1","so",airad !this air sphere radius center at zero
29 format(2X,A,2X,A,4X,F8.3)

!lxc=lcell/2.

!lyc=lcell/2.

!lz=watz/2. !starts from 0 origin no need to slice

lzc0=-1.*tcell 

lzc1=0.0

!lxn=lnuc/2.

!lyn=lnuc/2.

!lz=watz/2. !starts from 0 origin no need to slice

lzn1=       -1*(tcell-lnuc)/2.

lzn0=lzn1-lnuc






ltot = sqrt(real(ncell))*lcell

ltoth = ltot/2.

!negative position x, end of array in sqaure matrix
lxcn = -1.*ltoth

!positive position x, next to the end in square matrix
lxcp = lxcn + lcell

!negative position y, end of array in sqaure matrix
lycn = -1.*ltoth

!positive position y, next to the end in square matrix
lycp = lycn + lcell

!buffer medium
write(10,30) "2","rpp",-1.*ltoth,1.*ltoth,-1.*ltoth,1.*ltoth,lzc1,tbuffer
30 format(2X,A,2X,A,4X,ES11.4,X,ES11.4,3X,ES11.4,X,ES11.4,2X,ES11.4,X,ES11.4)


ycheck =1

nnc= 3

ncc= 4

open(999,file='gnu_plot/view.dat')


!set xrange [-0.1:0.1]

!set yrange [-0.1:0.1]


write(999,*) "reset"

write(999,*) "set xrange [-1.0:1.0]"

write(999,*) "set yrange [-1.0:1.0]"  

write(999,*) "set size square"

do i = 1,ncell

lxnn = ( (lcell - lnuc )/2. )+ lxcn

lxnp = lxnn + lnuc


lynn = ( (lcell - lnuc )/2. )+ lycn

lynp = lynn + lnuc


if(cytob==0)then

borcheck = 0

elseif(cytob==1)then

borcheck=1

elseif(cytob==2)then

if(signarr(i)==0)then

borcheck = 0

else if(signarr(i)==1)then

borcheck = 1

end if

end if




!nucleus
write(10,31) nnc,"rpp",lxnn,lxnp,lynn,lynp,lzn0,lzn1
31 format(I5,2X,A,4X,ES11.4,X,ES11.4,3X,ES11.4,X,ES11.4,2X,ES11.4,X,ES11.4)

!cytoplasm
write(10,32) ncc,"rpp",lxcn,lxcp,lycn,lycp,lzc0,lzc1
32 format(I5,2X,A,4X,ES11.4,X,ES11.4,3X,ES11.4,X,ES11.4,2X,ES11.4,X,ES11.4)

call viewer(ncc,lxcn,lxcp,lycn,lycp,lxnn,lxnp,lynn,lynp,nnc,borcheck)



lxcn = lxcn + lcell 

lxcp = lxcp + lcell 


 
 
if(ycheck==sqrt(real(ncell)))then

lycn = lycn + lcell 

lycp = lycp + lcell 

lxcn = -1.*ltoth

!positive position x, next to the end in square matrix
lxcp = lxcn + lcell

ycheck = 0

end if

ycheck = ycheck + 1

nnc = nnc + 2 !nucleus surface number counter

ncc = ncc + 2  !cell surface number counter

end do


!write(999,*) "plot ", -1.*ltot*2,"," , 1.*ltot*2

write(999,*) "plot x"

close(999)

write(10,*) " "

write(10,33) adjustl(trim("[ C e l l ]"))
33 format(A)

write(10,34) "  1   -1            1"
34 format(A)

write(10,35) "  2   1   -1.000   -2"
35 format(A)




nnc= 3

ncc= 4

nr1=0

nr2=0

do i = 1,ncell


write(10,36)  nnc,"2",rhon,-1*nnc 
36 format(I5,3X,A,3X,F6.3,3X,I6)

if(cytob==2)then

!do k=1,ncell

if(signarr(i)==0)then

!normal cytoplsm

rhoc1=-1.27

write(10,837)  ncc,"3",rhoc1,-1*ncc,"#",trim(str(nnc))
837 format(I5,3X,A,3X,F6.3,3X,I6,2x,A,A)

nr1=nr1+1

else if(signarr(i)==1)then

!boron cytoplasm

rhoc2 = -2.34

write(10,737)  ncc,"4",rhoc2,-1*ncc,"#",trim(str(nnc))
737 format(I5,3X,A,3X,F6.3,3X,I6,2x,A,A)

nr2=nr2+1

end if

!end do

else

write(10,37)  ncc,"3",rhoc,-1*ncc,"#",trim(str(nnc)) 
37 format(I5,3X,A,3X,F6.3,3X,I6,2x,A,A)

end if

!write(10,33)  "101    1",rhon,"   -11" 
!33 format(X,A,3X,F6.3,A)

!write(10,33)  "101    1",rhoc,"   -11" 
!33 format(X,A,3X,F6.3,A)

nnc = nnc + 2 !nucleus surface number counter

ncc = ncc + 2  !cell surface number counter

end do


if(cytob==2)then

print*, "Cells with normal cytoplasm [o]:", nr1

print*, "Cells with boron  cytoplasm [*]:", nr2

end if

nair = ncc + 1

nnc= 3

ncc= 4

nsub= 2

write(10,38,advance="no") nair,"   0   -1" !,"#",trim(str(nsub)) 
38 format(I5,A,2X)


itep = 20

do i = 1,ncell*2+1



write(10,39,advance="no") "#",trim(str(nsub)) 
39 format(X,A,A)

if(i == itep)then


write(10,334)
334 format(A,/,A)

write(10,333,advance="no") "      "
333 format(A) 


itep = itep +20

end if

if(itep > 20)then





!itep = itep +20

end if


!write(10,39,advance="no") nair,"    0           -1","#",trim(str(nsub)) 
!39 format(I3,A,2X,A,A)

nsub= nsub + 1



end do

write(10,*) ! Assumes default "advance='yes'".

!write(*,*) "--OK, the loop is done!"

write(10,40) "   "
40 format(A)


write(10,41) adjustl(trim("[T - G S H O W]"))
41 format(A)

write(10,42) "     mesh =  xyz"
42 format(A)

write(10,43) "     x-type = 2"
43 format(A)

write(10,44) "     xmin =",-1.*ltoth
44 format(A,X,ES11.4)

write(10,45) "     xmax =",ltoth
45 format(A,X,ES11.4)

write(10,46) "     nx = 100" !,ncell
46 format(A) !,X,I6)

write(10,47) "     y-type = 2"
47 format(A)

write(10,48) "     ymin =",-1.*ltoth
48 format(A,X,ES11.4)

write(10,49) "     ymax =",ltoth
49 format(A,X,ES11.4)

write(10,50) "     ny = 100" !,ncell
50 format(A) !,X,I6)

write(10,51) "     z-type = 1"
51 format(A)

write(10,52) "     nz = 1"
52 format(A)

write(10,53) lzc0,lzc1
53 format(ES11.4,X,ES11.4)

write(10,54) "     axis = xy"
54 format(A)

write(10,55) "     file = gshow.out"
55 format(A)


write(10,56) "     epsout = 1"
56 format(A)


write(10,57) "   "
57 format(A)

write(10,58) adjustl(trim("[T - T R A C K]"))
58 format(A)

write(10,59) "     mesh =  xyz"
59 format(A)

write(10,60) "     x-type = 2"
60 format(A)

write(10,61) "     xmin =",-1.*ltoth
61 format(A,X,ES11.4)

write(10,62) "     xmax =",ltoth
62 format(A,X,ES11.4)

write(10,63) "     nx = 100" !,ncell
63 format(A) !,X,I6)

write(10,64) "     y-type = 2"
64 format(A)

write(10,65) "     ymin =",-1.*ltoth
65 format(A,X,ES11.4)

write(10,66) "     ymax =",ltoth
66 format(A,X,ES11.4)

write(10,67) "     ny = 100" !,ncell
67 format(A) !,X,I6)

write(10,68) "     z-type = 1"
68 format(A)

write(10,69) "     nz = 1"
69 format(A)

write(10,70) lzc0,lzc1
70 format(ES11.4,X,ES11.4)

write(10,71) "     axis = xy"
71 format(A)

write(10,72) "     file = track.out"
72 format(A)

write(10,73) "     epsout = 1"
73 format(A)

write(10,74) "     e-type = 1"
74 format(A)

write(10,75) "     ne =    1"
75 format(A)

write(10,76) " 0.0  1000.0"
76 format(A)

write(10,77) "     unit =  1"
77 format(A)

write(10,78) "    part = all neutron photon alpha proton"
78 format(A)

write(10,*) "   "

write(10,79) adjustl(trim("[T - D E P O S I T]"))
79 format(A)

write(10,80) "     mesh =  xyz"
80 format(A)

write(10,81) "     x-type = 2"
81 format(A)

write(10,82) "     xmin =",-1.*ltoth
82 format(A,X,ES11.4)

write(10,83) "     xmax =",ltoth
83 format(A,X,ES11.4)

write(10,84) "     nx = 100" !,ncell
84 format(A) !,X,I6)

write(10,85) "     y-type = 2"
85 format(A)

write(10,86) "     ymin =",-1.*ltoth
86 format(A,X,ES11.4)

write(10,87) "     ymax =",ltoth
87 format(A,X,ES11.4)

write(10,88) "     ny = 100" !,ncell
88 format(A) !,X,I6)

write(10,89) "     z-type = 1"
89 format(A)

write(10,90) "     nz = 1"
90 format(A)

write(10,91) lzc0,lzc1
91 format(ES11.4,X,ES11.4)

write(10,92) "     axis = xy"
92 format(A)

write(10,95) "     material =  all"
95 format(A)

write(10,96) "     output =  dose"
96 format(A)

write(10,931) "     file = deposit_neutron.out"
931 format(A)

write(10,97) "     part =  neutron"
97 format(A)

write(10,98) "     gshow =    1"
98 format(A)

write(10,941) "     epsout = 1"
941 format(A)


write(10,*) "   "
!57 format(A)


write(10,379) adjustl(trim("[T - D E P O S I T]"))
379 format(A)

write(10,380) "     mesh =  xyz"
380 format(A)

write(10,381) "     x-type = 2"
381 format(A)

write(10,382) "     xmin =",-1.*ltoth
382 format(A,X,ES11.4)

write(10,383) "     xmax =",ltoth
383 format(A,X,ES11.4)

write(10,384) "     nx = 100" !,ncell
384 format(A) !,X,I6)

write(10,385) "     y-type = 2"
385 format(A)

write(10,386) "     ymin =",-1.*ltoth
386 format(A,X,ES11.4)

write(10,387) "     ymax =",ltoth
387 format(A,X,ES11.4)

write(10,388) "     ny = 100" !,ncell
388 format(A) !,X,I6)

write(10,389) "     z-type = 1"
389 format(A)

write(10,390) "     nz = 1"
390 format(A)

write(10,391) lzc0,lzc1
391 format(ES11.4,X,ES11.4)

write(10,392) "     axis = xy"
392 format(A)

write(10,395) "     material =  all"
395 format(A)

write(10,396) "     output =  dose"
396 format(A)

write(10,3931) "     file = deposit_alpha.out"
3931 format(A)

write(10,397) "     part =  alpha"
397 format(A)

write(10,398) "     gshow =    1"
398 format(A)

write(10,3941) "     epsout = 1"
3941 format(A)


write(10,*) "   "

write(10,479) adjustl(trim("[T - D E P O S I T]"))
479 format(A)

write(10,480) "     mesh =  xyz"
480 format(A)

write(10,481) "     x-type = 2"
481 format(A)

write(10,482) "     xmin =",-1.*ltoth
482 format(A,X,ES11.4)

write(10,483) "     xmax =",ltoth
483 format(A,X,ES11.4)

write(10,484) "     nx = 100" !,ncell
484 format(A) !,X,I6)

write(10,485) "     y-type = 2"
485 format(A)

write(10,486) "     ymin =",-1.*ltoth
486 format(A,X,ES11.4)

write(10,487) "     ymax =",ltoth
487 format(A,X,ES11.4)

write(10,488) "     ny = 100" !,ncell
488 format(A) !,X,I6)

write(10,489) "     z-type = 1"
489 format(A)

write(10,490) "     nz = 1"
490 format(A)

write(10,491) lzc0,lzc1
491 format(ES11.4,X,ES11.4)

write(10,492) "     axis = xy"
492 format(A)

write(10,495) "     material =  all"
495 format(A)

write(10,496) "     output =  dose"
496 format(A)

write(10,4931) "     file = deposit_proton.out"
4931 format(A)

write(10,497) "     part =  proton"
497 format(A)

write(10,498) "     gshow =    1"
498 format(A)

write(10,4941) "     epsout = 1"
4941 format(A)

write(10,*) "   "

write(10,4795) adjustl(trim("[T - D E P O S I T]"))
4795 format(A)

write(10,4805) "     mesh =  xyz"
4805 format(A)

write(10,4815) "     x-type = 2"
4815 format(A)

write(10,4825) "     xmin =",-1.*ltoth
4825 format(A,X,ES11.4)

write(10,4835) "     xmax =",ltoth
4835 format(A,X,ES11.4)

write(10,4845) "     nx = 100" !,ncell
4845 format(A) !,X,I6)

write(10,4855) "     y-type = 2"
4855 format(A)

write(10,4865) "     ymin =",-1.*ltoth
4865 format(A,X,ES11.4)

write(10,4875) "     ymax =",ltoth
4875 format(A,X,ES11.4)

write(10,4885) "     ny = 100" !,ncell
4885 format(A) !,X,I6)

write(10,4895) "     z-type = 1"
4895 format(A)

write(10,4905) "     nz = 1"
4905 format(A)

write(10,4915) lzc0,lzc1
4915 format(ES11.4,X,ES11.4)

write(10,4925) "     axis = xy"
4925 format(A)

write(10,4955) "     material =  all"
4955 format(A)

write(10,4965) "     output =  dose"
4965 format(A)

write(10,49315) "     file = deposit_photon.out"
49315 format(A)

write(10,4975) "     part =  photon"
4975 format(A)

write(10,4985) "     gshow =    1"
4985 format(A)

write(10,49415) "     epsout = 1"
49415 format(A)

write(10,*) "   "

write(10,4799) adjustl(trim("[T - D E P O S I T]"))
4799 format(A)

write(10,4809) "     mesh =  xyz"
4809 format(A)

write(10,4819) "     x-type = 2"
4819 format(A)

write(10,4829) "     xmin =",-1.*ltoth
4829 format(A,X,ES11.4)

write(10,4839) "     xmax =",ltoth
4839 format(A,X,ES11.4)

write(10,4849) "     nx = 100" !,ncell
4849 format(A) !,X,I6)

write(10,4859) "     y-type = 2"
4859 format(A)

write(10,4869) "     ymin =",-1.*ltoth
4869 format(A,X,ES11.4)

write(10,4879) "     ymax =",ltoth
4879 format(A,X,ES11.4)

write(10,4889) "     ny = 100" !,ncell
4889 format(A) !,X,I6)

write(10,4899) "     z-type = 1"
4899 format(A)

write(10,4909) "     nz = 1"
4909 format(A)

write(10,4919) lzc0,lzc1
4919 format(ES11.4,X,ES11.4)

write(10,4929) "     axis = xy"
4929 format(A)

write(10,4959) "     material =  all"
4959 format(A)

write(10,4969) "     output =  dose"
4969 format(A)

write(10,49319) "     file = deposit_Li7.out"
49319 format(A)

write(10,4979) "     part =  7Li"
4979 format(A)

write(10,4989) "     gshow =    1"
4989 format(A)

write(10,49419) "     epsout = 1"
49419 format(A)

write(10,*) "   "

write(10,579) adjustl(trim("[T - D E P O S I T]"))
579 format(A)

write(10,580) "     mesh =  r-z"
580 format(A)

write(10,581) "     r-type = 1"
581 format(A)

write(10,5822) "     nr = 1"
5822 format(A)

write(10,591) "0.00",ltoth
591 format(A,X,ES11.4)

write(10,585) "     z-type = 2"
585 format(A)

write(10,582) "     zmin =",lzc0
582 format(A,X,ES11.4)

write(10,583) "     zmax =",lzc1
583 format(A,X,ES11.4)

write(10,584) "     nz = 200" !,ncell
584 format(A) !,X,I6)

write(10,5851) "     unit = 2"
5851 format(A)

write(10,5951) "     material =  all"
5951 format(A)

write(10,5961) "     output =  dose"
5961 format(A)

write(10,592) "     axis = z"
592 format(A)

write(10,5931) "     file = deposit_z.out"
5931 format(A)

write(10,5971) "     part =  all neutron photon alpha proton"
5971 format(A)

write(10,598) "     gshow =    1"
598 format(A)

write(10,5941) "     epsout = 1"
5941 format(A)

write(10,*) "   "


write(10,5796) adjustl(trim("[T - D E P O S I T]"))
5796 format(A)

write(10,5806) "     mesh =  r-z"
5806 format(A)

write(10,5816) "     r-type = 1"
5816 format(A)

write(10,58226) "     nr = 1"
58226 format(A)

write(10,5916) "0.00",ltoth
5916 format(A,X,ES11.4)

write(10,5856) "     z-type = 2"
5856 format(A)

write(10,5826) "     zmin =",lzc0
5826 format(A,X,ES11.4)

write(10,5836) "     zmax =",lzc1
5836 format(A,X,ES11.4)

write(10,5846) "     nz = 200" !,ncell
5846 format(A) !,X,I6)

write(10,58516) "     unit = 2"
58516 format(A)

write(10,59516) "     material =  all"
59516 format(A)

write(10,59616) "     output =  dose"
59616 format(A)

write(10,5926) "     axis = z"
5926 format(A)

write(10,59316) "     file = deposit_z_Li.out"
59316 format(A)

write(10,59716) "     part =  7Li"
59716 format(A)

write(10,5986) "     gshow =    1"
5986 format(A)

write(10,59416) "     epsout = 1"
59416 format(A)

write(10,*) "   "

write(10,375) adjustl(trim("[ E n d ]"))
375 format(A)





close(10)



end subroutine scriptmaker


character(len=20) function str(k)
!   "Convert an integer to string."
    integer, intent(in) :: k

    write (str, *) k

    str = adjustl(str)

end function str