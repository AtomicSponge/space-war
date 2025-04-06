extends Area2D

@export var speed: int = 400
@export var Bullet: PackedScene
@export var Explosion: PackedScene

@onready var Sprite: Sprite2D = $PlayerSprite
@onready var RespawnAnimationPlayer: AnimationPlayer = $PlayerSprite/RespawnAnimationPlayer
@onready var PlayerHitbox: CollisionShape2D = $PlayerHitbox
@onready var ShotMarker: Marker2D = $ShotMarker
@onready var ShotTimer: Timer = $ShotTimer

@onready var ScreenSize: Vector2 = get_viewport_rect().size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name = "Player"
	# Use one shot so multiple hits do not cause extra deaths
	Events.player_hit.connect(_player_death, CONNECT_ONE_SHOT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handle attacking
	if Input.is_action_pressed("attack") and ShotTimer.is_stopped():
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.position = ShotMarker.global_position
		var testKey = Input.get_vector("keyboard_aim_left", "keyboard_aim_right", "keyboard_aim_up", "keyboard_aim_down", 0.0)
		var testJoy = Input.get_vector("joystick_aim_left", "joystick_aim_right", "joystick_aim_up", "joystick_aim_down", 0.05)
		# Test if using keyboard and assign rotation of attack
		if testKey.x > 0 or testKey.x < 0 or testKey.y > 0 or testKey.y < 0:
			b.rotation = testKey.angle()
		# Test if using joystick and assign rotation of attack
		elif testJoy.x > 0 or testJoy.x < 0 or testJoy.y > 0 or testJoy.y < 0:
			b.rotation = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)).angle()
		# Otherwise use the mouse to get attack angle
		else:
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

# Event for player taking damage
func _player_death():
	PlayerHitbox.set_deferred("disabled", true)
	hide()
	get_tree().paused = true
	# Insert playing explosion
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	# If extra lives, play respawn effect
	if GameState.PlayerLives >= 1:
		GameState.PlayerLives -= 1
		PlayerRespawn()
	# If extra continues, show continue screen
	elif GameState.PlayerContinues > 0:
		Events.game_continue.emit()
	# Otherwise end game
	else:
		Events.game_over.emit()

# Respawn player
func PlayerRespawn():
	show()
	PlayerHitbox.set_deferred("disabled", true)
	RespawnAnimationPlayer.play("Blink")
	await RespawnAnimationPlayer.animation_finished
	Events.player_hit.connect(_player_death, CONNECT_ONE_SHOT)
	PlayerHitbox.set_deferred("disabled", false)
