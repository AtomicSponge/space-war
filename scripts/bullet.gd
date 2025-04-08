extends Area2D

@onready var LifeTimer = $LifeTimer

@export var speed = 750

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LifeTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if LifeTimer.is_stopped():
		queue_free()
	position += transform.x * speed * delta

# Bullet hit enemy, emit hit event and pass node name
func _on_body_entered(body: Node2D) -> void:
	Events.enemy_hit.emit(body.name)
	queue_free()
