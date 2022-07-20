program ben
implicit none
integer :: ncell
real*4 :: lcell
real*4 :: tcell
real*4 :: lnuc
real*4 :: e0
integer :: maxcas
integer :: maxbch
real*4 :: r0
real*4 :: tbuffer
real*4 :: airad
integer :: n
integer :: inpmode
character(10),dimension(13) :: charent
real*4, dimension(13) :: valent
integer :: j
integer :: cytob
integer :: omp
integer :: emode

call welcome


55 print *, ''//achar(27)//'[95mEnter (1) to read from input file, (2) for manual input'//achar(27)//'[0m'
read*, inpmode

if(inpmode==1)then
open(787,file='input.dat')

do j=1,13

read(787,*)  charent(j), valent(j)
!charent is dummy, however can be used for testing 
!print*, charent(j), valent(j)

!pause

end do

close(787)

n= int(valent(1)) !10
lcell= valent(2)      !20000
tcell = valent(3)    !10000
lnuc = valent(4) !5000
tbuffer= valent(5)  !50000
airad = valent(6) !500
maxcas = int(valent(7)) !1000
maxbch = int(valent(8)) !10
e0= valent(9) !100
r0= valent(10) !5
emode = valent(11)
cytob = valent(12)
omp = valent(13)

e0 = e0/1000.


ncell = n**2
print *, 'total number of cells: ',ncell
!print*, n

if(cytob.NE.0)then
if(cytob.NE.1)then
if(cytob.NE.2)then
print *, ''//achar(27)//'[31mError(4) wrong entry for cytob value (0/1/2 only) try again'//achar(27)//'[0m'
end if
end if
end if

if(omp.NE.0)then
if(omp.NE.1)then
print *, ''//achar(27)//'[31mError(5) wrong entry for omp value (0/1 only) try again'//achar(27)//'[0m'
end if
end if

!print*, cytob

elseif(inpmode==2)then

print *, ''//achar(27)//'[95m> Enter cell array size (n^2): '//achar(27)//'[0m'
!print*, "> Enter number of cells: "
read*, n

ncell = n**2

print *, 'total number of cells: ',ncell

print *, ''//achar(27)//'[95m> Enter cell length (um): '//achar(27)//'[0m'
!print*, "> Enter cell length (um): "
read*, lcell

print *, ''//achar(27)//'[95m> Enter cell thickness (um): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, tcell


1 print *, ''//achar(27)//'[95m> Enter nucleus length (cube) (um): '//achar(27)//'[0m'
!1 print*, "> Enter nucleus length (cube) (um): "
read*, lnuc


if(lnuc>tcell)then
print *, ''//achar(27)//'[33mError(1):nucleus larger than cell thickness'//achar(27)//'[0m'
!print*, "Error(1):nucleus larger than cell thickness"
print *, ''//achar(27)//'[33mtry smaller nucleus size'//achar(27)//'[0m'
!print*, "try smaller nucleus size"
goto 1
end if

if(lnuc>lcell)then
print *, ''//achar(27)//'[33mError(2):nucleus larger than cell length'//achar(27)//'[0m'
!print*, "Error(2):nucleus larger than cell length"
print *, ''//achar(27)//'[33mtry smaller nucleus size'//achar(27)//'[0m'
!print*, "try smaller nucleus size"
goto 1
end if


print *, ''//achar(27)//'[95m> Enter buffer medium thickness (um): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, tbuffer

print *, ''//achar(27)//'[95m> Enter air radius (cm): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, airad


print *, ''//achar(27)//'[95m> Enter maxcas (integer): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, maxcas

print *, ''//achar(27)//'[95m> Enter maxbch (integer): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, maxbch

print *, ''//achar(27)//'[95m> Enter neutron beam energy (keV): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, e0

e0 = e0/1000.

print *, ''//achar(27)//'[95m> Enter beam radius (mm): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, r0

print *, ''//achar(27)//'[95m> Enter emode (2): '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, emode


434 print *, ''//achar(27)//'[95m> Enter (0) for normal (1) for boron (2) for random boron fill cytoplasm: '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, cytob

if(cytob.NE.0)then
if(cytob.NE.1)then
if(cytob.NE.2)then
print *, ''//achar(27)//'[31mError(3) wrong entry, try again'//achar(27)//'[0m'
go to 434
end if
end if
end if


435 print *, ''//achar(27)//'[95m> Enter (1) for MPI or (0) for serial: '//achar(27)//'[0m'
!print*, "> Enter cell thickness (um): "
read*, omp

if(omp.NE.0)then
if(omp.NE.1)then
print *, ''//achar(27)//'[31mError(5) wrong entry, try again'//achar(27)//'[0m'
go to 435
end if
end if


else
print *, ''//achar(27)//'[31mError(3) wrong entry, try again'//achar(27)//'[0m'
goto 55

end if




!call sleep(1)

call scriptmaker(ncell,lcell,tcell,lnuc,tbuffer,airad,maxcas,maxbch,e0,r0,emode,cytob,omp)

!print*, ncell, lcell, tcell, lnuc











print*, "  "








print *, ''//achar(27)//'[92m***Run Done!***'//achar(27)//'[0m'










end program ben
