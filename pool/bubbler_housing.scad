use <threads.scad>;
use <threadlib/threadlib.scad>;

$fn = 360;

nozzled = 0.4;
pool_hose_od = 43.5;

motor_inlet_od = 106.25;

wall = 2.04;

housing_id = 125.5;
housing_od = 125.5 + 2 * wall;

function mmToIn(mm) = mm * 0.03937007874;
function inToMm(in) = in * 25.4;

module motor_side() {
    difference() {
        union() {
            rotate([0, 90, 0]) {
                translate([0, 0, inToMm(1/2)])
                rotate([180, 0, 0])
                    english_thread(diameter = mmToIn(housing_od + wall), 
                        threads_per_inch=8, length = 1/2, taper = 1/16, 
                        internal = false, test = false, leadin = 1);
                translate([0, 0, inToMm(1/2)])
                    cylinder(d = housing_od, h = 90 - inToMm(1/2));
            }
        }
        rotate([0, 90,0]) cylinder(d = motor_inlet_od + nozzled, h = 90);
        rotate([0, 90,0]) cylinder(d = housing_id + nozzled, h = 88);
        
        // wire plug
        translate([40, 0, 0]) hull() {
            cylinder(d = 4.75 + nozzled, h = housing_od);
            translate([4.75, 0, 0]) cylinder(d = 4.75 + nozzled, h = housing_od);
        }
    }
}

module hose_side() {
    translate([inToMm(1/2), 0, 0]) rotate([0, -90, 0]) {
        difference() {
            union() {
                cylinder(d = housing_od + 7, h = inToMm(1/2) + 1.75);
                translate([0, 0, inToMm(1/2) + 1.75]) {
                    cylinder(d1 = housing_od + 7, d2 = pool_hose_od + 2 * wall, h = 60);
                    rotate ([0, 0, 180]) 
                    hull() {
                        cylinder(d = pool_hose_od, h = 60);
                        translate([(housing_od + 7) / 2, -housing_od * 1/3, 0]) cube([2, housing_od * 2/3, 60]);
                    }
                }
            }
            // threads
            english_thread(diameter = mmToIn(housing_od + wall), 
                    threads_per_inch = 8, length = 1/2, taper = 1/16, internal = true, test = false, leadin = 1);
            
            // Internal geometry
            translate([0, 0, inToMm(1/2)]) cylinder(d = 40 + nozzled, h = 5.5);
            translate([0, 0, inToMm(1/2) + 4.5]) cylinder(d1 = 40 + nozzled, d2 = pool_hose_od, h = 2.5);
            translate([0, 0, inToMm(1/2) + 4.5 + 2.5]) cylinder(d = pool_hose_od, h = 60);
            for (rz = [0 : 22.5 : 360]) {
                rotate([0, 0, rz]) translate([0, 20 + wall + 5, inToMm(1/2)]) rotate([35, 0, 0]) cube([6, 5, 40], center = true);
            }
            
            // Mounting locations
            translate([-housing_od / 2 - wall * 2 - 5, 0, inToMm(2.75)]) rotate([0, 90, 0]) 
                tap("M5", length = 30, higbee_arc = 90);
            translate([-housing_od / 2 - wall * 2 - 5, inToMm(1.25), inToMm(0.75)]) rotate([0, 90, 0]) 
                tap("M5", length = 30, higbee_arc = 90);
            translate([-housing_od / 2 - wall * 2 - 5, -inToMm(1.25), inToMm(0.75)]) rotate([0, 90, 0]) 
                tap("M5", length = 30, higbee_arc = 90);
        }
    }
}

//motor_side();
hose_side();