# Project instructions

All artifacts created or modified in this Git repository must be in English, including identifiers, comments, documentation, and commit messages. User-facing conversation may remain in the user's preferred language.

## Scan references and construction geometry

Always create a schematic 3D model from a scan before designing parts that fit or interact with the scanned object. In this project, `schematic_battery()` is the construction reference.

Scan meshes and `scan_reference()` are for visual comparison and alignment only. Never use them directly as construction geometry, including Boolean operations, projections, offsets, or mating surfaces. Derive all construction geometry, dimensions, and clearances from the schematic model and its parameters. Validate the schematic model against measurements and the scan before relying on its fit.

Apply this workflow to all future scan-based projects, and carry this rule into their project instructions.
