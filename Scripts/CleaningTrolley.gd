extends KinematicBody2D

var destination = null
var movementDirection
var arrived = true
var velocity = Vector2(1000, 0)

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_destination_arrive()
	
	apply_gravity(delta)
	
	if !arrived:
		move_and_slide(velocity * movementDirection, floorNormal)

func check_destination_arrive():
	if !destination:
		return
	
	if movementDirection == 1 && self.position.x >= destination:
		arrived = true
	elif movementDirection == -1 && self.position.x <= destination:
		arrived = true
	else:
		arrived = false

func push(dest):
	destination = dest
	movementDirection = 1 if (self.position.x < dest) else -1
	arrived = false

func apply_gravity(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += gravity * delta