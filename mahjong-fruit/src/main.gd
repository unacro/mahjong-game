extends Node


const GAME_TITLE = preload("res://src/client/title_scene.tscn")
const UNIT_TEST = preload("res://src/client/local_game/debug/debug_algorithm.tscn")


func hook_unit_test(enable_debug: bool = true) -> bool:
	enable_debug = false
	if enable_debug:
		SceneChanger.goto_scene(UNIT_TEST)
	return enable_debug


func _ready():
	if not hook_unit_test():
		SceneChanger.goto_scene(GAME_TITLE)
