extends Resource
class_name WaveData

@export var enemies: Array[Dictionary] = []
@export var spawn_delay: float = 0.0
@export var comment: String = ""

func setup(_enemies: Array[Dictionary], _delay: float, _comment: String) -> WaveData:
	enemies = _enemies
	spawn_delay = _delay
	comment = _comment
	return self
