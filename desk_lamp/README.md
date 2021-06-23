# Varnerized Articulating Desk Lamp

This documents my changes to the ["Articulating LED desk lamp"](https://www.thingiverse.com/thing:4862355) by Gladius_Illuminatus on Thingiverse.

## Printing
Have. Patience.

### Arm segments & Compression Wheel Covers
I printed all the arm parts and compression covers at 0.25mm layers, 2 perimeters, 3 solid layers on top and bottom.

Infill was 15%, Cubic. Top and bottom are rectilinear. I did not iron.

### Base, Base Insert, swivel, & compression screws
Adjusted the layer thickness to 0.15mm

### Clamp
Layer height: 0.25, 4 perimeters, 4 layers top / bottom (1mm shell).

Infill: cubic, 25%.


## Design Changes

### Compression covers

In testing, even with 0.25mm layers for the arm links, the Pins just couldn't hold tension on the springs well enough to make the lamp ridig to an acceptable level.
In order to get the kind of 'height' for my desk lamp that I need to work with my massive monitor and desk mess, it takes me at least four full arm segments. This is a considerable length of lever arm -- especially for the lower joints.

To overcome this I came up with covers which act like nuts which compress the inner springs and constrain the outer toothed section of the arms. They're connected through the normal pin hole with an M6 threaded screw that you print horizontally. I've had great success with these screws printed at 0.15mm layer heights.

The threads are deliberately undersized so that the extrusion width of the nozzle respects the geometry clearance required for an M6 thread.
If you print the covers at 0.1mm layer thickness, you'll likely not need to do any cleanup of the threads.
If you want to print the covers at > 0.1mm layer, you'll probably need an M6 tap to clean up the threads. Another option is an M6 bolt and some grease, or you can use a file to create a groove across the threads in the bolt to help cut things.

### Ikea Lights

Initially, I used two OMLOPP 24v 1.5w LED lamps, with a 19w ANSLUTA LED driver with cord.

I liked this arrangement enough that I went to purchase more OMLOPP lights... only to find they're discontinued in the US, no longer stocked, and unavailable for order.

I managed to find one more OMLOPP at my local IKEA in the 'as is' section.

Thankfully, at the time I'm writing this, you can still get VAXMYRA LEDs, which appear to be almost identical to the OMLOPP, except that they come in two packs, are less expensive, and have slightly sharper corners on the housing.
All attributes that lend well to this design, so I'm not going to complain at all.

The omlopp_top.scad is a dual-light lamp housing for both Omlopp and VAXMYRA lights.

### Clamp
I used the ["Super Clamp with customizer"](https://www.thingiverse.com/thing:3072415) by 247generator to print a clamp designed to fit within the base, and wide enough to clamp to my desk, which is 35mm thick. The settings for the knurling mirror the settings for the knurling on the compression wheels.

