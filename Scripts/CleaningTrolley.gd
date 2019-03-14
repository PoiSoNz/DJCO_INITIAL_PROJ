extends KinematicBody2D

var destination = null
var movementDirection
var arrived = true
var velocity = Vector2(500, 0)

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_gravity(delta)

	if !arrived:
		check_destination_arrive()
		move_and_slide(Vector2(velocity.x * movementDirection, velocity.y), floorNormal)
	else:
		# Only apply gravity force
		move_and_slide(Vector2(0, velocity.y), floorNormal)

func check_destination_arrive():
	if !destination:
		return
	
	if (movementDirection == 1 && self.position.x >= destination) || (movementDirection == -1 && self.position.x <= destination):
		arrived = true

func push(dest):
	destination = dest
	movementDirection = 1 if (self.position.x < dest) else -1
	arrived = false
	# Disable collision layer, so that it can't be pushed by the cleaning lady until cleaning lady is ready to push it again
	set_collision_layer_bit(1, 0)

func apply_gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += gravity * delta