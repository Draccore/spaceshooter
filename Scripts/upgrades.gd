extends Control

@onready var speed_value_label = $"VBoxContainer/Speed+/SpeedValueLabel"
@onready var friction_value_label = $"VBoxContainer/Friction+/FrictionValueLabel"
@onready var accel_value_label = $"VBoxContainer/Acceleration+/AccelValueLabel"
@onready var hp_value_label = $"VBoxContainer/HP+/HPValueLabel"

func _ready():
	update_stat_labels()

func update_stat_labels():
	speed_value_label.text = "%d (+%d)" % [PlayerStats.get_stat("speed"), PlayerStats.upgrades["speed"]]
	accel_value_label.text = "%d (+%d)" % [PlayerStats.get_stat("accel"), PlayerStats.upgrades["accel"]]
	friction_value_label.text = "%d (+%d)" % [PlayerStats.get_stat("friction"), PlayerStats.upgrades["friction"]]
	hp_value_label.text = "%d (+%d)" % [PlayerStats.get_stat("max_hp"), PlayerStats.upgrades["max_hp"]]

func _on_speed_pressed() -> void:
	PlayerStats.upgrade_stat("speed")
	update_stat_labels()

func _on_acceleration_pressed() -> void:
	PlayerStats.upgrade_stat("accel")
	update_stat_labels()

func _on_friction_pressed() -> void:
	PlayerStats.upgrade_stat("friction")
	update_stat_labels()

func _on_hp_pressed() -> void:
	PlayerStats.upgrade_stat("max_hp")
	update_stat_labels()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_save_pressed() -> void:
	SaveManager.save_data()
	$Label.text = "Game Saved!"
	$Label.show()
