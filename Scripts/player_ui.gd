extends Control

@onready var hp_label = $VBoxContainer/HP
@onready var speed_label = $VBoxContainer/Speed

func _physics_process(delta: float) -> void:
	hp_label.text = "HP = " +str(PlayerStats.HP)
	speed_label.text = "Speed = " +str(PlayerStats.MAX_SPEED)
