# Project instructions

All artifacts created or modified in this Git repository must be in English, including identifiers, comments, documentation, and commit messages. User-facing conversation may remain in the user's preferred language.

## Scan references and construction geometry

Always create a schematic 3D model from a scan before designing parts that fit or interact with the scanned object. In this project, `schematic_battery()` is the construction reference.

Scan meshes and `scan_reference()` are for visual comparison and alignment only. Never use them directly as construction geometry, including Boolean operations, projections, offsets, or mating surfaces. Derive all construction geometry, dimensions, and clearances from the schematic model and its parameters. Validate the schematic model against measurements and the scan before relying on its fit.

Apply this workflow to all future scan-based projects, and carry this rule into their project instructions.

## Commit keyword workflow

Apply this workflow to all future 3D construction projects and carry it into their project instructions.

When the user uses the keyword `commit` as an action request, case-insensitively, perform these steps:

1. Inspect the Git status and review all staged and unstaged changes. Check for whitespace errors and run the relevant available validation for the changes.
2. Summarize the intended commit scope and show the exact proposed English commit message, including its body when applicable. Ask the user to confirm it before creating the commit or pushing.
3. After confirmation, stage only the reviewed project files, create the commit with the approved message, and push the current branch to its configured upstream. If the destination is missing or ambiguous, ask the user to specify it. Never force-push without explicit authorization.
4. Verify that the push succeeded and report the commit identifier, message, destination, and remaining local changes, if any.

If the reviewed changes or proposed message change materially after confirmation, request confirmation again. Do not interpret a mention of `commit` in a question, quotation, or request to edit these instructions as authorization to commit or push. Do not automatically commit or push after ordinary modeling changes.
