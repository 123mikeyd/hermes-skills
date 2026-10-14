# Headless state-transition example

Original teaching fixture by Mike (123mikeyd) and Hermes Agent, under the MIT license in this skill's root. No art, external dependencies, UI, physics, or gameplay controller.

Use Hermes `terminal` with a 30-second timeout for each invocation. Substitute your Godot executable and this example's directory, quoting paths for your shell:

```text
terminal(command='"<godot>" --headless --path "<example-directory>" --import', timeout=30)
terminal(command='"<godot>" --headless --path "<example-directory>" --script res://run_tests.gd', timeout=30)
terminal(command='"<godot>" --headless --path "<example-directory>" --script res://run_tests.gd -- --force-failure', timeout=30)
```

Expected results:
- Import: exit 0 and no script/import errors.
- Normal runner: exit 0 and `PASS: state transitions (30 checks)`.
- Deliberate failure: exit 1 and `FAIL: state transitions (1/31 checks failed)`.
- A timeout, engine error, or missing completion marker is not a passing test.

The tests exercise pickup-once, interaction range, checkpoint activation, respawn preserving progress, character-switch persistence, invalid character rejection, and full reset. They call the state model directly; they do not exercise input delivery, collisions, rendering, audio, or an actual player route.

Verified locally using Godot `4.7.2.stable.official.ed1daf0bf` on Windows 11. The runner also passed without an import cache. Other versions/platforms are untested. These results prove only this example's state transitions, not that another game is playtested.

Adapt the checks to the real game's code instead of copying a separate model and claiming it validates production behavior. Keep failure exit codes and outer timeouts when integrating with CI.
