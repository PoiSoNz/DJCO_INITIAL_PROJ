extends KinematicBody2D

var destination = null
var movementDirection
var arrived = true
var velocity = Vector2(500, 0)

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const damage = 25

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_gravity(delta)
	
	check_player_hit()
	
	if !arrived:
		check_destination_arrive()
		move_and_slide(Vector2(velocity.x * movementDirection, velocity.y), floorNormal)
	else:
		# Only apply gravity force
		move_and_slide(Vector2(0, velocity.y), floorNormal)

func check_destination_arrive():
	if !destination:
		return
	
	if (movementDirection == 1 && self.global_position.x >= destination) || (movementDirection == -1 && self.global_position.x <= destination):
		arrived = true
		$Sprite.flip_h = !$Sprite.flip_h

func push(dest):
	destination = dest
	movementDirection = 1 if (self.global_position.x < dest) else -1
	arrived = false
	# Disable collision layer, so that it can't be pushed by the cleaning lady until cleaning lady is ready to push it again
	set_collision_layer_bit(2, 0)

func check_player_hit():
	var collision_info = move_and_collide(Vector2(0, 0))
	if collision_info:
		var collider = collision_info.collider.get_parent()
		if collider.name == "Player":
			collider.inflict_damage(damage, collision_info.normal)

func apply_gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += gravity * delta