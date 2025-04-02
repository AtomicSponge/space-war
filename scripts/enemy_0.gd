extends Area2D

@export var Bullet: PackedScene

@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox
@onready var TowerSprite: Sprite2D = $TowerSprite
@onready var CannonSprite: Sprite2D = $CannonSprite
@onready var TowerAnimationPlayer: AnimationPlayer = $TowerSprite/TowerAnimationPlayer
@onready var CannonAnimationPlayer: AnimationPlayer = $CannonSprite/CannonAnimationPlayer

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.disabled = true
	TowerAnimationPlayer.play("Fade")
	CannonAnimationPlayer.play("Fade")
	await TowerAnimationPlayer.animation_finished
	EnemyHitbox.disabled = false
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not _is_ready:
		return
	CannonSprite.look_at(get_global_mouse_position())
