extends Control

@onready var hp_label: Label = $VBoxContainer/HP
@onready var speed_label: Label = $VBoxContainer/Speed

func _physics_process(_delta: float) -> void:
	_update_stats()

func _update_stats():
	hp_label.text = "HP = %s" % PlayerStats.HP
	speed_label.text = "Speed = %s" % PlayerStats.get_stat("speed")
