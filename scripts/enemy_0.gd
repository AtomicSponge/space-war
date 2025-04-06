extends Area2D

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

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_hit.connect(_take_damage)
	EnemyHitbox.set_deferred("disabled", true)
	TowerAnimationPlayer.play("Fade")
	CannonAnimationPlayer.play("Fade")
	await TowerAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _is_ready:
		return

	CannonSprite.look_at(GameState.PlayerLocation)
	
	# Fire at player
	if ShotTimer.is_stopped():
		var b = Bullet.instantiate()
		add_child(b)
		b.position = ShotMarker.position
		b.look_at(GameState.PlayerLocation)
		ShotTimer.start()

# Enemy hit by player bullet, take damage
func _take_damage(testName: StringName) -> void:
	if name == testName:
		Health -= 20
		TowerAnimationPlayer.play("Flash")
		CannonAnimationPlayer.play("Flash")
	if Health == 0:
		_is_ready = false
		EnemyHitbox.set_deferred("disabled", true)
		GameState.PlayerScore += ScoreValue
		TowerSprite.hide()
		CannonSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = position
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()

# Collided with player
func _on_area_entered(area: Area2D) -> void:
	if area.name == "Player":
		Events.player_hit.emit()
		queue_free()
