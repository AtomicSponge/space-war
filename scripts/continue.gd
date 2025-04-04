extends CanvasLayer

@onready var CounterLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/CounterLabel
@onready var ContinueTimer = $ContinueTimer

var ContinueSelected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ContinueTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not ContinueTimer.is_stopped():
		CounterLabel.text = "%d" % snappedi(ContinueTimer.time_left, 1)
	else:
		hide()

# Check if a button or key is pressed
func _input(event: InputEvent) -> void:
	if not ContinueTimer.is_stopped():
		if event is InputEventKey or InputEventJoypadButton or InputEventMouseButton:
			if event is InputEventMouseMotion:
				return
			else:
				ContinueSelected = true
				ContinueTimer.stop()
				get_tree().paused = false
				hide()
