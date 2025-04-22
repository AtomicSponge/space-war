extends RigidBody2D

@export var Explosion: PackedScene
@export var speed: int = 350
@export var Health: int = 100
@export var ScoreValue: int = 100

@onready var BladeSprite: Sprite2D = $BladeSprite
@onready var BladeAnimationPlayer: AnimationPlayer = $BladeSprite/BladeAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	BladeAnimationPlayer.play("Fade")
	await BladeAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if name == testName:
		if bulletFlag == true:
			Health -= amount
			BladeAnimationPlayer.play("Flash")
		if Health <= 0:
			_is_ready = false
			EnemyHitbox.set_deferred("disabled", true)
			GameState.PlayerScore += ScoreValue
			BladeSprite.hide()
			var explosionEffect = Explosion.instantiate()
			add_child(explosionEffect)
			explosionEffect.global_position = position
			explosionEffect.emitting = true
			await get_tree().create_timer(1.0).timeout
			queue_free()
