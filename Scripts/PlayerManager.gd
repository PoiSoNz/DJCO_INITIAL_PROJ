extends Node

var ECTS = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func buy_attempt(item):
	match item:
		"croissant":
			print("comprou croissant")
		"water":
			print("comprou water")
		"coffee":
			print("comprou coffee")
		"special_merend":
			print("comprou special_merend")