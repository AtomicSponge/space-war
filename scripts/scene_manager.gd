extends Node
class_name NSceneManager

# A collection of scenes in the game. Scenes are added through the Inspector panel
@export var Scenes: Dictionary = {}

@onready var AniPlayer = $Fader/AnimationPlayer

# Description: Add a new scene to the scene collection
# Parameter sceneAlias: The alias used for finding the scene in the collection
# Parameter scenePath: The full path to the scene file in the file system
#func AddScene(sceneAlias: String, scenePath: String) -> void:
	#Scenes[sceneAlias] = scenePath

# Description: Remove an existing scene from the scene collection
# Parameter sceneAlias: The scene alias of the scene to remove from the collection
#func RemoveScene(sceneAlias: String) -> void:
	#Scenes.erase(sceneAlias)

# Description: Switch to the requested scene based on its alias
# Parameter sceneAlias: The scene alias of the scene to switch to
func SwitchScene(sceneAlias: String) -> void:
	get_tree().paused = true
	AniPlayer.play("Fade")
	await AniPlayer.animation_finished
	get_tree().change_scene_to_file(Scenes[sceneAlias])
	AniPlayer.play_backwards("Fade")
	await AniPlayer.animation_finished
	get_tree().paused = false

# Description: Restart the current scene
func RestartScene() -> void:
	get_tree().paused = true
	AniPlayer.play("Fade")
	await AniPlayer.animation_finished
	get_tree().reload_current_scene()
	AniPlayer.play_backwards("Fade")
	await AniPlayer.animation_finished
	get_tree().paused = false

# Description: Quit the game
func QuitGame() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
