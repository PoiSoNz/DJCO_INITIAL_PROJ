extends Control

var progress_factor = 30
#calculated by:
	#progress_factor = MAX_current_bonus / 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_HUD_score(value):
	$CurrentBonus/Value.text = str(floor(value))
	$CurrentBonus/ProgressBar.value = value/progress_factor

 