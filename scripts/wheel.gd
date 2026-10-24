#TEST - seems to work but needs robustly testing

#CAUTION - This script is vital to the game running. Be careful making any changes.

extends Node2D

signal wheel_result(seg)
signal wheel_dismissed


var wait_time = randi_range(4, 7)
var stopping = false
var close = false
var mapping = {}
var dir = []
var colour = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"stopping time".one_shot = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stopping == true:
		var remaining = $"stopping time".time_left / wait_time
		$Sprite2D/AnimationPlayer.speed_scale = remaining * remaining
		if $Sprite2D/AnimationPlayer.speed_scale == 0:
			stopping = false
			$Label.text = "Click anywhere to continue..."
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and close == true:
		hide()
		get_tree().paused = false
		emit_signal("wheel_dismissed")
		close = false
		reset_wheel()


func _on_button_pressed() -> void:
	$Sprite2D/AnimationPlayer.play("spin")
	print("SPIN")
	$Sprite2D/Button.hide()
	$Sprite2D/stop.show()
	$Label.text = "Click the wheel to stop..."

func _on_stop_pressed() -> void:
	print("stop pressed")
	$"stopping time".wait_time = wait_time
	$"stopping time".start()
	stopping = true
	$Sprite2D/stop.hide()
	$Label.text = "Stopping..."



func _on_stopping_time_timeout() -> void:
	var pos = fposmod($Sprite2D.rotation_degrees,360)
	print(pos)
	var seg = round(pos / 30)
	print(seg)
	if (pos >= 0 and pos < 30) or (pos >=120 and pos < 150) or (pos >= 240 and pos < 270) :
		print("green")
		colour = "green"
	elif (pos >= 30 and pos < 60) or (pos >= 150 and pos < 180) or (pos >= 270 and pos < 300) :
		print("red")
		colour = "red"
	elif (pos >= 60 and pos < 90) or (pos >= 180 and pos < 210) or (pos >= 300 and pos < 330) :
		print("blue")
		colour = "blue"
	elif (pos >= 90 and pos < 120) or (pos >= 210 and pos < 240) or (pos >= 330 and pos < 360) :
		print("yellow")
		colour = "yellow"
	else:
		print("ERROR POSITION NOT FOUND")
	emit_signal("wheel_result", colour)
	
	#green = seg 3 and 7
	#red = seg 2 and 6
	#yellow = seg 1 and 5
	#blue = seg 4 and 8
	close = true
	
func set_mapping(new_mapping):
	mapping = new_mapping

func changing(changing):
	dir = changing
	update_labels()
	
func update_labels():
	$VBoxContainer/Blue.text = "•Blue - change  " + dir[0] + " to " +  OS.get_keycode_string(mapping["blue"])
	$VBoxContainer/Red.text = "•Red - change  " + dir[1] + " to " +  OS.get_keycode_string(mapping["red"])
	$VBoxContainer/Yellow.text = "•Yellow - change " + dir[2] + " to " + OS.get_keycode_string(mapping["yellow"])
	$VBoxContainer/Green.text = "•Green - change " + dir[3] + " to " +  OS.get_keycode_string(mapping["green"])
	
func reset_wheel():
	# stop animation
	$Sprite2D/AnimationPlayer.stop()

	# reset speed
	$Sprite2D/AnimationPlayer.speed_scale = 1.0

	# reset rotation if needed
	$Sprite2D.rotation_degrees = 0

	# reset UI
	$Sprite2D/Button.show()
	$Sprite2D/stop.hide()
	
	$Label.text = "Click the wheel to spin..."
	
	print("Wheel reset")
