extends Node

var ECTS = 10000

var score = 0

# Vending machine item prices
const croissant_price = 40
const water_price = 50
const coffee_price = 70
const special_merend_price = 150

# Vending machine item stats
const croissant_hp_bonus = 40
const water_bonus_duration = 30
const coffee_speed_bonus = 100
const coffee_bonus_duration = 10
const special_merend_duration = 15

const no_immunity = 0
const one_time_immunity = 1
const persistent_immunity = 2

var immunity_type = no_immunity
var immunity_timer = null

#HealthbBar
signal reenable_bleeding()
signal immunity(immunity_type)

#Scores
signal score(value)

#PowerUps
signal bought_croissant()
signal bought_water()
signal bought_coffee()
signal bought_special()

signal water_ended()
signal special_ended()

#signal shield(immunity_type, immunity_timer)
#signal coffee(movement_speed_bonus_timer)

# Called when the node enters the scene tree for the first time.
func _ready():
	immunity_timer = Timer.new()
	immunity_timer.set_one_shot(true)
	immunity_timer.connect("timeout", self, "on_immunity_end")
	add_child(immunity_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	emit_signal("score", score)
	#emit_signal("shield", immunity_type, immunity_timer)
	#emit_signal("coffee", $KinematicBody2D.movement_speed_bonus_timer)

func buy_attempt(item):
	match item:
		"croissant":
			if ECTS >= croissant_price:
				$KinematicBody2D/Health.health_increment(croissant_hp_bonus)
				ECTS -= croissant_price
				emit_signal("bought_croissant")
				$KinematicBody2D/ParticlesCroissant.emitting = true
				print("croissant placeholder")
		"water":
			if ECTS >= water_price:
				ECTS -= water_price
				set_immunity(water_bonus_duration, one_time_immunity)
				emit_signal("bought_water")
				print("water placeholder")
		"coffee":
			if ECTS >= coffee_price:
				$KinematicBody2D.set_movement_speed_bonus(coffee_bonus_duration, coffee_speed_bonus)
				ECTS -= coffee_price
				emit_signal("bought_coffee")
				print("coffee placeholder")
		"special_merend":
			if ECTS >= special_merend_price:
				ECTS -= special_merend_price
				# Health bonus
				$KinematicBody2D/Health.health_increment(croissant_hp_bonus * 0.7)
				# Persistent shield
				set_immunity(special_merend_duration, persistent_immunity)
				# Movement speed bonus
				$KinematicBody2D.set_movement_speed_bonus(special_merend_duration, coffee_speed_bonus * 0.7)
				emit_signal("bought_special")
				print("special merend placeholder")

func add_currency(value):
	ECTS += value

func add_score(value):
	score += value

func inflict_damage(damage):
	$KinematicBody2D.apply_knock_back()
		
	if immunity_type == one_time_immunity:
		immunity_type = no_immunity
		immunity_timer.stop()
		emit_signal("immunity", immunity_type)
		emit_signal("water_ended")
	elif immunity_type == no_immunity:
		$KinematicBody2D/Health.reduce_health(damage)

func set_immunity(duration, immunity):
	immunity_type = immunity
	immunity_timer.set_wait_time(duration)
	emit_signal("immunity", immunity_type)
	immunity_timer.start()

func on_immunity_end():
	var immunity_just_ended = immunity_type
	immunity_type = no_immunity

	if immunity_just_ended == one_time_immunity:
		emit_signal("water_ended")
	elif immunity_just_ended == persistent_immunity:
		emit_signal("special_ended")
	emit_signal("immunity", immunity_type)

func _on_HealthBar_reenable_bleeding():
	emit_signal("reenable_bleeding")
