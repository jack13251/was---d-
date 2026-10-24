#BUG - RAM tool tip no longer displays due to RAM being instantly spent not being stored
#TODO Tell player that randomisation can be disabled via settings and that difficulty can be changed

extends Control

var ram = false
var played = false

@onready var control: Control = $"."



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if played == false:
		control.show()
		$"Tool tip".text = "You are a robot with brain damage. Your aim is to make it to the hospital by completing the level. Your controls will change randomly when the timer runs out. You can view your current controls any time in the pause menu. (Esc)"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if control.visible == true:
		get_tree().paused = true
	if ram == false and $"../..".ram >= 1:
		print($"../..".ram)
		$"Tool tip".text = "Collect ram and use it to expand your memory making you remember your controls for longer. press the plus icon next  to the timer to spend one  ram on expanding your time  by 1 second"
		control.show()
		ram = true


func _on_button_pressed() -> void:
	control.hide()
	get_tree().paused = false
