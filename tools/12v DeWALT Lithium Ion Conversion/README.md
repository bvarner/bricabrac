# 12v DeWALT NiCad -> LiIon Battery Conversion

A decade ago or so, I started purchasing used 12v NiCad DeWALT hand power tools.
Over the years, I've acquired at least two of the 12v drills, a 12v 1/4" impact driver, and a 9.6v drill/driver that has almost identical components to the 12v drills, in a slightly smaller formfactor.

I have about five of the 9.6v -> 14.4v NiCad chargers. They seem to output 48v without a load connected, and have some mystical custom zilog chip on them. I'm sure that output value changes based on the battery connected. In lieu of trying to use the AC/DC circuit on the charging boards, I opted to strip two (or three?) of these chargers down by unsoldering everything from the board. This took a few minutes with a hot air rework. It took much longer with just an old soldering iron.

I've purchased 40A, balanced BMS controllers, which I used to make 3S2P packs of LG HG2 18650 cells. Yes. Overkill. The packs output 12.6v (when charged to 4.2v), and hold that for an appreciable amount of time. I've mixed multiple 5 gallon buckets of paint with a drill/driver on these cells. The current output seems to be considerably higer than the NiCad packs for most of the discharge cycle. Even when dipping to the lower voltage range of their output, they more than turn the drill (albeit a bit slower). The 'over the counter' BMS things are likely to abuse my cells -- as they allow discharges lower than I'd like. So, as to help avoid that -- I've added a battery level monitor (again, off the shelf) to the design, which I use to keep an eye on the state of charge (based on output voltage).

After about 10 cycles with one pack, I'm seeing potential balance issues. I have two other packs that seem to be doing better.

## Supplies You'll Need
* Nylon Printer Filament
    * Maxpower 333865 Trimmer Line: Fairly Inexpensive. Requires dehydration. [5lb Spool](https://www.amazon.com/dp/B01E13CQ7Q/ref=cm_sw_em_r_mt_dp_U_80jLEbGX8BQJW)
    * Taulman Bridge: Fairly expensive. Comes ready to print. Requires dehydration after opening and sitting out. [Black](https://www.amazon.com/dp/B01F194DHU/ref=cm_sw_em_r_mt_dp_U_s2jLEbVW9FVB0)
* Donor NiCad Pack (to harvest parts):
    * Tool / Charging terminal connector from the top battery.
    * Latch buttons and latch springs from both sides. (variations exist for all known spring types)
    * Pan Head Screws.
* Battery Pack Making:
    * 18650 Cells. 6 Per Pack. 3S2P. (I used LG HG2, 3000mAh 20A cells) [Reliable Seller](https://18650batterystore.com)
    * 105mm Width PVC Heat Shrink wrap. 
    * Battery Management System board, 3S 40A Balanced.
    * Nickel Strip (0.15mm or 0.2mm thick).
    * Barley paper insulation gaskets. Solid and Hole-Punched.
    * #10 or #12 stranded copper wire. (Used to connect BMS to tool / charger terminal)
    * 3S Battery Capacity Indicator Module. (Optional)
        * Epoxy. 5-10 Minute Cure.
        * #22 stranded wire / hookup wire. (from BMS to charge indicator & tactile switch)
        * 3x6x5 Tactile (Patch) Switch.
* Charger Modifications
    * 5A Step Down Buck Charging Board CC/CV.
    * 19v Laptop power supply.
    * 2.1x5.5mm DC Power Pigtails. 18AWG wire required! (for 5A current)
* Steel Thread Rolling Screws Black Oxide Pan Head, Star Drive, #4-20 x 3/4". (Used to replace tamper resistant screws in chargers, and are the same as used in battery packs)

## Tooling Required
* Battery Spot welder. There are many 'how to' things online for building a DIY battery powered spot welder. I made mine using the following parts. Many of which I already had on-hand. The key here is to understand what you are aiming for, and adjust as necessary. Let the journey be part of the fun.
    * Arduino Nano 5v version works well.
    * 6 LEDs & resistors
    * 3 tactile switches
    * 5v Relay board.
    * 12v motorcycle starter solenoid.
    * Wire Connectors / Harness / etc.
    * I used #4 welding wire and the necessary zinc-plated eyebolt ends.
    * P12 terminal block
    * #12 wire to individual battery cells.
    * 4x 12v 20Ah power scooter batteris -- I had to remove two of the cells, as it was _too_ powerful.
    * Foot Switch
* Soldering Iron (any will do, but a hot-air rework and some good tweezers are great for the charger modifications).
* Hair Dryer / Heat Gun / Hot-Air Rework for heat-shrink tubing.
* [Battery Cell Welding Jig](https://www.thingiverse.com/thing:4072448)

## Post Printing
It took a few rounds of printing and test-fitting before I was happy with how things were coming out. I've had better success with the Taulman not shrinking as much as the maxxpower. If you end up with heavily warped prints, try slower print rates, print in a hot box, etc. All the normal tricks.

Once you've printed the nylon, boil-anneal your parts it in a pot of water, then while they're still warm screw the parts together (empty) and let them cool off. You may need to do this process a few times. The hot-water bath helps stabilize the nylon, which is going to soak up moisure from the air, so you may as well stabilize it before it becomes a problem.

# How it was designed
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


