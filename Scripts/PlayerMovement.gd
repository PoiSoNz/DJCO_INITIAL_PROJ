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
const slideCooldown = 0.3

const knockbackXForce = 500
const knockbackYForce = 500
const knockbackCooldown = 0.2
var knockback_timer = null

const recover_duration = 0.4
var recover_timer = null

var is_slowed = false
var is_knocked = false
var movement_speed_bonus_timer = null
var sliding = false
var slide_timer = slideCooldown

onready var anim_state = "Idle"
var previolus_anim_state = "Idle"

onready var playback = $Sprite/AnimationTree.get("parameters/playback")

signal coffee_ended()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Prepare movement speed timer
	movement_speed_bonus_timer = Timer.new()
	movement_speed_bonus_timer.set_one_shot(true)
	movement_speed_bonus_timer.connect("timeout", self, "on_movement_speed_bonus_end")
	add_child(movement_speed_bonus_timer)
	# Prepare knockback timer
	knockback_timer = Timer.new()
	knockback_timer.set_one_shot(true)
	knockback_timer.set_wait_time(knockbackCooldown)
	knockback_timer.connect("timeout", self, "on_knockback_end")
	add_child(knockback_timer)
	# Prepare recover timer
	recover_timer = Timer.new()
	recover_timer.set_one_shot(true)
	recover_timer.set_wait_time(recover_duration)
	recover_timer.connect("timeout", self, "on_recovery_end")
	add_child(recover_timer)
	
	$Sprite/AnimationTree.active = true
	playback.start("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	frameDelta = delta;
	
	check_ceiling()
	apply_gravity()
	
	check_wall()
	
	check_sliding(delta)
	
	previolus_anim_state = anim_state
	
	if !is_knocked:
		player_movement(delta)
	
	if previolus_anim_state != anim_state:
		playback.start(anim_state)
		change_hit_box(anim_state)
	
	if is_slowed && !is_knocked:
		var slowed_velocity = Vector2(0.6*velocity.x,velocity.y)
		move_and_slide(slowed_velocity, floorNormal)
	else:
		#print(is_knocked)
		move_and_slide(velocity, floorNormal)
	
	check_out_of_bonds()

func check_out_of_bonds():
	if position.x < $Camera2D.backingLimitX:
		position.x = $Camera2D.backingLimitX

func change_hit_box(anim_state):
	match anim_state:
		"Idle":
			$CollisionShape2D.position.x = 1
			$CollisionShape2D.position.y = 2
			$CollisionShape2D.shape.extents.x = 24
			$CollisionShape2D.shape.extents.y = 42
			#print("idle", $CollisionShape2D.shape.extents)
		"DoubleJump":
			$CollisionShape2D.position.x = 2
			$CollisionShape2D.position.y = -3
			$CollisionShape2D.shape.extents.x = 27
			$CollisionShape2D.shape.extents.y = 37
			#print("doublejump", $CollisionShape2D.shape.extents)
		"Slide":
			$CollisionShape2D.position.x = 4
			$CollisionShape2D.position.y = 22
			$CollisionShape2D.shape.extents.x = 34
			$CollisionShape2D.shape.extents.y = 22
			#print("slide", $CollisionShape2D.shape.extents)
		_: #Run or Jump
			$CollisionShape2D.position.x = 8
			$CollisionShape2D.position.y = 0
			$CollisionShape2D.shape.extents.x = 24
			$CollisionShape2D.shape.extents.y = 44
			#print("run/jump", $CollisionShape2D.shape.extents)

func check_sliding(delta):
	if sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			slide_timer = slideCooldown
			sliding = false

func apply_knock_back():
	self.set_collision_layer_bit(1, 0)
	if $Sprite.flip_h:
		velocity = Vector2(knockbackXForce, -knockbackYForce)
	else:
		velocity = Vector2(-knockbackXForce, -knockbackYForce)	
	is_knocked = true
	knockback_timer.start()

func apply_delta(value):
	return value * frameDelta

func check_ceiling():
	if is_on_ceiling():
		velocity.y = 0 

func check_wall():
	if is_on_wall():
		velocity.x = 0

func apply_gravity():
	if is_on_floor() && !is_knocked:
		reset_gravity()
		jumpCount = 2
	else:
		velocity += apply_delta(gravity)

func reset_gravity():
	velocity.y = 0

func player_movement(delta):
	var frameAcceleration = apply_delta(runAcceleration)
	# Run right
	if Input.is_key_pressed(KEY_RIGHT) && !Input.is_key_pressed(KEY_LEFT) && velocity.x >= 0 && !sliding:
		if velocity.y == 0:
			anim_state = "Run"
		$Sprite.flip_h = false
		if velocity.x + frameAcceleration.x < currMaxVelocity:
			velocity += frameAcceleration
		else:
			velocity.x = currMaxVelocity
	# Run left
	elif Input.is_key_pressed(KEY_LEFT) && !Input.is_key_pressed(KEY_RIGHT) && velocity.x <= 0 && !sliding:
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
				#anim_state = "Run"
				$Sprite.flip_h = false
			elif velocity.x < 0:
				#anim_state = "Run"
				$Sprite.flip_h = true
			else:
				anim_state = "Idle"
		
		if !sliding:
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
		
	if Input.is_action_just_pressed("player_slide") && !sliding && anim_state != "Jump" && anim_state != "DoubleJump":
		sliding = true
		anim_state = "Slide"
		if !$Sprite.flip_h:
			velocity = Vector2(standardMaxVelocity-100,0)
		else:
			velocity = Vector2(-standardMaxVelocity+100,0)

func set_movement_speed_bonus(duration, bonus):
	currMaxVelocity = standardMaxVelocity + bonus
	movement_speed_bonus_timer.set_wait_time(duration)
	movement_speed_bonus_timer.start()

func set_slowed(value):
	is_slowed = value

func on_movement_speed_bonus_end():
	currMaxVelocity = standardMaxVelocity
	emit_signal("coffee_ended")

func on_knockback_end():
	is_knocked = false
	recover_timer.start()

func on_recovery_end():
	self.set_collision_layer_bit(1, 1)