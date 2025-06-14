extends RigidBody2D

@export var Explosion: PackedScene
@export var speed: int = 350
@export var ScoreValue: int = 150

@onready var ShipSprite: Sprite2D = $ShipSprite
@onready var ShipAnimationPlayer: AnimationPlayer = $ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox
@onready var ExplosionAudio: AudioStreamPlayer = $ExplosionAudio

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	ShipAnimationPlayer.play("Fade")
	await ShipAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Move the enemy
func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	look_at(GameState.PlayerLocation)
	if not _is_ready:
		return
	var pos = position.direction_to(GameState.PlayerLocation)
	linear_velocity = speed * pos

# Hit
func _take_damage(testName: StringName, _amount: int, bulletFlag: bool) -> void:
	if name == testName:
		_is_ready = false
		EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		ShipSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = position
		ExplosionAudio.play()
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
