extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("pressed", Callable(self, "_on_exit_pressed"))

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Action RPG Resources/UI/menu_inicial.tscn")

