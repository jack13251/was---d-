extends Control

var now = []
@onready var settings: Control = $"../Control2"

func _ready() -> void:
	hide()
	get_tree().paused = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and get_tree().paused == false:
		show()
		get_tree().paused = true
		print("PAUSED")
		settings.hide()
	elif Input.is_action_just_pressed("ui_cancel"):
		hide()
		get_tree().paused = false

func update_current_controls(current):
	now = current
	$VBoxContainer2/Forward.text = "Forward - " + OS.get_keycode_string(now[0] )
	$VBoxContainer2/Backward.text = "Backward - " + OS.get_keycode_string(now[1] )
	$VBoxContainer2/Jump.text = "Jump - " + OS.get_keycode_string(now[2] )


func _on_resume_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_options_pressed() -> void:
	settings.show()



func _on_resume_4_pressed() -> void:
	MainMenu.saveGame()
	get_tree().change_scene_to_file("res://scenes/main menu.tscn") #game progress will be reet
	#NOTE no way back from temp main menu
