extends Node

var ECTS = 0

const croissant_price = 40
const water_price = 50
const coffee_price = 70
const special_merend_price = 150

const croissant_hp_bonus = 40
const coffee_speed_bonus = 40 #SPEED
const special_merend_bonus = 40 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func buy_attempt(item):
	match item:
		"croissant":
			if ECTS >= croissant_price:
		"water":
			if ECTS >= water_price:
		"coffee":
			if ECTS >= coffee_price:
		"special_merend":
			if ECTS >= special_merend_price: