extends MarginContainer
# 副露区 一组面子


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
export(float) var tile_gap: float = 2.0
export(float) var meld_gap: float = 20.0

################################################################
# Public variables 公共变量
################################################################
var melds: Array = [] setget set_melds

################################################################
# Private variables 私有变量
################################################################
var _texture_size: Vector2 = Vector2.ZERO
var _scale_multiple: float = 0.4
var _render_cursor: float = 0.0

################################################################
# Onready variables 自动初始化变量
################################################################


################################################################
# built-in virtual methods 内置的虚函数
################################################################
func _init():
	var sprite = TILE_SPRITE.instance()
	_texture_size = sprite.frames.get_frame("v2_80x112_38", 0).get_size()
	sprite.queue_free()


#func _ready():
#	_scale_multiple = rect_size.y / _texture_size.y


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _render_tile(tile_frame: int = 34, rotated: bool = false, plus: bool = false) -> void:
	var sprite = TILE_SPRITE.instance()
	sprite.scale = Vector2(_scale_multiple, _scale_multiple)
	sprite.frame = tile_frame
	if plus:
		sprite.rotation_degrees = -90
		sprite.position = Vector2(
				_render_cursor - _texture_size.y * _scale_multiple - tile_gap,
				(_texture_size.y - _texture_size.x) * _scale_multiple)
	elif rotated:
		sprite.rotation_degrees = -90
		sprite.position = Vector2(_render_cursor, _texture_size.y * _scale_multiple)
		_render_cursor += _texture_size.y * _scale_multiple + tile_gap
	else:
		sprite.position = Vector2(_render_cursor, 0)
		_render_cursor += _texture_size.x * _scale_multiple + tile_gap
	add_child(sprite)


func _render_meld(meld_data: Dictionary) -> void:
	if meld_data.empty():
		printerr("设置副露值时发生错误")
		queue_free()
	else:
		if meld_data["pick"].empty():  # 暗杠
			if meld_data["have"][0] > 400:
				_render_tile()
				_render_tile(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile()
			else:
				_render_tile(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile()
				_render_tile()
				_render_tile(MahjongBase.index_of(meld_data["have"][0]))
			pass
		elif len(meld_data["pick"]) == 2:  # 加杠
			match meld_data["mark"]:
				2:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["pick"][1]), true, true)
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
				3:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["pick"][1]), true, true)
				_:
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["pick"][1]), true, true)
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
		elif len(meld_data["have"]) == 3:  # 大明杠
			match meld_data["mark"]:
				2:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
					_render_tile(MahjongBase.index_of(meld_data["have"][2]))
				3:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
					_render_tile(MahjongBase.index_of(meld_data["have"][2]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
				_:
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
					_render_tile(MahjongBase.index_of(meld_data["have"][2]))
		elif int(meld_data["have"][0] / 10) == int(meld_data["pick"][0] / 10):  # 碰
			match meld_data["mark"]:
				2:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
				3:
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
				_:
					_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
					_render_tile(MahjongBase.index_of(meld_data["have"][0]))
					_render_tile(MahjongBase.index_of(meld_data["have"][1]))
		else:  # 吃
			_render_tile(MahjongBase.index_of(meld_data["pick"][0]), true)
			for tile in meld_data["have"]:
				_render_tile(MahjongBase.index_of(tile))
		_render_cursor += meld_gap


################################################################
# Setter/Getter methods
################################################################
func set_melds(new_melds: Array) -> void:
	melds = new_melds
	for meld_node in get_children():
		meld_node.queue_free()
	_render_cursor = 0.0
	for meld in new_melds:
		_render_meld(meld)


################################################################
# Callback methods 回调函数
################################################################
