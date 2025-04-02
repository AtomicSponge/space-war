extends Area2D

@export var Bullet: PackedScene

@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox
@onready var TowerSprite: Sprite2D = $TowerSprite
@onready var CannonSprite: Sprite2D = $CannonSprite
@onready var TowerAnimationPlayer: AnimationPlayer = $TowerSprite/TowerAnimationPlayer
@onready var CannonAnimationPlayer: AnimationPlayer = $CannonSprite/CannonAnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.disabled = true
	TowerAnimationPlayer.play("Fade")
	CannonAnimationPlayer.play("Fade")
	await TowerAnimationPlayer.animation_finished
	EnemyHitbox.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
