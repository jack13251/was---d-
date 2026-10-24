#handles logic for keys to open chests for better upgrades not sure what yet
#maybe extra lifes, speed boost, jump boost, (super rare) control lock so it can not be randomised either permanently or temporarily

#NOTE Keycards and chests not yet added to game this script simply sets up for keys to be added

extends Sprite2D

var keys = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	keys += 1 #may need changing to something more like the ram script
	queue_free()
