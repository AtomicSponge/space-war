extends CanvasLayer

@onready var CounterLabel = $MarginContainer/VBoxContainer/CenterContainerBottom/CounterLabel
@onready var ContinueTimer = $ContinueTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	ContinueTimer.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not ContinueTimer.is_stopped():
		CounterLabel.text = snapped(ContinueTimer.time_left, 10)
