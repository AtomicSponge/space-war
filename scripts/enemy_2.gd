extends Area2D

@export var Explosion: PackedScene
@export var Health: int = 50
@export var ScoreValue: int = 250
@export var speed: float = 0.2

@onready var ShipSprite: Sprite2D = $ShipSprite
@onready var ShipAnimationPlayer: AnimationPlayer = $ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

var _target_progress: float = 0.99
var _is_ready: bool = false
const MAX_PROGRESS: float = 0.99
const MIN_PROGRESS: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	ShipAnimationPlayer.play("Fade")
	await ShipAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	# works but maybe a better solution?
	name = get_parent().get_parent().name
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return
	if get_parent().progress_ratio < _target_progress:
		get_parent().progress_ratio += delta * speed
		ShipSprite.flip_h = false
		_target_progress = MAX_PROGRESS
	if get_parent().progress_ratio > _target_progress:
		get_parent().progress_ratio += delta * (speed * -1.0)
		ShipSprite.flip_h = true
		_target_progress = MIN_PROGRESS

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if name == testName:
		Health -= amount
		ShipAnimationPlayer.play("Flash")
	if Health == 0:
		_is_ready = false
		EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		ShipSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = global_position
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		# this needs to be better
		get_parent().get_parent().queue_free()
