extends Path2D

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

@onready var EnemyPathE: PathFollow2D = $EnemyPathE
@onready var ShipE: Area2D = $EnemyPathE/ShipE
@onready var ShipSpriteE: Sprite2D = $EnemyPathE/ShipE/ShipSprite
@onready var ShipAnimationPlayerE: AnimationPlayer = $EnemyPathE/ShipE/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxE: CollisionShape2D = $EnemyPathE/ShipE/EnemyHitbox

@onready var PathArray: Array[PathFollow2D] = [
	EnemyPathA, EnemyPathB, EnemyPathC, EnemyPathD, EnemyPathE
]

@onready var SpriteArray: Array[Sprite2D] = [
	ShipSpriteA, ShipSpriteB, ShipSpriteC, ShipSpriteD, ShipSpriteE
]

var _target_progress: Array[float] = [ 0.99, 0.99, 0.99, 0.99, 0.99 ]
var _is_ready: bool = false
const MAX_PROGRESS: float = 0.99
const MIN_PROGRESS: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitboxA.set_deferred("disabled", true)
	EnemyHitboxB.set_deferred("disabled", true)
	EnemyHitboxC.set_deferred("disabled", true)
	EnemyHitboxD.set_deferred("disabled", true)
	EnemyHitboxE.set_deferred("disabled", true)
	# Make sure the ships have unique names
	ShipA.name = str(ShipA.get_path())
	ShipB.name = str(ShipB.get_path())
	ShipC.name = str(ShipC.get_path())
	ShipD.name = str(ShipD.get_path())
	ShipE.name = str(ShipE.get_path())
	ShipAnimationPlayerA.play("Fade")
	ShipAnimationPlayerB.play("Fade")
	ShipAnimationPlayerC.play("Fade")
	ShipAnimationPlayerD.play("Fade")
	ShipAnimationPlayerE.play("Fade")
	await ShipAnimationPlayerA.animation_finished
	EnemyHitboxA.set_deferred("disabled", false)
	EnemyHitboxB.set_deferred("disabled", false)
	EnemyHitboxC.set_deferred("disabled", false)
	EnemyHitboxD.set_deferred("disabled", false)
	EnemyHitboxE.set_deferred("disabled", false)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return
	for idx in PathArray.size():
		if not is_instance_valid(PathArray[idx]):
			PathArray.remove_at(idx)
			SpriteArray.remove_at(idx)
			_target_progress.remove_at(idx)
		if PathArray[idx].progress_ratio < _target_progress[idx]:
			PathArray[idx].progress_ratio += delta * speed
			SpriteArray[idx].flip_h = false
			_target_progress[idx] = MAX_PROGRESS
		if PathArray[idx].progress_ratio > _target_progress[idx]:
			PathArray[idx].progress_ratio += delta * (speed * -1.0)
			SpriteArray[idx].flip_h = true
			_target_progress[idx] = MIN_PROGRESS
		# All enemies in group defeated, remove
		if PathArray.is_empty():
			queue_free()
