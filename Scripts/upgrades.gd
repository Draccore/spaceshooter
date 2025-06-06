extends Control

@onready var speed_upgrade_progress = $VBoxContainer/SpeedUpgradeProgress
@onready var accel_upgrade_progress = $VBoxContainer/AccelUpgradeProgress
@onready var friction_upgrade_progress = $VBoxContainer/FrictionUpgradeProgress
@onready var hp_upgrade_progress = $VBoxContainer/HPUpgradeProgress

func _ready():
	update_progress_bars()

func update_progress_bars():
	speed_upgrade_progress.value = PlayerStats.upgrades["speed"]
	accel_upgrade_progress.value = PlayerStats.upgrades["accel"]
	friction_upgrade_progress.value = PlayerStats.upgrades["friction"]
	hp_upgrade_progress.value = PlayerStats.upgrades["max_hp"]

func _on_speed_pressed() -> void:
	PlayerStats.upgrade_stat("speed")
	update_progress_bars()

func _on_acelleration_pressed() -> void:
	PlayerStats.upgrade_stat("accel")
	update_progress_bars()

func _on_friction_pressed() -> void:
	PlayerStats.upgrade_stat("friction")
	update_progress_bars()

func _on_hp_pressed() -> void:
	PlayerStats.upgrade_stat("max_hp")
	update_progress_bars()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_save_pressed() -> void:
	SaveManager.save_data()
	$Label.text = "Game Saved!"
	$Label.show()
