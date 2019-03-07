extends Node

var frameDelta
var health = 100
var bleed = true

signal health_changed(oldHealth, newHealth)
signal bled(oldHealth, newHealth)
signal slowed()

# Called when the node enters the scene tree for the first time.
#func _ready():
#	emit_signal("health_changed", health, health)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frameDelta = delta;
	
	if bleed:
		health_bleed(2)
	
	if health <= 30:
		emit_signal("slowed")
	else:
		emit_signal("normal_speed")

func health_increment(gain):
	var oldHP = health
	
	var newHP = health + gain
	if newHP > 100:
		newHP = 100
	health = newHP
	
	bleed = false
	emit_signal("health_changed", oldHP, health)
	
func reduce_health(damage):
	var oldHP = health
	
	var newHP = health - damage
	if newHP < 0 :
		newHP = 0
	health = newHP
	
	bleed = false
	emit_signal("health_changed", oldHP, health)

func health_bleed(value):
	var oldHP = health
	
	var newHP = health - apply_delta(value)
	if newHP < 0 :
		newHP = 0
	health = newHP
	
	emit_signal("bled", oldHP, health)

func apply_delta(value):
	return value * frameDelta

func _on_Player_reenable_bleeding():
	bleed = true
