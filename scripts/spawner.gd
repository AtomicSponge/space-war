extends Node

const _SpawnQueue: Array[Dictionary] = [
	#  WAVE 1
	{ "time": 180.0, "type": 0, "location": Vector2(50, 50), "rotation": 0.0 },
	{ "time": 180.0, "type": 0, "location": Vector2(1230, 50), "rotation": 0.0 },
	{ "time": 180.0, "type": 0, "location": Vector2(50, 670), "rotation": 0.0 },
	{ "time": 180.0, "type": 0, "location": Vector2(1230, 670), "rotation": 0.0 },
	{ "time": 180.0, "type": 3, "location": Vector2(15, 375), "rotation": 315.0 },
	{ "time": 180.0, "type": 3, "location": Vector2(1265, 375), "rotation": 225.0 },
	{ "time": 180.0, "type": 3, "location": Vector2(1265, 345), "rotation": 135.0 },
	{ "time": 180.0, "type": 3, "location": Vector2(15, 345), "rotation": 45.0 },
	{ "time": 175.0, "type": 1, "location": Vector2(624, 360), "rotation": 0.0 },
	{ "time": 175.0, "type": 1, "location": Vector2(656, 360), "rotation": 0.0 },
	{ "time": 175.0, "type": 1, "location": Vector2(640, 344), "rotation": 0.0 },
	{ "time": 175.0, "type": 1, "location": Vector2(640, 372), "rotation": 0.0 },
	{ "time": 170.0, "type": 1, "location": Vector2(624, 360), "rotation": 0.0 },
	{ "time": 170.0, "type": 1, "location": Vector2(656, 360), "rotation": 0.0 },
	{ "time": 170.0, "type": 1, "location": Vector2(640, 344), "rotation": 0.0 },
	{ "time": 170.0, "type": 1, "location": Vector2(640, 372), "rotation": 0.0 },
	
	# WAVE 2
	{ "time": 160.0, "type": 2, "location": Vector2(-16, 0), "rotation": 0.0 },
	{ "time": 160.0, "type": 2, "location": Vector2(1296, 720), "rotation": 180.0 }
]

# Get all enemies for the current time
func GetEnemies(currentTime: float) -> Array[Dictionary]:
	return _SpawnQueue.filter(func(item: Dictionary): return item["time"] == currentTime)
