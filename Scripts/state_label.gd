extends Label
@onready var player = $"../.."

func _physics_process(delta: float) -> void:
	self.text = (player.current_state.name)
