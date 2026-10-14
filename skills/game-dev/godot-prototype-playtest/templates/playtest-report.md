# Prototype playtest report

## Scope and identity
- Player goal:
- Intentionally excluded:
- Exact source revision / artifact filename and SHA-256:
- Engine version:
- Host OS:
- Review save isolation:
- Modified files and reasons:

## Controls
- Move:
- Camera:
- Interact:
- Respawn:
- Full reset:
- Other:

## Evidence labels
Use PASS, FAIL, BLOCKED, UNTESTED, or N/A for each case. Name the method: direct state calls, engine-injected input, OS input, human playtest, rendered capture, or artifact inspection. Add actual observations, not expected behavior copied into the results column.

## Checks
- Import / bounded startup; exit code and log findings:
- Spawn framing, focus, and readable instructions:
- Ordinary movement from spawn to objective:
- Pickup once; repeated contact does not duplicate reward:
- Out-of-range interaction rejected; in-range accepted:
- Checkpoint activation and visible confirmation:
- Respawn position; progress preserved as designed:
- Full reset; initial state restored as designed:
- Character switching; intended progress retained (or N/A):
- Camera, collision, and objective reachability:
- Status feedback remains readable rather than immediately overwritten:
- Animation/audio checks (separate from state tests):
- Intentional failure proves automated harness fails correctly:
- Exact deliverable extracted to a path with spaces and launched:
- Required assets/import settings included:
- Public payload privacy and redistribution review:

## Handoff
- What is verified:
- What failed or remains untested:
- Untested platforms:
- Known prototype limitations:
- User approval received (specific scope, or not received):
- How to open/play:

Do not label the prototype fully playtested based only on a headless launch, generated state fixture, or screenshots.
