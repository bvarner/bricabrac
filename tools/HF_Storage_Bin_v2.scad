/**
 * Harbor Freight Small Parts Storage Tray Bins
 * 
 * Insipired by: 
 *     https://www.thingiverse.com/thing:569241
 *     https://www.thingiverse.com/thing:671740
 * 
 * You can use this as a box generator. Woohoo. Fun.
 * 
 * I'm including many STLs for boxes I've generated and use.
 * But of course you can use this to generate custom boxes, too. Without having to learn a CAD tool. :-)
 * 
 * I've made the module take a couple of parameters.
 *    wall_thickness - let's you control the wall thickness, so you can optimize STLs for your printer nozzle and layer height.
 *    subdivisions = [by length, by width] Lets you define a number of 'buckets' to put in each tray. A normal tray will have 1 bucket, which translates to [1, 1]. If you wanted 3 buckets along the length, and two rows of them, [3, 2] is what you want.
 *    box_size = [length , width] - Lets you define the size of the box in units it occupies in the storage system! A 'small' box is a [1, 1]. The HF kit comes with [1,1], [2, 1], and [2, 2] sizes.
*/

/** -- Basic Single "bucket" (no sub-divisions) trays -- */
 
// Your basic 'small' tray.
//hf_tray();

// A 'medium' tray
//hf_tray(box_size = [1, 2]);

// A 'large' tray
//hf_tray(box_size = [2, 2]);

// A tray size you can't even get at HF.
//hf_tray(box_size = [3, 3]);

/** -- Subdivisions! -- */

// A 'small' tray with sub-divisions (3 along the length, 2 along the width).
//hf_tray(subdivisions = [3, 2]);

// A Medium tray with 6 slots to put things like through-hole resistor tape reels in.
//hf_tray(box_size = [2, 2], subdivisions = [6, 1]); 


/** -- Wall Thickness! -- */
/* Wall thickness can be optimized to give your slicing 
    software something really peaceful to work with. It can 
    speed up print times, improve print quality, etc.

    I've tested a few of these configurations with Slic3r using
    0.25 and 0.4 nozzles printing nylon trimmer string.
*/
     
// Printing with a 0.25 nozzle, at 0.10mm / layer, 3 perimeters.
//hf_tray(subdivisions = [1, 1], wall_thickness = 0.71);

// Printing with a 0.25 nozzle, at 0.20mm / layer, 2 perimeters.
//hf_tray(subdivisions = [2, 2], wall_thickness = 0.66);

// Printing with a 0.4 nozzle, at 0.10mm / layer, 2 perimeters.
//hf_tray(subdivisions = [2, 2], wall_thickness = .88, lip_height = 1.5);


/** -- lip_height! -- */
/* For more robust / ridgid boxes along the top edge, increase the lip height. 
    The HF trays tend to have a 0.75mm lip, a consequence of the injection 
    molding process with polypropylene. I found that using the thin walls above
    things were a bit too flimsey at the top edge for my liking, and a slightly taller
    lip worked well to stiffen up the nylon.
*/

//hf_tray(box_size = [2, 2],
//            subdivisions = [6, 1],
//            wall_thickness = 0.88,
//            lip_height = 1.5);
         
/** -- Stacking Fractional height units!!! -- */
/* To really make the most of the storage space, set a box_size with a fractional 'z' height,
    make sure you make the lower boxes is_top = false
*/

// A tray that's one of the lower two in a stack of 3.
//hf_tray(box_size = [2, 2, (1/2)],
//            subdivisions = [4, 2],
//            wall_thickness = 0.86,
//            lip_height = 1.5,
//            is_top = true);
            

// A tray that's the top box in a stack of 3.
//hf_tray(box_size = [2, 2, (1/3)],
//            subdivisions = [6, 1],
//            wall_thickness = 0.88,
//            lip_height = 1.5,
//            is_top = true);


/** Customizer Support **/
 
/* [Box Dimensions] */
// Number of units wide a box is.
box_width = 1;
// Number of units long a box is.
box_length = 2;

