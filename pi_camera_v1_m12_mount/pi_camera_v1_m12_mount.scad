include <lib/polyScrewThread_r1.scad>
include <MCAD/units.scad>

base_size = 16;			    // Width and length of square base
base_height = 6;		    // Height of square base
base_cavity_margin = 3;		// Wall thickness of cavity in square base

thread_diameter = 12.25;	// Diameter of thread (M12) + extra for shrinking
thread_margin = 2;		// Thickness of ring around thread
thread_pitch = 0.5;		// Pitch of thread
mount_height = 15.5;	// Overall height of thread

hole_distance = 21;		// Distance between the two mounting holes
hole_diameter = 2.0;	// Diameter of mounting holes
hole_style = 1;			// 0 = flange, 1 = straight bars
hole_height = 3.5;

miniconnector_x = 8.5;
miniconnector_z = 2;

enable_thread = true;	// Turn on/off thread (takes a while to render)
enable_base = true;		// Turn on/off square base
enable_mount = true;	// Turn on/off circular mount

$fn = $preview ? 32 : 90;

// Base
if(enable_base) {
	difference() {
		if(hole_style == 0) {
			hull() {
				// Square base
				translate([0,0,base_height/2])
					cube([base_size, base_size, base_height], center = true);
			
				// Right flange
				translate([hole_distance/2, 0, 0])
					cylinder(r = 2, h = base_height, $fn = 15);
			
				// Left flange
				translate(-[hole_distance/2, 0, 0])
					cylinder(r = 2, h = base_height, $fn = 15);
			}
		} else if(hole_style == 1) {
			union() {
				// Square base
				translate([0,0,base_height/2])
					cube([base_size, base_size, base_height], center = true);
			
				// Right flange
				translate([hole_distance/2, 0, 0])
					cylinder(r = 2, h = hole_height, $fn = 15);
			
				// Left flange
				translate(-[hole_distance/2, 0, 0])
					cylinder(r = 2, h = hole_height, $fn = 15);
	
				// Joining bar
				if(hole_style == 1)
					translate([0,0,hole_height/2])
						cube([hole_distance, 4, hole_height], center = true);
			}
		}

		// Hollow center
		translate([0,0,base_height/2])
			cube([base_size - base_cavity_margin*2, base_size - base_cavity_margin*2, base_height], center = true);
	
		// Right hole
		translate([hole_distance/2, 0, 0])
			cylinder(r = hole_diameter/2, h = hole_height + 2, $fn = 15);
	
		// Left hole
		translate([-hole_distance/2, 0, 0])
			cylinder(r = hole_diameter/2, h = hole_height + 2, $fn = 15);

		// Nappe hole 
		translate([0, base_size / 4, miniconnector_z / 2])
			cube([miniconnector_x, base_size / 2, miniconnector_z], center = true);
        
        translate([0, 0, 0])
            cylinder(r = thread_diameter / 2, h = base_height);
	}
}

// M12 threaded mount
if(enable_mount) {
	translate([0, 0, base_height - 1])
	difference() {
		cylinder(r = thread_diameter/2 + thread_margin/2, h = mount_height - base_height);
		
		// M12 thread 
		// (Outer diameter, pitch, thread angle, length, resolution, countersink style)
		if(enable_thread) {
			screw_thread(thread_diameter, thread_pitch, 55, mount_height - base_height + 1, 3.14/2, 0);
        } else {
			cylinder(r = thread_diameter/2, h = mount_height - base_height);
        }
	}
}
