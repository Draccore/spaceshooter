extends Node

const SAVE_DIR := "user://saves/"
const SAVE_FILE_PREFIX := "save_slot_"
const SAVE_FILE_SUFFIX := ".json"
const SECURITY_KEY := "AJSFGIO900921AFSKIFaks01234912kASD0kfkasdl2123"
const NUM_SLOTS := 3

var current_slot := 1 # default to slot 1
var current_display_name := "Save Slot 1"
var player_data := PlayerData.new()

func _ready():
	DirAccess.make_dir_absolute(SAVE_DIR)

func get_save_path(slot: int) -> String:
	return SAVE_DIR + SAVE_FILE_PREFIX + str(slot) + SAVE_FILE_SUFFIX

func save_data(display_name: String = ""):
	if display_name != "":
		current_display_name = display_name

	# Gather player data
	player_data.speed_upgrade = PlayerStats.upgrades.get("speed", 0)
	player_data.health_upgrade = PlayerStats.upgrades.get("max_hp", 0)
	player_data.friction_upgrade = PlayerStats.upgrades.get("friction", 0)
	player_data.accel_upgrade = PlayerStats.upgrades.get("accel", 0)

	var path = get_save_path(current_slot)
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		printerr("SaveManager: Could not open save file for writing: %s" % FileAccess.get_open_error())
		return

	var data = {
		"display_name": current_display_name,
		"player_data": {
			"speed_upgrade": player_data.speed_upgrade,
			"health_upgrade": player_data.health_upgrade,
			"friction_upgrade": player_data.friction_upgrade,
			"accel_upgrade": player_data.accel_upgrade,
		}
	}
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()
	print("SaveManager: Game saved to slot %d with name '%s'." % [current_slot, current_display_name])

func load_data(slot: int = -1):
	if slot > 0:
		current_slot = slot
	var path = get_save_path(current_slot)
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			printerr("SaveManager: Could not open save file for reading: %s" % FileAccess.get_open_error())
			return

		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data == null:
			printerr("SaveManager: Cannot parse save file as JSON: %s" % content)
			return

		current_display_name = data.get("display_name", "Save Slot %d" % current_slot)
		var pd = data.player_data
		player_data.speed_upgrade = pd.speed_upgrade
		player_data.health_upgrade = pd.health_upgrade
		player_data.friction_upgrade = pd.friction_upgrade
		player_data.accel_upgrade = pd.accel_upgrade

		PlayerStats.upgrades["speed"] = player_data.speed_upgrade
		PlayerStats.upgrades["max_hp"] = player_data.health_upgrade
		PlayerStats.upgrades["friction"] = player_data.friction_upgrade
		PlayerStats.upgrades["accel"] = player_data.accel_upgrade

		print("SaveManager: Game loaded from slot %d ('%s')." % [current_slot, current_display_name])
	else:
		printerr("SaveManager: No save file found at %s" % path)
		current_display_name = "Save Slot %d" % current_slot

func delete_save(slot: int = -1):
	if slot > 0:
		current_slot = slot

	# Remove the actual save file
	var path = get_save_path(current_slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		print("SaveManager: Save file deleted for slot %d." % current_slot)
	else:
		print("SaveManager: No save file found to delete for slot %d." % current_slot)

	# Optionally: Reset in-memory data
	player_data.speed_upgrade = 0
	player_data.health_upgrade = 0
	player_data.friction_upgrade = 0
	player_data.accel_upgrade = 0

	PlayerStats.upgrades["speed"] = 0
	PlayerStats.upgrades["max_hp"] = 0
	PlayerStats.upgrades["friction"] = 0
	PlayerStats.upgrades["accel"] = 0

	current_display_name = "Save Slot %d" % current_slot

func get_all_slot_display_names() -> Array:
	var names = []
	for i in range(1, NUM_SLOTS + 1):
		var path = get_save_path(i)
		if FileAccess.file_exists(path):
			var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
			if file:
				var content = file.get_as_text()
				file.close()
				var data = JSON.parse_string(content)
				var display_name = data.get("display_name", "Save Slot %d" % i)
				names.append(display_name)
			else:
				names.append("Save Slot %d" % i)
		else:
			names.append("EMPTY")
	return names

# Optionally, set slot and display name externally
func set_current_slot(slot: int):
	current_slot = clamp(slot, 1, NUM_SLOTS)
	load_data(current_slot)

func set_current_display_name(name: String):
	current_display_name = name


func reset_player_data():
	player_data.speed_upgrade = 0
	player_data.health_upgrade = 0
	player_data.friction_upgrade = 0
	player_data.accel_upgrade = 0

	PlayerStats.upgrades["speed"] = 0
	PlayerStats.upgrades["max_hp"] = 0
	PlayerStats.upgrades["friction"] = 0
	PlayerStats.upgrades["accel"] = 0

func save_exists(slot: int) -> bool:
	var path = get_save_path(slot)
	return FileAccess.file_exists(path)

func all_saves_empty() -> bool:
	var names = get_all_slot_display_names()
	for name in names:
		if name != "EMPTY":
			return false
	return true
