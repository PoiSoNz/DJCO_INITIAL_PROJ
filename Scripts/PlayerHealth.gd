extends Node

var frameDelta
var health = 100

signal health_changed(health)

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("health_changed", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	reduce_health(2)
	emit_signal("health_changed", health)
	
func reduce_health(value):
	health -= apply_delta(value)

func apply_delta(value):
	return value * frameDelta