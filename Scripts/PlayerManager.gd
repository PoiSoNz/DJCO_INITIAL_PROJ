extends Node

var ECTS = 100000

const croissant_price = 40
const water_price = 50
const coffee_price = 70
const special_merend_price = 150

const croissant_hp_bonus = 40
const water_bonus_duration = 40
const coffee_speed_bonus = 100
const coffee_bonus_duration = 10
const special_merend_duration = 5

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
				$KinematicBody2D/Health.health_increment(croissant_hp_bonus)
				ECTS -= croissant_price
				print("croissant placeholder")
		"water":
			if ECTS >= water_price:
				ECTS -= water_price
				print("water placeholder")
		"coffee":
			if ECTS >= coffee_price:
				$KinematicBody2D.set_movement_speed_bonus(coffee_bonus_duration, coffee_speed_bonus)
				ECTS -= coffee_price
				print("coffee placeholder")
		"special_merend":
			if ECTS >= special_merend_price:
				ECTS -= special_merend_price
				$KinematicBody2D.set_movement_speed_bonus(special_merend_duration, coffee_speed_bonus * 0.7)
				#TODO: APPLY OTHER BUFFS
				print("special merend placeholder")