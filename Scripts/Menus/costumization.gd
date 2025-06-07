extends Control

# Called when engine option is selected in customization menu
func _on_engine_select(engine_name: String) -> void:
	PlayerStats.selected_engine = engine_name
	# Update preview if present
	$Container/PreviewSprite.texture = PlayerStats.engines[engine_name]["sprite"]

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# Engine button handlers
func _on_base_engine_pressed() -> void:
	_on_engine_select("default_engine")

func _on_pulse_engine_pressed() -> void:
	_on_engine_select("pulse_engine")

func _on_burst_engine_pressed() -> void:
	_on_engine_select("burst_engine")

func _on_supercharged_engine_pressed() -> void:
	_on_engine_select("supercharged_engine")
