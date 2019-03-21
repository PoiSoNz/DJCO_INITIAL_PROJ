extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$GoldCoin.set_type(0)
	$GoldCoin2.set_type(0)
	$SilverCoin.set_type(1)
	$SilverCoin2.set_type(1)
	$BronzeCoin.set_type(2)
	$BronzeCoin2.set_type(2)
	$VendingMachine.set_tier(3)
	$VendingMachine2.set_tier(3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
