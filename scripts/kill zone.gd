#BUG - player dies instantly upon game starting and then no further issues. 
#TODO add checkpoint after difficult spike jump (will require slight rework of system)


extends Area2D

var checkpoint = Vector2(281, 307)

@onready var respawn_delay: Timer = $"respawn delay"


func _on_body_entered(body: Node2D) -> void:
	print("you died!")
	respawn_delay.start()

func _on_respawn_delay_timeout() -> void:
	respawn()


func _on_checkpoint_1_body_entered(body: Node2D) -> void:
	checkpoint = Vector2(1256, 294)
	print("checkpoint")
	#NOTE i am thinking of defining coords for multiple checjpoints and usinf an if in this function to check which collision shape then using that checkpoint location. Or another system is good too
	
func respawn():
	$"../CharacterBody2D".global_position = checkpoint
