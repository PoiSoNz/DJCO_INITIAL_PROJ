extends KinematicBody2D

var velocity = Vector2()
var frameDelta;

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const runAcceleration = Vector2(750, 0)
const runDeacceleration = Vector2(1500, 0)
const maxVelocity = 200

var is_slowed = false
var movement_speed_bonus_timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_speed_bonus_timer = Timer.new()
	movement_speed_bonus_timer.set_one_shot(true)
	movement_speed_bonus_timer.connect("timeout", self, "on_movement_speed_bonus_end")
	add_child(movement_speed_bonus_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	apply_gravity()
	
	check_wall()
	
	player_movement(delta)
	
	if is_slowed:
		var slowed_velocity = Vector2(0.5*velocity.x,velocity.y)
		move_and_slide(slowed_velocity, floorNormal)
	else:
		move_and_slide(velocity, floorNormal)

func apply_delta(value):
	return value * frameDelta

func check_wall():
	if is_on_wall():
		velocity.x = 0

func apply_gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += apply_delta(gravity)

func player_movement(delta):
	var frameAcceleration = apply_delta(runAcceleration)
	# Run right
	if Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT) && velocity.x >= 0:
		$run.flip_h = false
		if velocity.x + frameAcceleration.x < maxVelocity:
			velocity += frameAcceleration
		else:
			velocity.x = maxVelocity
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0:
		$run.flip_h = true
		if velocity.x - frameAcceleration.x > -maxVelocity:
			velocity -= frameAcceleration
		else:
			velocity.x = -maxVelocity
	# Run deacceleration (no movement key is being pressed or both are being pressed)
	else:
		var frameDeacceleration = apply_delta(runDeacceleration)
		
		if velocity.x - frameDeacceleration.x >= 0:
			velocity -= frameDeacceleration
		elif velocity.x + frameDeacceleration.x <= 0:
			velocity += frameDeacceleration
		else:
			velocity.x = 0

func on_movement_speed_bonus_end():
	pass