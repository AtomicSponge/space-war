extends RigidBody2D

@export var speed: int = 300

@onready var ShipSprite: Sprite2D = $ShipSprite
@onready var ShipAnimationPlayer: AnimationPlayer = $ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

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
	look_at(GameState.PlayerLocation)
	if not _is_ready:
		return
	position += transform.x * speed * delta

# Hit by player bullet
func _take_damage(testName: StringName) -> void:
	if name == testName:
		queue_free()

# Collided
#func _on_area_entered(area: Area2D) -> void:
	# Collided with player
	#if area.name == "Player":
		#Events.player_hit.emit()
		#queue_free()

func _on_body_entered(body: Node) -> void:
	# Collided with player
	if body.name == "Player":
		Events.player_hit.emit()
		queue_free()
