extends Area2D

@onready var LifeTimer = $LifeTimer

@export var speed = 750
@export var damageAmount = 25

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
	Events.enemy_hit.emit(body.name, damageAmount, true)
	queue_free()

# Bullet hit enemy, emit hit event and pass node name
func _on_area_entered(area: Area2D) -> void:
	Events.enemy_hit.emit(area.name, damageAmount, true)
	queue_free()
