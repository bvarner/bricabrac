// Estes A, B, and C engine dimensions
// [ Engine Form Dimensions ]
engine_od = 17.5;
engine_wall = 2.25;
engine_id = engine_od - engine_wall;
form_length = 70;

outer_form_bolt_diameter = 3;

// Dimensions of the profile for the casing layers.
// Nozzle, primary charge, delay charge, upper cap
casing_profile = [10, 40, 6, 8];

nozzle_divergent_length = casing_profile[0] * (2/3);
nozzle_divergent_diameter= 3.5; // based on measurements of an estes engine.
nozzle_convergent_length = casing_profile[0] * (1/3);

nozzle_throat_diameter = 3; // 12awg solid copper wire for the core forming.
nozzle_pin_diameter = 2.05; // 12 awg solid copper wire stripped.

// Calculate the length of the divergent parabola.
nozzle_height = parabolaPoint(nozzle_divergent_diameter,
                                                sqrt(nozzle_divergent_length / nozzle_divergent_diameter) / 2);

// [ Printer Related Settings ]
printer_nozzle_od = 0.4;
wall = 1.22; // thickness of printed walls
band_height = 1.2; // z-layer height of vent hole bands ( make a multiple of your slice layers)

// [ Render Options ]
$fn = 360;

outer_form = true;
outer_form_tie = true;

inner_form = true;
inner_form_support = true;
retainer_clip = false; 

ramming_rod = true;
ramming_base = true;
nozzle_forms = true;


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
   
    if (outer_form == true) {
        // Ventilation Holes
        for(i = [0 : 1 : (form_length / segment_height)] ) {
            translate([0, 0, i * segment_height]) 
            // z becomes a counter of which band we're on within this segment
            for(z = [1 : 1 : (segment_height - (band_height * 2)) / band_height]) {
                layer_rot = z * 22.5;
                rotate([0, 0, layer_rot])
                translate([0, 0, z * band_height]) {
                    render() 
                    for(l = [0:45:360]) {
                        rotate([0, 0, l])
                            translate([0, 0, band_height / 2])
                                hull () {
                                    translate([0, engine_od / 3, 0]) cylinder(d = wall / 4, h = band_height, $fn = 3, center = true);
                                    translate([0, (engine_od + printer_nozzle_od + wall + wall) / 2 + 1, 0]) cube([3, 1, band_height], center = true);
                                }
                    }
                }
            }
        }
    }
    
    if (inner_form == true) {
        for (z = [band_height : band_height : form_length - band_height * 2]) {
            layer_rot = (z / band_height) * 22.5;
            translate([0, 0, z])
                rotate([0, 0, layer_rot])
                    render() 
                    for(l = [0:45:360]) {
                        rotate([0, 0, l])
                            translate([0, 0, band_height / 2])
                                hull () {
                                    translate([0, (engine_id - printer_nozzle_od) / 3, 0]) 
                                        cylinder(d = wall / 4, h = band_height, $fn = 3, center = true);
                                    translate([0, (engine_id - printer_nozzle_od) / 2, 0]) 
                                        cube([1.5, 1, band_height], center = true);
                                }
                    };
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
if (inner_form_support == true) {
    support_od = engine_id - printer_nozzle_od - wall - wall - printer_nozzle_od;
    // Support is made of 3 'legs', which are hulled cubes intersected 
    // with the properly sized cylinder to round their outter wall.
    intersection() {
        union() {
            intersection() {
                union() {
                    for (zr = [0:120:360]) {
                        // Leg at 0-degrees is wider, to 
                        rotate([0, 0, zr]) 
                            hull() {
                                translate([0, -wall, -5])
                                    cube([0.1, wall * 2, form_length + 10]);
                                
                                translate([support_od / 2 - 0.1, - wall * ((zr == 0 ? 4 : 1) / 2), -5])
                                    cube([0.1, wall * (zr == 0 ? 4 : 1 ), form_length + 10]);
                            };
                    }
                }
                union() {
                    cylinder(d = support_od, h = form_length);
                    translate([0, 0, form_length]) 
                        cylinder(d1 = engine_id - printer_nozzle_od - wall - wall - printer_nozzle_od, d2 = engine_id - 5, h = 5);
                    translate([0, 0, -5]) 
                        cylinder(d2 = engine_id - printer_nozzle_od - wall - wall - printer_nozzle_od, d1 = engine_id - 5, h = 5);
                }
            }
            // Spreader to fill out the outer wall.
            hull() {
                // Lower cube.
                translate([0, - wall / 2 + (printer_nozzle_od / 2), -5]) 
                    cube([engine_id / 2 - 2.75, wall - printer_nozzle_od , 0.1]);
                
                // Main cube filler.
                translate([0, - wall + (printer_nozzle_od / 2), 0]) 
                    cube([engine_id / 2, (wall * 2) - printer_nozzle_od , form_length]);
                
                // Upper cube
                translate([0, - wall / 2 + (printer_nozzle_od / 2), form_length + 5]) 
                    cube([engine_id / 2 - 2.75, wall - printer_nozzle_od , 0.1]);
                
            }
            
        }
        translate([0, 0, -5])
            cylinder(d = engine_id - printer_nozzle_od, h = form_length + 10);
    }
}


if (nozzle_forms == true) {
    form_od = engine_od + printer_nozzle_od + wall + wall;
    
    // Nozzle Parabola on the top end for forming nozzles.
    translate([100, 0, 0]) {
        difference() {
            union() {
                difference() {
                    union() {
                        cylinder(d = form_od,
                                     h = 15);
                        
                        translate([0, 0, 15 + nozzle_height]) mirror([0, 0, 1]) 
                        {
                            intersection() {
                                parabola(nozzle_divergent_diameter, sqrt(nozzle_divergent_length / nozzle_divergent_diameter) / 2);
                                translate([0, 0, nozzle_height - casing_profile[0]])
                                cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                                     h = casing_profile[0]);
                            }
                        }
                    };
                    // Remove the throat, so we can provide a flat top.
                    translate([0, 0, 15]) 
                        cylinder(d = nozzle_throat_diameter + printer_nozzle_od,
                                     h = casing_profile[0]);
                }
                
                // Add back in the throat with a nice flat top.
                translate([0, 0, 15]) 
                        cylinder(d = nozzle_throat_diameter + printer_nozzle_od, 
                                                             h = casing_profile[0] - nozzle_convergent_length);
            }
            // Center bore for the alignment pin.
            cylinder(d = nozzle_pin_diameter + printer_nozzle_od,
                         h = 15 + casing_profile[0]);
            
            // Knurl
            for(zr = [0 : 30 : 330]) {
                rotate([0, 0, zr])
                    translate([form_od / 2 + 1, 0, 0])
                        cylinder(d1 = 4, d2 = 2, h = 13);
            }
            
            // Watermark
            translate([0, -form_od / 4, 0])
            mirror([0, 1, 0])
                linear_extrude(height = 0.4)
                text(str(nozzle_throat_diameter), 5, 
                       font = "Arial:style=Bold", valign = "center", halign = "center");
            }
    }
    
    
    // Rod for forming the convergent side.
    translate([100, 25, 0]) {
        difference() {
            union() {
                // 3 legged support -- No Infil
                // Very much like the insertable type for the inner forms.
                intersection() {
                    union() {
                        for (zr = [0:120:360]) {
                            rotate([0, 0, zr]) 
                                hull() {
                                    translate([0, -(wall * 2) / 2, -5])
                                        cube([0.1, wall * 2, form_length + 10]);
                                    translate([(engine_id - printer_nozzle_od - printer_nozzle_od) / 2 - 0.1, 
                                                     - wall * (1 / 2), 
                                                     -5])
                                        cube([0.1, wall, form_length + 10]);
                                };
                        }
                    };
                    cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 h = form_length - casing_profile[0]);
                }
                
                // Support for convergent seal.
                translate([0, 0, form_length - casing_profile[0] - 10])
                    cylinder(d1 = 1,
                                 d2 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 h = 10);
                
                // Convergent side
                translate([0, 0, form_length - casing_profile[0]])
                    cylinder(d1 = engine_id - printer_nozzle_od - printer_nozzle_od,
                                 d2 = nozzle_throat_diameter + printer_nozzle_od,
                                 h = nozzle_convergent_length);
            }

            // Center Bore for alignment pin
            translate([0, 0, form_length - casing_profile[0] - 5]) 
                cylinder(d = nozzle_pin_diameter + printer_nozzle_od,
                             h = casing_profile[0] + 5);
            
            rotate([90, 0, 5])
                translate([(engine_id - printer_nozzle_od - printer_nozzle_od) / 4, 4, wall - 0.2])
                linear_extrude(height = wall / 2)
                text(str(nozzle_throat_diameter), 5, 
                       font = "Arial:style=Bold", valign = "center", halign = "center");
        }        
    }
}
    
