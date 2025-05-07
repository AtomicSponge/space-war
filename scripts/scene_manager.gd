extends Node
class_name NSceneManager

# A collection of scenes in the game. Scenes are added through the Inspector panel
@export var Scenes: Dictionary = {}

@onready var BGMuisc = $BGMusic
@onready var AniPlayer = $Fader/AnimationPlayer

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# Switch to the requested scene based on its alias
# Parameter sceneAlias: The scene alias of the scene to switch to
func SwitchScene(sceneAlias: String) -> void:
	get_tree().paused = true
	AniPlayer.play("Fade")
	await AniPlayer.animation_finished
	get_tree().change_scene_to_file(Scenes[sceneAlias])
	AniPlayer.play_backwards("Fade")
	await AniPlayer.animation_finished
	get_tree().paused = false

# Restart the current scene
func RestartScene() -> void:
	get_tree().paused = true
	AniPlayer.play("Fade")
	await AniPlayer.animation_finished
	get_tree().reload_current_scene()
	AniPlayer.play_backwards("Fade")
	await AniPlayer.animation_finished
	get_tree().paused = false

# Quit the game
func QuitGame() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
