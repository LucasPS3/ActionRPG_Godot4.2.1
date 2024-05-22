extends Node2D

const GrassEffect = preload("res://Action RPG Resources/Effects/grass_effect.tscn")

func _create_grass_effect():
	var grassEffect = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_hurtbox_area_entered(_area):
	_create_grass_effect()
	queue_free()
