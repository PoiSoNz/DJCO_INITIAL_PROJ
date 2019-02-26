extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func isInside():
	pass

func _on_Area2D_body_entered(body):
	print("ola")
	$Control.visible = true


func _on_Area2D_body_exited(body):
	print("ole")
	$Control.visible = false