// Box Depth how tall the box is (for stacking).
box_depth = 0.5; // [1:1, 0.5:1/2, 0.33333:1/3, 0.25:1/4, 0.75:3/4, 0.66666:2/3]

// Is the box the top box in the stack?
top_of_stack = 1; // [1:Yes, 0:No]
lid = 0; // [1:Yes, 0:No]

// How many subdivisions along the width of the box.
subdivisions_wide = 2;
// How many subdivisions along the length of the box.
subdivisions_long = 2;


/* [Bin Geometry] */
// Height of the lip around the top
lip = .5;
// Corner Radius
corner_radius = 2.5;
// Taper ration of the bin.
taper = 0.9;
// Height of the bin.
box_height = 47.5; // [47.5, 46.15]


/* [Foot Geometry] */
// Separate the feet from the box? (for easier printing)
separate_feet = 1; // [1:Yes, 0:No]
// Slop to use when creating the joinery hole for the foot.
// 0.2 works well when using a 0.4mm nozzle.
foot_joinery_slop = 0.2;
// height of the foot, in mm.
foot_height = 3.85; // [3.85, 1.75]
// Taper height. Foot will taper from the bottom to this height, at which point it will be 'full size'.
foot_taper_height = 2.00;
// Taper the foot to the bottom by this many mm. Makes it easier to nest.
foot_taper = 0.5;


/* [Print Tweaks] */
// Specify this based on your print settings.
wall_thickness = 0.85;
bottom_thickness = 0.75;

// The height of the wider reinforcing lip at the top of the box.
lip_height = 1.5;

/* [Hidden] */
$fn = 64;



hf_tray(box_size = [box_width, box_length, box_depth],
            subdivisions = [subdivisions_wide, subdivisions_long],
            wall_thickness = wall_thickness,
            lip_height = lip_height,
            is_top = (top_of_stack == 1));

module hf_tray(box_size = [1, 1], subdivisions = [1, 1], wall_thickness = 0.8, lip_height = 0.75, is_top = true) {
    // Size of a 'small' unit in the storage system.
    unit_length = 54.5 * box_size[0];
    unit_width = 39.5 * box_size[1] ;
    unit_height = ((box_height - bottom_thickness) * (len(box_size) < 3 ? 1 : box_size[2])) +
                         (len(box_size) < 3 || box_size[2] == 1 ? 0 : box_size[2] * (corner_radius + wall_thickness));

    x_div = subdivisions[0];
    y_div = subdivisions[1];

    // Do a bunch of boundary calculations up-front, so we don't have to keep doing math all over the place.

    // Top lip x and y
    top_lip_length = unit_length - (corner_radius * 2);
    top_lip_width = unit_width - (corner_radius * 2);

    // Top x and y
    top_length = top_lip_length - (lip * 2);
    top_width = top_lip_width - (lip * 2);

    top_inside_length = top_length - (wall_thickness * 2);
    top_inside_width = top_width - (wall_thickness * 2);

    // Bottom x and y
    bottom_length = top_length - (taper * 2);
    bottom_width = top_width - (taper * 2);

    bottom_inside_length = bottom_length - (wall_thickness * 2);
    bottom_inside_width = bottom_width - (wall_thickness * 2);
    
    // Flip it right-side up.
    translate([0, 0, unit_height + foot_height]) rotate([180, 0, 0])
    
