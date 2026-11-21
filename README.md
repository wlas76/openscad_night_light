# Night light holder

Parametric OpenSCAD battery holder with an upper lid and an interleaved barrel hinge.
All dimensions are in millimeters. The scan is visual reference only.

## Lid and hinge

The long-edge hinge uses seven alternating knuckles, a 7.5 mm barrel and a separate 3 mm
pin. Its axis runs along Y at the long negative-X side. It is centered at Y0, with four fixed red knuckles and three moving blue knuckles.
The fixed half is fused to the bracket; the other half is fused to the lid. The barrel diameter follows the lid thickness. Its centered bore is 3.75 mm from each lid face, and the full-depth lid webs remove the underside step.
The upper hinge half sits inside the closed assembly envelope: no barrel projects
above the lid top or beyond the bracket's side edge or length. The lid is a new
7.5 mm top cover above the existing bracket, with a 0.3 mm closure gap. It does not
replace the bracket roof or its existing slot. The hinge-side strip is relieved for
rotation; this is a cover, not a sealed enclosure.

- `lid_open_angle = 0`: closed; adjustable from 0 to 110 degrees.
- `show_lid`, `show_u_bracket`, `show_hinge_pin`: assembly visibility.
- `export_part`: `assembly`, `bracket`, `lid`, `pin`, or `print_layout`.
- `lid_thickness`, `lid_gap`: cover thickness and vertical clearance.
- `hinge_length`, `hinge_knuckle_count`, `hinge_barrel_diameter`: hinge size.
- `hinge_pin_diameter`, `hinge_pin_radial_clearance`, `hinge_axial_gap`: fits.

Use F6 before exporting. Select individual parts for STL export. The lid export
places its top face on the build plate; the pin export places its head on the bed.
The bracket still has a large roof overhang and may need supports or a different
print orientation. A metal rod is an alternative to the printed headed pin.
Retain the pin mechanically after assembly; an end retainer is not yet modeled.
Printed fit depends on the printer: test the hinge before producing the full part.
The earlier 55 mm opening versus 55.5 mm schematic battery interference remains.
PDF drawings predate the lid and hinge and must be regenerated before manufacturing.

## Self-contained hinge construction

All hinge geometry is constructed directly in night_light.scad with cylinders,
attachment webs and coaxial bores. The bracket owns four even-numbered knuckles;
the lid owns three odd-numbered knuckles. No external SCAD files or libraries
are needed. The knuckles retain their existing dimensions and centered layout.

## Geometry validation

OpenSCAD 2021.01 compiled the full assembly without warnings. The lid and headed
pin were rendered independently as simple closed solids. The lid STL passed an
edge-manifold check. Direct intersections between the fixed hinge half and lid
were empty at 0, 90 and 110 degrees in the long-edge configuration using preview tessellation. Throughout
that angle range, the moving parts remain above the original bracket body top:
the minimum height is the closed lid underside at Z39.3 versus the body top Z39.
These are CAD checks, not a physical print or load test. The axial and pin fits
still require calibration on the target printer. No latch or pin-end retainer
is included in this first lid design.

## Lamp retaining profile

The lid carries a curved rear retaining wall without lateral returns. Its central
X/Z housing section is extruded uniformly along the complete 87 mm lid edge.
The measured schematic section parameters, not the STL mesh, define the curve.
`schematic_led_housing()` provides the corresponding prismatic construction model.
`led_light.stl` remains preview-only.

- `lamp_pocket_wall = led_light_edge_offset - lamp_pocket_clearance`: wall thickness, currently 4.7 mm; the outer base is flush with the hinge-side lid edge.
- `lamp_pocket_clearance = 0.3`: horizontal clearance to the central profile.
- `lamp_pocket_height = 22`: wall height above the lid.
- `show_lamp_pocket`: include or hide the retaining wall.

The wall follows the lamp placement and lid motion. Its contour is constant over
its full width, so it does not follow the lamp's rounded side ends. Verify the
physical fit before printing. Existing lid drawings predate this retaining wall.
