extends Node

var SpawnQueue:Array[Dictionary] = []

const _queue_path: String = "res://spawner.dat"

func LoadScript() -> int:
	var file = FileAccess.open_encrypted_with_pass(_queue_path, FileAccess.READ, "dragongelatohierarchy")
	if file == null:
		GameState.alert('Could not load spawner data!')
		return -1
	SpawnQueue = file.get_var()
	file.close()
	return 0
