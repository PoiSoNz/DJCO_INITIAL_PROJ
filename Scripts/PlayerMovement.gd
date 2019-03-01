extends KinematicBody2D

var velocity = Vector2()
var jumpCount = 2
var frameDelta;
var currMaxVelocity = 500

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const runAcceleration = Vector2(750, 0)
const runDeacceleration = Vector2(1500, 0)
const jumpAcceleration = Vector2(0, -700)
const standardMaxVelocity = 500

var is_slowed = false
var movement_speed_bonus_timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_speed_bonus_timer = Timer.new()
	movement_speed_bonus_timer.set_one_shot(true)
	movement_speed_bonus_timer.set_wait_time(10)
	movement_speed_bonus_timer.connect("timeout", self, "on_movement_speed_bonus_end")
	add_child(movement_speed_bonus_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	apply_gravity()
	check_ceiling()
	check_wall()
	
	
	player_movement(delta)
	
	if is_slowed:
		var slowed_velocity = Vector2(0.5*velocity.x,velocity.y)
		move_and_slide(slowed_velocity, floorNormal)
	else:
		move_and_slide(velocity, floorNormal)

func apply_delta(value):
	return value * frameDelta

func check_ceiling():
	if is_on_ceiling():
		velocity.y = 0 

func check_wall():
	if is_on_wall():
		velocity.x = 0

func apply_gravity():
	if is_on_floor():
		reset_gravity()
		jumpCount = 2
	else:
		velocity += apply_delta(gravity)

func reset_gravity():
	velocity.y = 0

func player_movement(delta):
	var frameAcceleration = apply_delta(runAcceleration)
	# Run right
	if Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT) && velocity.x >= 0:
		if velocity.x + frameAcceleration.x < currMaxVelocity:
			velocity += frameAcceleration
		else:
			velocity.x = currMaxVelocity
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0:
		if velocity.x - frameAcceleration.x > -currMaxVelocity:
			velocity -= frameAcceleration
		else:
			velocity.x = -currMaxVelocity
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

func set_movement_speed_bonus(duration, bonus):
	currMaxVelocity = standardMaxVelocity + bonus
	movement_speed_bonus_timer.set_wait_time(duration)
	movement_speed_bonus_timer.start()

func on_movement_speed_bonus_end():
	currMaxVelocity = standardMaxVelocity

func _on_Health_slowed():
	is_slowed = true;

func _on_Health_normal_speed():
	is_slowed = false;