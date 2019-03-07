extends Node

signal health_changed(oldHealth, newHealth)
signal bled(oldHealth, newHealth)

func _on_Health_health_changed(oldHealth, newHealth):
	emit_signal("health_changed", oldHealth, newHealth)

func _on_Health_bled(oldHealth, newHealth):
	emit_signal("bled", oldHealth, newHealth)
