extends Control


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


func _on_quit_pressed():
	SaveManager.save_data()
	get_tree().quit()


func _on_upgrades_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/upgrades.tscn")



func _on_costumization_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/costumization.tscn")



func _on_saves_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/saves.tscn")
