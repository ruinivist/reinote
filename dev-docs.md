How to build the 2d grid
- custom painter witha  stack and offset ( x cant scale, inefficient)
- renderbox full custom ( the best, physics will need to be custom )
- two_dimensional_scrollables ( x good but can't scale )
- I think at this point I should just use a fucking game endgine but no, we got this

---

i've got some stuff working correctly, looks like its rebuilding the full widget tree on a repaint but I don't think that can be helped here. And as long as I keep the number of widgets on screen less, we should be good.

problem is how do I determine precisely what children to send to render.


well... for now, let's just render the full tree, a lot will be offscreen but this is how it's gonna be for now.

---

yeah, im retarded. losing sight of what's actually important. let me revisit what I was trying to make again