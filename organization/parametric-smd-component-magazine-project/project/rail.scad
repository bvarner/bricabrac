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


// Imports from original data from @LordAsdi (https://www.printables.com/model/580643-smd-component-tape-magazine-8-12-16mm)
// which is licensed under CC-BY 4.0
module rail_centered()
{
    rotate([-90,0,0])translate([0,0,1])import("LordAsdi_sources/rail_100mm.stl");
}

module spring(l=100)
{   
    //spring_len=48.48;
    //spring_len=49;
    //spring_len=49.5;
  
    spring_len=50;
  
    difference()
    {
        group()
        {
            cube([spring_len+2.8,l,0.8],center=true);
            for (x=[1,-1]) translate([x*spring_len/2,l/2,0.4]) difference()
            {
                rotate([90,0,0])cylinder(d=2.8,h=l);
                translate([-3/2,-l-1,-3])cube([3,l+2,3]);
            }
        }
        
        for(y=[0:6:l/2])
        {
            for (dir=[1,-1]) hull()
            {
                translate([-(spring_len/2-3),y*dir,-1]) cylinder(d=2,h=3);
                translate([ (spring_len/2-3),y*dir,-1]) cylinder(d=2,h=3);
            }
        }
    }
}

module 2d_rail_body()
{
    projection(true) translate([0,0,50])rail_centered();
}

module 2d_spring_cutout($fn=1000)
{
    intersection()
    {
        difference()
        {
            translate([0,-98]) circle(d=200+0.2);
            translate([0,-98]) circle(d=200-0.8*2-0.2);
        }
        translate([-24,-4])square([48,8]);
    }
    
    
    intersection()
    {
        difference()
        {
            translate([0,-98]) circle(d=200+2);
            translate([0,-98]) circle(d=200-0.8*2-0.2);
        }
        translate([-22,-4])square([44,8]);
    }

    intersection()
    {
        group()
        {
            translate([0,-98])rotate(-14)translate([0,100-0.8])circle(d=3.2);
            translate([0,-98])rotate( 14)translate([0,100-0.8])circle(d=3.2);
        }
        translate([0,-98]) circle(d=200+0.2); 
    }
  
  
    intersection()
    {
        translate([0,98]) circle(d=200);
        translate([-25,-4])square([50,8]);
    }
  
}

module 2d_rail_profile(hollow=false)
{
    difference()
    {
        2d_rail_body();
        translate([2,0])2d_spring_cutout();
        
        if (hollow) hull()
        {
            translate([13,-7]) circle(d=3);
            translate([-24.5,-7]) circle(d=3);
            translate([-21,-18]) circle(d=3);
        }
    }
}

module 2d_cutout_round_weight(d=8)
{
    
    difference()
    {
        circle(d=d+0.4);
        translate([(d+0.4)/2,0])circle(d=1.3);
    }
    difference()
    {
        translate([(d+0.4)/2,0])circle(d=3);
        translate([(d+0.4)/2,0])circle(d=1.3);
        translate([(d+0.4)/2-0.5,0])square([1,4]);
    }
}

module 2d_rail_profile_weights_round()
{
    difference()
    {
        2d_rail_profile(false);
        translate([-18,-11]) rotate(60)2d_cutout_round_weight(12.75);
        translate([-6,-10]) rotate(120)2d_cutout_round_weight(8);
        translate([ 4, -8]) 2d_cutout_round_weight(8);

        
    }    
}

module countersunk_m2_5(l1=10,l2=.1)
{
    translate([0,0,-l2+0.01])cylinder(h=l2+0.01,d=4.2);
    cylinder(h=1.2,d1=4.2,d2=2.6);
    cylinder(h=l1,d=2.6);
}

module rail_weighted_round(l=100)
{
    difference()
    {
        group()
        {
            linear_extrude(2) 2d_rail_body();
            linear_extrude(l+2) 2d_rail_profile_weights_round();
        }
        translate([0,0,l+1])linear_extrude(1.01) difference()
        {
            2d_rail_profile();
            offset(r=-.9)2d_rail_profile();
        }
        for (pos=[[-26.5,-11],[-26.5,4],[18,-11]])rotate([0,0,18])translate([pos.x,pos.y,l+2-12])cylinder(h=12.01,d=2);
    
        
        for (pos=[[-18,-21,10],[-18,-21,l-10],[32,-4.78,10],[32,-4.78,l-10]])
        {    
            translate(pos)rotate([-90,0,18])
            {
                translate([0,0,-0.01]) cylinder(d=9.2,h=1.01);
            }
        }
    }
}


module rail_weighted_round_cap()
{
    difference()
    {
        group()
        {
            translate([0,0,1])linear_extrude(2) 2d_rail_body();
            linear_extrude(3) difference()
            {
                2d_rail_profile();
                offset(r=-.8)2d_rail_profile();
            }
        }
        
        for (pos=[[-26.5,-11],[-26.5,4],[18,-11]])rotate([0,0,18])translate([pos.x,pos.y,3])rotate([180,0,0]) countersunk_m2_5();
    }
        
        
}

rail_weighted_round();
//rail_weighted_round_cap();
//spring(100);
    
    



