extends Node2D

var checkpoints = []

var test = 100

signal send_score(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkpoints = get_children()
	var current_check_point = checkpoints.front()
	#emit_signal("send_score",current_check_point.current_bonus)
	emit_signal("send_score", current_check_point.current_bonus)
