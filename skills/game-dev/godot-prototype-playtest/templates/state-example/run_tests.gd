# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Mike (123mikeyd) and Hermes Agent
# Run with --headless --path . --script res://run_tests.gd
# Append -- --force-failure to verify nonzero failure detection.
# Bound each engine invocation externally; reject timeout or engine errors.
# No scenes, rendering, physics, input, or real gameplay are tested here.
extends SceneTree

var failures := 0
var checks := 0

func check(condition: bool, label: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		print("FAIL: " + label)

func _init() -> void:
	var source: Script = load("res://prototype_state.gd")
	if source == null or not source.can_instantiate():
		print("FAIL: state model unavailable")
		quit(1)
		return
	var state = source.new()
	for method in ["pickup", "interact", "activate_checkpoint", "respawn", "switch_character", "full_reset"]:
		if not state.has_method(method):
			print("FAIL: missing API " + method)
			quit(1)
			return
	check(state.pickup("token"), "first pickup succeeds")
	check(not state.pickup("token"), "duplicate pickup rejected")
	check(state.pickups.size() == 1, "pickup counted once")
	check(not state.interact(Vector2(2.01, 0)), "out of range rejected")
	check(state.interaction_count == 0, "rejection preserves interaction count")
	check(state.interact(Vector2(2, 0)), "range boundary included")
	check(state.interact(Vector2(1, 0)), "inside range accepted")
	check(state.interaction_count == 2, "only accepted interactions counted")
	state.position = Vector2(8, 3)
	state.activate_checkpoint()
	check(state.checkpoint == Vector2(8, 3), "checkpoint uses current position")
	state.position = Vector2(-10, -10)
	state.respawn()
	check(state.position == Vector2(8, 3), "respawn returns to checkpoint")
	check(state.pickups.has("token"), "respawn preserves pickup")
	check(not state.pickup("token"), "respawn cannot duplicate pickup")
	check(state.interaction_count == 2, "respawn preserves interactions")
	check(state.switch_character("builder"), "known character accepted")
	check(state.character == "builder", "character changed")
	check(state.position == Vector2(8, 3), "switch preserves position")
	check(state.checkpoint == Vector2(8, 3), "switch preserves checkpoint")
	check(state.pickups.has("token"), "switch preserves pickup")
	check(state.interaction_count == 2, "switch preserves interactions")
	check(not state.switch_character("unknown"), "unknown character rejected")
	check(state.character == "builder", "invalid switch preserves character")
	state.respawn()
	check(state.character == "builder", "respawn preserves character")
	state.full_reset()
	check(state.position == Vector2.ZERO, "reset restores start position")
	check(state.checkpoint == Vector2.ZERO, "reset clears checkpoint")
	check(state.character == "scout", "reset restores initial character")
	check(state.pickups.is_empty(), "reset clears pickups")
	check(state.interaction_count == 0, "reset clears interactions")
	check(state.pickup("token"), "pickup collectible again after reset")
	check(not state.pickup(""), "empty pickup ID rejected")
	state.full_reset()
	state.position = Vector2(1, 1)
	state.respawn()
	check(state.position == Vector2.ZERO, "reset respawn uses initial checkpoint")
	if "--force-failure" in OS.get_cmdline_user_args():
		check(false, "deliberately forced failure")
	if failures > 0:
		print("FAIL: state transitions (%d/%d checks failed)" % [failures, checks])
		quit(1)
	else:
		print("PASS: state transitions (%d checks)" % checks)
		quit(0)
