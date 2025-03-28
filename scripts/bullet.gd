extends Area2D

@export var speed = 750

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()
