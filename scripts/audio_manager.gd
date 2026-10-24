#ATTENTION - The music sucks replace it with better music
#TODO Add some sound effects for all things. Jump, pickup, death. Make like mario in terms of sound fx

extends Node

@onready var music = $AudioStreamPlayer

func _ready():
	$"..".volume_changed.connect(changeVolume)
	changeVolume($"..".volume)
	
	if !music.playing:
		music.play()
	AudioServer.set_bus_volume_linear(1, 100)
	

func changeVolume(volume):
	AudioServer.set_bus_volume_linear(1, volume )
