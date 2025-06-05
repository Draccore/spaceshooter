extends Control

func _on_speed_pressed() -> void:
	PlayerStats.MAX_SPEED += 10

func _on_friction_pressed() -> void:
	PlayerStats.FRICTION += 0.5

func _on_acelleration_pressed() -> void:
	PlayerStats.ACCEL += 0.5

func _on_hp_pressed() -> void:
		PlayerStats.MAX_HP += 10

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
