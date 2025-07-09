/**
 * SMD Component Container Rail(c) by T.Wirtl
 *
 * is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
 * You should have received a copy of the license along with this work. If not, see 
 * <http://creativecommons.org/licenses/by-sa/4.0/>.
 *
 * Disclaimer: Profile shapes are imported from a model by @LordAsdi
 *
 **/


$fn=100;
counterbore_spacing = 0.6;
tape_spacing = 0.8;
slider_spacing=0.5;
side_wall_thickness=1.25;
slider_pos=33.5;

// Imports from original data from @LordAsdi (https://www.printables.com/model/580643-smd-component-tape-magazine-8-12-16mm)
// which is licensed under CC-BY 4.0
module body_centered()
{
    translate([-0.4,-32.5,0])rotate([-90,0,0]) import("LordAsdi_sources/Body_8mm.stl");
}

module lid_centered()
{
    translate([-0.4,-32.5,-14.2])rotate([-90,0,0]) import("LordAsdi_sources/Lid.stl");
}

module slider_centered()
{
    translate([-0.4,-32.5,0])rotate([-90,0,0])  import("LordAsdi_sources/Slider_8mm.stl");
}

module 2d_right()
{
    projection(true) translate([0,0,-1.2])body_centered();
}

module 2d_mid_noslot()
{
    projection(true) translate([0,0,-2])body_centered();
}

module 2d_mid_slot()
{
    projection(true) translate([0,0,-3])body_centered();
}

module 2d_mid_slot_cutout()
{
    difference()
    {
        projection(true) translate([0,0,-3])body_centered();
        translate([29,33])square([10,5]);
    }
}
module 2d_label(width=8)
{
    difference()
    {
        hull()for(x=[1,-1],y=[1,-1])translate([6*x,6*y])circle(r=4);
        hull()for(x=[1,-1],y=[1,-1])translate([5.5*x,5.5*y])circle(r=3.5);
    }
    translate([0,3.5,0])mirror([1,0,0]) text(str(width),size=9,halign="center", valign="center", font="Liberation Sans:style=Bold");
    translate([0,-5,0])mirror([1,0,0]) text("mm",size=6,halign="center", valign="center", font="Liberation Sans:style=Bold");
}

module 2d_lid()
{
    projection(true) lid_centered();
}

module 2d_slider()
{
    projection(true) translate([0,0,-8])slider_centered();
}

module body_base(wall=1.2, width=8, slot=6)
{
    difference()
    {
        linear_extrude(wall) union()
        {
            2d_right();
            2d_mid_noslot(); // added for the thumb rest
        }
        
    }
    linear_extrude(wall+width) // label space removal
    { 
        intersection()
        {
            2d_right();
            translate([-50,30])square([70,50]);
        }
    }
    difference() {
        linear_extrude(2 * wall+width)2d_mid_slot_cutout();
        // Remove the lid. Resized because it fits weird...
        translate([0, 0, wall+width]) linear_extrude(wall + .5) {
            translate([0.25, 0.2, 0]) scale([1.02, 1.02, 1]) 2d_lid();
        }
        // Clean up... 
        translate([-20, -40, wall+width]) cube([60, 80, wall]);
    }
    linear_extrude(wall+(width-slot)/2) 2d_mid_noslot();
    linear_extrude(wall+(width-slot)/2+slot) 2d_mid_slot();
}

module countersunk_m2_5(l1=10,l2=0.25)
{
    cylinder(h=l2,d=5);
    translate([0, 0, l2]) {
        cylinder(h=1.5,d1=5,d2=2.6);
        cylinder(h=l1,d=2.6);
    }
}

module body(width = 8)
{
    spaced_width = width + tape_spacing;
    
    difference()
    {
        body_base(side_wall_thickness, spaced_width, spaced_width - 2);
        translate([20,20,-0.01]) linear_extrude(.4) 2d_label(width);
        
        for (pos=[[-21,-27],[21,-27],[-25, 27],[18, 32.8]])
        {
            translate([pos.x,pos.y,side_wall_thickness]) cylinder(h=spaced_width+.1,d=2.05); // tap
            translate([pos.x,pos.y,side_wall_thickness+spaced_width-2]) cylinder(h=1.25,d1=2.05,d2=2.75);
            translate([pos.x,pos.y,side_wall_thickness+spaced_width-1]) cylinder(h=1,d1=4,d2=5);
        }
        translate([slider_pos+1,-18.79,spaced_width/2+side_wall_thickness]) rotate([90,0,0])cylinder(h=1.51,d=4.4);
     
        // LABEL
        translate([-8.75,33,spaced_width/2+side_wall_thickness+0.01]) rotate([0,0,2.75])
        {
            translate([1, -1, 0]) cube([40+3,1.25,spaced_width], center=true);
            translate([1, 1,0])cube([40,4,spaced_width], center=true);
        }
        translate([-54.5,25.85,-0.00])cylinder(d2=36,d1=36+1.6, h=2,$fn=300);
        translate([-54.5,25.85, side_wall_thickness + width + tape_spacing / 4])cylinder(d1=36,d2=36+1.6, h=2,$fn=300);
    }

    
    hull()
    {
        translate([34.6,30,0]) cylinder(h=side_wall_thickness,d=3);
        translate([34.6,-20.3,0]) cylinder(h=side_wall_thickness,d=3);
    }
    
