extends Node2D

const switch_delay = 2.0
var timer = 0
var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		timer += 2
		toggle_open()

func toggle_open():
	open = !open
	if open:
		$RigidBody2D/CollisionShape2D.disabled = true
		$RigidBody2D/closed_doors.visible = false
		$RigidBody2D/open_door_far.visible = true
		$RigidBody2D/open_door_near.visible = true
	else:
		$RigidBody2D/CollisionShape2D.disabled = false
		$RigidBody2D/closed_doors.visible = true
		$RigidBody2D/open_door_far.visible = false
		$RigidBody2D/open_door_near.visible = false
