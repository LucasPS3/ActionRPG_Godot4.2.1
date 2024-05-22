extends CharacterBody2D

const PlayerHurtSound = preload("res://Action RPG Resources/Player/player_hurt_sound.tscn")

@export var  ACCELERATION = 500
@export var MAX_SPEED = 80
@export var  ROLL_SPEED = 120
@export var ATTACK_SPEED=400
@export var FRICTION = 500
@export var knockback_strength = 500
@export var stun_timer = 0.2 # Tempo de duração do estado STUN em segundos
@export var full_health = 4

var stun_timer_elapsed = 0

var player: CharacterBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
	STUN
}
var state = MOVE
var stats = PlayerStats

var roll_vector = Vector2.DOWN
var projectile_vector = Vector2.RIGHT
#var attack_vector = Vector2.DOWN

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/SwordHitbox
@onready var hurtbox = $Hurtbox
@onready var blinkAnimation = $BlinkAnimationPlayer
@onready var hurtboxCollisionShape = $Hurtbox/CollisionShape2D

func _ready():
	stats.health = full_health
	stats.no_health.connect(queue_free)
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
	match state:
		ROLL:
			roll_state(delta)
	match state:
		ATTACK:
			attack_state(delta)
	match state:
		STUN:
			stun_state(delta)

func move_state(delta):
	if hurtboxCollisionShape.disabled == true:
		hurtboxCollisionShape.disabled = false
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Rigth") -Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") -Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		projectile_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		#attack_vector = input_vector
		animationTree.set("parameters/Idle/blend_position",input_vector)
		animationTree.set("parameters/Run/blend_position",input_vector)
		animationTree.set("parameters/Attack/blend_position",input_vector)
		animationTree.set("parameters/Roll/blend_position",input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED,ACCELERATION * delta)
		# input_vector * max_speed = O que queremos obter gradualmente 
		#acceleration * delta = A velocidade em que iremos obter 
	else :
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO,FRICTION * delta)
	
	move()
	
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	#if Input.is_action_pressed("shoot"):
		#state = SHOOTING
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
	
func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	hurtboxCollisionShape.disabled = true
	
	move()

func stun_state(delta):
	animationState.travel("Idle")
	stun_timer_elapsed += delta
	if stun_timer_elapsed >= stun_timer:
		state = MOVE
	

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func move():
	move_and_slide()


func _on_hurtbox_area_entered(area):
	"""
	Codigo de knocback de player
	# Calcula o vetor de knockback como a direção do hitbox do inimigo para a hurtbox do jogador
	#var direction_to_player = (area.global_position - global_position).normalized()
	# Aplica o vetor de knockback à posição do jogador
	#velocity -= direction_to_player * knockback_strength
	"""
	"""
	Codigo de stun de player
	"""
	#state = STUN
	stun_timer_elapsed = 0  # Reinicia o temporizador de STUN
	stats.health -= area.damage
	velocity = area.knockback*120
	hurtbox.star_invencibility(0.5)
	hurtbox._create_hit_effect()
	var playerHurtSounds = PlayerHurtSound.instantiate()
	get_tree().current_scene.add_child(playerHurtSounds)


func _on_hurtbox_invincibility_ended():
	blinkAnimation.play("Stop")


func _on_hurtbox_invincibility_started():
	blinkAnimation.play("Start")