    difference() {
        // Union everything.
        union() {
            // Subtract the 'inside' void'
            difference() {
                // Main shell.
                union () {
                    // top lip.
                    minkowski() {
                        translate([-top_lip_length / 2, -top_lip_width / 2, 0]) cube([top_lip_length, top_lip_width, lip_height / 2]);
                        union() {
                            cylinder(r = corner_radius, h = lip_height / 2);
                            translate([0, 0, lip_height / 2]) 
                            cylinder(r1 = corner_radius, 
                                                r2 = corner_radius - wall_thickness / 2, h = lip_height / 2);
                        }
                    }

                    // Taperd Body
                    minkowski() {
                        // Hull the top and bottom for a proper taper.
                        hull() {
                            // top 
                            translate([-top_length / 2, -top_width / 2, lip_height]) cube([top_length, top_width, 1]);
                            // bottom
                            translate([-bottom_length / 2, -bottom_width / 2, unit_height - corner_radius - 1]) cube([bottom_length, bottom_width, 1]);
                        }
                        // Minkowski a sphere around it.
                        scale([1, 1, (separate_feet ? 1.75 : 1)])
                            sphere( r = corner_radius);
                    }
                }
                // Cut the bottom of the body flush.
                // (removes minkowski round-over at the 'top' of the bin)
                translate([-unit_length / 2, -unit_width / 2, -corner_radius * 2]) 
                    cube([unit_length, unit_width, corner_radius * 2]);
                // (removes minkowski rount-over at the 'bottom' of the bin)
                translate([-unit_length / 2, -unit_width / 2, unit_height]) 
                    cube([unit_length, unit_width, corner_radius * 2]);
                
                // Produce a 'positive' to remove from the main cavity. Think of it like a press die.
                difference() {
                    // Tapered body main cavity.
                    minkowski() {
                        // Hull the top and bottom for a proper taper.
                        hull() {
                            // top 
                            translate([-top_length / 2, -top_width / 2, 0]) cube([top_length, top_width, 1]);
                            // bottom
                            translate([-bottom_length / 2, -bottom_width / 2, unit_height - corner_radius - bottom_thickness]) cube([bottom_length, bottom_width, 1]);
                        }
                        
                        // Minkowski a sphere around it.
                        scale([corner_radius - wall_thickness, corner_radius - wall_thickness, bottom_thickness * 2])
                            sphere(r = 1);
                    }
                    
                    
                    // Now that there's a positive shape for being pushed into the tray to form the inside,
                    // remove any divider walls from the positive.
                    if (x_div > 1 || y_div > 1) {
                        difference() {
                            union() {
                                if (x_div > 1) {
                                    for ( xwall = [1 : x_div - 1] ) {
                                        translate([-top_length / 2 - (wall_thickness / 2) - corner_radius + (xwall * ((top_length + 2 * corner_radius) / x_div)),
                                                        -top_width / 2 - corner_radius,
                                                        0])
                                        if (is_top) {
                                            cube([wall_thickness, top_width + (2 * corner_radius), unit_height]);
                                        } else {
                                            translate([0, 0, foot_height + wall_thickness])
                                            cube([wall_thickness, top_width + (2 * corner_radius), unit_height]);
                                        }
                                    }
                                }
                                
                                if (y_div > 1) {
                                    for (ywall = [1 : y_div - 1]) {
                                        translate([-top_inside_length / 2 - corner_radius,
                                                        -(top_inside_width / 2) - (wall_thickness / 2) - corner_radius + (ywall * ((top_inside_width + 2 * corner_radius) / y_div)),
                                                        0])
                                        if (is_top) {
                                            cube([top_inside_length + (2 * corner_radius), wall_thickness, unit_height]);
                                        } else {
                                            translate([0, 0, foot_height + wall_thickness])
                                            cube([top_inside_length + (2 * corner_radius), wall_thickness, unit_height]);
                                        }
                                    }
                                }
                            }
                            
                            // If we have divider walls, cut reliefs around the outside edge.
                            translate([-top_inside_length / 2 - corner_radius, -top_inside_width / 2 - corner_radius, 0])
                                rotate([-90, 0, 0]) 
                                    cylinder(r = 3.5, h = top_inside_width + 2 * corner_radius);
                            
                            translate([top_inside_length / 2 + corner_radius, -top_inside_width / 2 - corner_radius, 0]) 
                                rotate([-90, 0, 0]) 
                                    cylinder(r = 3.5, h = top_inside_width + 2 * corner_radius);
                            
                            translate([-top_inside_length / 2 - corner_radius, -top_inside_width / 2 - corner_radius, 0]) 
                                rotate([0, 90, 0]) 
                                    cylinder(r = 3.5, h = top_inside_length + 2 * corner_radius);
                            
                            translate([-top_inside_length / 2 - corner_radius, top_inside_width / 2 + corner_radius, 0]) 
                                rotate([0, 90, 0]) 
                                    cylinder(r = 3.5, h = top_inside_length + 2 * corner_radius);
                        }
                    }
                    
                    // Then we need to remove the corners to block for stacking.
                    // Set the threshold to 2, so that the upper stack doesn't "rock" back and forth.
                    if (is_top != true && x_div <= 2 && y_div <= 2) {
                        for (mx = [0, 1]) {
                            mirror([mx, 0, 0]) {
                                for (my = [0, 1]) {
                                    mirror([0, my, 0]) {
                                        translate([-top_length / 2 - (wall_thickness / 2) - corner_radius,
                                                   -top_width / 2 - corner_radius, 0])
                                            translate([wall_thickness, wall_thickness, foot_height + wall_thickness])
                                                cylinder(d = wall_thickness * 2 + 2 * corner_radius, h = unit_height);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Add the feet.
            foot(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
            mirror([1, 0, 0]) foot(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
            mirror([0, 1, 0]) foot(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
            rotate([0, 0, 180]) foot(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
        }
        
        
        // If we're doing detached feet, add the holes to the feet for filament joint.
        if (separate_feet == 1) {
                foot_holes(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
                mirror([1, 0, 0]) foot_holes(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
                mirror([0, 1, 0]) foot_holes(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
                rotate([0, 0, 180]) foot_holes(bottom_length = bottom_length, bottom_width = bottom_width, unit_height = unit_height, corner_radius = corner_radius, foot_height = foot_height);
        }
    }
}

module foot_holes(bottom_length = 0, bottom_width = 0, unit_height = 0, corner_radius = 2.5, foot_height = 2.5) {
    // Box section to receive the foot
    translate([-bottom_length / 2, -bottom_width / 2, unit_height - corner_radius]) {
        rotate([0, 0, 45])
            translate([0, 0, 0])
                scale([1, 1.25, 1])
                    cylinder(d = 2 + foot_joinery_slop, h = foot_height + corner_radius);
    }
}

module foot(bottom_length = 0, bottom_width = 0, unit_height = 0, corner_radius = 2.5, foot_height = 2.5) {
    // Flat part to receive the foot.
    translate([-bottom_length / 2, -bottom_width / 2, unit_height - corner_radius]) {
        rotate([0, 0, 45])
        difference() {
            cylinder(r = corner_radius, h = corner_radius);
            translate([0, -corner_radius, 0]) 
                cube([corner_radius, 2 * corner_radius, corner_radius / 2 * (separate_feet ? 1.75 : 1)]);
            sphere(r = corner_radius);
        }
    }
    
    if (separate_feet) {
        // Create the protrusion to fit the joinery hole.
        translate([-bottom_length / 2 - (separate_feet ? 10 : 0), -bottom_width / 2 - (separate_feet ? 10 : 0), unit_height - (separate_feet ? foot_height : 0)]) 
            rotate([0, 0, 45])
                translate([0, 0, -corner_radius / 2])
                    scale([1, 1.25, 1])
                        cylinder(d = 2, h = foot_height);
    }
    
    // Actual part of the foot.
    translate([-bottom_length / 2 - (separate_feet ? 10 : 0), -bottom_width / 2 - (separate_feet ? 10 : 0), unit_height - (separate_feet ? foot_height : 0)]) {
        rotate([0, 0, 45]) {
            difference() {
                union() {
                    cylinder(r = corner_radius, h = foot_height - foot_taper_height);
                    translate([0, 0, foot_height - foot_taper_height]) cylinder(r1 = corner_radius, r2 = corner_radius - foot_taper, h = foot_taper_height);
                    
                }
                translate([corner_radius / 2, -corner_radius, 0]) 
                    cube([corner_radius, 2 * corner_radius, foot_height]);
            }
        }
    }
}
