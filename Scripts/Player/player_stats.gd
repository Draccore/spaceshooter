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
		"sprite": preload("res://Sprites/Player/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Base Engine.png"),
		"effect_animation_power": "base_engine_power",
		"effect_animation_idle": "base_engine_idle",
		"base_stats": {
			"speed": 200,
			"accel": 2,
			"friction": 2,
		},
		"upgrade_increments": {
			"speed": 10,
			"accel": 0.5,
			"friction": 0.5,
		}
	},
	"pulse_engine": {
		"display_name": "Big Pulse Engine",
		"sprite": preload("res://Sprites/Player/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Big Pulse Engine.png"),
		"effect_animation_power": "big_pulse_engine_power",
		"effect_animation_idle": "big_pulse_engine_idle",
		"base_stats": {
			"speed": 600,
			"accel": 0.5,
			"friction": 0.5,
		},
		"upgrade_increments": {
			"speed": 15,
			"accel": 0.1,
			"friction": 0.1,
		}
	},
	"burst_engine": {
		"display_name": "Burst Engine",
		"sprite": preload("res://Sprites/Player/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Burst Engine.png"),
		"effect_animation_power": "base_engine_power",
		"effect_animation_idle": "base_engine_idle",
		"base_stats": {
			"speed": 250,
			"accel": 10,
			"friction": 10,
		},
		"upgrade_increments": {
			"speed": 5,
			"accel": 1,
			"friction": 1,
		}
	},
	"supercharged_engine": {
		"display_name": "Supercharged Engine",
		"sprite": preload("res://Sprites/Player/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Supercharged Engine.png"),
		"effect_animation_power": "base_engine_power",
		"effect_animation_idle": "base_engine_idle",
		"base_stats": {
			"speed": 700,
			"accel": 8,
			"friction": 8,
		},
		"upgrade_increments": {
			"speed": 10,
			"accel": 1,
			"friction": 1,
		}
	},
}

var selected_engine: String = "default_engine"
var selected_ship: String = "default_ship"

# Current values for runtime-only stats
var HP : float = base_stats["max_hp"]

# Weapon stats
var WPN_SPEED = 300
var WPN_DAMAGE = 10
var WPN_ATTACK_SPEED = 1

# Get the current value (base + upgrade) of a stat
func get_stat(stat_name: String) -> float:
	# max_hp is global, not engine-specific
	if stat_name == "max_hp":
		if base_stats.has("max_hp") and upgrade_increments.has("max_hp") and upgrades.has("max_hp"):
			return base_stats["max_hp"] + upgrade_increments["max_hp"] * upgrades["max_hp"]
		return 0

	# Other stats are engine-specific
	var engine_name = selected_engine
	if not engine_name or not engines.has(engine_name):
		engine_name = "default_engine"
	var engine = engines[engine_name]
	if engine.base_stats.has(stat_name) and engine.upgrade_increments.has(stat_name) and upgrades.has(stat_name):
		return engine.base_stats[stat_name] + engine.upgrade_increments[stat_name] * upgrades[stat_name]
	return 0

# Upgrade a stat by one
func upgrade_stat(stat_name: String):
	if upgrades.has(stat_name):
		upgrades[stat_name] += 1

# Set HP to max (call on new game/respawn)
func reset_hp():
	HP = get_stat("max_hp")
