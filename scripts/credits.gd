extends Node

@export var scroll_time: float
@export var scroll_stop: int

@onready var CreditsScrollContainer: ScrollContainer = $CreditsScrollContainer
@onready var ScrollTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreditsScrollContainer.scroll_vertical = 0
	ScrollTween = create_tween()
	ScrollTween.tween_property(CreditsScrollContainer, "scroll_vertical", scroll_stop, scroll_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not ScrollTween.is_running():
		CreditsScrollContainer.scroll_vertical = 0
		ScrollTween = create_tween()
		ScrollTween.tween_property(CreditsScrollContainer, "scroll_vertical", scroll_stop, scroll_time)

# Check if a button or key is pressed and return to main menu
func _input(event: InputEvent) -> void:
	if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
		if event is InputEventMouseMotion:
			return
		else:
			SceneManager.SwitchScene("MainMenu")
