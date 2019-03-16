extends KinematicBody2D

var velocity = Vector2(200, 0)
var movementDirection = 1
var frameDelta;
var platformMaxRangeX = 0
var platformMinRangeX = 0

var repositioning = false
var repositioningDestination

const floorNormal = Vector2(0, -1)
const gravity = Vector2(0, 1550)
const idle_duration = 1
const leftSideCollision = Vector2(-1, 0)
const rightSideCollision = Vector2(1, 0)
const platformSpareSpace = 300
const repositioningDistance = 200
const damage = 40

var is_idle = false
var idle_timer = null
var check_boundaries = true

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
	
	check_collision()
	
	if is_idle:
		set_cleaning_lady_animation("Idle")
		return
	else:
		set_cleaning_lady_animation("Walking")
	
	if repositioning:
		check_repositioning_complete()
	
	move_and_slide(Vector2(velocity.x * movementDirection, velocity.y), floorNormal)

func apply_delta(value):
	return value * frameDelta

func set_cleaning_lady_animation(newAnimation):
	if $Sprite/AnimationPlayer.current_animation != newAnimation:
		$Sprite/AnimationPlayer.play(newAnimation)

func check_collision():
	# Cleaning lady stops for a while after it collides with any object, being it a player or a cleaning trolley.
	var collision_info = move_and_collide(Vector2(0, 0))
	if collision_info:
		var colliderParent = collision_info.collider.get_parent()
		var collider = collision_info.collider
		# Stop lady movement and push trolley when it collides against it
		if collider.name == "CleaningTrolley":
			start_idle_period()
			collider.push(get_trolley_destination(collision_info.normal))
			repositioning = true
		# Just stop lady movement when it collides against the player
		elif colliderParent.name == "Player":
			colliderParent.inflict_damage(damage, collision_info.normal)
			start_idle_period()
		# Obtain trolley possible movement range
		elif check_boundaries && colliderParent.name.begins_with("Platform"):
			print("ENTROU")
			get_range_info(collider)
			check_boundaries = false

func get_trolley_destination(collisionNormal):
	if collisionNormal == leftSideCollision:
		movementDirection = 1
		repositioningDestination = platformMaxRangeX + repositioningDistance
		print("trolley dest ", platformMaxRangeX)
		return platformMaxRangeX
	elif collisionNormal == rightSideCollision:
		movementDirection = -1
		repositioningDestination = platformMinRangeX - repositioningDistance
		return platformMinRangeX

func get_range_info(platform):
	#print("BOAS")
	var platformScaleX = platform.get_parent().scale.x
	var platformOriginalHalfLength = platform.get_node("CollisionShape2D").get_shape().get_extents().x
	var platformHalfLength = platformOriginalHalfLength * platformScaleX
	
	var platformPositionX = platform.get_parent().global_position.x
	
	platformMaxRangeX = platformPositionX + (platformHalfLength - platformSpareSpace)
	platformMinRangeX = platformPositionX - (platformHalfLength - platformSpareSpace)
	#print("BOAS ", platformMaxRangeX, "BOAS ",  platformMinRangeX)

func check_repositioning_complete():
	if movementDirection == 1 && self.global_position.x >= repositioningDestination:
		make_trolley_hittable()
		movementDirection = -1
		$Sprite.flip_h = true
		repositioning = false
	elif movementDirection == -1 && self.global_position.x <= repositioningDestination:
		make_trolley_hittable()
		movementDirection = 1
		$Sprite.flip_h = false
		repositioning = false

func make_trolley_hittable():
	get_parent().get_node("CleaningTrolley").set_collision_layer_bit(2, 1)

func check_wall():
	if is_on_wall():
		velocity.x = 0

func apply_gravity():
	if is_on_floor():
		velocity.y = 0
	else:
		velocity += apply_delta(gravity)

func start_idle_period():
	is_idle = true
	idle_timer.start()

func on_idle_period_end():
	is_idle = false