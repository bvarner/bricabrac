difference() {
    union() {
        difference() {
            union() {
                import("iPhone5s-case.STL");

                // make the side buttons enclosed.
                translate([0, 0, -46]) intersection() {
                    import("iPhone5s-case.STL");
                    translate([0, 0, 60]) cube([3, 11, 44]);
                }
                
                // Join the top around the power button
                translate([0, 11, 0]) mirror([0, 1, 0]) intersection() {
                    import("iPhone5s-case.STL");
                    translate([38, 0, 0]) cube([17.5, 5, 3]);
                }
                
            }
            
            translate([2, 1.5, 0]) {
                // Headphone Port Expansion.
                translate([0, 0, 120]) hull() {
                    translate([10.45, 3.56, 0]) cylinder(d = 7, h = 20, $fn = 6);
                    translate([10.45, 13.56, 0]) cylinder(d = 7, h = 20, $fn = 6);
                }
                
                // Camera Port in the right spot.
                translate([0, -0.1, 2])
                translate([58.57 - 9.28, -1.5, 7.35]) rotate([-90, 0, 0]) {
                    hull() {
                        cylinder(r = 7, h = 3, $fn = 90);
                        translate([-9.33, 0, 0]) 
                            cylinder(r = 7, h = 3, $fn = 90);
                    }
                }
                
                // Hollow by the side buttons
                hull() {
                    translate([0, 11 / 2 - 1.5, 18]) rotate([0, 90, 0]) cylinder(d = 8, h = 4, center = true);
                    translate([0, 11 / 2 - 1.5, 46]) rotate([0, 90, 0]) cylinder(d = 8, h = 4, center = true);
                }                
            }
        }
        
        
        // Hull the object to fill in the back (so it's not hexagons)
        difference() {
            intersection() {
                cube([70, 1.5, 130]);
                hull() {
                    import("iPhone5s-case.STL");
                }
            }
            translate([2, 1.5, 2]) {
                // Camera Port in the right spot.
                translate([58.57 - 9.28, -1.5, 7.35]) rotate([-90, 0, 0]) {
                    hull() {
                        cylinder(r = 7, h = 1.51, $fn = 90);
                        translate([-9.33, 0, 0]) 
                            cylinder(r = 7, h = 1.51, $fn = 90);
                    }
                }
            }
        }
    }
    // Comment out if you want the thick back.
//    cube([65, 1, 130]);
}