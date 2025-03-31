extends CanvasLayer

@onready var PlayerLabel = $PlayerLabel
@onready var ScoreLabel = $ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerLabel.text = "%d" % GameState.NumberLives + " - C %d" % GameState.NumberContinues
	ScoreLabel.text = "%016d" % GameState.PlayerScore

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	PlayerLabel.text = "%d" % GameState.PlayerLives + " - C %d" % GameState.PlayerContinues
	ScoreLabel.text = "%016d" % GameState.PlayerScore
