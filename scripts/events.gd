extends Node

# Called when a player bullet hits an enemy
# Param: name -> name of the object
# Param: amount -> amount of damage
# Param: bulletFlag -> bullet or player hitting enemy
signal enemy_hit(name: StringName, amount: int, bulletFlag: bool)

# Called to display the continue screen
signal game_continue
# Called when a continue is selected
signal game_continue_selected

# Call to do a game over
signal game_over
