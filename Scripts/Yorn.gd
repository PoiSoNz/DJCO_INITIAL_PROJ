extends Node2D

const reload = 2
const lowCard = Vector2(0, 70)
const highCard = Vector2(0, 10)

onready var simCard = preload("res://Scenes/SIMCard.tscn")

var shootTimer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shootTimer -= delta
	if shootTimer <= 0:
		var card = simCard.instance()
		var randomHeight = randi() % 2
		if randomHeight == 0:
			card.position += lowCard
		else :
			card.position += highCard
		$SimCards.add_child(card)
		shootTimer += reload
