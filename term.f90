subroutine term(ncell,signarr,cytob)
implicit none
integer :: i
integer :: ncell
integer :: n
integer :: j
integer, dimension(ncell) :: signarr
integer :: cytob


write(*,*) " "

write(*,*) " "

!print*, ncell,cytob

!ncell = n**2

n = int(sqrt(real(ncell)))

j=n


if(cytob==0)then

do i=1,ncell

write(*,139,advance="no") "[o]"
139 format(X,A)

if(i==j)then

write(*,331)
331 format(A,/,A)

write(*,*) " "

j=j+n

end if

signarr(i) = 0

end do

end if


if(cytob==1)then

do i=1,ncell

write(*,140,advance="no") "[*]"
140 format(X,A)

if(i==j)then

write(*,332)
332 format(A,/,A)

write(*,*) " "

j=j+n

end if

signarr(i) = 0

end do

end if


if(cytob==2)then

do i=1,ncell

if(signarr(i)==0)then

write(*,39,advance="no") "[o]"
39 format(X,A)

else if(signarr(i)==1)then

write(*,40,advance="no") "[*]"
40 format(X,A)

end if


if(i==j)then

write(*,334)
334 format(A,/,A)

write(*,*) " "

j=j+n

end if


end do

end if




	 
write(*,*) " "

	 
	 
	 

end subroutine term