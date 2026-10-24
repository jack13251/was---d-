extends Control

signal difficulty_changed(difficulty: String)
signal volume_changed(volume: float)

var config = ConfigFile.new()
var display = DisplayServer.window_get_mode()
var difficulty = "medium"
var enabled = true
var volume = 100
var error = config.load("user://settings.cfg") #ATTENTION must match save path below
var changed = false

func _ready() -> void:
	hide()
	openAndLoad()

func _process(delta: float) -> void:
	if visible == true and changed == true:
		updateMenu()
		changed = false

func _on_button_pressed() -> void:
	hide()


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$VBoxContainer/Difficulty/HBoxContainer/Button2.button_pressed = false
		$VBoxContainer/Difficulty/HBoxContainer/Button3.button_pressed = false
		difficulty = "easy"
		Save()
		difficulty_changed.emit(difficulty)


func _on_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$VBoxContainer/Difficulty/HBoxContainer/Button.button_pressed = false
		$VBoxContainer/Difficulty/HBoxContainer/Button3.button_pressed = false
		difficulty = "medium"
		Save()
		difficulty_changed.emit(difficulty)


func _on_button_3_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		$VBoxContainer/Difficulty/HBoxContainer/Button.button_pressed = false
		$VBoxContainer/Difficulty/HBoxContainer/Button2.button_pressed = false
		difficulty = "hard"
		Save()
		difficulty_changed.emit(difficulty)

func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		display = 0
	elif index == 1:
		display = 2 #NOTE skips minimised
	elif index == 2:
		display = 3
	elif index == 3:
		display = 4
	DisplayServer.window_set_mode(display)
	Save()

func _on_check_button_toggled(toggled_on: bool) -> void:
	print("toggled")
	if toggled_on == false:
		print("off")
		enabled = false
		$VBoxContainer/CheckButton/Label.text = "Disabled"
		Save()
	else:
		print("on")
		enabled = true
		$VBoxContainer/CheckButton/Label.text = "Enabled"
		Save()


func _on_h_slider_drag_ended(value_changed: bool) -> void:
	volume = $VBoxContainer/HSlider.value
	volume_changed.emit(volume)
	Save()


func Save() -> void:
	config.set_value("Display", "Mode", display)
	config.set_value("Gameplay", "Difficulty", difficulty)
	config.set_value("Gameplay", "Wheel_Enabled", enabled)
	config.set_value("Audio", "Music_Volume", volume)


	config.save("user://settings.cfg") #NOTE this is the real path outside of testing

func openAndLoad() -> void:
	if error == OK:
		changed = true
		
		display = config.get_value("Display", "Mode")
		DisplayServer.window_set_mode(display)
		
		difficulty = config.get_value("Gameplay", "Difficulty")
		difficulty_changed.emit(difficulty)
		
		enabled = config.get_value("Gameplay", "Wheel_Enabled")
		
		volume = config.get_value("Audio", "Music_Volume")
		volume_changed.emit(volume)

	else:
		pass

func updateMenu() -> void:
	if difficulty == "easy":
		$VBoxContainer/Difficulty/HBoxContainer/Button.set_pressed_no_signal(true)
		$VBoxContainer/Difficulty/HBoxContainer/Button2.set_pressed_no_signal(false)
		$VBoxContainer/Difficulty/HBoxContainer/Button3.set_pressed_no_signal(false)
	elif difficulty == "medium":
		$VBoxContainer/Difficulty/HBoxContainer/Button.set_pressed_no_signal(false)
		$VBoxContainer/Difficulty/HBoxContainer/Button2.set_pressed_no_signal(true)
		$VBoxContainer/Difficulty/HBoxContainer/Button3.set_pressed_no_signal(false)
	elif difficulty == "hard":
		$VBoxContainer/Difficulty/HBoxContainer/Button.set_pressed_no_signal(false)
		$VBoxContainer/Difficulty/HBoxContainer/Button2.set_pressed_no_signal(false)
		$VBoxContainer/Difficulty/HBoxContainer/Button3.set_pressed_no_signal(true)
	
	if enabled == true:
		$VBoxContainer/CheckButton/Label.text = "Enabled"
		$VBoxContainer/CheckButton.set_pressed_no_signal(true)
	else:
		$VBoxContainer/CheckButton/Label.text = "Disabled"
		$VBoxContainer/CheckButton.set_pressed_no_signal(false)
	
	
	$VBoxContainer/HSlider.set_value_no_signal(volume)
	
	print("Display mode", display)
	if display == 0:
		#$VBoxContainer/OptionButton.set_pressed_no_signal(false)
		$VBoxContainer/OptionButton.select(display)
	else:
		#$VBoxContainer/OptionButton.set_pressed_no_signal(false)
		$VBoxContainer/OptionButton.select(display - 1)
