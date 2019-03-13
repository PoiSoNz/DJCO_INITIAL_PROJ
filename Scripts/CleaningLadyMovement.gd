extends KinematicBody2D

var velocity = Vector2()
var frameDelta;
var platformMaxRangeX = null
var platformMinRangeX = null

var repositioning = false

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const runAcceleration = Vector2(750, 0)
const runDeacceleration = Vector2(1500, 0)
const maxVelocity = 700
const idle_duration = 2
const leftSideCollision = Vector2(-1, 0)
const rightSideCollision = Vector2(1, 0)
const platformSpareSpace = 400

var is_idle = false
var idle_timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	idle_timer = Timer.new()
	idle_timer.set_one_shot(true)
	idle_timer.set_wait_time(idle_duration)
	idle_timer.connect("timeout", self, "on_idle_period_end")
	add_child(idle_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	apply_gravity()
	
	if is_idle:
		return
	
	cleaning_lady_movement(delta)
	
	move_and_slide(velocity, floorNormal)
	
	check_collision()

func apply_delta(value):
	return value * frameDelta

func check_collision():
	# Cleaning lady stops for a while after it collides with any object, being it a player or a cleaning trolley.
	# That's why it moves with "move_and_collide"
	var collision_info = move_and_collide(Vector2(0, 0))
	if collision_info:
		var colliderParent = collision_info.collider.get_parent()
		var collider = collision_info.collider
		# Obtain trolley possible movement range
		if !platformMaxRangeX && colliderParent.name == "Platform":
			get_range_info(collider)
		# Stop lady movement and push trolley when it collides against it
		elif !repositioning && collider.name == "CleaningTrolley":
			print("COLIDIU", collider.name)
			start_idle_period()
			collider.push(get_trolley_destination(collision_info.normal))
			repositioning = true
		# Just stop lady movement when it collides against the player
		elif colliderParent.name == "Player":
			start_idle_period()
		#Colisoes efeitos:
		# - jogador: nada,
		# - carrinho: flag que indica o lado do carrinho que deve ser atingido

func get_trolley_destination(collisionNormal):
	if collisionNormal == leftSideCollision:
		return platformMaxRangeX
	elif collisionNormal == rightSideCollision:
		return platformMinRangeX

func get_range_info(platform):
	var platformScaleX = platform.get_parent().scale.x
	var platformOriginalHalfLength = platform.get_node("CollisionPolygon2D").get_shape().get_extents().x
	var platformHalfLength = platformOriginalHalfLength * platformScaleX
	
	var platformPositionX = platform.get_parent().position.x
	
	platformMaxRangeX = platformPositionX + (platformHalfLength - platformSpareSpace)
	platformMinRangeX = platformPositionX - (platformHalfLength - platformSpareSpace)

func check_wall():
	if is_on_wall():
		velocity.x = 0

func apply_gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += apply_delta(gravity)

func cleaning_lady_movement(delta):
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

func start_idle_period():
	is_idle = true
	
	idle_timer.start()

func on_idle_period_end():
	is_idle = false