extends Node

# Array[{"time" (float), "type" (int), "location" (Vector2)}]
const SpawnQueue:Array[Dictionary] = [
	{ "time": 300.0, "type": 0, "location": Vector2(0,0)}
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array:
	return SpawnQueue.filter(func(item): return item["time"] == currentTime)

# Load the spawning script
#func LoadScript() -> int:
#	var file = FileAccess.open_encrypted_with_pass(_queue_path, FileAccess.READ, "dragongelatohierarchy")
#	if file == null:
#		GameState.alert('Could not load spawner data!')
#		return -1
#	SpawnQueue = file.get_var()
#	file.close()
	
	# Sort by decending time
#	SpawnQueue.sort_custom(func(a, b): return a["time"] > b["time"])
	
#	return 0
