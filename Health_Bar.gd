extends Control


onready var health_bar = $Bar

func _on_health_updated(health):
	health_bar.value = health
