extends Node2D

const bonus_bleed_per_sec = 300
var current_bonus = 3000
var bonus_bleed_enabled = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if bonus_bleed_enabled:
		bleed_bonus(delta)

func bleed_bonus(delta):
	current_bonus -= bonus_bleed_per_sec * delta
	if current_bonus <= 0:
		current_bonus = 0
		bonus_bleed_enabled = false

func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		body.get_parent().add_score(current_bonus)
		queue_free()
