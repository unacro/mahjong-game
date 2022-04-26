extends Control
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

################################################################
# Exported variables 导出变量
################################################################

################################################################
# Public variables 公共变量
################################################################

################################################################
# Private variables 私有变量
################################################################
var _random_melds_count: bool = true
var _meld_count: int = 0
var _is_tsumo: bool = false
var _is_banker: bool = false
var _dora: Array = []

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _input_line = get_node_or_null("VSplitContainer/TopPanel/VBoxContainer/HBoxContainer/LineEdit")
onready var _hand_render_region = get_node_or_null("VSplitContainer/TopPanel/HandTiles")
onready var _dora_render_region = get_node_or_null("VSplitContainer/TopPanel/DoraTiles")
onready var _result_stamp = [
	get_node_or_null("VSplitContainer/TopPanel/NotRonStamp"),
	get_node_or_null("VSplitContainer/TopPanel/RonStamp"),
	get_node_or_null("VSplitContainer/TopPanel/ErrorInfo"),
]
onready var _meld_count_btn = get_node_or_null("VSplitContainer/TopPanel/VBoxContainer/HBoxContainer/MeldCount")


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	pass


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _render_stamp(is_ron: bool = true, hidden: bool = false):
	var random_offset: Array = [
		Vector2(745, 115) + Vector2(randi() % 10, randi() % 10),
		- (randi() % 15 + 15),
	]
	if is_ron:
		_result_stamp[1].rect_position = random_offset[0]
		_result_stamp[1].rect_rotation = random_offset[1]
	else:
		_result_stamp[0].rect_position = random_offset[0]
		_result_stamp[0].rect_rotation = random_offset[1]
	if hidden:
		_hand_render_region.visible = false
		_result_stamp[0].visible = false
		_result_stamp[1].visible = false
		_result_stamp[2].visible = true
	else:
		_hand_render_region.visible = true
		_result_stamp[0].visible = not is_ron
		_result_stamp[1].visible = is_ron
		_result_stamp[2].visible = false


func _render(text: String):
	text = text.strip_edges().replace(" ", "").to_lower()
	if text.empty():
		return false
	var hand: Array = []
	var melds: Array = []
	if "." in text:
		var temp: Array = text.split(".")
		text = temp.pop_front()
		for meld_data in MahjongBase.deserialize_meld(temp):
			if meld_data != null:
				melds.append(meld_data)
	hand = MahjongBase.deserialize(text)
	if not hand.empty():
		var temp: int = hand.pop_back()
		hand.sort()
		hand.append(temp)
	if len(hand) % 3 == 2:
		_hand_render_region.melds = melds
		_hand_render_region.hand_tiles = hand
		var temp: Array = MahjongBase.serialize_meld(melds)
		var melds_str: String = "" if temp.empty() else " . %s" % Utils.array_join(temp, " . ")
		_input_line.text = MahjongBase.serialize(hand) + melds_str
		if MahjongBase.can_win(hand):
			_render_stamp(true)
		else:
			_render_stamp(false)
		return true
	else:
		_result_stamp[2].bbcode_text = "[center][color=#1e88e5]%s[/color] → 解析 → [color=#43a047]%s[/color]\n[color=#e53935]Error: 手牌数量错误(%d)[/color][/center]" % [
				_input_line.text, MahjongBase.serialize(hand), len(hand) ]
		_render_stamp(false, true)
		return false


func _test():
	var sample_hands: Array = [
#		"1m2m3m9m9m9m1p2p3p9p9p9p1s9s",
#		"9p9p1s2s3s9s9s9s1z1z1z7z7z7z",
		"1m2m3m5m6m7m1p2p3p5p6p7p2z2z",  # 11101110111011102
		"1m1m1m2m3m4m6m7m8m1z1z1z2z2z",  # 311101110302
		"1m1m1m2m2m2m2m3m3m3m3m4m4m4m",  # 3443
		"1m3m5m7m9m1p3p5p7p9p1z2z3z4z",  # 101010101010101010101010101
		"1m3m5m7m9m1s3s5s7s9s1z2z3z4z",  # 101010101010101010101010101
	]
	var temp_text: String = ""
	for i in range(len(sample_hands)):
		var can_win: bool = MahjongBase.can_win(sample_hands[i])
		temp_text += "第%d副手牌 %s 是否能和牌=" % [i, sample_hands[i]]
		if can_win:
			temp_text += "[color=#00c853]{0}[/color]\n".format([can_win])
		else:
			temp_text += "[color=#d50000]{0}[/color]\n".format([can_win])
	print(temp_text)


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
func _on_LineEdit_text_entered(new_text):
	if not _render(str(new_text)):
		print("输入的字符串非法 渲染失败")


func _on_ConfirmButton_pressed():
	if not _render(_input_line.text):
		print("输入的字符串非法 渲染失败")


func _on_LineEdit_text_changed(new_text):
	_dora = MahjongBase.deserialize(new_text)
	_dora_render_region.dora = _dora


func _on_RandomButton_pressed():
	var result: Dictionary = {}
	if _random_melds_count:
		result = MahjongFaker.gen_random_hand()
	else:
		result = MahjongFaker.gen_random_hand(_meld_count)
	var temp: Array = MahjongBase.serialize_meld(result["meld"])
	var melds_str: String = "" if temp.empty() else " . %s" % Utils.array_join(temp, " . ")
	_input_line.text = MahjongBase.serialize(result["hand"]) + melds_str
	assert(_render(_input_line.text))


func _on_MeldCount_value_changed(value):
	_meld_count = int(value)


func _on_RandomMeldsCount_toggled(button_pressed):
	_random_melds_count = button_pressed


func _on_TsumoButton_toggled(button_pressed):
	_is_tsumo = button_pressed


func _on_BankerButton_toggled(button_pressed):
	_is_banker = button_pressed
