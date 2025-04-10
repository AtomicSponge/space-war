extends PathFollow2D

@export var Explosion: PackedScene
@export var Health: int = 50
@export var ScoreValue: int = 250

@onready var ShipSprite: Sprite2D = $Ship/ShipSprite
@onready var ShipAnimationPlayer: AnimationPlayer = $Ship/ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $Ship/EnemyHitbox

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EnemyHitbox.set_deferred("disabled", true)
	ShipAnimationPlayer.play("Fade")
	await ShipAnimationPlayer.animation_finished
	EnemyHitbox.set_deferred("disabled", false)
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if name == testName:
		Health -= amount
		ShipAnimationPlayer.play("Flash")
	if Health == 0:
		_is_ready = false
		EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		ShipSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = position
		explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
