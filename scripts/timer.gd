#BUG read below
#BUG progress bar is often fully filled far before the wheel appears (likely due to total time changing inbetween wheel spins)
#possible BUG wheel may show still when disabled

extends Node

@onready var timer = $Timer
@onready var progress_bar = $CanvasLayer/ProgressBar
@onready var wheel = $CanvasLayer/wheel



var ram = 0
var total_time = 10 # seconds NOTE starts at medium difficulty
#var enabled = true

func _ready():
	print("ready")
	wheel.visible = false
	$CanvasLayer/wheel.wheel_dismissed.connect(on_wheel_dismissed)
	$CanvasLayer/Control2.difficulty_changed.connect(difficultyChange)
	difficultyChange($CanvasLayer/Control2.difficulty)
	print("signal connected")

	
	timer.wait_time = total_time
	timer.one_shot = true
	if $CanvasLayer/Control2.enabled == true:
		timer.start()
	progress_bar.min_value = 0
	progress_bar.max_value = total_time
	progress_bar.value = 0

func _process(_delta):
	var elapsed = total_time - timer.time_left
	progress_bar.value = elapsed
	if ram > 0:
		ram -= 1 #the instant decrease in ram causes the ram tool tip not to run
		total_time += 2
		timer.wait_time += 2
		timer.start(timer.time_left + 2)
	if $CanvasLayer/Control2.enabled == false:
		timer.stop()
	else:
		if timer.is_stopped() == true:
			timer.start()

func _on_timer_timeout():
	if $CanvasLayer/Control2.enabled == true:
		wheel.visible = true
		get_tree().paused = true
	

func on_wheel_dismissed():
	timer.wait_time = total_time
	if $CanvasLayer/Control2.enabled == true:
		timer.start()


#BUG resets ram addon time if changed mid game
#NOTE (possibly a BUG) changing difficulty setting will only come into effect after first wheel 

func difficultyChange(difficulty: String) -> void:
	if difficulty == "easy":
		total_time = 120 #EASY
		print(total_time)
	elif difficulty == "medium":
		total_time = 60 #EASY
		print(total_time)
	elif difficulty == "hard":
		total_time = 30
		print(total_time)
	else:
		print("UNKNOWN DIFFICULTY RECIEVED")
