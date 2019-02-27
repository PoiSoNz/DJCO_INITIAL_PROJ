extends Node2D

# Declare member variables here. Examples:
var playerInRange = false
var game
var tier = 3

#func _init(gameManager, machineFloor):
#	game = gameManager
#	tier = machineFloor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerInRange:
		if tier == 2 && Input.is_action_just_pressed("buy_croissant"):
			game.buy_croissant()
		if tier == 2 && Input.is_action_just_pressed("buy_water"):
			game.buy_water()
		if tier == 3 && Input.is_action_just_pressed("buy_coffee"):
			game.buy_coffee()
		if tier == 3 && Input.is_action_just_pressed("buy_special_merend"):
			game.buy_special_merend()

func setGame(gameManager):
	game = gameManager

func setTier(machineFloor):
	tier = machineFloor

func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		print("é jogador")
		playerInRange = true
		$Control.visible = true


func _on_Area2D_body_exited(body):
	print("ole")
	playerInRange = false
	$Control.visible = false
