// points of interest.
base_max_elevation = 87;
base_min_elevation = 30;

spacing = 220;
spacing_trim = 0.15;
wall_thickness = 1.24;

laptop_depth = 230;
laptop_thickness_at_rear = 15.5;
laptop_thickness_at_front = 14.5;

support_ratio = 9/10;
separate_by = 20;

// calculate the rise from min_elevation to max_elevation over a tangent distance of laptop_depth
base_rise = base_max_elevation - base_min_elevation;
echo("base_rise: ", base_rise);

base_length = sqrt(pow(laptop_depth, 2) - pow(base_rise, 2));
rise_angle = asin(base_rise / laptop_depth);

echo("base_length: ", base_length);
echo("rise_angle: ", rise_angle);
echo("upper_angle: ", 90 - rise_angle);

// supported ratio
support_base = base_length * support_ratio;
support_hyp = support_base / sin(90 - rise_angle);
support_leg = support_hyp * sin(rise_angle);

echo("support base:", support_base);
echo("support hyp: ", support_hyp);
echo("support leg: ", support_leg);

module side() {
    difference() {
        hull() {
            // Rear Upper Support Point
            translate([0, support_base, support_leg + base_min_elevation - 15 / 2]) rotate([0, 90, 0]) cylinder(d = 15, h = 15);
            // Front Upper Support Point
            translate([0, 0, base_min_elevation + 15 / 2]) rotate([0, 90, 0]) rotate([0, 0, 45 + rise_angle])
                cylinder(d = laptop_thickness_at_front + 3.5, h = 15, $fn = 4);
            // Rear Base Point
            translate([0, laptop_depth, 15 / 2]) rotate([0, 90, 0]) {
                translate([-15 / 2, -15 / 2, 0]) cube(15);
            }
            // Front Base Point
            translate([0, base_length * (1 - support_ratio), 15 / 2]) rotate([0, 90, 0])
                cylinder(d = 15, h = 15);
        }
        hull() {
            // Front Upper Support Point
            translate([0, 0, base_min_elevation]) rotate([0, 90, 0]) rotate([0, 0, rise_angle])
                translate([-5 - laptop_thickness_at_front, 15, 0]) cube([laptop_thickness_at_front + 5, 15, 15]);
            translate([0, 0, base_min_elevation]) rotate([0, 90, 0]) rotate([0, 0, rise_angle])
                translate([-5 - laptop_thickness_at_front, 0, 0]) cube([laptop_thickness_at_front, 2, 15]);
            // Rear Upper Support Point
            translate([0, support_base, support_leg + base_min_elevation - 15 / 2]) rotate([0, 90, 0])
                translate([-15-7.5, -15 / 2 + 15 / 2, 0]) cube([laptop_thickness_at_front, 15, 15]);
        }
        
        
        translate([2, 0, 0])
            spreader_bar();

        translate([0, -(base_length * (1 - support_ratio)) - 15 / 2 - 1, support_leg + base_min_elevation - 15 / 2 - 15 / 2 - 5])
            spreader_bar();
    }
}

side();
translate([spacing + separate_by * 2, 0, 0]) mirror([1, 0, 0]) side();

translate([separate_by, 0, 0]) 
    spreader_bar(trim = true);


module spreader_bar(trim = false) {
    translate([0, laptop_depth, 0])
    mirror([0, 1, 0]) 
    rotate([90, 0, 0])
    difference() {
        union() {
            translate([0, 2.5, 0])
                cube([spacing, 10, 2.5]);
            translate([15, 0, 0])
                cube([spacing - 30, 15, 2.5]);
        }
        if (trim == true) {
            translate([0, 0, 2 - spacing_trim]) {
                cube([15, 15, 2]);
                translate([spacing - 15, 0, 0])
                    cube([15, 15, 2]);
            }
        }
    }
}