extends Node


func hook_unit_test(enable_debug: bool = true) -> bool:
	var unit_test_scene = "res://src/client/game/new_game.tscn"
	#enable_debug = false
	if enable_debug:
		SceneChanger.goto_scene(unit_test_scene)
	return enable_debug


func _ready():
	if not hook_unit_test():
		SceneChanger.goto_scene("res://scenes/init.tscn")