    translate([slider_pos,-5.3,0]) cylinder(h=side_wall_thickness + 1,d=1.9);
    hull()
    {
        translate([slider_pos,16.3,0]) cylinder(h=side_wall_thickness + 1,d=1.9);
        translate([slider_pos,10.5,0]) cylinder(h=side_wall_thickness + 1,d=1.9);
    }
}

module lid()
{
    difference()
    {
        group()
        {
            linear_extrude(side_wall_thickness) 2d_lid();
            for (pos=[[-21,-27],[21,-27],[-25, 27],[18, 32.8]])
                translate([pos.x,pos.y,-1.2]) cylinder(h=1.2, d1=4 - counterbore_spacing, d2=5 - counterbore_spacing);
            
            hull()
            {
                translate([34.6,30,0]) cylinder(h=side_wall_thickness,d=3);
                translate([34.6,-20.3,0]) cylinder(h=side_wall_thickness,d=3);
            }
        }

        for (pos=[[-21,-27],[21,-27],[-25, 27],[18, 32.8]])
            translate([pos.x,pos.y,side_wall_thickness]) rotate([180,0,0]) countersunk_m2_5();
        
        hull()
        {
            translate([slider_pos,-15.7,-.01]) cylinder(h=1.4,d=2.2);
            translate([slider_pos,-5.3,-.01]) cylinder(h=1.4,d=2.2);
        }
        hull()
        {
            translate([slider_pos,16.3+10.4,-.01]) cylinder(h=1.4,d=2.2);
            translate([slider_pos,10.5,-.01]) cylinder(h=1.4,d=2.2);
        }
    }
}

module slider(width=8)
{

    width = width + tape_spacing - slider_spacing;
    difference()
    {
        group()
        {
            linear_extrude(width) 2d_slider();
            
            translate([slider_pos,-15.7,0]) cylinder(h=width + 1,d=1.9);
            hull()
            {
                translate([slider_pos,16.3,0]) cylinder(h=width + 1,d=1.9);
                translate([slider_pos,10.5,0]) cylinder(h=width + 1,d=1.9);
            }
        }
        hull()
        {
            translate([slider_pos,-15.7,-.01]) cylinder(h=1.6,d=2.2);
            translate([slider_pos,-5.3,-.01]) cylinder(h=1.6,d=2.2);
        }
        hull()
        {
            translate([slider_pos,16.3,-.01]) cylinder(h=1.6,d=2.2);
            translate([slider_pos,10.5-10.4,-.01]) cylinder(h=1.6,d=2.2);
        }
        translate([slider_pos+1,-18.61,width/2]) rotate([-90,0,0])cylinder(h=4.51,d=4.4);
        
    }
    for (x=[0:3:3*10])
    translate([slider_pos,-15+x,0.105+1.4]) cube([3,1,0.21],center=true);

}

module label(width=8)
{
    translate([-5,40,0]) {
        cube([40 + 2 - counterbore_spacing , width+tape_spacing - counterbore_spacing, .8]);
        translate([1, 0, 0.8]) cube([40 - counterbore_spacing, width + tape_spacing - counterbore_spacing, 2.5]);
    }
}

module preview(width=8)
{
    translate([0,10,side_wall_thickness+slider_spacing/2 ])slider(width);
    translate([0,0,side_wall_thickness + width+tape_spacing+0.1]) lid();
    body(width);
}

module build_plate(width=8)
{
    translate([65,5,0])rotate([0,0,90])slider(width);
   translate([75,0,side_wall_thickness])rotate([180,0,0])lid();
    body(width);
    label(width);
}

//label(8);

//body(8);
//preview(8);
build_plate(12);
//translate([75,0,side_wall_thickness])rotate([180,0,0])lid();

//slider(8);
