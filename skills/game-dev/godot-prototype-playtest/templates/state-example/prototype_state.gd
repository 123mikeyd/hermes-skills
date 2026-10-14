# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Mike (123mikeyd) and Hermes Agent
# Illustrative headless state model; not a game controller.
extends RefCounted

const START := Vector2.ZERO
const INTERACTION_RANGE := 2.0
var position := START
var checkpoint := START
var pickups: Dictionary = {}
var character := "scout"
var interaction_count := 0

func pickup(id: String) -> bool:
	if id.is_empty() or pickups.has(id):
		return false
	pickups[id] = true
	return true

func interact(target: Vector2) -> bool:
	if position.distance_to(target) > INTERACTION_RANGE:
		return false
	interaction_count += 1
	return true

func activate_checkpoint() -> void:
	checkpoint = position

func respawn() -> void:
	position = checkpoint

func switch_character(id: String) -> bool:
	if id not in ["scout", "builder"]:
		return false
	character = id
	return true

func full_reset() -> void:
	position = START
	checkpoint = START
	pickups.clear()
	character = "scout"
	interaction_count = 0
