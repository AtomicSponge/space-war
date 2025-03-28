extends Area2D

@export var speed: int = 400
@export var Bullet: PackedScene

@onready var Sprite: Sprite2D = $PlayerSprite
@onready var ScreenSize: Vector2 = get_viewport_rect().size
@onready var ShotMarker: Marker2D = $ShotMarker
@onready var ShotTimer: Timer = $ShotTimer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle attacking
	if Input.is_action_pressed("attack") and ShotTimer.is_stopped():
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.position = ShotMarker.global_position
		b.look_at(get_global_mouse_position())
		ShotTimer.start()
	
	# Handle movement
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
	
	# Rotate sprite
	if velocity.x != 0 or velocity.y != 0:
		Sprite.rotation = lerp_angle(Sprite.rotation, atan2(velocity.x, -velocity.y), delta * 10.0)
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, ScreenSize)
