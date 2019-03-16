extends KinematicBody2D

const damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision_info = move_and_collide(Vector2(0, 0))
	if collision_info:
		var collider = collision_info.collider.get_parent()
		if collider.name == "Player":
			collider.inflict_damage(damage, collision_info.normal)