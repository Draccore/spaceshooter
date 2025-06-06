extends Node

# Base values for each stat
var base_stats := {
	"speed": 300,
	"accel": 5,
	"friction": 5,
	"max_hp": 100,
}

# Upgrade increments for each stat
var upgrade_increments := {
	"speed": 20,
	"accel": 0.5,
	"friction": 0.5,
	"max_hp": 10,
}

# Upgrade levels for each stat
var upgrades := {
	"speed": 0,
	"accel": 0,
	"friction": 0,
	"max_hp": 0,
}

var engines = {
	"default_engine": {
		"display_name": "Standard Engine",
		"sprite": preload("res://Sprites/Engines/Main Ship - Engines - Base Engine.png"),
		"base_stats": {
			"speed": 300,
			"accel": 5,
			"friction": 5,
		},
		"upgrade_increments": {
			"speed": 20,
			"accel": 0.5,
			"friction": 0.5,
			"max_hp": 10,
		}
	},
	"pulse_engine": {
		"display_name": "Big Pulse Engine",
		"sprite": preload("res://Sprites/Engines/Main Ship - Engines - Big Pulse Engine.png"),
		"base_stats": {
			"speed": 500,
			"accel": 2,
			"friction": 2,
		},
		"upgrade_increments": {
			"speed": 20,
			"accel": 0.5,
			"friction": 0.5,
			"max_hp": 10,
		}
	},
}
var selected_engine: String = "default"

# Current values for runtime-only stats
var HP : float = base_stats["max_hp"]

# Weapon stats (left as-is, but you can modularize similarly)
var WPN_SPEED = 300
var WPN_DAMAGE = 10
var WPN_ATTACK_SPEED = 1

# Get the current value (base + upgrade) of a stat
func get_stat(stat_name: String) -> float:
	if base_stats.has(stat_name) and upgrade_increments.has(stat_name) and upgrades.has(stat_name):
		return base_stats[stat_name] + upgrade_increments[stat_name] * upgrades[stat_name]
	return 0

# Upgrade a stat by one
func upgrade_stat(stat_name: String):
	if upgrades.has(stat_name):
		upgrades[stat_name] += 1

# Set HP to max (call on new game/respawn)
func reset_hp():
	HP = get_stat("max_hp")
