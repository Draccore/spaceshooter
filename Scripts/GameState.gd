extends Node

var current_slot: int = -1 # -1 means no slot selected

# Remember last used slot across sessions
func save_last_used_slot():
	var config = ConfigFile.new()
	config.set_value("save", "last_slot", current_slot)
	config.save("user://last_slot.cfg")

func load_last_used_slot():
	var config = ConfigFile.new()
	if config.load("user://last_slot.cfg") == OK:
		if config.has_section_key("save", "last_slot"):
			current_slot = int(config.get_value("save", "last_slot"))
