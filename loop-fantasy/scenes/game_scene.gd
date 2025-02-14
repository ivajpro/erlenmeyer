extends Node2D

func _ready():
	var camera = Camera2D.new()
	camera.make_current()
	add_child(camera)
