extends Area2D

@export var Explosion: PackedScene
@export var Health: int = 50
@export var ScoreValue: int = 250

@onready var ShipSprite = $ShipSprite
@onready var ShipAnimationPlayer = $ShipSprite/ShipAnimationPlayer
@onready var EnemyHitbox: CollisionShape2D = $EnemyHitbox

var Defeated: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.enemy_hit.connect(_take_damage)

# Hit
func _take_damage(testName: StringName, amount: int, bulletFlag: bool) -> void:
	if name == testName:
		Health -= amount
		ShipAnimationPlayer.play("Flash")
	if Health == 0:
		EnemyHitbox.set_deferred("disabled", true)
		if bulletFlag == true:
			GameState.PlayerScore += ScoreValue
		ShipSprite.hide()
		var explosionEffect = Explosion.instantiate()
		add_child(explosionEffect)
		explosionEffect.global_position = global_position
		explosionEffect.emitting = true
		Defeated = true
