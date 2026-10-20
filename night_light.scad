// Battery top: schematic reconstruction from a 3D scan
// Assumption: STL units are millimeters. Verify dimensions before designing mating parts!
// X = width, Y = length, Z = height above the idealized cut plane.
// The scan cut surface was NOT measured as a precise reference plane.
// Rounded corners, base, and top are deliberately simplified; not mating geometry.

$fn = 64;
show_scan = false;       // Transparent reference in F5 preview only
show_model = true;

width = 60;
length = 90.5;
overall_height = 22.5;
corner_radius = 8;
base_height = 6;
body_width = 55.5;
body_length = 87;
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

if (show_model)
    color([0.2,0.55,0.75]) schematic_battery();

if (show_scan)
    %scan_reference();
