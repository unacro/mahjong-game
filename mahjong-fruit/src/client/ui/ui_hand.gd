extends MarginContainer
# 手牌 UI 交互脚本


################################################################
# Signals 信号
################################################################
signal tile_clicked(hand_index)

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################

################################################################
# Exported variables 导出变量
################################################################
export(bool) var active: bool = false
export(bool) var visible_tiles: bool = false setget set_visible_tiles

################################################################
# Public variables 公共变量
################################################################
var hand_tiles: Array = [] setget set_hand_tiles

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _hand_tile_nodes = [
	$HBoxContainer/TileNode1,
	$HBoxContainer/TileNode2,
	$HBoxContainer/TileNode3,
	$HBoxContainer/TileNode4,
	$HBoxContainer/TileNode5,
	$HBoxContainer/TileNode6,
	$HBoxContainer/TileNode7,
	$HBoxContainer/TileNode8,
	$HBoxContainer/TileNode9,
	$HBoxContainer/TileNode10,
	$HBoxContainer/TileNode11,
	$HBoxContainer/TileNode12,
	$HBoxContainer/TileNode13,
	$HBoxContainer/TileNodeInput,
]
onready var _gap = $HBoxContainer/SeparatorGap


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready() -> void:
	if active:
		for i in len(_hand_tile_nodes):  # 初始化每一张麻将牌
			_hand_tile_nodes[i].hand_index = i
			_hand_tile_nodes[i].connect("tile_released", self, "_on_TileNode_released")
#	self.hand_tiles = [110, 190, 210, 290, 310, 390, 410, 420, 430, 440, 450, 460, 470, 470]


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _deferred_set_hand_tiles(tiles: Array) -> void:
	hand_tiles = tiles.duplicate()
	var hand_count: Array = [0, false]
	if len(tiles) % 3 == 2:
		hand_count[0] = len(tiles) - 1
		hand_count[1] = true
	else:
		hand_count[0] = len(tiles)
		hand_count[1] = false
	for i in range(hand_count[0]):  # 渲染持有的手牌
		if visible_tiles:
			_hand_tile_nodes[i].tile_index = MahjongBase.index_of(tiles[i])
		else:
			_hand_tile_nodes[i].tile_index = 34
		_hand_tile_nodes[i].visible = true
	for i in range(hand_count[0], 14):
		_hand_tile_nodes[i].visible = false  # 隐藏多余的手牌栏位
	if hand_count[1]:  # 渲染摸到的牌
		if visible_tiles:
			_hand_tile_nodes[13].tile_index = MahjongBase.index_of(tiles[hand_count[0]])
		else:
			_hand_tile_nodes[13].tile_index = 34
		_hand_tile_nodes[13].visible = true


################################################################
# Setter/Getter methods
################################################################
func set_hand_tiles(tiles: Array) -> void:
	call_deferred("_deferred_set_hand_tiles", tiles)


func set_visible_tiles(enable_xray: bool) -> void:
	visible_tiles = enable_xray
	call_deferred("_deferred_set_hand_tiles", hand_tiles)


################################################################
# Callback methods 回调函数
################################################################
func _on_TileNode_released(hand_index: int) -> void:
	if len(hand_tiles) % 3 == 2:
		_hand_tile_nodes[hand_index]._sprite.position.y = 0  # 取消 hover 特效
		emit_signal("tile_clicked", hand_tiles[hand_index])
