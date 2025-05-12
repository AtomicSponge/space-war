extends RigidBody2D

@export var Bullet: PackedScene
@export var Explosion: PackedScene
@export var Health: int = 100
@export var ScoreValue: int = 500

@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox
@onready var TowerSprite: Sprite2D = $TowerSprite
@onready var TowerAnimationPlayer: AnimationPlayer = $TowerSprite/TowerAnimationPlayer
@onready var CannonSprite: Sprite2D = $CannonSprite
@onready var CannonAnimationPlayer: AnimationPlayer = $CannonSprite/CannonAnimationPlayer
@onready var ShotMarker: Marker2D = $ShotMarker
@onready var ShotTimer: Timer = $ShotTimer
@onready var ExplosionAudio: AudioStreamPlayer = $ExplosionAudio

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	TowerAnimationPlayer.play("Fade")
	CannonAnimationPlayer.play("Fade")
	await TowerAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	CannonSprite.look_at(GameState.PlayerLocation)
	if not _is_ready:
		return
	
	# Fire at player
	if ShotTimer.is_stopped():
		var b = Bullet.instantiate()
		get_tree().get_current_scene().add_child(b)
		b.global_position = ShotMarker.global_position
		b.look_at(GameState.PlayerLocation)
		ShotTimer.start()

# Enemy hit by player bullet, take damage
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if name == testName:
		Health -= amount
		TowerAnimationPlayer.play("Flash")
		CannonAnimationPlayer.play("Flash")
	if Health <= 0:
		_is_ready = false
		EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		TowerSprite.hide()
		CannonSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = position
		ExplosionAudio.play()
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
