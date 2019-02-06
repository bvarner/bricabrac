// Estes A, B, and C engine dimensions
// [ Engine Form Dimensions ]
engine_od = 17.5;
engine_wall = 2.25;
engine_id = engine_od - engine_wall;
form_length = 70;

outer_form_bolt_diameter = 3;

// Nozzle, primary charge, delay charge, upper cap
casing_profile = [10, 40, 6, 8];

// [ Printer Related Settings ]
printer_nozzle_od = 0.4;
wall = 1.22; // thickness of printed walls
band_height = 1.2; // z-layer height of vent hole bands ( make a multiple of your slice layers)

// [ Render Options ]
$fn = 360;

outer_form = true;
outer_form_tie = true;

inner_form = false;
retainer_clip = false;

ramming_base = false;
ramming_rod = false;

bands_per_segment = ((form_length) / band_height)  / 5;
segment_height = band_height * bands_per_segment;

difference() {
    union() {
        // Outer shell and hold sides.
        if (outer_form == true) {
            outer_form();
        }
        
        // Inside forming tube
        if (inner_form == true) {
            difference() {
                cylinder(d = engine_id - printer_nozzle_od, h = form_length);
                cylinder(d = engine_id - printer_nozzle_od - wall - wall, h = form_length);
                translate([0, - wall, 0]) cube([engine_id, wall * 2, form_length]);
            }
        }
    }
   
    if (outer_form == true || inner_form == true) {
        // Ventilation Holes
        for(i = [0 : 1 : (form_length / segment_height)] ) {
            translate([0, 0, i * segment_height]) 
            // z becomes a counter of which band we're on within this segment
            for(z = [1 : 1 : (segment_height - (band_height * 2)) / band_height]) {
                layer_rot = (z % 2 == 0 ? 45 / 2  : 0);
                rotate([0, 0, layer_rot])
                translate([0, 0, z * band_height]) {
                    render() 
                    for(l = [0:45:360]) {
                        rotate([0, 0, l])
                            translate([0, 0, band_height / 2])
                                hull () {
                                    cylinder(d = wall / 4, h = band_height, $fn = 3);
                                    translate([0, (engine_od + printer_nozzle_od + wall + wall) / 2 + 1, 0]) cube([3, 1, band_height], center = true);
                                }
                    }
                }
            }
        }
    }
}

// retainer clip
if (retainer_clip == true) {
    translate([engine_od, -engine_od - 8, 0]) {    
        difference() {
            cube([wall * 4 * 2, 8 - wall + (wall), 4]);
            translate([wall * 2 - (printer_nozzle_od / 2), 0, 0]) cube([wall * 4 + printer_nozzle_od , 8 - wall, 4]);
        }
        translate([wall * 2 - (printer_nozzle_od / 2), 2.75, 2]) resize([wall, 0, 0]) sphere(d = 4 - printer_nozzle_od);
        translate([wall * 6 + (printer_nozzle_od / 2), 2.75, 2]) resize([wall, 0, 0]) sphere(d = 4 - printer_nozzle_od);
    }
}

// Inner Form Support
if (inner_form == true) {
    difference() {
        union() {
            cylinder(d = engine_id - printer_nozzle_od - wall - wall - printer_nozzle_od, h = form_length);
            translate([0, 0, form_length]) cylinder(d1 = engine_id - printer_nozzle_od - wall - wall - printer_nozzle_od, d2 = engine_id - 5, h = 10);
            translate([0, - wall + (printer_nozzle_od / 2), 0]) cube([(engine_id - printer_nozzle_od) / 2, (wall * 2) - printer_nozzle_od , form_length]);
        }
            for(mx = [0:1]) {
                mirror([mx, 0 , 0])
                for (my = [0:1]) {
                    mirror([0, my, 0])
                        translate([wall, wall * 1.5, 0]) 
                            cube([engine_id / 2, engine_id / 2, form_length + 10]);
                }
           }
    }
}

if (ramming_base == true) {
    base_thickness = 7;
    translate([0, 75, 0]) {
        difference() {
            $fn = 64;
            union() {
                difference() {
                    cylinder(d = engine_od + 40, h = base_thickness);
                    
                    // Form base to inset
                    for (rz = [0 : 10]) {
                       rotate([0, 0, rz]) translate([0, 0, base_thickness - 2]) minkowski() {
                             intersection() {
                                outer_form(separate = false);
                                cylinder(d = engine_od + printer_nozzle_od + wall + wall + 16, h = 0.1);
                            };
                            cylinder(d = printer_nozzle_od, h = 2.9, $fn = 12);
                        }
                    }
                    translate([0, 0, base_thickness - 2]) cylinder(d = engine_od + printer_nozzle_od, h = 2);
                }
                
                // Inset for nozzle pack
                translate([0, 0, base_thickness - 2]) {
                    cylinder(d = engine_id - printer_nozzle_od, h = casing_profile[0] - 0.5);
                    translate([0, 0, casing_profile[0] - 0.5]) cylinder(d1 = engine_id - printer_nozzle_od, d2 = engine_id - printer_nozzle_od - 0.5, h = 0.5);
                }
                
//                // Nozzle Parabola.
//                nozzle_width = 3.5;
//                nozzle_depth = casing_profile[0];
//                
//                translate([0, 0, base_thickness - 1 + nozzle_depth]) 
//                    mirror([0, 0, 1])
//                        parabola(nozzle_width, sqrt(nozzle_depth / nozzle_width) / 2, 15);
                
                // Core Bore -- Ideally, about 3mm.
                // I have a 2.92mm (0.115") drill I use
                translate([0, 0, base_thickness - 1]) cylinder(d = 2.92 - printer_nozzle_od, h = 10);
            }
            
            cylinder(d = 3 + printer_nozzle_od, h = 10 + base_thickness);
        }
    }
}




