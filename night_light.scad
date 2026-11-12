use <lib/recessed_hinge.scad>

// Battery top: schematic reconstruction from a 3D scan
// Assumption: STL units are millimeters. Verify dimensions before designing mating parts!
// X = width, Y = length, Z = height above the idealized cut plane.
// The scan cut surface was NOT measured as a precise reference plane.
// Rounded corners, base, and top are deliberately simplified; not mating geometry.

$fn = $preview ? 16 : 64;
show_scan = false;       // Transparent reference in F5 preview only
show_model = true;

// The reference objects are preview-only so exports contain only the new part.
show_u_bracket = true;
show_lid = true;
show_hinge_pin = true;
// assembly, bracket, lid, pin, or print_layout. Angle 0 is closed.
export_part = "assembly";
lid_open_angle = 0;
lid_thickness = 7.5;
lid_gap = 0.3;
hinge_length = 60;
hinge_knuckle_count = 7;
hinge_barrel_diameter = 6;
hinge_pin_diameter = 3;
hinge_pin_radial_clearance = 0.2;
hinge_axial_gap = 0.3;

// U-bracket dimensions in millimeters. Clearance controls the bridge height.
bracket_clearance = 1;
// Bridge thickness matches the side walls and grows upward.
bracket_inner_width = 55;
bracket_outer_width = 70;
bracket_wall = (bracket_outer_width - bracket_inner_width) / 2;
// Bracket depth follows the full length of the schematic battery body.
bracket_extra_height = 8;
bracket_bottom_chamfer = 1; // 45-degree chamfers on both lower edges of each leg.

// Through-slot in the bridge, open at the positive Y end.
bracket_corner_radius = 2; // Four outer corners and both slot entrance corners.
bracket_top_radius = 5; // Inner and outer upper corners in the X/Z section.
bracket_inner_edge_radius = 1; // Full inner opening rim at both ends.
bridge_slot_width = 20;
bridge_slot_depth = 44; // Total depth from the edge, including the rounded end.

width = 60;
length = 90.5;
overall_height = 22.5;
corner_radius = 8;
base_height = 6;
body_width = 55.5;
body_length = 87;
bracket_depth = body_length;
shoulder_height = 14;
top_width = 43;
top_length = 80;

// Used only for visual alignment of the scan reference.
scan_tilt_x = 0;
scan_tilt_y = 0;
scan_rotation_z = 0;
scan_offset = [0, 0, 0];
scan_file = "accu_reference.stl";

module outline(w, l, r) {
    offset(r=r)
        square([w-2*r, l-2*r], center=true);
}

module slice(w, l, r, z) {
    translate([0,0,z])
        linear_extrude(height=0.02)
            outline(w,l,r);
}

// Reusable volume for subsequent adapter design.
module schematic_battery() {
    union() {
        linear_extrude(height=base_height)
            outline(width,length, corner_radius);
        hull() {
            slice(width,length,corner_radius,base_height-0.02);
            slice(body_width,body_length,7,base_height+1.5);
        }
        hull() {
            slice(body_width,body_length,7,base_height);
            slice(body_width,body_length,7,shoulder_height);
            slice(top_width,top_length,7,overall_height-0.02);
        }
    }
}

module scan_reference() {
    // Original bounds: X 40.901..101.115, Y 19.603..42.280,
    // Z -313.469..-222.750. Rotation places the large surface horizontally.
    translate(scan_offset)
        rotate([scan_tilt_x,scan_tilt_y,scan_rotation_z])
            translate([-71.00782585,-268.10929108,-19.6028614])
                rotate([90,0,0])
                    import(scan_file, convexity=10);
}

// Two convex components of the schematic X/Z opening profile.
module bracket_opening_profile(part, inner_width, bridge_bottom, leg_bottom) {
    if (part == 0)
        translate([-inner_width/2+bracket_top_radius, leg_bottom-bracket_top_radius])
            offset(r=bracket_top_radius)
                square([inner_width-2*bracket_top_radius, bridge_bottom-leg_bottom]);
    else
        polygon(points=[
            [-width/2, leg_bottom-0.01], [width/2, leg_bottom-0.01],
            [width/2, base_height], [body_width/2, base_height+1.5],
            [body_width/2, base_height+1.52], [-body_width/2, base_height+1.52],
            [-body_width/2, base_height+1.5], [-width/2, base_height]
        ]);
}
// Inverted U across X, centered along Y, with its opening facing down.
// Legs extend to the battery underside; the inner relief follows its base and shoulder.
// Fit uses the schematic battery dimensions, not a measured scan surface.
module u_bracket_body() {
    inner_width = bracket_inner_width;
    outer_width = bracket_outer_width;
    leg_bottom = 0;
    bridge_bottom = overall_height + bracket_clearance + bracket_extra_height;
    bracket_top = bridge_bottom + bracket_wall;
    epsilon = 0.01;

