extends Control

## Save properties
const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "save.json"
## Not secure to have key here. Move it.
const SECURITY_KEY = "AJSFGIO900921AFSKIFaks01234912kASD0kfkasdl2123"

var player_data = PlayerData.new()

func _ready():
	verify_save_directory(SAVE_DIR)


func verify_save_directory(path : String):
	DirAccess.make_dir_absolute(path)

func save_data(path : String):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, SECURITY_KEY)
	if file == null:
		print(FileAccess.get_open_error())
		return
	
	var data = {
		"player_data":{
			"speed_upgrade": player_data.speed_upgrade,
			"health_upgrade": player_data.health_upgrade,
			"friction_upgrade": player_data.friction_upgrade,
			"accel_upgrade": player_data.accel_upgrade,
		}
	}
	
	var json_string = JSON.stringify(data, "\t")
	file.store_string(json_string)
	file.close()


func load_data(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, SECURITY_KEY)
		if file == null:
			print(FileAccess.get_open_error())
			return
			
		var content = file.get_as_text()
		file.close()
	
	
		var data = JSON.parse_string(content)
		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [path, content])
			return
		
		player_data = PlayerData.new()
		player_data.speed_upgrade = data.player_data.speed_upgrade
		player_data.health_upgrade = data.player_data.health_upgrade
		player_data.friction_upgrade = data.player_data.friction_upgrade
		player_data.accel_upgrade = data.player_data.accel_upgrade
		
		
	else:
		printerr("Cannot open non-existent file at %s!" % [path])

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_quit_pressed() -> void:
	save_data(SAVE_DIR + SAVE_FILE_NAME)
	get_tree().quit()


func _on_upgrades_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/upgrades.tscn")



func _on_costumization_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/costumization.tscn")


func _on_load_save_pressed() -> void:
	load_data(SAVE_DIR + SAVE_FILE_NAME)
