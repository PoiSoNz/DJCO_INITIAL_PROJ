extends Node

var green_hp = Color("87da37")
var red_hp = Color("cd0404")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_health_changed(health):
	$ProgressBar.value = health
	if health > 30:
		$ProgressBar.get("custom_styles/fg").bg_color = green_hp
	else:
	 	$ProgressBar.get("custom_styles/fg").bg_color = red_hp