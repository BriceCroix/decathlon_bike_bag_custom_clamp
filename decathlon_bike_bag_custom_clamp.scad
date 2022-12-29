// All measurements are in millimeters

// Special variables
$fn = 100;

// Parameters
clamp_gap = 12;
clamp_bloc = 10;
clamp_arm_thickness = 5;
clamp_length = 50;

base_plate_thickness = 3;

jaw_arm_length = 3;
jaw_arm_thickness = 3;
jaw_tooth_length = 2.5;
jaw_between_arms = 22;

bump_length = 25;
bump_height = 8;
space_between_clamp_and_bump = 15;

hole_radius = 2;

canyon_gap = 17;

bolt_radius = 4.5;
bolt_thickness = 2.5;

// Values depending on parameters
total_width = jaw_arm_thickness + jaw_between_arms + jaw_arm_thickness;
total_length = clamp_bloc + clamp_length + space_between_clamp_and_bump + bump_length;
total_base_thickness = jaw_arm_thickness+jaw_arm_length+base_plate_thickness;
total_bump_height = total_base_thickness+bump_height;
total_height = total_base_thickness + clamp_gap + clamp_arm_thickness;
hole_distance = (base_plate_thickness+bump_height) / 2;

// Constraints
if(hole_radius > base_plate_thickness+bump_height)
{
    hole_radius = base_plate_thickness+bump_height;
}

// Actual model

//rotate([0,-90,-90]) // Rotation for vertical model
difference(){
    linear_extrude(height=total_width)
        difference(){
            // Main shape
            polygon([
                [0, 0],
                [total_length, 0],
                [total_length, total_bump_height],
                [total_length-bump_length, total_bump_height],
                [total_length-bump_length-bump_height, total_base_thickness],
                [clamp_bloc, total_base_thickness],
                [clamp_bloc, total_base_thickness+clamp_gap],
                [clamp_bloc+clamp_length, total_base_thickness+clamp_gap],
                [clamp_bloc+clamp_length, total_base_thickness+clamp_gap+clamp_arm_thickness],
                [0, total_base_thickness+clamp_gap+clamp_arm_thickness],
            ]);
            // Screw hole
            translate([total_length-hole_distance,total_bump_height-hole_distance,0])
                circle(hole_radius);
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
                        square([0.1+space_between_clamp_and_bump+bump_length-canyon_gap/2, canyon_gap]);
                        translate([0, canyon_gap/2,0])
                            circle(canyon_gap/2);
                    }
    // Bolt space
    translate([0,0,total_width])
        mirror([0,0,1])
            linear_extrude(height=bolt_thickness)
                translate([total_length-hole_distance,total_bump_height-hole_distance,0])
                    circle(r=bolt_radius, $fn=6);
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