extends Node

# Array[{"time" (float), "type" (int), "location" (Vector2)}]
const SpawnQueue:Array[Dictionary] = [
	{ "time": 180.0, "type": 0, "location": Vector2(0, 0) },
	{ "time": 180.0, "type": 0, "location": Vector2(0, 0) },
	{ "time": 180.0, "type": 0, "location": Vector2(0, 0) },
	{ "time": 180.0, "type": 0, "location": Vector2(0, 0) }
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array:
	return SpawnQueue.filter(func(item): return item["time"] == currentTime)
