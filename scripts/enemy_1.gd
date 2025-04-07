extends Area2D

var _is_ready: bool = false

@onready var ShipAnimationPlayer: AnimationPlayer = $ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_hit.connect(_take_damage)
	EnemyHitbox.set_deferred("disabled", true)
	ShipAnimationPlayer.play("Fade")
	await ShipAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not _is_ready:
		return

func _take_damage() -> void:
	pass
