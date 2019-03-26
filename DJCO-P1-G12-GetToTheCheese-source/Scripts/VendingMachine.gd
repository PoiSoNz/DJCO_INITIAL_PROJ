extends Node2D

onready var grayscale = preload("res://Materials/SpriteGrayScale.tres")

const font_grayscale = Color("6b6b6b")

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
	if tier == 2:
		$Control/Coffee/Sprite.material = grayscale
		$Control/Coffee/SpriteCoinIcon.material = grayscale
		$Control/Coffee/LabelE.set("custom_colors/font_color", font_grayscale)
		$Control/Coffee/LabelPrice.set("custom_colors/font_color", font_grayscale)
		$Control/SpecialMerend/Sprite.material = grayscale
		$Control/SpecialMerend/SpriteCoinIcon.material = grayscale
		$Control/SpecialMerend/LabelR.set("custom_colors/font_color", font_grayscale)
		$Control/SpecialMerend/LabelPrice.set("custom_colors/font_color", font_grayscale)
	else:
		$Control/Croissant/Sprite.material = grayscale
		$Control/Croissant/SpriteCoinIcon.material = grayscale
		$Control/Croissant/LabelQ.set("custom_colors/font_color", font_grayscale)
		$Control/Croissant/LabelPrice.set("custom_colors/font_color", font_grayscale)
		$Control/Water/Sprite.material = grayscale
		$Control/Water/SpriteCoinIcon.material = grayscale
		$Control/Water/LabelW.set("custom_colors/font_color", font_grayscale)
		$Control/Water/LabelPrice.set("custom_colors/font_color", font_grayscale)

func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		playerNode = body.get_parent()
		playerInRange = true
		$Control.visible = true

func _on_Area2D_body_exited(body):
	if body.get_parent().name == "Player":
		playerInRange = false
		$Control.visible = false