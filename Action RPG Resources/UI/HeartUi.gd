extends Control

#forma de declarar uma variavel setget na versão 4.2

@onready var HeartUIFull = $HeartUIFull
@onready var HeartUIEmpty = $HeartUIEmpty

var hearts: int = 4:
	set(value):
		hearts = clamp(value, 0, max_hearts)
		if HeartUIFull != null:
			HeartUIFull.size.x = hearts * 15
		
	get:
		return hearts

var max_hearts: int = 4:
	set(value):
		max_hearts = max(value, 1)
		self.hearts = min(hearts,max_hearts)
		if HeartUIEmpty != null:
			HeartUIEmpty.size.x = max_hearts * 15
			
	get:
		return max_hearts

func _set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if HeartUIFull != null:
		HeartUIFull.size.x = hearts * 15
		
func _set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts,max_hearts)
	if HeartUIEmpty != null:
		HeartUIEmpty.size.x = max_hearts * 15
	
	
func  _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", Callable(self, "_set_hearts"))
	PlayerStats.connect("max_health_changed", Callable(self, "_set_max_hearts"))
