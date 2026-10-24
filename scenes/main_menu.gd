#NOTE this provides temporary functionality to the menu to allow quitiing. Real menu following later
#TODO finsish setting up


extends Control

#Button to quit game
func _on_button_pressed() -> void:
	#add save before close?
	get_tree().quit() #Immediatley closes game


func _on_continue_pressed() -> void:
	loadGame()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func loadGame() -> void:
	print("load \a")

func saveGame() -> void:
	print("save")
