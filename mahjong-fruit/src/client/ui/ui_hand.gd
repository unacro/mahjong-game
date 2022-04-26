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
const TILE_SPRITE = preload("res://src/client/ui/ui_tile_sprite.tscn")

################################################################
# Exported variables 导出变量
################################################################
export(bool) var active: bool = false
export(bool) var visible_tiles: bool = false setget set_visible_tiles
export(float) var tile_gap: float = 2.0
export(float) var meld_gap: float = 15.0

################################################################
# Public variables 公共变量
################################################################
var hand_tiles: Array = [] setget set_hand_tiles
var melds: Array = [] setget set_melds

################################################################
# Private variables 私有变量
################################################################
var _texture_size: Vector2 = Vector2.ZERO
var _scale_multiple: float = 0.5
var _render_cursor: float = 0.0

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _hand_tile_box = $OuterVBox/InnerVBox
onready var _hand_tile_nodes = [
	$OuterVBox/InnerVBox/TileNode1,
	$OuterVBox/InnerVBox/TileNode2,
	$OuterVBox/InnerVBox/TileNode3,
	$OuterVBox/InnerVBox/TileNode4,
	$OuterVBox/InnerVBox/TileNode5,
	$OuterVBox/InnerVBox/TileNode6,
	$OuterVBox/InnerVBox/TileNode7,
	$OuterVBox/InnerVBox/TileNode8,
	$OuterVBox/InnerVBox/TileNode9,
	$OuterVBox/InnerVBox/TileNode10,
	$OuterVBox/InnerVBox/TileNode11,
	$OuterVBox/InnerVBox/TileNode12,
	$OuterVBox/InnerVBox/TileNode13,
	$OuterVBox/InnerVBox/TileNodeInput,
]
onready var _melds_box = $OuterVBox/MeldsContainer


################################################################
# built-in virtual methods 内置的虚函数
################################################################
func _init():
	var sprite = TILE_SPRITE.instance()
	_texture_size = sprite.frames.get_frame("v2_80x112_38", 0).get_size()
	sprite.queue_free()


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
func _render_tile_sprite(tile_frame: int = 34, rotated: bool = false, plus: bool = false) -> void:
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
	_melds_box.add_child(sprite)


func _render_meld(meld_data: Dictionary) -> void:
	if meld_data.empty():
		printerr("副露数据为空")
		return
	if meld_data["pick"].empty():  # 暗杠
		if meld_data["have"][0] > 400:
			_render_tile_sprite()
			_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
			_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
			_render_tile_sprite()
		else:
			_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
			_render_tile_sprite()
			_render_tile_sprite()
			_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
		pass
	elif len(meld_data["pick"]) == 2:  # 加杠
		match meld_data["mark"]:
			2:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][1]), true, true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
			3:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][1]), true, true)
			_:
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][1]), true, true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
	elif len(meld_data["have"]) == 3:  # 大明杠
		match meld_data["mark"]:
			2:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][2]))
			3:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][2]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
			_:
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][2]))
	elif int(meld_data["have"][0] / 10) == int(meld_data["pick"][0] / 10):  # 碰
		match meld_data["mark"]:
			2:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
			3:
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
			_:
				_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][0]))
				_render_tile_sprite(MahjongBase.index_of(meld_data["have"][1]))
	else:  # 吃
		_render_tile_sprite(MahjongBase.index_of(meld_data["pick"][0]), true)
		for tile in meld_data["have"]:
			_render_tile_sprite(MahjongBase.index_of(tile))
	_render_cursor += meld_gap


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
	if len(tiles) <= 14:
		hand_tiles = tiles
		call_deferred("_deferred_set_hand_tiles", tiles)
	else:
		printerr("手牌数量(%d)超出限制(<= 14) 渲染失败" % len(tiles))


func set_visible_tiles(enable_xray: bool) -> void:
	visible_tiles = enable_xray
	call_deferred("_deferred_set_hand_tiles", hand_tiles)


func set_melds(new_melds: Array) -> void:
	melds = new_melds
	for meld_node in _melds_box.get_children():
		meld_node.queue_free()
	_render_cursor = 0.0
	for meld in new_melds:
		_render_meld(meld)
	_melds_box.rect_min_size.x = _render_cursor


################################################################
# Callback methods 回调函数
################################################################
func _on_TileNode_released(hand_index: int) -> void:
	if len(hand_tiles) % 3 == 2:
		_hand_tile_nodes[hand_index]._sprite.position.y = 0  # 取消 hover 特效
		emit_signal("tile_clicked", hand_tiles[hand_index])
