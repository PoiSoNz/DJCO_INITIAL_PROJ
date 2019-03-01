extends Node

var frameDelta
var health = 100

signal health_changed(health)
signal slowed()
signal normal_speed()

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("health_changed", health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	health_bleed(2)
	emit_signal("health_changed", health)
	
	if health <= 30:
		emit_signal("slowed")
	else:
		emit_signal("normal_speed")

func health_increment(hp_increment):
	var newHP = health + hp_increment
	health = newHP if(newHP <= 100) else 100
	
func reduce_health(damage):
	var newHP = health - damage
	if newHP < 0 :
		newHP = 0
	health = newHP

func health_bleed(value):
	reduce_health(apply_delta(value))

func apply_delta(value):
	return value * frameDelta