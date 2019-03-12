extends Node

signal health_changed(oldHealth, newHealth)
signal bled(oldHealth, newHealth)
signal immunity(immunity_type)
signal score(value)

func _on_Health_health_changed(oldHealth, newHealth):
	emit_signal("health_changed", oldHealth, newHealth)

func _on_Health_bled(oldHealth, newHealth):
	emit_signal("bled", oldHealth, newHealth)

func _on_Player_immunity(immunity_type):
	emit_signal("immunity", immunity_type)

func _on_CheckPoints_send_score(value):
	emit_signal("score", value)
