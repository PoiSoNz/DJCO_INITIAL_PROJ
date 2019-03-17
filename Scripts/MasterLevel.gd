extends Node2D

const levelSize = 3500

onready var level = preload("res://Scenes/Test3.tscn")
onready var checkpoint = preload("res://Scenes/Checkpoint.tscn")
var levelArray = []
var checkPointArray = []
var checkPointRefArray = []
var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	instanceLevel()
	
func _process(delta):
	check_cps()
	check_fail()
	$CheckPoints.receive_player_pos($Player/KinematicBody2D.global_position.y, delta)

func instanceLevel():
	var l = level.instance()
	l.position.x = levelSize * currentLevel
	$Levels.add_child(l)
	levelArray.append(l)
	currentLevel += 1
	var cp = checkpoint.instance()
	cp.position.x = levelSize * currentLevel
	$CheckPoints.add_child(cp)
	checkPointArray.append(cp)
	checkPointRefArray.append(weakref(cp))
	
func check_cps():
	if checkPointRefArray.size() != 0:
		if !checkPointRefArray[0].get_ref():
			checkPointArray.pop_front()
			checkPointRefArray.pop_front()
			levelArray[0].queue_free()
			levelArray.pop_front()
		
		if !checkPointArray[0].is_active:
			checkPointArray[0].is_active = true
			instanceLevel()
			
func check_fail():
	if $Player/KinematicBody2D/Health.health == 0:
		get_tree().change_scene("res://Scenes/PlayAgain.tscn")