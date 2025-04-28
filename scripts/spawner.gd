extends Node

const _SpawnQueue: Array[Dictionary] = [
	#{ "time": 180.0, "type": 0, "location": Vector2(50, 50), "rotation": 0.0 },
	#{ "time": 180.0, "type": 0, "location": Vector2(1230, 50), "rotation": 0.0 },
	#{ "time": 180.0, "type": 0, "location": Vector2(50, 670), "rotation": 0.0 },
	#{ "time": 180.0, "type": 0, "location": Vector2(1230, 670), "rotation": 0.0 },
	#{ "time": 170.0, "type": 1, "location": Vector2(100, 100), "rotation": 0.0 },
	#{ "time": 170.0, "type": 1, "location": Vector2(1180, 100), "rotation": 0.0 },
	#{ "time": 170.0, "type": 1, "location": Vector2(100, 620), "rotation": 0.0 },
	#{ "time": 170.0, "type": 1, "location": Vector2(1180, 620), "rotation": 0.0 },
	#{ "time": 180.0, "type": 2, "location": Vector2(-16, 0), "rotation": 0.0 },
	#{ "time": 180.0, "type": 2, "location": Vector2(1296, 720), "rotation": 180.0 }
	{ "time": 180.0, "type": 3, "location": Vector2(25, 250), "rotation": 45.0 }
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array[Dictionary]:
	return _SpawnQueue.filter(func(item: Dictionary): return item["time"] == currentTime)
