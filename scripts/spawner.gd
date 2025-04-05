extends Node

# Array[{"time" (float), "type" (int), "location" (Vector2)}]
const _SpawnQueue:Array[Dictionary] = [
	{ "time": 180.0, "type": 0, "location": Vector2(10, 10) },
	{ "time": 180.0, "type": 0, "location": Vector2(1270, 10) },
	{ "time": 180.0, "type": 0, "location": Vector2(10, 710) },
	{ "time": 180.0, "type": 0, "location": Vector2(1270, 710) },
	{ "time": 170.1, "type": 0, "location": Vector2(50, 50) },
	{ "time": 170.1, "type": 0, "location": Vector2(1230, 50) },
	{ "time": 170.1, "type": 0, "location": Vector2(50, 670) },
	{ "time": 170.1, "type": 0, "location": Vector2(1230, 670) }
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array:
	return _SpawnQueue.filter(func(item): return item["time"] == currentTime)
