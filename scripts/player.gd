#CAUTION this is the most important script of the game be very careful with sweeping changes
#TODO add check to make sure randomised keys dont overlap
#TODO make reset controls option functional where controls are put back to default.
#TODO add jet pack (maybe with limited fuel or flight duration before landing)
#TODO animate character sprite

extends CharacterBody2D

@onready var timer_speed: Timer = $"../Speed Boost/DurationS"
@onready var timer_jump: Timer = $"../Jump Boost/DurationJ"

var SPEED = 130
var JUMP_VELOCITY = -300

var changing = []
var current = []

var controls = {
	"forward": KEY_RIGHT,
	"jump": KEY_SPACE,
	"backward": KEY_LEFT
}

#Below lists all allowed keys for randomisation NOTE checks should be added to control combinations 

var poss = [
	KEY_UP, KEY_DOWN, KEY_LEFT, KEY_RIGHT,
	KEY_A, KEY_B, KEY_C, KEY_D, KEY_E, KEY_F, KEY_G, KEY_H,
	KEY_I, KEY_J, KEY_K, KEY_L, KEY_M, KEY_N, KEY_O, KEY_P,
	KEY_Q, KEY_R, KEY_S, KEY_T, KEY_U, KEY_V, KEY_W, KEY_X,
	KEY_Y, KEY_Z
]

var changeable = ["forward", "jump", "backward"]

var mapping = []

@onready var wheel = get_node("../CanvasLayer/wheel")
@onready var pause_menu = get_node ("../CanvasLayer/pause menu")

func _ready():
	wheel.wheel_result.connect(on_wheel_result)

func _process(delta: float) -> void:
	$"../CanvasLayer/Speed boost time remaining/Label".text = "Speed boost left: " + str(timer_speed.time_left).substr(0, 3)
	$"../CanvasLayer/Jump boost remaining/Label".text = "Jump boost left: " + str(timer_jump.time_left).substr(0, 3)

func _on_timer_timeout() -> void:
	mapping = generate_wheel_mapping()
	wheel.set_mapping(mapping)
	changeable.shuffle()
	changing = [changeable[randi_range(0,2)], changeable[randi_range(0,2)],changeable[randi_range(0,2)], changeable[randi_range(0,2)]]
	wheel.changing(changing)

func generate_wheel_mapping():
	poss.shuffle()
	var selected = poss.slice(0, 4)

	return {
		"red": selected[0],
		"blue": selected[1],
		"green": selected[2],
		"yellow": selected[3]
	}

func on_wheel_result(colour):
	print("signal recieved", colour)
	set_control_mode(colour)
	
func set_control_mode(colour):
	if colour == "yellow": #yellow
		controls[changing[2]] = mapping["yellow"]
	elif colour == "red": #red
		controls[changing[1]] = mapping["red"]
	elif colour == "green": #green
		controls[changing[3]] = mapping["green"]
	elif colour == "blue": #blue
		controls[changing[0]] = mapping["blue"]
	else:
		print("CONTROLS COULD NOT BE UPDATED")
	print(controls.forward)
	
	current = [controls.forward, controls.backward, controls.jump]
	print(current)
	pause_menu.update_current_controls(current)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_key_pressed(controls.jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := 0
	if Input.is_key_pressed(controls.forward):
		direction += 1
	if Input.is_key_pressed(controls.backward):
		direction -= 1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)



	move_and_slide()

#### handles speed boost ###
func _on_speed_boost_body_entered(body: CharacterBody2D) -> void:
	timer_speed.wait_time = 12 #duration of speed boost effect
	timer_speed.start()
	SPEED = 260 #sets speed value during boost


func _on_duration_timeout() -> void:
	SPEED = 130 #reset to default speed
	timer_speed.stop()
	timer_speed.wait_time = 0
#### end of speed boost handling ###


### handles jump boost ###
#NOTE perhaps the camera should zoom out during jump boost for easier control
func _on_jump_boost_body_entered(body: CharacterBody2D) -> void:
	timer_jump.wait_time = 12 #duration of jump boost effect
	timer_jump.start()
	JUMP_VELOCITY = -600 #sets jump value during boost (lowe = higher jump)
	#NOTE a lower jump can be used for a level section with hightened gravity or magnetic floor

func _on_duration_j_timeout() -> void:
	JUMP_VELOCITY = -300 #reset to default jump
	timer_jump.stop()
	timer_jump.wait_time = 0
### end of jump boost handling ###