if (ramming_rod == true) {
    // General Ram-Rod for packing.
    translate([75, 0, 0]) {
        difference() {
            cylinder(d = engine_id - printer_nozzle_od - printer_nozzle_od,
                         h = form_length + 5);

            // Hollow for brass...
            cylinder(d = 3 + printer_nozzle_od, h = form_length + 5);

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

if (ramming_base == true) {
    translate([100, 100, 0]) {
        difference() {
            cylinder(d = engine_od + printer_nozzle_od + wall * 2 + 16, h = 15);
            translate([0, 0, 15 - 3]) {
                cylinder(d = engine_od + printer_nozzle_od + wall + wall + printer_nozzle_od, h = 4);
                for (zr = [0 : 10]) {
                    rotate([0, 0, zr]) 
                        outer_form(separate = false, hull = true);
                }
            }
            cylinder(d = 4.96 + printer_nozzle_od, h= 15);
            cylinder(d = 20 + printer_nozzle_od, h = 4);
        }
    }    
}

module outer_form(separate = true, hull = false) {
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
            if (!hull) {
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
}

// Shamelessly ripped from some google searching....
// Found here: http://forum.openscad.org/Parabolic-Trough-td5362.html

//Standard parabola
function parabolaPoint(x, k) = k * x * x;

//Focal point equals Y where derivative of parabolaPoint is 1.
function focal_length(k) = parabolaPoint(0.5 / k, k);

//Cup shape
module outer_parabola(width, k, segments = $fn / 10, base_thickness = 1) {
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, -base_thickness], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, -base_thickness]],
            [[3, 2, 1, 0]]);
    }
}

//Bulge shape
module inner_parabola(width, k, segments = $fn / 10) {
    max_y = parabolaPoint(width, k);
    for(i = [-segments:1:segments - 1]) {
        x1 = i * width / segments;
        x2 = (i + 1) * width / segments;
        polygon([[x1, max_y], [x1, parabolaPoint(x1, k)],
            [x2, parabolaPoint(x2, k)], [x2, max_y]],
            [[0, 1, 2, 3]]);
    }
}

module parabola(width, k, segments = $fn / 10) {
    rotate_extrude($fn = segments * 4)
    intersection() {
        inner_parabola(width, k, segments);
        translate([0, -1])
        square([width + 1, parabolaPoint(width, k) + 2]);
    }
}