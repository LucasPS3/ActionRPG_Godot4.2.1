extends Camera2D

# Referências aos nós de TopLeft e BottomRight
@onready var topLeft = $Node/TopLeft
@onready var bottomRight = $Node/BottomRight
@onready var player = $"../Player"

# Chamado quando o nó entra na árvore da cena pela primeira vez.
func _ready():
	# Defina os limites da câmera
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
# Chamado a cada quadro.
func _physics_process(delta: float):
	# Obtenha a posição do jogador
	var player_position = player.global_transform.origin
	# Verifique se o jogador está fora dos limites da câmera
	if player_position.x < limit_left or  player_position.x > limit_right or  player_position.y < limit_top or  player_position.y > limit_bottom:
		change_scene("res://Action RPG Resources/UI/menu_inicial.tscn")
		   
# Função para mudar a cena
func change_scene(scene_path: String):
	# Obtenha uma referência à árvore da cena
	var scene_tree = get_tree()
	# Carregue a nova cena
	var new_scene = load(scene_path)
	# Mude para a nova cena
	get_tree().change_scene_to_file(scene_path)
