extends Node2D

const levelSize = 2500

onready var level = preload("res://Scenes/Test2.tscn")
var levelArray = []
var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	instanceLevelAt(levelSize * currentLevel)
	instanceLevelAt(levelSize * currentLevel)
	instanceLevelAt(levelSize * currentLevel)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func instanceLevelAt(x):
	var l = level.instance()
	l.position.x = x
	$Levels.add_child(l)
	levelArray.append(l)
	currentLevel += 1
