extends Control
# 玩家 UI


################################################################
# Signals 信号
################################################################
signal tile_discarded(tile_value)
signal tile_called(holding_tiles)

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################
const TILE_NODE = preload("res://src/client/ui/new_game/tile_node.tscn")

################################################################
# Exported variables 导出变量
################################################################

################################################################
# Public variables 公共变量
################################################################
var known_dora: Array = [] setget set_known_dora
var hand_tiles: Array = [] setget set_hand_tiles
var the_tile: int = -1 setget set_the_tile

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _dora_tile_nodes = [
	$DoraContainer/HBoxContainer/DoraTile1,
	$DoraContainer/HBoxContainer/DoraTile2,
	$DoraContainer/HBoxContainer/DoraTile3,
	$DoraContainer/HBoxContainer/DoraTile4,
	$DoraContainer/HBoxContainer/DoraTile5,
]
onready var _debug_info = $DebugInfo/Label
onready var _output_history = $OutputTiles/GridContainer
onready var _call_tile_buttons = [
	$CallTile/Buttons/Chow,
	$CallTile/Buttons/Pong,
	$CallTile/Buttons/Kong,
	$CallTile/Buttons/Win,
]
onready var _hand_tile_nodes = [
	$MarginContainer/HandTiles/TileNode1,
	$MarginContainer/HandTiles/TileNode2,
	$MarginContainer/HandTiles/TileNode3,
	$MarginContainer/HandTiles/TileNode4,
	$MarginContainer/HandTiles/TileNode5,
	$MarginContainer/HandTiles/TileNode6,
	$MarginContainer/HandTiles/TileNode7,
	$MarginContainer/HandTiles/TileNode8,
	$MarginContainer/HandTiles/TileNode9,
	$MarginContainer/HandTiles/TileNode10,
	$MarginContainer/HandTiles/TileNode11,
	$MarginContainer/HandTiles/TileNode12,
	$MarginContainer/HandTiles/TileNode13,
	$MarginContainer/HandTiles/TileNodeInput,
]


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready() -> void:
	for tile_node in _hand_tile_nodes:  # 启用手牌交互按钮
		tile_node.connect("tile_released", self, "_on_TileNode_released")
	for dora_node in _dora_tile_nodes:  # 初始化宝牌指示器
		dora_node.material.set_shader_param("active", true)
#	adapt_hand_tiles([110, 190, 210, 290, 310, 390, 410, 420, 430, 440, 450, 460, 470, 470])


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################
func adapt_known_dora(tiles: Array) -> void:  # 渲染宝牌指示器
	for i in range(len(tiles)):
		_dora_tile_nodes[i].tile_index = Mahjong.MAHJONG_INDEX[
				int(tiles[i] / 10)]
		_dora_tile_nodes[i].material.set_shader_param("active", false)
	for i in range(len(tiles), 5):  # 隐藏未知的宝牌指示器
		_dora_tile_nodes[i].material.set_shader_param("active", true)


func adapt_hand_tiles(tiles: Array) -> void:  # 渲染手牌
	for i in range(len(tiles)):
		_hand_tile_nodes[i].tile_index = Mahjong.MAHJONG_INDEX[
				int(tiles[i] / 10)]
		_hand_tile_nodes[i].visible = true
	for i in range(len(tiles), len(_hand_tile_nodes)):  # 隐藏多余的手牌栏位
		_hand_tile_nodes[i].visible = false


func discard_tile(hand_index: int) -> void:
	if len(hand_tiles) % 3 == 2:
		_debug_info.text = "打出 → 手牌[{0}]={1}".format([hand_index, hand_tiles[hand_index]])
		_hand_tile_nodes[hand_index]._sprite.position.y = 0
		var new_output = TILE_NODE.instance()
		new_output.tile_index = Mahjong.MAHJONG_INDEX[int(hand_tiles[hand_index] / 10)]
		_output_history.add_child(new_output)
		emit_signal("tile_discarded", hand_tiles[hand_index])


func call_tile(called_data: Dictionary) -> void:
	emit_signal("tile_called", called_data)


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################
func set_known_dora(tiles: Array) -> void:
	known_dora = tiles
	adapt_known_dora(tiles)


func set_hand_tiles(tiles: Array) -> void:
	hand_tiles = tiles
	adapt_hand_tiles(tiles)


func set_the_tile(tile: int) -> void:
	var options: Dictionary = Mahjong.check_call(hand_tiles, tile)
	if len(options) == 0:
		return
	print("[DEBUG]", options)
	if options.has(Mahjong.CALL.CHOW):
		_call_tile_buttons[Mahjong.CALL.CHOW].visible = true
	if options.has(Mahjong.CALL.PONG):
		_call_tile_buttons[Mahjong.CALL.PONG].visible = true
	if options.has(Mahjong.CALL.KONG):
		_call_tile_buttons[Mahjong.CALL.KONG].visible = true
	if options.has(Mahjong.CALL.WIN):
		_call_tile_buttons[Mahjong.CALL.WIN].visible = true


################################################################
# Callback methods 回调函数
################################################################
func _on_TileNode_released(hand_index) -> void:
	discard_tile(hand_index)


func _on_Chow_pressed() -> void:
	print("吃")


func _on_Pong_pressed() -> void:
	print("碰")


func _on_Kong_pressed() -> void:
	print("杠")


func _on_Win_pressed() -> void:
	print("和")
