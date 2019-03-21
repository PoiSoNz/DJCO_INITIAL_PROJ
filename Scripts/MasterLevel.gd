extends Node2D

const levelSize = 3840

onready var level1 = preload("res://Scenes/Test1.tscn")
onready var level2 = preload("res://Scenes/Test2.tscn")
onready var level3 = preload("res://Scenes/Test3.tscn")
onready var level4 = preload("res://Scenes/Test4.tscn")
onready var level5 = preload("res://Scenes/Test5.tscn")
onready var first_level = preload("res://Scenes/FirstLevel.tscn")

onready var existingLevels = [level1, level2, level3, level4, level5]
onready var levelsToInstance = []
onready var currentIndex = 0
const numLevels = 20

onready var checkpoint = preload("res://Scenes/Checkpoint.tscn")
var levelArray = []
var checkPointArray = []
var checkPointRefArray = []
var currentLevel = 0
var deleteFlag = false

# Called when the node enters the scene tree for the first time.
func _ready():
	chooseLevels()
	instanceLevel()
	
func chooseLevels():
		randomize()
		var previousLevel = -1
		
	
		var index = previousLevel
	
		for i in range(numLevels-1):
			
			while(index == previousLevel):
				index = randi() % existingLevels.size()
				
			levelsToInstance.append(existingLevels[index])
			previousLevel = index
			
			print(index)
	
func _process(delta):
	check_cps()
	check_fail()
	$CheckPoints.receive_player_pos($Player/KinematicBody2D.global_position.y, delta)

func instanceLevel():
	var l = levelsToInstance[currentIndex].instance()
	currentIndex += 1
	print(currentLevel)
	l.position.x = levelSize * currentLevel + levelSize
	$Levels.add_child(l)
	levelArray.append(l)
	currentLevel += 1
	var cp = checkpoint.instance()
	cp.position.x = levelSize * currentLevel + levelSize
	$CheckPoints.add_child(cp)
	checkPointArray.append(cp)
	checkPointRefArray.append(weakref(cp))
	
func check_cps():
	if checkPointRefArray.size() > 0:
		if !checkPointRefArray[0].get_ref():
			checkPointArray.pop_front()
			checkPointRefArray.pop_front()
			if deleteFlag:
				levelArray[0].queue_free()
				levelArray.pop_front()
			deleteFlag = true
		
		if !checkPointArray[0].is_active:
			checkPointArray[0].is_active = true
			instanceLevel()
			
func check_fail():
	if $Player/KinematicBody2D/Health.health == 0:
		get_tree().change_scene("res://Scenes/PlayAgain.tscn")