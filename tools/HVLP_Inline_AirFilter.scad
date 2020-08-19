use <threads.scad>;

/**
 * Inline Air Filter for a Chicago Electric (or older model Rockler) HVLP 
 *   spray system like this: 
 *       https://www.amazon.com/rockler-hvlp-spray-gun/dp/b001dt1z7o
 * Using a Tecumseh 35066 Filter.
 */
$fn = 90;

// wall thickness: PrusaSlicer 0.15mm layer, 4 perimiters...
thin_wall = 0.87;
wall = 1.70;
thick_wall = 2.54;
// Shell Thickness, 7 layers top bottom, first layer 0.15mm
top = 1.05;
bottom = 1.05;

// Produce a cut-away of the main housing?
debug = false;

// area of 20.5mm diameter  =  330
// area of 44.5mm diameter  = 1555.5
// diameter of a              1885.5 square mm circle? = ~49 (48.9968688) 
// Making up for the 7mm wide supports, we added 126, and hit ~2011 sq mm.
// so that caluclates to about a 50.5, which gets us to a small pressure drop for the supports.
filter_od = 45;
housing_id = 50.5;
housing_od = housing_id + 2 * thick_wall;

center_bore = 20.5 - thin_wall * 2;

function mmToIn(mm) = mm * 0.03937007874;
function inToMm(in) = in * 25.4;

//translate([0, 0, 114]) rotate([180, 0, 0]) 
upper_part();
//translate([0, 0, -inToMm(0.75)]) 
//lower_part();

module lower_part() {
    translate([0, 0, 0]) {
        difference() {
            union() {
                difference() {
                    english_thread(diameter = mmToIn(housing_od), 
                        threads_per_inch=8, length = 1/2, taper = 1/16, internal = false, test = false, leadin = 1);
                    cylinder(d = filter_od, h = inToMm(1/2));
                }
                
                compression_seal(bottom = true);

                // The bottom
                mirror([0, 0, 1]) {
                    difference() {
                        cylinder(d = housing_od, h = 22.5 + bottom);
                        // friction fit adapter
                        translate([0, 0, 22.5 + bottom - 21 + 3])
                            cylinder(d1 = 28.75, d2 = 29.75, h = 21);
                    }
                }
            }
           
            mirror([0, 0, 1]) 
                translate([0, 0, 22.5 + bottom - 21]) 
                    cylinder(d1 = center_bore, d2 = 28.75, h = 3);
            
            // center bore
            translate([0, 0, -22.5 - bottom - 1]) {
                cylinder(d = center_bore, h = 22.5 + bottom + inToMm(1/2) + 2);
            
                // knurling
                for (i = [0 : 7.5 : 360]) {
                    rotate([0, 0, i]) {
                        translate([housing_od / 2, 0, 0]) 
                            rotate([0, 0, 180]) cylinder(d = 3.5, h = 21, $fn = 3);
                    }
                }
            }
        }
    }
}


module upper_part() {
    difference() {
        union() {
            housing();

            translate([0, 0, 72])
                mirror([0, 0, 1])
                    compression_seal();
        }

        // Center Bore for Outlet.
        translate([0, 0, 72 + top]) {
            cylinder(d = center_bore, h = 50);
        }
    }
}





// compression seal ridge
module compression_seal(bottom = false) {
    difference() {
        cylinder(d = 37.5, h = 1.5);
        cylinder(d = 31.5, h = 1.5);
    }
    
    if (!bottom) {
        intersection() {
            union() {
                translate([0, 0, .75]) cube([100, 7, 1.5], center = true);
                translate([0, 0, .75]) cube([7, 100, 1.5], center = true);
            }
            cylinder(d = housing_od, h = 1.5);
        }
    }
    
    cylinder(d = 20.5, h = 5.5);
}

module housing() {
    difference() {
        union() {
            cylinder(d = housing_od, h = 72 + top);
            cylinder(d = housing_od + thick_wall, h = inToMm(0.5));
            translate([0, 0, inToMm(0.5)])
                cylinder(d1 = housing_od + thick_wall, d2 = housing_od, h = 4);
            translate([0, 0, 72 + top]) {
                cylinder(d1 = housing_od, d2 = 29.75, h = 20);
                translate([0, 0, 20]) {
                    cylinder(d1 = 29.75, d2 = 28.75, h = 21);
                }
            }
        }
        
        // main hollow
        cylinder(d = housing_id, h = 72);

        // thread the bottom
        mirror([0, 0, 0])
        english_thread(diameter = mmToIn(housing_od), 
            threads_per_inch=8, length = 1/2, taper = 1/16, internal = true, test = debug);
        
        // Remove the outer ring by the top.
        translate([0, 0, 72 - 0.01]) difference() {
            cylinder(d = housing_id, h = top + 0.75);
            cylinder(d = 44.5, h = top + 0.75);
        }
        
        // Remove the upper airflow channel
        translate([0, 0, 72 + top]) {
            difference() {
                cylinder(d1 = housing_id, d2 = center_bore, h = 20);
                
                // supports / fins
                for (i = [0 : 45 : 180]) {
                    rotate([0, 0, i])
                        cube([housing_od, thin_wall, 41 * 2], center = true);
                }
            }
        }
        

        if (debug) {
            translate([-50, -50, 0])
                cube([100, 50, 100]);
        }
    }
}