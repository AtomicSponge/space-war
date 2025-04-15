extends Path2D

@export var speed: float = 5.0
@export var ScoreValue: int = 250

@onready var EnemyPathA: PathFollow2D = $EnemyPathA
@onready var ShipA: Area2D = $EnemyPathA/ShipA
@onready var ShipSpriteA: Sprite2D = $EnemyPathA/ShipA/ShipSprite
@onready var ShipAnimationPlayerA: AnimationPlayer = $EnemyPathA/ShipA/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxA: CollisionShape2D = $EnemyPathA/ShipA/EnemyHitbox
@onready var ExplosionEffectA: GPUParticles2D = $EnemyPathA/ShipA/ExplosionOrange
@onready var TweenA: Tween

@onready var EnemyPathB: PathFollow2D = $EnemyPathB
@onready var ShipB: Area2D = $EnemyPathB/ShipB
@onready var ShipSpriteB: Sprite2D = $EnemyPathB/ShipB/ShipSprite
@onready var ShipAnimationPlayerB: AnimationPlayer = $EnemyPathB/ShipB/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxB: CollisionShape2D = $EnemyPathB/ShipB/EnemyHitbox
@onready var ExplosionEffectB: GPUParticles2D = $EnemyPathB/ShipB/ExplosionOrange
@onready var TweenB: Tween

@onready var EnemyPathC: PathFollow2D = $EnemyPathC
@onready var ShipC: Area2D = $EnemyPathC/ShipC
@onready var ShipSpriteC: Sprite2D = $EnemyPathC/ShipC/ShipSprite
@onready var ShipAnimationPlayerC: AnimationPlayer = $EnemyPathC/ShipC/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxC: CollisionShape2D = $EnemyPathC/ShipC/EnemyHitbox
@onready var ExplosionEffectC: GPUParticles2D = $EnemyPathC/ShipC/ExplosionOrange
@onready var TweenC: Tween

@onready var EnemyPathD: PathFollow2D = $EnemyPathD
@onready var ShipD: Area2D = $EnemyPathD/ShipD
@onready var ShipSpriteD: Sprite2D = $EnemyPathD/ShipD/ShipSprite
@onready var ShipAnimationPlayerD: AnimationPlayer = $EnemyPathD/ShipD/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxD: CollisionShape2D = $EnemyPathD/ShipD/EnemyHitbox
@onready var ExplosionEffectD: GPUParticles2D = $EnemyPathD/ShipD/ExplosionOrange
@onready var TweenD: Tween

@onready var EnemyPathE: PathFollow2D = $EnemyPathE
@onready var ShipE: Area2D = $EnemyPathE/ShipE
@onready var ShipSpriteE: Sprite2D = $EnemyPathE/ShipE/ShipSprite
@onready var ShipAnimationPlayerE: AnimationPlayer = $EnemyPathE/ShipE/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitboxE: CollisionShape2D = $EnemyPathE/ShipE/EnemyHitbox
@onready var ExplosionEffectE: GPUParticles2D = $EnemyPathE/ShipE/ExplosionOrange
@onready var TweenE: Tween

@onready var EnemyPathArray: Array[PathFollow2D] = [
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

@onready var TweenArray: Array[Tween] = [ 
	TweenA, TweenB, TweenC, TweenD, TweenE
]

var _health: Array[int] = [ 50, 50, 50, 50, 50 ]
var _foward_direction: Array[bool] = [ true, true, true, true, true ]
var _running: Array[bool] = [ false, false, false, false, false ]
var _defeated: Array[bool] = [ false, false, false, false, false ]
var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for hitbox in EnemyHitboxArray:
		hitbox.set_deferred("disabled", true)
	# Make sure the ships have unique names
	for ship in ShipArray:
		ship.name = str(ship.get_path())
	for shipAnimationPlayer in ShipAnimationPlayerArray:
		shipAnimationPlayer.play("Fade")
	await ShipAnimationPlayerA.animation_finished
	for hitbox in EnemyHitboxArray:
		hitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _is_ready:
		return
	for idx in EnemyPathArray.size():
		if _defeated[idx]:
			continue
		if _foward_direction[idx] and not _running[idx]:
			TweenArray[idx] = create_tween().set_trans(Tween.TRANS_SINE)
			TweenArray[idx].tween_property(EnemyPathArray[idx], "progress_ratio", 0.96 + (idx * 0.01), speed)
			ShipSpriteArray[idx].flip_h = false
			_foward_direction[idx] = false
			_running[idx] = true
		if not _foward_direction[idx] and not _running[idx]:
			TweenArray[idx] = create_tween().set_trans(Tween.TRANS_SINE)
			TweenArray[idx].tween_property(EnemyPathArray[idx], "progress_ratio", 0.00 + (idx * 0.01), speed)
			ShipSpriteArray[idx].flip_h = true
			_foward_direction[idx] = true
			_running[idx] = true
		if not TweenArray[idx].is_running():
			_running[idx] = false

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	for idx in ShipArray.size():
		if ShipArray[idx].name == testName:
			_health[idx] -= amount
			ShipAnimationPlayerArray[idx].play("Flash")
			if _health[idx] <= 0:
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
