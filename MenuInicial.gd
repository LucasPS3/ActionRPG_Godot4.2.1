extends Control



func _ready():
	 # Conectar sinais
	$ButtonStart.connect("pressed", Callable(self, "_on_start_pressed"))
	$ButtonExit.connect("pressed", Callable(self, "_on_exit_pressed"))

func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://World.tscn")
	



func _on_button_exit_pressed():
	get_tree().quit()
