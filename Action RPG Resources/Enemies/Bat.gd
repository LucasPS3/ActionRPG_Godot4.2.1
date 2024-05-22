extends CharacterBody2D

const  EnemyDeathEffect = preload("res://Action RPG Resources/Effects/enemy_death_effect.tscn")

@export var ACCELERATION = 300
@export var MAX_SPEED = 30
@export var FRICTION = 200
@export var WANDER_RANGE = 4

@onready var sprite = $Sprite2D
@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var hurtbox = $Hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderControler = $WanderControler
@onready var animationPlayer = $AnimationPlayer

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

func  _ready():
	state = pick_random_state([IDLE,WANDER])

func _physics_process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move_and_slide()
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderControler._get_time_left() == 0:
				updtade_wander()
		WANDER:
			seek_player()
			if wanderControler._get_time_left() == 0:
				updtade_wander()
			accelerate_towards_point(wanderControler.target_position,delta)
			if global_position.distance_to(wanderControler.target_position) <= WANDER_RANGE:
				updtade_wander()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position,delta)
			else :
				state = IDLE
	
	if softCollision._is_collinding():
		velocity += softCollision._push_vector() * delta * 400
	
	move_and_slide()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()
	
func accelerate_towards_point(point,delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED,ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func updtade_wander():
	state = pick_random_state([IDLE,WANDER])
	wanderControler._start_wander_timer(randf_range(1,3))
	
func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	velocity = area.knockback_vector *120
	#hurtbox.star_invencibility(0.5)
	hurtbox._create_hit_effect()
	hurtbox. star_invencibility(0.4)

func _on_stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_hurtbox_invincibility_started():
	animationPlayer.play("Start")
