extends MarginContainer
# 单张麻将牌


################################################################
# Signals 信号
################################################################
signal tile_released(hand_index)

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################

################################################################
# Exported variables 导出变量
################################################################
export(int) var tile_index: int = 34 setget set_tile_index  # 默认为牌背
export(int) var hand_index: int = -1  # 手牌序号
export(int) var clickable_offset: float = 20.0  # hover 凸出显示的偏移量

################################################################
# Public variables 公共变量
################################################################

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _sprite = $TileSprite


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	_sprite.scale = rect_size / _sprite.frames.get_frame(
			"v2_80x112_38", 0).get_size()  # 自动缩放图片素材以适应容器大小


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _deferred_set_tile_img(img_index: int) -> void:
	_sprite.frame = img_index


################################################################
# Setter/Getter methods
################################################################
func set_tile_index(p_index: int) -> void:
	tile_index = p_index
	call_deferred("_deferred_set_tile_img", p_index)


################################################################
# Callback methods 回调函数
################################################################
func _on_TileSprite_mouse_entered():  # 显示 hover 特效
	if hand_index >= 0:
#		rect_global_position.y -= clickable_offset  # FIXME: 光标从可选区域下方移出会导致不停重复判定进出
		_sprite.position.y -= clickable_offset


func _on_TileSprite_mouse_exited():  # 取消 hover 特效
	if hand_index >= 0:
#		rect_global_position.y += clickable_offset
		_sprite.position.y = 0


func _on_TileSprite_gui_input(event):
	if hand_index >= 0:
		if event is InputEventMouseButton and not event.pressed:
			var pos = rect_size - event.position
			if pos.x < rect_size.x and pos.y < rect_size.y:
				if pos.x > 0 and pos.y > 0:
					# 这里已经丢失具体麻将牌的身份信息了(只知道是什么牌不知道是哪张牌) 因此只能
					emit_signal("tile_released", hand_index)  # 发送信号 打出第几张手牌
#	match event.get_class():
#		"InputEventMouseButton":
#			emit_signal("tile_released", index)
#		_:
#			pass  #print(event.as_text())
