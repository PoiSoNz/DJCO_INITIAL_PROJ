extends KinematicBody2D

var velocity = Vector2()
var jumpCount = 2
var frameDelta;
var currMaxVelocity = 500
var knock_back_timer = knockBackCooldown

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const runAcceleration = Vector2(750, 0)
const runDeacceleration = Vector2(1500, 0)
const jumpAcceleration = Vector2(0, -700)
const standardMaxVelocity = 500
const knockBackCooldown = 0.1

var is_slowed = false
var is_knocked = false
var movement_speed_bonus_timer = null

onready var anim_state = "Idle"
var previolus_anim_state = "Idle"

onready var playback = $Sprite/AnimationTree.get("parameters/playback")

signal coffee_ended()

# Called when the node enters the scene tree for the first time.
func _ready():
	movement_speed_bonus_timer = Timer.new()
	movement_speed_bonus_timer.set_one_shot(true)
	movement_speed_bonus_timer.connect("timeout", self, "on_movement_speed_bonus_end")
	add_child(movement_speed_bonus_timer)
	$Sprite/AnimationTree.active = true
	playback.start("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	check_ceiling()
	apply_gravity()
	
	check_wall()
	
	check_knock_back(delta)
	
	previolus_anim_state = anim_state
	player_movement(delta)
	
	if previolus_anim_state != anim_state:
		playback.start(anim_state)
		change_hit_box(anim_state)
	
	if is_slowed && !is_knocked:
		var slowed_velocity = Vector2(0.6*velocity.x,velocity.y)
		move_and_slide(slowed_velocity, floorNormal)
	else:
		move_and_slide(velocity, floorNormal)
		
func change_hit_box(anim_state):
	match anim_state:
		"Idle":
			$CollisionShape2D.position.x = 1
			$CollisionShape2D.position.x = 0
			$CollisionShape2D.shape.extents.x = 24
			$CollisionShape2D.shape.extents.y = 44
			print("idle", $CollisionShape2D.shape.extents)
		"DoubleJump":
			$CollisionShape2D.position.x = 2
			$CollisionShape2D.position.x = -3
			$CollisionShape2D.shape.extents.x = 27
			$CollisionShape2D.shape.extents.y = 37
			print("DoubleJump", $CollisionShape2D.shape.extents)
		_: #Run or Jump
			$CollisionShape2D.position.x = 8
			$CollisionShape2D.position.x = 0
			$CollisionShape2D.shape.extents.x = 24
			$CollisionShape2D.shape.extents.y = 44
			print("run/jump", $CollisionShape2D.shape.extents)
		
		
func check_knock_back(delta):
	var collision_info = move_and_collide(Vector2(0,0))
	if collision_info:
		if collision_info.collider.get_parent().name == "Bench" && !is_knocked:
			benched(collision_info)
	if(is_knocked):
		knock_back_timer -= delta
		if knock_back_timer <= 0:
			knock_back_timer = knockBackCooldown
			is_knocked = false
			
func benched(collision_info):
	is_knocked = true
	$Health.reduce_health(10)
	apply_knock_back(collision_info)
			
func apply_knock_back(collision_info):
	print("normal (", collision_info.normal.x, ", ", collision_info.normal.y, ")")
	if collision_info.normal == Vector2(-1,0):
		velocity = Vector2(-500,-250)
	elif collision_info.normal == Vector2(1,0):
		velocity = Vector2(500,-250)
	elif collision_info.normal == Vector2(0,-1):
		velocity = Vector2(0,-500)

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
		if velocity.y == 0:
			anim_state = "Run"
		$Sprite.flip_h = false
		if velocity.x + frameAcceleration.x < currMaxVelocity:
			velocity += frameAcceleration
		else:
			velocity.x = currMaxVelocity
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0:
		if velocity.y == 0:
			anim_state = "Run"
		$Sprite.flip_h = true
		if velocity.x - frameAcceleration.x > -currMaxVelocity:
			velocity -= frameAcceleration
		else:
			velocity.x = -currMaxVelocity
	# Run deacceleration (no movement key is being pressed or both are being pressed)
	else:
		if velocity.y == 0:
			if velocity.x > 0:
				anim_state = "Run"
				$Sprite.flip_h = false
			elif velocity.x < 0:
				anim_state = "Run"
				$Sprite.flip_h = true
			else:
				anim_state = "Idle"
			
		var frameDeacceleration = apply_delta(runDeacceleration)
		
		if velocity.x - frameDeacceleration.x >= 0:
			velocity -= frameDeacceleration
		elif velocity.x + frameDeacceleration.x <= 0:
			velocity += frameDeacceleration
		else:
			velocity.x = 0
			
	if Input.is_action_just_pressed("player_jump") && jumpCount > 0:
		reset_gravity()
		var multiplier = 1.15
		if jumpCount == 2:
			anim_state = "Jump"
			multiplier = 0.70
		else:
			anim_state = "DoubleJump"
		velocity += jumpAcceleration * multiplier
		jumpCount -= 1

func set_movement_speed_bonus(duration, bonus):
	currMaxVelocity = standardMaxVelocity + bonus
	movement_speed_bonus_timer.set_wait_time(duration)
	movement_speed_bonus_timer.start()

func set_slowed(value):
	is_slowed = value

func on_movement_speed_bonus_end():
	currMaxVelocity = standardMaxVelocity
	emit_signal("coffee_ended")