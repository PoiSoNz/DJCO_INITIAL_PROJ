extends Camera2D

var cameraFixedY

var furthestPlayerX
var backingLimitX
var maxBackingDistance

const halfBackgroundHeight = 600

# Called when the node enters the scene tree for the first time.
func _ready():
	# We want the camera to always be following horizontaly,
	# without that small margin when the player moves on the center of the screen
	drag_margin_h_enabled = false
	
	var screenWidth = get_viewport_rect().size.x
	var screenHeigth = get_viewport_rect().size.y
	
	cameraFixedY = screenHeigth/2 - halfBackgroundHeight
	
	var playerShapeSpareSpace = get_parent().get_node("CollisionShape2D").get_shape().get_extents().x
	maxBackingDistance = screenWidth/2 - playerShapeSpareSpace
	
	furthestPlayerX = get_parent().position.x
	
	backingLimitX = furthestPlayerX - maxBackingDistance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var screenWidth = get_viewport_rect().size.x
	var playerX = get_parent().position.x
	var playerY = get_parent().position.y
	
	position.y = cameraFixedY - playerY
	# Detect if the player is going back
	if playerX <= furthestPlayerX:
		position.x = furthestPlayerX - playerX
		backingLimitX = furthestPlayerX - maxBackingDistance
	else:
		furthestPlayerX = playerX