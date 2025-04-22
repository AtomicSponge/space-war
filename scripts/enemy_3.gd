extends RigidBody2D

@onready var BladeSprite: Sprite2D = $BladeSprite
@onready var BladeAnimationPlayer: AnimationPlayer = $BladeSprite/BladeAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return
