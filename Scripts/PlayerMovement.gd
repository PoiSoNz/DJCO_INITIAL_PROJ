extends KinematicBody2D

var velocity = Vector2()
var jumpCount = 2

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 9.8)
const runAcceleration = Vector2(30, 0)
const runDeacceleration = Vector2(10, 0)
const jumpAcceleration = Vector2(0, -700)
const maxVelocity = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	apply_gravity()
	
	if is_on_wall():
		velocity.x = 0
	
	player_movement()
	
	move_and_slide(velocity, floorNormal)
	

func apply_gravity():
	if is_on_floor():
		reset_gravity()
		jumpCount = 2
	else:
		velocity += gravity
	
func reset_gravity():
	velocity.y = 0

func player_movement():
	# Run right
	if Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT) && velocity.x >= 0:
		if velocity.x < maxVelocity:
			velocity += runAcceleration
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0:
		if velocity.x > -maxVelocity:
			velocity -= runAcceleration
	# Run deacceleration (no movement key is being pressed or both are being pressed)
	elif is_on_floor():
		if velocity.x - runDeacceleration.x >= 0:
			velocity -= runDeacceleration
		elif velocity.x + runDeacceleration.x <= 0:
			velocity += runDeacceleration
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("player_jump") && jumpCount > 0:
		jumpCount -= 1
		reset_gravity()
		velocity += jumpAcceleration
		