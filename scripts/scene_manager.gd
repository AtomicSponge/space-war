extends Node
class_name NSceneManager

# Identifiers for the audio streams
enum Audio {
	Menu, Game
}

# A collection of scenes in the game. Scenes are added through the Inspector panel
@export var Scenes: Dictionary = {}
# List of background music files
@export var BGMuisc: Array[AudioStreamPlayer]

@onready var AniPlayer = $Fader/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManager.BGMuisc[Audio.Menu].play()

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
