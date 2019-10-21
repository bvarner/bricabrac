# 12v DeWALT NiCad -> LiIon Battery Conversion

A decade ago or so, I started purchasing used 12v NiCad DeWALT hand power tools.
Over the years, I've acquired at least two of the 12v drills, a 1/4" impact driver, and a 9.6v drill that has almost identical components to the 12v drills.

I have about five of the 9.6v -> 14.4v NiCad chargers. They seem to output 48v without a load connected. I'm sure that value changes based on the battery connected. I'll do some testing with this theory before converting a charger to CC/CV for the LiIon charging.

I've purchased 40A, balanced BMS controllers, with the intent of making a single 3S2P pack. It should be able to crank out 12.6v (when charged to 4.2v), and hold that for an appreciable amount of time. The current output should be considerably higer than the NiCad packs for most of the discharge cycle, so I expect the drills and impact drivers to work just fine with the 3S arrangement. If they don't, I'll bump up to a 4S and see if we get better results.

## DeWALT NiCad Pack Modifications / 3D Print Files

The DeWALT battery packs are full of Bezier curves, which made reverse-engineering the lower battery case rather... interesting.
In order to get the best possible fit (and to remove the fuss of trying to divine appropriate control points and weights I used the following process:

### Reverse-Engineering the shape of the pack
* I placed the top-half of a battery pack onto my ancient flat-bed scanner. I scanned in color at 150DPI.
    * Photo was cropped, and exported in PNG.
    * Background colors were removed in the GIMP.
    * Final image was exported as PNG.
* The image was imported into Inkscape, using the DPI from the imported file.
    * The document size was adjusted appropriately to fit the cropped and cleaned up image.
    * I created a Bezier path to trace the outline of the upper portion of the case.
    * This path was selected, then the Path to OpenSCAD plugin was used to export the path to an OpenSCAD module. I used a 1mm height, with 0.001 step sizes.
* In OpenSCAD I rendered the top, opened in my slicing software, and printed a test-fit part. It fit. Perfectly. On. The. First. Try.


