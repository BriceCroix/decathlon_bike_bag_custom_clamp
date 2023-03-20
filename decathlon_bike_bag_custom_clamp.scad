// All measurements are in millimeters

/**** Special variables ****/
$fn = 100;

/**** Parameters ****/
// Space between the base plate and the clamp arm
clamp_gap = 16;
// Thickness of clamp base bloc
clamp_bloc = 8;
// Thickness of arm of clamp
clamp_arm_thickness = 5;
// Length of clamp arm
clamp_length = 46;

// Thickness of main base plate
base_plate_thickness = 3;

// Decathlon bag rail specific value
jaw_arm_length = 3;
// Decathlon bag rail specific value
jaw_arm_thickness = 3;
// Decathlon bag rail specific value
jaw_tooth_length = 2.5;
// Decathlon bag rail specific value
jaw_between_arms = 22;

// Space between end of clamp arm and beginning of protrusion
space_between_clamp_and_bump = 30;

// Radius of screw hole
hole_radius = 2.25;

// Space between the two screw arms
canyon_gap = 17;

// Open-end wrench size for the bolt
bolt_wrench = 7.5;
// Depth of hole for the bolt
bolt_thickness = 2.5;
// Margin around bolt hole
bolt_margin = 1;
// External radius of bolt
//bolt_radius = 4.5;

/**** Values depending on parameters ****/
// External radius of bolt
bolt_radius = bolt_wrench / (2 * cos(30));
// Height of bolt protrusion
bump_height = bolt_wrench + 2*bolt_margin - base_plate_thickness;
// Length of bolt protrusion
bump_length = 2*bolt_margin + bolt_radius;
total_width = jaw_arm_thickness + jaw_between_arms + jaw_arm_thickness;
total_length = clamp_bloc + clamp_length + space_between_clamp_and_bump + bump_length + bump_height + base_plate_thickness;
total_base_thickness = jaw_arm_thickness+jaw_arm_length+base_plate_thickness;
total_bump_height = total_base_thickness+bump_height;
total_height = total_base_thickness + clamp_gap + clamp_arm_thickness;
hole_distance = (base_plate_thickness+bump_height) / 2;

/**** Constraints ****/
if(hole_radius > base_plate_thickness+bump_height)
{
    hole_radius = base_plate_thickness+bump_height;
}

/**** Actual model ****/

rotate([0,-90,-90]) // Rotation for vertical model
difference(){
    linear_extrude(height=total_width)
        difference(){
            // Main shape
            polygon([
                [0, 0],
                [total_length, 0],
                [total_length, jaw_arm_thickness + jaw_arm_length],
                [total_length-base_plate_thickness-bump_height, total_bump_height],
                [total_length-base_plate_thickness-bump_height-bump_length, total_bump_height],
                [clamp_bloc+clamp_length+space_between_clamp_and_bump-bump_height, total_base_thickness],
                [clamp_bloc+clamp_gap/2, total_base_thickness],
                [clamp_bloc+clamp_gap/2, total_base_thickness+clamp_gap],
                [clamp_bloc+clamp_length, total_base_thickness+clamp_gap],
                [clamp_bloc+clamp_length, total_base_thickness+clamp_gap+clamp_arm_thickness],
                [0, total_base_thickness+clamp_gap+clamp_arm_thickness],
            ]);
            // Circle at bottom of clamp
            translate([clamp_bloc + clamp_gap/2, jaw_arm_thickness + jaw_arm_length + base_plate_thickness + clamp_gap/2, 0])
                circle(clamp_gap/2);
        }
    // Jaw
    rotate([0,90,0])
        linear_extrude(height=total_length+0.1)
            mirror([1,0,0])
                polygon([
                    [jaw_arm_thickness+jaw_tooth_length, -0.1],
                    [jaw_arm_thickness+jaw_tooth_length, jaw_arm_thickness],
                    [jaw_arm_thickness, jaw_arm_thickness],
                    [jaw_arm_thickness, jaw_arm_thickness+jaw_arm_length],
                    [jaw_arm_thickness+jaw_between_arms, jaw_arm_thickness+jaw_arm_length],
                    [jaw_arm_thickness+jaw_between_arms, jaw_arm_thickness],
                    [jaw_arm_thickness+jaw_between_arms-jaw_tooth_length, jaw_arm_thickness],
                    [jaw_arm_thickness+jaw_between_arms-jaw_tooth_length,-0.1],
                ]);
    // Canyon
    mirror([0,1,0])
        translate([clamp_bloc+clamp_length+canyon_gap/2, 0, (total_width-canyon_gap)/2])
            rotate([90,0,0])
                linear_extrude(height=total_bump_height+0.1)
                    union()
                    {
                        square([0.1+space_between_clamp_and_bump+bump_length+bump_height+base_plate_thickness-canyon_gap/2, canyon_gap]);
                        translate([0, canyon_gap/2,0])
                            circle(canyon_gap/2);
                    }
    // Screw space
    translate([0,0,total_width])
        mirror([0,0,1])
            translate([clamp_bloc+clamp_length+space_between_clamp_and_bump+bump_length/2,total_bump_height-hole_distance,0])
                union(){
                    // Bolt space
                    linear_extrude(height=bolt_thickness)
                        circle(r=bolt_radius, $fn=6);
                    // Screw hole
                    cylinder(total_width, hole_radius, hole_radius);
            }
    // Rounded clamp
    translate([clamp_length+clamp_bloc-total_width/2, total_height,0])
    rotate([90,0,0])
    linear_extrude(height=clamp_arm_thickness)
    difference()
    {
        square([0.1+total_width/2, total_width]);
        translate([0,total_width/2,0]) circle(total_width/2);
    }
}