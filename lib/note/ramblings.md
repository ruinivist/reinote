starting source is 0 with pos 0,0

I want a screen offset independent way to keep track of positions
when I chage a source it must know where it was? but what if it was never rendered?
ensure this otherwise you just rebuild the class

I set a source and can then assuming this source to be at (0,0) I can get
position of any other source by just adding the offset of the source to the

when I resource it means dfs now starts at that one but the positions to be calc
must still be same

what is reactive here?

when you pan -> offset changes -> this offset is passet to controller to
determinet the new source -> of the previous built ones -> pick one closest to
new screen center -> set this as new source -> so I can just set offset as the
param to update the controller