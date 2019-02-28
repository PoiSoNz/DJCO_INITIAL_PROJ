extends KinematicBody2D

var velocity = Vector2()
var jumpCount = 2
var frameDelta;

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const runAcceleration = Vector2(750, 0)
const runDeacceleration = Vector2(1500, 0)
const jumpAcceleration = Vector2(0, -700)
const maxVelocity = 500

var is_slowed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	apply_gravity()
	
	if is_on_wall():
		velocity.x = 0
	
	player_movement(delta)
	
	if is_slowed:
		var slowed_velocity = Vector2(0.5*velocity.x,velocity.y)
		move_and_slide(slowed_velocity, floorNormal)
	else:
		move_and_slide(velocity, floorNormal)

func apply_delta(value):
	return value * frameDelta

func apply_gravity():
	if is_on_floor():
		reset_gravity()
		jumpCount = 2
	else:
		velocity += apply_delta(gravity)

func reset_gravity():
	velocity.y = 0

func player_movement(delta):
	# Run right
	if Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT) && velocity.x >= 0:
		if velocity.x < maxVelocity:
			velocity += apply_delta(runAcceleration)
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0:
		if velocity.x > -maxVelocity:
			velocity -= apply_delta(runAcceleration)
	# Run deacceleration (no movement key is being pressed or both are being pressed)
	else:
		var frameDeacceleration = apply_delta(runDeacceleration)
		
		if velocity.x - frameDeacceleration.x >= 0:
			velocity -= frameDeacceleration
		elif velocity.x + frameDeacceleration.x <= 0:
			velocity += frameDeacceleration
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("player_jump") && jumpCount > 0:
		jumpCount -= 1
		reset_gravity()
		velocity += jumpAcceleration

func _on_Health_slowed():
	is_slowed = true;


func _on_Health_normal_speed():
	is_slowed = false;