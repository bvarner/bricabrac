use <threads.scad>;


function inToMm(i) = i * 25.4;


difference() {
    // outter form
    union() {
        scoop();
    }
    
    // Inner form
    translate([inToMm(0.5) - inToMm(0.5 * 0.8), 0, 0]) scale([0.8, 0.8, 1]) {
        scoop(offy = 0.8);
    }
}



module scoop(offy = 1) {
    offt = (inToMm(0.75) - inToMm(0.75 * offy)) / 2 * offy;
    hull() {
        cylinder(d = inToMm(0.5), h = 1);
        translate([30, 0, 0])
            cylinder(d = inToMm(0.5), h = 1);
        translate([15 + offt / 2, 50 + (50 - (50 * offy)) + (inToMm(0.75) - (inToMm(0.75) * offy)) - offt, 40])
            sphere(d = inToMm(0.75));
    }
    translate([15 + offt / 2, 50 + (50 - (50 * offy)) + (inToMm(0.75) - (inToMm(0.75) * offy)) - offt, 40]) {
        // extension
        
        cylinder(d = inToMm(0.75), h = 15 + (offy != 1 ? inToMm(0.75) : 0));
        translate([0, 0, 15]) {
            // threads
            if (offy == 1) {
                english_thread(diameter = 0.84, 
                               threads_per_inch = 14, 
                               length = 0.75, 
                               taper = 1/16, 
                               internal = false, test = false);
            }
        }
    }
}