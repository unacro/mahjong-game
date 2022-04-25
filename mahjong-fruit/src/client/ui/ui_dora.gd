extends MarginContainer
# 宝牌指示器


################################################################
# Signals 信号
################################################################

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################

################################################################
# Exported variables 导出变量
################################################################
export(float) var scale_multiple: float = 0.8

################################################################
# Public variables 公共变量
################################################################
var dora: Array = [] setget set_dora

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _dora_tiles = [
	$HboxContainer/Dora1,
	$HboxContainer/Dora2,
	$HboxContainer/Dora3,
	$HboxContainer/Dora4,
	$HboxContainer/Dora5,
]


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	rect_scale = Vector2(scale_multiple, scale_multiple)


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################
func set_dora(tiles: Array) -> void:
	dora = tiles
	for i in range(len(tiles)):
		_dora_tiles[i].tile_index = MahjongBase.index_of(tiles[i])
	for i in range(len(tiles), 5):
		_dora_tiles[i].tile_index = 34


################################################################
# Callback methods 回调函数
################################################################