    assert(outer_width > inner_width && inner_width > 0,
           "Bracket widths must satisfy outer > inner > 0.");
    assert(bracket_clearance >= 0, "Bracket clearance must be nonnegative.");
    assert(bracket_wall > 0 && bracket_depth > 0,
           "Bracket wall thickness and depth must be positive.");
    assert(bridge_bottom > leg_bottom, "Bracket legs must have positive height.");

    difference() {
        translate([0,0,leg_bottom])
            linear_extrude(height=bracket_top-leg_bottom)
                outline(outer_width, bracket_depth, bracket_corner_radius);
        // Full internal opening, including the lower schematic base relief.
        for (part = [0,1])
            rotate([90,0,0])
                linear_extrude(height=bracket_depth+2*epsilon, center=true)
                    bracket_opening_profile(part,inner_width,bridge_bottom,leg_bottom);
        // Four 1 x 1 mm bottom chamfers in the X/Z section, full depth.
        for (side = [-1,1])
            scale([side,1,1])
                rotate([90,0,0])
                    linear_extrude(height=bracket_depth+2*epsilon, center=true) {
                        // Inner bottom edge follows the wider battery base relief.
                        polygon(points=[
                            [width/2-epsilon, leg_bottom-epsilon],
                            [width/2+bracket_bottom_chamfer+epsilon, leg_bottom-epsilon],
                            [width/2-epsilon, leg_bottom+bracket_bottom_chamfer+epsilon]
                        ]);
                        polygon(points=[
                            [outer_width/2-bracket_bottom_chamfer-epsilon, leg_bottom-epsilon],
                            [outer_width/2+epsilon, leg_bottom-epsilon],
                            [outer_width/2+epsilon, leg_bottom+bracket_bottom_chamfer+epsilon]
                        ]);
                    }
        // Round both external upper corners along the full bracket depth.
        for (side = [-1,1])
            scale([side,1,1])
                rotate([90,0,0])
                    linear_extrude(height=bracket_depth+2*epsilon, center=true)
                        translate([outer_width/2-bracket_top_radius,
                                   bracket_top-bracket_top_radius])
                            difference() {
                                square([bracket_top_radius+epsilon,
                                        bracket_top_radius+epsilon]);
                                circle(r=bracket_top_radius);
                            }
        // Rolling R1 edge relief around the complete front and rear opening.
        // Angular segments approximate the quarter-circle cross-section.
        edge_steps = $preview ? 6 : 24;
        for (end = [-1,1], part = [0,1], step = [0:edge_steps-1])
            hull()
                for (sample = [step,step+1]) {
                    angle = 90 * sample / edge_steps;
                    rim_y = end * (bracket_depth/2-bracket_inner_edge_radius
                                   + bracket_inner_edge_radius*sin(angle));
                    relief = bracket_inner_edge_radius*(1-cos(angle));
                    translate([0,rim_y,0])
                        rotate([90,0,0])
                            linear_extrude(height=0.002, center=true)
                                offset(delta=relief)
                                    bracket_opening_profile(part,inner_width,
                                                            bridge_bottom,leg_bottom);
                }
        // Open-ended slot: straight sides and a semicircular R10 end.
        slot_radius = bridge_slot_width / 2;
        slot_center_y = bracket_depth/2 - bridge_slot_depth + slot_radius;
        assert(bridge_slot_width > 0 && bridge_slot_width < inner_width,
               "Bridge slot must fit between the side walls.");
        assert(bridge_slot_depth >= slot_radius && bridge_slot_depth < bracket_depth,
               "Bridge slot depth must include its radius and leave a rear bridge.");
        translate([0,0,bridge_bottom-epsilon])
            linear_extrude(height=bracket_wall+2*epsilon)
                union() {
                    translate([-slot_radius,slot_center_y])
                        square([bridge_slot_width,bridge_slot_depth-slot_radius+epsilon]);
                    translate([0,slot_center_y])
                        circle(r=slot_radius);
                    // Remove the two convex entrance corners with R2 arcs.
                    for (side = [-1,1])
                        scale([side,1])
                            translate([slot_radius,bracket_depth/2-bracket_corner_radius])
                                difference() {
                                    square([bracket_corner_radius,
                                            bracket_corner_radius+epsilon]);
                                    translate([bracket_corner_radius,0])
                                        circle(r=bracket_corner_radius);
                                }
                }
    }
}

