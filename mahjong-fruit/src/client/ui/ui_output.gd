extends MarginContainer
# docstring 文档说明


################################################################
# Signals 信号
################################################################

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################
const TILE_SPRITE = preload("res://src/client/ui/ui_tile_sprite.tscn")

################################################################
# Exported variables 导出变量
################################################################
export(int) var line_count: int = 10
export(float) var tile_scale: float = 0.38

################################################################
# Public variables 公共变量
################################################################
var discarded_tiles: Array = [] setget set_discarded_tiles

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


#func _ready():
#	pass


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _render_tile(tile_value: int, render_index: int = 0) -> void:
	var tile_node = TILE_SPRITE.instance()
	tile_node.scale = Vector2(tile_scale, tile_scale)
	# warning-ignore:integer_division
	tile_node.position = Vector2((render_index % line_count) * 32,
			int(render_index / line_count) * 45)
	tile_node.frame = Mahjong.index_of(tile_value)
	add_child(tile_node)


func _clear_tiles() -> void:
#	print("[DEBUG] 切换玩家身份 清空舍张历史记录")
	for tile_node in get_children():
		tile_node.queue_free()


################################################################
# Setter/Getter methods
################################################################
func set_discarded_tiles(new_history: Array) -> void:
	new_history = new_history.duplicate(true)
	var last_discarded_tile: int = -1
	var render_index: int = 0
	if new_history.empty():
		if not discarded_tiles.empty():
			_clear_tiles()
	else:
		last_discarded_tile = new_history.pop_back()
		if discarded_tiles != new_history:  # Array.hash()有几率(无论多小)产生碰撞 而且多了运算量
			_clear_tiles()
			for i in range(len(new_history)):
				_render_tile(new_history[i], i)
		render_index = len(new_history)
		new_history.append(last_discarded_tile)
	discarded_tiles = new_history
	if last_discarded_tile > 0:
		_render_tile(last_discarded_tile, render_index)


################################################################
# Callback methods 回调函数
################################################################
