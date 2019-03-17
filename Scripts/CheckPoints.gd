extends Node2D

var checkpoints = []

const layer1max = 780
const layer2min = 730
const layer2max = 510
const layer3min = 460

const bar_refresh_rate = 1 #in seconds

onready var currentLayer = 1
onready var multiplier = 1
onready var bar = 0

onready var bar_cooldown = bar_refresh_rate

signal send_bonus(value)
signal send_bonus_info(bar_value, multiplier_value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkpoints = get_children()
	var current_check_point = checkpoints.front()
	
	change_multiplier()
	
	print("multiplier: ", multiplier, "bar: ", bar)
	
	emit_signal("send_bonus", current_check_point.current_bonus)
	emit_signal("send_bonus_info", bar, multiplier)

func change_multiplier():
	if bar >= 0 && bar <= 99:
		multiplier = 1
	elif bar >= 100 && bar <= 199:
		multiplier = 2
	elif bar >= 200 && bar <= 300:
		multiplier = 3
	else:
		print("invalid bar value")

func receive_player_pos(playerY, delta):
	if playerY >= layer1max:
		currentLayer = 1
	elif playerY <= layer2min && playerY >= layer2max:
		currentLayer = 2
	elif playerY < layer3min:
		currentLayer = 3
	
	bar_cooldown -= delta
	if bar_cooldown <= 0:
		update_bar()
		bar_cooldown = bar_refresh_rate
	
func update_bar():
	match multiplier:
		1:
			multiplier1_update_bar()
		2:
			multiplier2_update_bar()
		3:
			multiplier3_update_bar()
		_:
			print("invalid multiplier")
			
func multiplier1_update_bar():
	match currentLayer:
		1:
			add_bar(-10)
		2:
			add_bar(10)
		3:
			add_bar(20)
		_:
			print("invalid layer")
	
func multiplier2_update_bar():
	match currentLayer:
		1:
			add_bar(-15)
		2:
			add_bar(5)
		3:
			add_bar(15)
		_:
			print("invalid layer")
	
func multiplier3_update_bar():
	match currentLayer:
		1:
			add_bar(-20)
		2:
			add_bar(0)
		3:
			add_bar(10)
		_:
			print("invalid layer")
	
func add_bar(value):
	var result = bar + value
	if result >= 300:
		bar = 300
	elif result <= 0:
		bar = 0
	else:
		bar = result
	