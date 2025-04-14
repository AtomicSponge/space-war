extends Path2D

@export var Explosion: PackedScene
@export var Health: int = 50
@export var ScoreValue: int = 250
@export var speed: float = 0.2

@onready var EnemyPathA: PathFollow2D = $EnemyPathA
@onready var ShipA: Area2D = $EnemyPathA/ShipA
@onready var ShipSpriteA: Sprite2D = $EnemyPathA/ShipA/ShipSprite
@onready var ShipAnimationPlayerA: AnimationPlayer = $EnemyPathA/ShipA/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxA: CollisionShape2D = $EnemyPathA/ShipA/EnemyHitbox

@onready var EnemyPathB: PathFollow2D = $EnemyPathB
@onready var ShipB: Area2D = $EnemyPathB/ShipB
@onready var ShipSpriteB: Sprite2D = $EnemyPathB/ShipB/ShipSprite
@onready var ShipAnimationPlayerB: AnimationPlayer = $EnemyPathB/ShipB/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxB: CollisionShape2D = $EnemyPathB/ShipB/EnemyHitbox

@onready var EnemyPathC: PathFollow2D = $EnemyPathC
@onready var ShipC: Area2D = $EnemyPathC/ShipC
@onready var ShipSpriteC: Sprite2D = $EnemyPathC/ShipC/ShipSprite
@onready var ShipAnimationPlayerC: AnimationPlayer = $EnemyPathC/ShipC/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxC: CollisionShape2D = $EnemyPathC/ShipC/EnemyHitbox

@onready var EnemyPathD: PathFollow2D = $EnemyPathD
@onready var ShipD: Area2D = $EnemyPathD/ShipD
@onready var ShipSpriteD: Sprite2D = $EnemyPathD/ShipD/ShipSprite
@onready var ShipAnimationPlayerD: AnimationPlayer = $EnemyPathD/ShipD/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxD: CollisionShape2D = $EnemyPathD/ShipD/EnemyHitbox

@onready var EnemyPathE: PathFollow2D = $EnemyPathA
@onready var ShipE: Area2D = $EnemyPathA/ShipA
@onready var ShipSpriteE: Sprite2D = $EnemyPathA/ShipA/ShipSprite
@onready var ShipAnimationPlayerE: AnimationPlayer = $EnemyPathA/ShipA/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxE: CollisionShape2D = $EnemyPathA/ShipA/EnemyHitbox

var _target_progress: float = 0.99
var _is_ready: bool = false
const MAX_PROGRESS: float = 0.99
const MIN_PROGRESS: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ShipA.name = str(ShipA.get_path())
	EnemyHitboxA.set_deferred("disabled", true)
	ShipAnimationPlayerA.play("Fade")
	await ShipAnimationPlayerA.animation_finished
	EnemyHitboxA.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return
	if EnemyPathA.progress_ratio < _target_progress:
		EnemyPathA.progress_ratio += delta * speed
		ShipSpriteA.flip_h = false
		_target_progress = MAX_PROGRESS
	if EnemyPathA.progress_ratio > _target_progress:
		EnemyPathA.progress_ratio += delta * (speed * -1.0)
		ShipSpriteA.flip_h = true
		_target_progress = MIN_PROGRESS

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	print(testName)
	if name == testName:
		Health -= amount
		ShipAnimationPlayerA.play("Flash")
	if Health == 0:
		_is_ready = false
		EnemyHitboxA.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		ShipSpriteA.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = global_position
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
