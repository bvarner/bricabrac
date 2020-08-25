/** 
 * Customizable Router Bit Storage Trays & Inserts
 */

$fn = $preview ? 32 : 360;

printer_nozzle_od = 0.4;

l = inToMm(4.125 * 2);
w = inToMm(6 + 5/16);
d = inToMm(0.5);
spacing = inToMm(1.25);
hole = inToMm(5/8);

function mmToIn(mm) = mm * 0.03937007874;
function inToMm(in) = in * 25.4;

echo("Size: ", l, "x", w, " hole diameter:", hole, " spacing: ", spacing);

cols = ceil((w - spacing) / spacing);
rows = ceil((l - spacing) / spacing);

coffset = (w - (spacing * cols)) / 2;
roffset = (l - (spacing * rows)) / 2;

echo("cols: ", cols, " rows: ", rows);

base();

translate([w + spacing, 0, 0]) insert(1/2);
translate([w + spacing * 2, 0, 0]) insert(1/4);


module base() {
    difference() {
        cube([w, l, d]);
        for (c = [0 : cols - 1]) {
            for (r = [0 : rows - 1]) {
                translate([coffset + ((spacing / 2) + (c * spacing)), 
                           roffset + ((spacing / 2) + (r * spacing)), 
                           -0.25]) 
                    cylinder(d1 = hole, d2 = hole + printer_nozzle_od * 2, h = d + 0.5);
            }
        }
    }
}

module insert(shank = 1/2) {
    difference() {
        union() {
            cylinder(d1 = hole - printer_nozzle_od, d2 = hole + printer_nozzle_od, h = d);
            translate([0, 0, d]) cylinder(d = hole + inToMm(3/8), h = inToMm(3/16));
        }
        translate([0, 0, -inToMm(1/32)]) {
            cylinder(d = inToMm(shank) + printer_nozzle_od, h = d + inToMm(1/4));
            translate([-printer_nozzle_od / 2, 0, 0])
                cube([printer_nozzle_od, hole + inToMm(3/8), d + inToMm(1/4)]);
        }
    }
}    