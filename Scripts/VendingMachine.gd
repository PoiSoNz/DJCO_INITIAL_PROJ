extends Node2D

var playerInRange = false
var playerNode
var tier = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playerInRange:
		if tier == 2 && Input.is_action_just_pressed("buy_croissant"):
			playerNode.buy_attempt("croissant")
		if tier == 2 && Input.is_action_just_pressed("buy_water"):
			playerNode.buy_attempt("water")
		if tier == 3 && Input.is_action_just_pressed("buy_coffee"):
			playerNode.buy_attempt("coffee")
		if tier == 3 && Input.is_action_just_pressed("buy_special_merend"):
			playerNode.buy_attempt("special_merend")

func set_tier(machineFloor):
	tier = machineFloor

func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		playerNode = body.get_parent()
		playerInRange = true
		$Control.visible = true

func _on_Area2D_body_exited(body):
	if body.get_parent().name == "Player":
		playerInRange = false
		$Control.visible = false