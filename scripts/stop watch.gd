#add functionality for this to save a pb
#then add an online leader board (there are plugins which could be helpful idk)

extends Control

var stop = false
var time_taken = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stop == false:
		time_taken += delta #adds time elapst since last frame to keep track of play time
		$Label.text = "Time taken: " + str(time_taken).substr(0, 4)




func _on_hospital_body_entered(body: CharacterBody2D) -> void:
	stop = true
