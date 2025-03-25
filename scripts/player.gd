extends Area2D

@export var speed: int = 400

@onready var Sprite: Sprite2D = $PlayerSprite

var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# Moving
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	# Stopped
	else:
		pass
	
	Sprite.rotation = lerp_angle(Sprite.rotation, atan2(velocity.x, -velocity.y), delta * 10.0)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