if (ramming_rod == true) {
    // Nozzle Parabola on the top end.
    nozzle_width = 3.5;
    nozzle_depth = 10;
    
    translate([100, 0, 0]) {
        difference() {
            union() {
                cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                             h = 15);
                translate([0, 0, 15 + casing_profile[0]]) mirror([0, 0, 1])
                    intersection() {
                        parabola(3.5, sqrt(nozzle_depth / nozzle_width) / 2, 15);
                        cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                             h = casing_profile[0]);
                    }
            };
            translate([0, 0, -1]) cylinder(d = 2.92 + printer_nozzle_od, h = 15 + casing_profile[0] + 2);
        }    
    }
    
    translate([75, 0, 0]) {
        difference() {
            cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                         h = form_length + 5);

            // Top of nozzle marking.
            translate([0, 0, form_length - casing_profile[0]]) {
                difference() {
                    cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od, h = 1);
                    
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 h = 0.5);
                    
                    translate([0, 0, 0.5])
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od, 
                                 h = 0.5);
                }
            }
            
            // Top of propellant.
            translate([0, 0, form_length - casing_profile[0] - casing_profile[1]]) {
                difference() {
                    cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od, h = 1);
                    
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 h = 0.5);
                    
                    translate([0, 0, 0.5])
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od, 
                                 h = 0.5);
                }
            }
            
            // Top of delay charge.
            translate([0, 0, form_length - casing_profile[0] - casing_profile[1] - casing_profile[2]]) {
                difference() {
                    cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od, h = 1);
                    
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 h = 0.5);
                    
                    translate([0, 0, 0.5])
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od, 
                                 h = 0.5);
                }
            }
            
            // Top of cap.
            translate([0, 0, form_length - casing_profile[0] - casing_profile[1] - casing_profile[2] - casing_profile[3]]) {
                difference() {
                    cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od, h = 1);
                    
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 h = 0.5);
                    
                    translate([0, 0, 0.5])
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od - 1,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od, 
                                 h = 0.5);
                }
            }
        }
    }
}

module outer_form(separate = true) {
    for (z = [0 : 120 : 240]) {
        spreadxy = separate == true && z == 240 ? 1 : 0;
        rotate([0, 0, z]) translate([spreadxy, spreadxy, 0])
        difference() {
            union() {
                //  Outer casing cylinder
                cylinder(d = engine_od + printer_nozzle_od + wall + wall, h  = form_length);
                
                // Outer casing walls.
                translate([-wall * 2, 0 , 0]) cube([wall * 4, (engine_od + printer_nozzle_od + wall + wall) / 2 + 8, form_length]);
                rotate([0, 0, -120]) translate([-wall * 2, 0 , 0]) cube([wall * 4, (engine_od + printer_nozzle_od + wall + wall) / 2 + 8, form_length]);
            }
            
            // Outer casing ID.
            cylinder(d = engine_od + printer_nozzle_od, h = form_length);
            
            // Cut outer casing to 1/3'rd portion.
            rotate([0, 0, - 120]) translate([0, -(engine_od + printer_nozzle_od + wall + wall) / 2 , 0]) 
                cube([(engine_od + printer_nozzle_od + wall + wall) / 2, engine_od + printer_nozzle_od + wall + wall + 8 - (spreadxy == 0 && outer_form_tie == true ? 0.2 : 0), form_length]);
                
            rotate([0, 0, - 180]) translate([0, -(engine_od + printer_nozzle_od + wall + wall) / 2 - 8 + (spreadxy == 0 && outer_form_tie == true ? 0.2 : 0), 0]) 
                cube([(engine_od + printer_nozzle_od + wall + wall) / 2, engine_od + printer_nozzle_od + wall + wall, form_length]);
            
            // Snap Holes on outer Form.
            for(i = [0 : segment_height : form_length] ) {
                for(z = [0:240:240]) {
                    rotate([0, 0, z])
                    translate([0, (engine_od + printer_nozzle_od + wall + wall) / 2 + 4, i + segment_height / 2]) rotate([0,90,0]) cylinder(d = outer_form_bolt_diameter + printer_nozzle_od, h = 10, center = true);
                }
            }
        }
    }
}

// Shamelessly ripped from some google searching....
// Found here: http://forum.openscad.org/Parabolic-Trough-td5362.html

//Standard parabola
function parabolaPoint(x, k) = k * x * x;

//Focal point equals Y where derivative of parabolaPoint is 1.
function focal_length(k) = parabolaPoint(0.5 / k, k);

//Cup shape
module outer_parabola(width, k, segments, base_thickness = 1) {
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, -base_thickness], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, -base_thickness]],
            [[3, 2, 1, 0]]);
    }
}

//Bulge shape
module inner_parabola(width, k, segments) {
    max_y = parabolaPoint(width, k);
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, max_y], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, max_y]],
            [[0, 1, 2, 3]]);
    }
}

module parabola(width, k, segments) {
    rotate_extrude($fn = segments * 4)
    intersection() {
        inner_parabola(width, k, segments);
        translate([0, -1])
        square([width + 1, parabolaPoint(width, k) + 2]);
    }
}