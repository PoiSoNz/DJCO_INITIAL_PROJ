extends Node2D

const levelSize = 2500

onready var level = preload("res://Scenes/Test2.tscn")
onready var checkpoint = preload("res://Scenes/Checkpoint.tscn")
var levelArray = []
var currentLevel = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	instanceLevelAt()
	instanceLevelAt()
	instanceLevelAt()
	
func _process(delta):
	check_cps()

func instanceLevelAt():
	var l = level.instance()
	l.position.x = levelSize * currentLevel
	$Levels.add_child(l)
	levelArray.append(l)
	currentLevel += 1
	var cp = checkpoint.instance()
	cp.position.x = levelSize * currentLevel
	$CheckPoints.add_child(cp)
	
func check_cps():
	if $CheckPoints.get_child_count() != 0:
		if !$CheckPoints.get_child(0).bonus_bleed_enabled:
			$CheckPoints.get_child(0).toggle_enable()