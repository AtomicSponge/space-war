extends Path2D

@export var Explosion: PackedScene
@export var speed: float = 1.0
@export var Health: int = 100
@export var ScoreValue: int = 100

@onready var EnemyPath: PathFollow2D = $EnemyPath
@onready var Saw: Area2D = $EnemyPath/Saw
@onready var BladeSprite: Sprite2D = $EnemyPath/Saw/BladeSprite
@onready var BladeAnimationPlayer: AnimationPlayer = $EnemyPath/Saw/BladeSprite/BladeAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyPath/Saw/EnemyHitbox
@onready var rotateTween: Tween
@onready var movementTween: Tween

var _rotating: bool = false
var _moving: bool = false
var _foward_direction: bool = true
var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	Saw.name = str(Saw.get_path())
	BladeAnimationPlayer.play("Fade")
	await BladeAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _is_ready:
		return
	if not _rotating:
		rotateTween = create_tween().set_trans(Tween.TRANS_SINE)
		rotateTween.tween_property(BladeSprite, "rotation_degrees", 360.0, 0.1)
		_rotating = true
	if not rotateTween.is_running():
		BladeSprite.rotation_degrees = 0
		_rotating = false
	if _foward_direction and not _moving:
		movementTween = create_tween().set_trans(Tween.TRANS_SINE)
		movementTween.tween_property(EnemyPath, "progress_ratio", 1.0, speed)
		_foward_direction = false
		_moving = true
	if not _foward_direction and not _moving:
		movementTween = create_tween().set_trans(Tween.TRANS_SINE)
		movementTween.tween_property(EnemyPath, "progress_ratio", 0.0, speed)
		_foward_direction = true
		_moving = true
	if not movementTween.is_running():
		_moving = false

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if Saw.name == testName:
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
			explosionEffect.global_position = Saw.global_position
			explosionEffect.emitting = true
			await get_tree().create_timer(1.0).timeout
			queue_free()
