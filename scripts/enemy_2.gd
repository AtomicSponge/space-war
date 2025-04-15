extends Path2D

@export var speed: float = 0.2
@export var ScoreValue: int = 250

@onready var EnemyPathA: PathFollow2D = $EnemyPathA
@onready var ShipA: Area2D = $EnemyPathA/ShipA
@onready var ShipSpriteA: Sprite2D = $EnemyPathA/ShipA/ShipSprite
@onready var ShipAnimationPlayerA: AnimationPlayer = $EnemyPathA/ShipA/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxA: CollisionShape2D = $EnemyPathA/ShipA/EnemyHitbox
@onready var ExplosionEffectA: GPUParticles2D = $EnemyPathA/ShipA/ExplosionOrange

@onready var EnemyPathB: PathFollow2D = $EnemyPathB
@onready var ShipB: Area2D = $EnemyPathB/ShipB
@onready var ShipSpriteB: Sprite2D = $EnemyPathB/ShipB/ShipSprite
@onready var ShipAnimationPlayerB: AnimationPlayer = $EnemyPathB/ShipB/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxB: CollisionShape2D = $EnemyPathB/ShipB/EnemyHitbox
@onready var ExplosionEffectB: GPUParticles2D = $EnemyPathB/ShipB/ExplosionOrange

@onready var EnemyPathC: PathFollow2D = $EnemyPathC
@onready var ShipC: Area2D = $EnemyPathC/ShipC
@onready var ShipSpriteC: Sprite2D = $EnemyPathC/ShipC/ShipSprite
@onready var ShipAnimationPlayerC: AnimationPlayer = $EnemyPathC/ShipC/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxC: CollisionShape2D = $EnemyPathC/ShipC/EnemyHitbox
@onready var ExplosionEffectC: GPUParticles2D = $EnemyPathC/ShipC/ExplosionOrange

@onready var EnemyPathD: PathFollow2D = $EnemyPathD
@onready var ShipD: Area2D = $EnemyPathD/ShipD
@onready var ShipSpriteD: Sprite2D = $EnemyPathD/ShipD/ShipSprite
@onready var ShipAnimationPlayerD: AnimationPlayer = $EnemyPathD/ShipD/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxD: CollisionShape2D = $EnemyPathD/ShipD/EnemyHitbox
@onready var ExplosionEffectD: GPUParticles2D = $EnemyPathD/ShipD/ExplosionOrange

@onready var EnemyPathE: PathFollow2D = $EnemyPathE
@onready var ShipE: Area2D = $EnemyPathE/ShipE
@onready var ShipSpriteE: Sprite2D = $EnemyPathE/ShipE/ShipSprite
@onready var ShipAnimationPlayerE: AnimationPlayer = $EnemyPathE/ShipE/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxE: CollisionShape2D = $EnemyPathE/ShipE/EnemyHitbox
@onready var ExplosionEffectE: GPUParticles2D = $EnemyPathE/ShipE/ExplosionOrange

@onready var PathArray: Array[PathFollow2D] = [
	EnemyPathA, EnemyPathB, EnemyPathC, EnemyPathD, EnemyPathE
]

@onready var ShipArray: Array[Area2D] = [
	ShipA, ShipB, ShipC, ShipD, ShipE
]

@onready var ShipSpriteArray: Array[Sprite2D] = [
	ShipSpriteA, ShipSpriteB, ShipSpriteC, ShipSpriteD, ShipSpriteE
]

@onready var ShipAnimationPlayerArray: Array[AnimationPlayer] = [
	ShipAnimationPlayerA, ShipAnimationPlayerB, ShipAnimationPlayerC, ShipAnimationPlayerD, ShipAnimationPlayerE
]

@onready var EnemyHitboxArray: Array[CollisionShape2D] = [
	EnemyHitboxA, EnemyHitboxB, EnemyHitboxC, EnemyHitboxD, EnemyHitboxE
]

@onready var ExplosionEffectArray: Array[GPUParticles2D] = [
	ExplosionEffectA, ExplosionEffectB, ExplosionEffectC, ExplosionEffectD, ExplosionEffectE
]

var _target_progress: Array[float] = [ 0.99, 0.99, 0.99, 0.99, 0.99 ]
var _health: Array[int] = [ 50, 50, 50, 50, 50 ]
var _defeated: Array[bool] = [ false, false, false, false, false ]
var _is_ready: bool = false
const MAX_PROGRESS: float = 0.99
const MIN_PROGRESS: float = 0.01

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for hitbox in EnemyHitboxArray:
		hitbox.set_deferred("disabled", true)
	# Make sure the ships have unique names
	ShipA.name = str(ShipA.get_path())
	ShipB.name = str(ShipB.get_path())
	ShipC.name = str(ShipC.get_path())
	ShipD.name = str(ShipD.get_path())
	ShipE.name = str(ShipE.get_path())
	for ShipAnimationPlayer in ShipAnimationPlayerArray:
		ShipAnimationPlayer.play("Fade")
	await ShipAnimationPlayerA.animation_finished
	for hitbox in EnemyHitboxArray:
		hitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return
	for idx in PathArray.size():
		# Check if defeated
		if _defeated[idx]:
			continue
		if PathArray[idx].progress_ratio < _target_progress[idx]:
			PathArray[idx].progress_ratio += delta * speed
			ShipSpriteArray[idx].flip_h = false
			_target_progress[idx] = MAX_PROGRESS
		if PathArray[idx].progress_ratio > _target_progress[idx]:
			PathArray[idx].progress_ratio += delta * (speed * -1.0)
			ShipSpriteArray[idx].flip_h = true
			_target_progress[idx] = MIN_PROGRESS

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	for idx in ShipArray.size():
		if ShipArray[idx].name == testName:
			_health[idx] -= amount
			ShipAnimationPlayerArray[idx].play("Flash")
		if ShipArray[idx].name == testName and _health[idx] <= 0:
			EnemyHitboxArray[idx].set_deferred("disabled", true)
			if bulletFlag == true:
				GameState.PlayerScore += ScoreValue
			ShipSpriteArray[idx].hide()
			ExplosionEffectArray[idx].global_position = ShipArray[idx].global_position
			ExplosionEffectArray[idx].emitting = true
			_defeated[idx] = true
	# All enemies in group defeated, remove
	if _defeated.all(func(val): return val):
		# Make sure final explosion is played
		await get_tree().create_timer(1.0).timeout
		queue_free()
