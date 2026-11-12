# Night light holder

Parametric OpenSCAD battery holder with an upper lid and an interleaved barrel hinge.
All dimensions are in millimeters. The scan is visual reference only.

## Lid and hinge

The long-edge hinge uses seven alternating knuckles, a 6 mm barrel and a separate 3 mm
pin. Its axis runs along Y at the long negative-X side. It is centered at Y0, with four fixed red knuckles and three moving blue knuckles.
The fixed half is fused to the bracket; the other half is fused to the lid.
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

## Upstream hinge model

The alternating knuckle layout in `lib/recessed_hinge.scad` is adapted from
[BOSL2 knuckle_hinge](https://github.com/BelfrySCAD/BOSL2/blob/450f7fa5fc5222279ca4c4e564e1a6c01ccdd57c/hinges.scad),
under the BSD 2-Clause License. The adapter removes the BOSL2 attachment and screw
systems and supplies new recessed mounting webs for this assembly. No external
OpenSCAD libraries are required. The upstream license is retained in
`third_party/BOSL2-LICENSE.txt`. The source revision is recorded in the adapter.

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
