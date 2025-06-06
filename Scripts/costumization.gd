extends Control

# For example, on a button press in customization menu
func _on_engine_select(engine_name: String):
	PlayerStats.selected_engine = engine_name
	# If you have a preview Sprite2D in menu:
	$PreviewSprite.texture = PlayerStats.engines[engine_name]["sprite"]



func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
