extends Control

@onready var slot_buttons = [
	$"VBoxContainer/Slot 1/Slot Button",
	$"VBoxContainer/Slot 2/Slot Button",
	$"VBoxContainer/Slot 3/Slot Button"
]
@onready var delete_buttons = [
	$"VBoxContainer/Slot 1/Delete Button",
	$"VBoxContainer/Slot 2/Delete Button",
	$"VBoxContainer/Slot 3/Delete Button"
]

var selected_slot := -1

@onready var name_dialog = $NameDialog # PopupDialog with LineEdit as child
@onready var confirm_dialog = $ConfirmDialog # AcceptDialog for deletion

func _ready():
	update_slots()

func update_slots():
	var names = SaveManager.get_all_slot_display_names()
	for i in range(3):
		slot_buttons[i].text = names[i]
		slot_buttons[i].disabled = false
		if names[i] == "EMPTY":
			delete_buttons[i].visible = false
		else:
			delete_buttons[i].visible = true

func _on_slot_button_pressed(idx):
	var names = SaveManager.get_all_slot_display_names()
	selected_slot = idx
	if names[idx] == "EMPTY":
		name_dialog.popup_centered()
		name_dialog.get_node("LineEdit").text = ""
	else:
		SaveManager.load_data(idx + 1) # slots are 1-indexed
		GameState.current_slot = idx + 1
		GameState.save_last_used_slot()
		# Transition to game or show slot loaded message

func _on_delete_button_pressed(idx):
	selected_slot = idx
	confirm_dialog.popup_centered()

func _on_name_dialog_confirmed():
	var name = name_dialog.get_node("LineEdit").text.strip_edges()
	if name == "":
		# Optionally show error
		return
	SaveManager.set_current_slot(selected_slot + 1)
	GameState.current_slot = selected_slot + 1
	GameState.save_last_used_slot()
	SaveManager.reset_player_data()  # Make sure the save starts clean!
	SaveManager.save_data(name)
	update_slots()

func _on_confirm_dialog_confirmed():
	SaveManager.set_current_slot(selected_slot + 1)
	GameState.current_slot = selected_slot + 1
	GameState.save_last_used_slot()
	SaveManager.delete_save()
	update_slots()

	# New logic: If all saves are now empty, reset current_slot
	if SaveManager.all_saves_empty():
		GameState.current_slot = -1
		GameState.save_last_used_slot()

# Connect the signals in the editor or with code like this:
func _on_VBoxContainer_HBoxContainer_Button_pressed():
	_on_slot_button_pressed(0)
func _on_VBoxContainer_HBoxContainer2_Button_pressed():
	_on_slot_button_pressed(1)
func _on_VBoxContainer_HBoxContainer3_Button_pressed():
	_on_slot_button_pressed(2)
func _on_VBoxContainer_HBoxContainer_DeleteButton_pressed():
	_on_delete_button_pressed(0)
func _on_VBoxContainer_HBoxContainer2_DeleteButton_pressed():
	_on_delete_button_pressed(1)
func _on_VBoxContainer_HBoxContainer3_DeleteButton_pressed():
	_on_delete_button_pressed(2)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
