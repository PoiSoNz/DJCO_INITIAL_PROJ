extends Node2D

const speed = 350
const damage = 20

var lifetime = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x -= speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func _on_Area2D_body_entered(body):
	if body.get_parent().name == "Player":
		body.get_parent().inflict_damage(damage)
		queue_free()
