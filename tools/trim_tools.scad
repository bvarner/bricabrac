// Transitional Craftsman Trim Header Clips

function inToMm(i) = i * 25.4;

reveal = inToMm(1/4);

length = inToMm(2);

// Casing Material [width, thickness]
casing = [inToMm(3 + 1 / 4), inToMm(1/2)];
// Header sizing. [protrusion per side, thickness, height] per entry.
header = [[inToMm(5/16), inToMm(13 / 16), casing[1]], 
          [0, casing[1], inToMm(2 + 3 / 4)], 
          [inToMm(3/4), inToMm(1 + 1/ 4), inToMm(1)]];


// Recursive function to calculate the y-axis start location of a header layer.
function headerLayerStart(target, current = 0, sum = 0) =
    (target == current) || current > len(header) - 1? 
        sum :
        headerLayerStart(target, current + 1, sum + header[current][2]);
        
function headerProtrusions() = [ for (i = [0 : len(header) - 1]) each header[i][0]];
        
function headerHeight() = headerLayerStart(len(header));
        
//color("green") sample_casing();
//sample_header();
//header_alignment_helper();

header_assembly_clip();

translate([150, 0, 0]) mirror([1, 0, 0]) header_assembly_clip();

module header_assembly_clip() {
    top_layer_protrusion = header[len(header) - 1][0];
    
    difference() {
        translate([-max(headerProtrusions()) - reveal, 0, - reveal]) {
            cube([reveal + max(headerProtrusions()) + reveal * 10, headerHeight() + reveal * 8, casing[1] + reveal]);
        }
        translate([0, reveal * 4, 0]) {
            // remove 1/4" from the upper portion for clamping effect.
            difference() {
                sample_header(outset = reveal / 2);
                translate([0 - top_layer_protrusion, headerHeight() - reveal, 0])
                    cube([top_layer_protrusion + casing[0] + length, 
                            reveal, 
                            header[len(header) - 1][1]]);
            }
        }
        // Hollow for featherboards
        translate([-top_layer_protrusion, headerLayerStart(len(header) - 1) + reveal * 4, 0]) {
            cube([top_layer_protrusion + reveal * 10, 
                    header[len(header) - 1][2] + reveal * 3, 
                    casing[1]]);
        }
        
        // Trim the extra off the bottom.
        translate([-max(headerProtrusions()) - reveal, 0, - reveal]) {
            cube([reveal + max(headerProtrusions()) + reveal * 10, reveal * 3, casing[1] + reveal]);
        }
    }
    
    // Add the featherboards
    translate([-top_layer_protrusion + reveal * 2, headerHeight() - (reveal / 5) + reveal * 4, 0]) {
        difference() {
            intersection() {
                cube([top_layer_protrusion + reveal * 8, reveal * 4 + reveal, casing[1]]);
                for (i = [0 : 2 : 8]) {
                    translate([reveal * i, 0, 0])
                        rotate([0, 0, -35]) 
                            cube([2.54, (reveal * 4) / cos(35), casing[1]]);
                }
            }
            // undercut for freedom of movement
            translate([0, 0.75, 0]) cube([top_layer_protrusion + reveal * 9, reveal * 4 - 0.75, 0.5]);
            
        }
    }
}



module header_alignment_helper() {
    translate([0 - header[0][0] - reveal, 0, 0]) {
        difference() {
            cube([header[0][0] + reveal, header[0][2] + reveal * 10, reveal]);
            translate([reveal, reveal * 9, 0]) {
                translate([0, -1, 0]) cube([header[0][0], header[0][2] + 2, reveal]);
            }
        }
    }
}


module sample_casing() {
    // round the top, flatten the bottom casing
    cube([casing[0], length, casing[1]]);
}

// Outset lets you make the parts bigger so they'll slide into a negative.
module sample_header(outset = 0) {
    for (i = [0 : len(header) - 1]) {
        ymin_outset = (i == 0) ? 0 : outset;
        ymax_outset = (i == len(header) -1) ? 0 : outset;
        translate([0 - header[i][0], headerLayerStart(i) - ymin_outset, 0])
            cube([header[i][0] + casing[0] + length, header[i][2] + ymin_outset + ymax_outset, header[i][1]]);
    }
}