extends Node2D

const bonus_drop_per_sec = 300
var current_bonus = 3000
var bonus_drop_enabled = true
var is_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if is_active && bonus_drop_enabled:
		bleed_bonus(delta)

func bleed_bonus(delta):
	current_bonus -= bonus_drop_per_sec * delta
	if current_bonus <= 0:
		current_bonus = 0
		toggle_enable()

func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		body.get_parent().add_score(current_bonus)
		queue_free()

func toggle_enable():
	bonus_drop_enabled = !bonus_drop_enabled

func get_bonus_drop_enabled():
	return bonus_drop_enabled