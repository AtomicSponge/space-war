extends Node

# Called when the player is hit by an object
signal player_hit
# Called when a player bullet hits an enemy
signal enemy_hit(name: StringName)
# Called to display the continue screen
signal game_continue
# Called when a continue is selected
signal game_continue_selected
# Call to do a game over
signal game_over
