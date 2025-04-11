extends Node

# Array[{"time" (float), "type" (int), "location" (Vector2)}]
const _SpawnQueue:Array[Dictionary] = [
	#{ "time": 180.0, "type": 0, "location": Vector2(50, 50) },
	#{ "time": 180.0, "type": 0, "location": Vector2(1230, 50) },
	#{ "time": 180.0, "type": 0, "location": Vector2(50, 670) },
	#{ "time": 180.0, "type": 0, "location": Vector2(1230, 670) },
	#{ "time": 170.0, "type": 1, "location": Vector2(100, 100) },
	#{ "time": 170.0, "type": 1, "location": Vector2(1180, 100) },
	#{ "time": 170.0, "type": 1, "location": Vector2(100, 620) },
	#{ "time": 170.0, "type": 1, "location": Vector2(1180, 620) },
	{ "time": 180.0, "type": 2, "location": Vector2(0, 0) },
	{ "time": 178.0, "type": 2, "location": Vector2(0, 0) }
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array:
	return _SpawnQueue.filter(func(item): return item["time"] == currentTime)
