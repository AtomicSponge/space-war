extends RigidBody2D

@export var Explosion: PackedScene
@export var ScoreValue: int = 250

var _is_ready: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Fade in animation
	Events.enemy_hit.connect(_take_damage)
	_is_ready = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Hit
func _take_damage(testName: StringName, _amount: int, bulletFlag: bool) -> void:
	if name == testName:
		_is_ready = false
		#EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		#ShipSprite.hide()
		#var explosionEffect = Explosion.instantiate()
		#add_child(explosionEffect)
		#explosionEffect.global_position = position
		#explosionEffect.emitting = true
		await get_tree().create_timer(1.0).timeout
		queue_free()
