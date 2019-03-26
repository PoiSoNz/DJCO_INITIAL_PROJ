extends Node2D

func _ready():
	$GoldCoin.set_type(0)
	$GoldCoin2.set_type(0)
	$GoldCoin3.set_type(0)
	$GoldCoin4.set_type(0)
	$SilverCoin.set_type(1)
	$BronzeCoin.set_type(2)
	$BronzeCoin2.set_type(2)
	$VendingMachine.set_tier(3)
	$VendingMachine2.set_tier(2)
	$VendingMachine3.set_tier(2)