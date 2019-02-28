extends Node2D

var lifetime = 2
var speed = 350

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
