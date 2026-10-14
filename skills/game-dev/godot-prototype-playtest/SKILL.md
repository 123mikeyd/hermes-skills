---
name: godot-prototype-playtest
description: Build small Godot prototypes with honest playtest evidence.
version: 0.1.0
author: Mike (123mikeyd), Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [godot, game-dev, prototype, playtesting]
    related_skills: []
---

# Godot Prototype Playtest Skill

Take a small Godot 4 prototype from an agreed gameplay loop to a reviewable handoff. This is a workflow for choosing scope and collecting evidence, not a general GDScript reference or a promise that headless tests prove a game feels good.

## When to Use

- Build a small editable Godot prototype for someone to try.
- Prepare an existing prototype for a friend or community demo.
- Check pickups, checkpoints, interaction, respawn, reset, or character switching.
- Don't use for a full engine migration, art generation, or broad unrelated test-suite repair.

## Prerequisites

- A user-authorized project directory and a compatible Godot 4 executable.
- Hermes file and `terminal` tools. Visual review also requires a way to capture and inspect the running game, or a human playtester.
- No account, paid asset service, MCP server, or testing addon is required.
- Treat project scripts and editor plugins as executable code. Inspect unfamiliar projects before opening/importing them; use a disposable copy or sandbox for untrusted downloads.

## How to Run

Use `terminal` to run the actual executable with a bounded timeout. Replace placeholders with discovered native paths and quote them for the host shell:

```text
terminal(command='"<godot-executable>" --version', timeout=30)
terminal(command='"<godot-executable>" --headless --path "<review-project>" --import', timeout=120)
terminal(command='"<godot-executable>" --headless --path "<review-project>" --quit-after 120', timeout=60)
```

Check `--help` on that binary before relying on flags. `--quit-after` bounds iterations, not elapsed seconds; the outer timeout is still required. These commands establish version, import, and bounded startup only. Capture output and inspect it for script/import/runtime errors even if the process exits zero.

For AI-generated assets or research tools, consult `references/ai-3d-options.md`: it separates Tripo/Hunyuan3D asset intake from untested research leads and defines asset-to-engine checks. These are optional references, not required services or a tested combined pipeline.

For the included original state-model example, see `templates/state-example/README.md`. It is a separate headless teaching fixture, not a playable game or a substitute for tests against the target game's real code.

## Procedure

1. **Identify the actual target.** Use `search_files` and `read_file` to locate `project.godot`, the main scene, input actions, relevant scripts, and existing tests. Record the exact project root and engine version. Do not infer installed behavior from an old report or another copy of the project.
2. **Set one playable goal.** For a new prototype, choose one movement loop, one interaction, one success condition, and a way to restart. Use original primitives or already-cleared assets. For an existing demo, preserve its design and fix only the agreed blockers. Completion: a short acceptance list that says what the player can do and what is deliberately out of scope.
3. **Protect work and saves.** Inspect Git status through `terminal`; preserve dirty/untracked files and live editor changes. Use a separate review copy or agreed branch. Read application name, custom user-directory settings, and save paths: different folders can still share `user://` data. Give the disposable review project a unique data directory before execution; never erase the user's saves to create a clean test.
4. **Build the smallest loop.** Use `write_file` and `patch` for targeted edits. Keep scenes/scripts editable. Do not replace approved art or add gameplay systems to hide a test failure. Completion: each changed file has a reason tied to an acceptance item.
5. **Check actual state transitions.** Adapt `templates/playtest-report.md` to the real mechanics. Test repeated pickup, an interaction just outside range, checkpoint activation, respawn versus full reset, and switching characters if supported. Mark absent mechanics N/A. Use explicit pass/fail accounting and a nonzero failure exit in automated runners. Completion: each applicable case has an observed result; at least one deliberately wrong expectation proves the harness detects failure.
6. **Exercise the normal player route.** Walk from spawn to the objective through ordinary controls, rather than teleporting into test positions. Verify input focus, camera, reachability, collisions, and readable feedback. Separate direct state calls, engine-injected input, OS keyboard/gamepad input, and human playtesting in the report. A counter changing in memory does not prove the player sees it.
7. **Review presentation separately.** Capture and inspect the actual running viewport if available. Check spawn framing, instructions, objective visibility, status messages, and reset feedback. Headless startup is not graphics/audio verification; a still image is not animation-timing verification. If visual or input access is unavailable, mark those checks untested instead of inventing observations.
8. **Package only the approved scope.** When sharing is requested, allowlist the editable source and required assets. Exclude credentials, local paths, logs, caches, personal saves, and private provenance. Check redistribution permission for each retained asset/animation separately; a code license does not grant rights to unrelated artwork. Reuse prior valid evidence after demo approval rather than reopening an endless polish cycle.
9. **Test the delivered copy.** If producing a ZIP/export, freshly extract that exact artifact to a path with spaces and invoke its documented launcher. Verify included dependencies and required import settings. A source project requires Godot; an export is a different deliverable. Report tested OS/engine and explicitly name untested platforms.
10. **Hand off without inflating the claim.** Fill `templates/playtest-report.md` with controls, artifact identity, passed/failed/untested cases, and remaining limitations. Distinguish engine execution, rendered observation, real input, and user approval. Stop when the accepted scope is satisfied; do not demand another art review for unrelated packaging changes.

## Pitfalls

- A working sibling project or generated example does not prove the requested project works.
- Directly calling a pickup function bypasses collision/input delivery. Test both layers when claiming end-to-end behavior.
- Respawn usually preserves progress while full reset restores initial state, but establish the project's intended contract rather than silently imposing one.
- A zero exit code can accompany script errors. Require clean logs and expected completion markers for automated evidence.
- Assertion-only runners can stop before cleanup/exit. Use failure counters, explicit exit codes, and an external timeout.
- Import settings may be intentionally tracked even when cache files are ignored. Inspect the exact packaged tree instead of blindly removing all `.import` files.
- Unrelated baseline test failures are not permission to redesign gameplay. Report them separately from regressions and harness mistakes.
- Supported workflow platforms are not claims of completed cross-platform testing. Report only hosts actually exercised.

## Verification

The skill has done its job when every acceptance item is mapped to real evidence or explicitly marked failed, blocked, or untested; edited source is preserved; and the handoff names the exact tested artifact. A launch-only or state-model-only result must not be labeled fully playtested.

For the bundled example's pass and intentional-failure commands, use `templates/state-example/README.md`. Run those checks before modifying the example, then rerun them afterward. Keep the example's evidence separate from the target game's results.
