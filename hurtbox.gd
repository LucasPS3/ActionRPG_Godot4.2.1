extends Area2D

#@export var show_hit:bool = true

const HitEffect = preload("res://Action RPG Resources/Effects/hit_effect.tscn")

@onready var timer = $Timer

signal invincibility_started
signal invincibility_ended

var invincible  = false:
	get:
		return invincible
	set(value):
		invincible = value
		if invincible == true:
			emit_signal("invincibility_started")
		else :
			emit_signal("invincibility_ended")

func star_invencibility(duration):
	self.invincible = true
	timer.start(duration)

func _create_hit_effect():
	var effect = HitEffect.instantiate()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position= global_position 

func _on_timer_timeout():
	self.invincible = false

func _on_invincibility_started():
	set_deferred("monitoring", false)
	
func _on_invincibility_ended():
	monitoring = true



