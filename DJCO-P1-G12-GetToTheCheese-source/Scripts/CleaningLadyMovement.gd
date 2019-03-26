extends Node2D

var velocity = Vector2(125, 0)
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
func _physics_process(delta):
	frameDelta = delta;
	
	#check_collision()
	
	if is_idle:
		set_cleaning_lady_animation("Idle")
		return
	else:
		set_cleaning_lady_animation("Walking")
	
	if repositioning:
		check_repositioning_complete()
	
	position.x += apply_delta(velocity.x * movementDirection)

func apply_delta(value):
	return value * frameDelta

func set_cleaning_lady_animation(newAnimation):
	if $Sprite/AnimationPlayer.current_animation != newAnimation:
		$Sprite/AnimationPlayer.play(newAnimation)

#func check_collision():


func get_trolley_destination(collisionNormal):
	if collisionNormal == leftSideCollision:
		repositioningDestination = platformMaxRangeX + repositioningDistance
		print("max ", platformMaxRangeX)
		return platformMaxRangeX
	elif collisionNormal == rightSideCollision:
		repositioningDestination = platformMinRangeX - repositioningDistance
		print("min ", platformMinRangeX)
		return platformMinRangeX

func get_range_info(platform):
	#print("BOAS")
	var platformScaleX = platform.get_parent().scale.x
	var platformOriginalHalfLength = platform.get_node("ColorRect").rect_size.x/2
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

func start_idle_period():
	if !is_idle:
		is_idle = true
		idle_timer.start()

func on_idle_period_end():
	is_idle = false

func _on_Area2D_body_entered(body):
	# Cleaning lady stops for a while after it collides with any object, being it a player or a cleaning trolley.
		var colliderParent = body.get_parent()
		var collider = body
		# Stop lady movement and push trolley when it collides against it
		if collider.name == "CleaningTrolley" && !repositioning && !is_idle:
			start_idle_period()
			collider.push(get_trolley_destination(Vector2(-movementDirection, 0)))
			repositioning = true
		# Just stop lady movement when it collides against the player
		elif colliderParent.name == "Player" && !body.is_knocked && !body.recovering:
			colliderParent.inflict_damage(damage)
			start_idle_period()
		# Obtain trolley possible movement range
		elif check_boundaries && colliderParent.name.begins_with("Platform"):
			print("ENTROU")
			get_range_info(collider)
			check_boundaries = false
	
	
	
#	var collider = body.get_parent()

			
