extends Node

const SAVE_DIR := "user://saves/"
const SAVE_FILE_NAME := "save.json"
const SECURITY_KEY := "AJSFGIO900921AFSKIFaks01234912kASD0kfkasdl2123"

var player_data := PlayerData.new()

func _ready():
	DirAccess.make_dir_absolute(SAVE_DIR)
	load_data()

func save_data():
	player_data.speed_upgrade = PlayerStats.upgrades.get("speed", 0)
	player_data.health_upgrade = PlayerStats.upgrades.get("max_hp", 0)
	player_data.friction_upgrade = PlayerStats.upgrades.get("friction", 0)
	player_data.accel_upgrade = PlayerStats.upgrades.get("accel", 0)

	var path = SAVE_DIR + SAVE_FILE_NAME
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		printerr("SaveManager: Could not open save file for writing: %s" % FileAccess.get_open_error())
		return

	var data = {
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
	print("SaveManager: Game saved.")

func load_data():
	var path = SAVE_DIR + SAVE_FILE_NAME
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

		var pd = data.player_data
		player_data.speed_upgrade = pd.speed_upgrade
		player_data.health_upgrade = pd.health_upgrade
		player_data.friction_upgrade = pd.friction_upgrade
		player_data.accel_upgrade = pd.accel_upgrade

		PlayerStats.upgrades["speed"] = player_data.speed_upgrade
		PlayerStats.upgrades["max_hp"] = player_data.health_upgrade
		PlayerStats.upgrades["friction"] = player_data.friction_upgrade
		PlayerStats.upgrades["accel"] = player_data.accel_upgrade

		print("SaveManager: Game loaded.")
	else:
		printerr("SaveManager: No save file found at %s" % path)

func reset_save():
	player_data.speed_upgrade = 0
	player_data.health_upgrade = 0
	player_data.friction_upgrade = 0
	player_data.accel_upgrade = 0

	PlayerStats.upgrades["speed"] = 0
	PlayerStats.upgrades["max_hp"] = 0
	PlayerStats.upgrades["friction"] = 0
	PlayerStats.upgrades["accel"] = 0

	save_data()
	print("SaveManager: Save reset.")
