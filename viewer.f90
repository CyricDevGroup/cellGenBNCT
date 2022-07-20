subroutine viewer(ncc,lxcn,lxcp,lycn,lycp,lxnn,lxnp,lynn,lynp,nnc,borcheck)
real*4 :: lxcn
real*4 :: lxcp
real*4 :: lycn
real*4 :: lycp
real*4 :: lxnn
real*4 :: lxnp
real*4 :: lynn
real*4 :: lynp
integer :: ncc
integer :: nnc
integer :: borcheck



write(999,*) "set object ",nnc," rect from ",lxnn,",",lynn," to ", lxnp,",",lynp, 'fs transparent solid 0.5 fc rgb "red"' !, 'fc rgb "red" fs pattern 2'


if(borcheck==0)then

write(999,*) "set object ",ncc," rect from ",lxcn,",",lycn," to ", lxcp,",",lycp,'fs transparent solid 0.2 fc rgb "cyan"' !, 'fc rgb "cyan" fs pattern 1'


else if(borcheck==1)then

write(999,*) "set object ",ncc," rect from ",lxcn,",",lycn," to ", lxcp,",",lycp,'fs transparent solid 0.2 fc rgb "yellow"' !, 'fc rgb "cyan" fs pattern 1'


end if





!set xrange [-0.1:0.1]

!set yrange [-0.1:0.1]









end subroutine viewer