// Closed hinge envelope: inside X +/-35, Y +/-43.5, top flush with lid.
// The hinge is centered on the long negative-X edge, with its axis along Y.
assembly_roof_z = overall_height + bracket_clearance + bracket_extra_height + bracket_wall;
lid_bottom_z = assembly_roof_z + lid_gap;
lid_top_z = lid_bottom_z + lid_thickness;
hinge_radius = hinge_barrel_diameter/2;
hinge_axis_x = -bracket_outer_width/2 + hinge_radius;
hinge_axis_y = 0;
hinge_axis_z = lid_top_z - hinge_radius;
lid_side_cut_x = hinge_axis_x + hinge_radius + hinge_axial_gap;
hinge_bore_diameter = hinge_pin_diameter + 2*hinge_pin_radial_clearance;

assert(hinge_length < bracket_depth-2*bracket_corner_radius,
       "Hinge must remain centered inside the long bracket edge.");
assert(lid_thickness >= hinge_barrel_diameter,
       "The barrel must fit within the lid height.");
assert(lid_open_angle >= 0 && lid_open_angle <= 110,
       "Supported lid opening range is 0 to 110 degrees.");

module hinge_pose() {
    translate([hinge_axis_x,hinge_axis_y,hinge_axis_z])
        rotate([0,0,-90]) children();
}

module fixed_hinge_half() {
    hinge_pose()
        recessed_hinge_leaf(length=hinge_length,segs=hinge_knuckle_count,
            inner=false,knuckle_diam=hinge_barrel_diameter,
            pin_diam=hinge_bore_diameter,gap=hinge_axial_gap,
            web=[-1,1,assembly_roof_z-hinge_axis_z-3,0]);
}

module u_bracket() {
    union() {
        u_bracket_body();
        fixed_hinge_half();
    }
}

module upper_lid() {
    union() {
        difference() {
            translate([0,0,lid_bottom_z])
                linear_extrude(height=lid_thickness)
                    outline(bracket_outer_width,bracket_depth,bracket_corner_radius);
            // Leave a free band along the long hinge edge for lid rotation.
            translate([-bracket_outer_width/2-1,-bracket_depth/2-1,lid_bottom_z-1])
                cube([lid_side_cut_x+bracket_outer_width/2+1,bracket_depth+2,
                      lid_thickness+2]);
        }
        hinge_pose()
            recessed_hinge_leaf(length=hinge_length,segs=hinge_knuckle_count,
                inner=true,knuckle_diam=hinge_barrel_diameter,
                pin_diam=hinge_bore_diameter,gap=hinge_axial_gap,
                web=[0,hinge_radius+4,0,hinge_radius]);
    }
}

module posed_lid(angle=lid_open_angle) {
    hinge_pose()
        rotate([angle,0,0])
            rotate([0,0,90])
                translate([-hinge_axis_x,-hinge_axis_y,-hinge_axis_z]) upper_lid();
}

// A headed pin is provided as an optional printed part. A 3 mm metal rod
// may be substituted; mechanically retain its ends after assembly.
module loose_hinge_pin() {
    pin_length = hinge_length + 0.8;
    union() {
        cylinder(h=pin_length,d=hinge_pin_diameter);
        translate([0,0,-1.5]) cylinder(h=1.5,d=hinge_pin_diameter+2);
    }
}

module assembled_hinge_pin() {
    hinge_pose()
        translate([-hinge_length/2-0.4,0,0])
            rotate([0,90,0]) loose_hinge_pin();
}

if (export_part == "assembly") {
    if (show_u_bracket) color([0.9,0.15,0.1]) u_bracket();
    if (show_lid) color([0.2,0.45,0.85]) posed_lid();
    if (show_hinge_pin) color([0.7,0.7,0.72]) assembled_hinge_pin();
    if (show_model) %color([0.2,0.55,0.75]) schematic_battery();
    if (show_scan) %scan_reference();
} else if (export_part == "bracket") {
    u_bracket();
} else if (export_part == "lid") {
    // Top face on the build plate, hinge barrels facing upward.
    translate([0,0,lid_top_z]) rotate([180,0,0]) upper_lid();
} else if (export_part == "pin") {
    translate([0,0,1.5]) loose_hinge_pin();
} else if (export_part == "print_layout") {
    u_bracket();
    translate([bracket_outer_width+15,0,lid_top_z]) rotate([180,0,0]) upper_lid();
    translate([-bracket_outer_width/2-10,0,1.5]) loose_hinge_pin();
} else {
    assert(false,"Unknown export_part selector.");
}
