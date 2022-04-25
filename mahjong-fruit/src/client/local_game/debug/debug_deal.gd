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
var _echo_tile_value: bool = false
var _enable_continuous: bool = false
var _player_count: int = 4
var _banker_jump: bool = true
var _draw_stack_times: int = 3
var _draw_stack_count: int = 2
var _kong_times: int = 0
var _deck_sequence: String = "" setget set_deck_sequence

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _tile_value_btn = $MainPanel/HSplitContainer/ConsolePanel/CenterContainer/VBoxContainer/TileValueButton
onready var _player_count_ui = $MainPanel/HSplitContainer/ConsolePanel/CenterContainer/VBoxContainer/PlayerCount
onready var _stack_count_btn = $MainPanel/HSplitContainer/ConsolePanel/CenterContainer/VBoxContainer/DrawCount
onready var _kong_times_ui = $MainPanel/HSplitContainer/ConsolePanel/CenterContainer/VBoxContainer/KongTimes
onready var _deck_sequence_ui = {
	"label": $MainPanel/HSplitContainer/VSplitContainer/DeckPanel/CenterContainer/VBoxContainer/HBoxContainer/LineEdit,
	"md5": $MainPanel/HSplitContainer/VSplitContainer/DeckPanel/CenterContainer/VBoxContainer/HBoxContainer2/MD5Label,
}
onready var _deck_label = [
	$MainPanel/HSplitContainer/VSplitContainer/DeckPanel/CenterContainer/VBoxContainer/HBoxContainer3/RichTextLabel,
	$MainPanel/HSplitContainer/VSplitContainer/DeckPanel/CenterContainer/VBoxContainer/HBoxContainer4/RichTextLabel,
]
onready var _deck_count_ui = $MainPanel/HSplitContainer/VSplitContainer/DeckPanel/CenterContainer/VBoxContainer/HBoxContainer3/VBoxContainer/Label2
onready var _simulate_ui = $WindowDialog
onready var _hands_ui = $MainPanel/HSplitContainer/VSplitContainer/PlayerPanel/CenterContainer/VBoxContainer/RichTextLabel


class Faker:
	
	
	static func gen_ordered_num(length: int = 136) -> Array:
		var arr: Array = []
		for i in range(1, length + 1):
			arr.append(i)
		return arr
	
	
	static func gen_ordered_deck(enable_sequence: bool = true):
		var sequence: String = ""
		var suit: Array = ["m", "p", "s"]
		for i in range(3):
			for j in range(1, 10):
				for _k in range(4):
					sequence += "{0}{1}".format([j, suit[i]])
		for i in range(1, 8):
			for _j in range(4):
				sequence += "%dz" % i
		if enable_sequence:
			return sequence
		else:
			return MahjongBase.deserialize(sequence)


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	randomize()
	self._deck_sequence = MahjongBase.new_tile_walls(true)
	_render()


#func _process(delta):
#	pass


func _unhandled_key_input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_page_up"):
			_player_count_ui.value += 1
		elif Input.is_action_just_pressed("ui_page_down"):
			_player_count_ui.value -= 1
		elif Input.is_action_just_pressed("ui_home"):
			_kong_times_ui.value += 1
		elif Input.is_action_just_pressed("ui_end"):
			_kong_times_ui.value -= 1


#func _input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		match event.button_index:
#			BUTTON_WHEEL_UP:
#				_player_count_ui.value += 1
#			BUTTON_WHEEL_DOWN:
#				_player_count_ui.value -= 1


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _deal_tiles(player_index: int = -1):
	return MahjongBase.deal_tiles(_deck_sequence, player_index, _player_count,
			_banker_jump, _draw_stack_times, _draw_stack_count, _enable_continuous)


func _render():
	_deck_count_ui.text = "%d 张" % (len(_deal_tiles()) - _kong_times)
	var debug_data: Array = MahjongBase.get_debug_info(_deck_sequence, _kong_times, 69, _echo_tile_value)
	_deck_label[0].bbcode_text = debug_data[0]
	_deck_label[1].bbcode_text = debug_data[1]
	var temp_text: String = ""
	var colors: Array = [ "#d50000", "#ffd600", "#2962ff", "#00c853",
							"#aa00ff", "#ff6d00", "#00b8d4", "#c51162"]
	for i in range(_player_count):
		var hand: Array = _deal_tiles(i)
		var hand_text: String = "[color=%s][b]玩家%s[/b][/color]的手牌: " % [colors[i], char(ord("A") + i)]
		for j in range(len(hand)):
			if _echo_tile_value:
				hand_text += "[color=%s][u]%s [/u][/color]" % [colors[i], hand[j]]
			else:
				hand_text += "[color=%s][u]%s [/u][/color]" % [colors[i], MahjongBase.ord_at(hand[j])]
			if (j + 1) % (_draw_stack_count * 2) == 0:
				hand_text += "  "
		temp_text += "%s\n" % hand_text
	_hands_ui.bbcode_text = temp_text


################################################################
# Setter/Getter methods
################################################################
func set_deck_sequence(sequence: String) -> void:
	_deck_sequence = sequence
	_deck_sequence_ui["label"].text = sequence
	_deck_sequence_ui["md5"].text = "MD5: %s" % sequence.md5_text()


################################################################
# Callback methods 回调函数
################################################################
func _on_TileValueButton_toggled(button_pressed):
	_echo_tile_value = button_pressed
	_render()


func _on_UseIntButton_toggled(button_pressed):
	_enable_continuous = button_pressed
	_tile_value_btn.pressed = true
	_tile_value_btn.disabled = button_pressed
	_render()


func _on_PlayerCount_value_changed(value) -> void:
	_player_count = int(value)
	_render()


func _on_NotJumpButton_toggled(button_pressed) -> void:
	_banker_jump = not button_pressed
	_render()


func _on_DrawTimes_value_changed(value) -> void:
	_draw_stack_times = int(value)
	_render()


func _on_DrawCount_item_selected(index) -> void:
	_draw_stack_count = _stack_count_btn.get_item_id(index)
	_render()


func _on_KongTimes_value_changed(value) -> void:
	_kong_times = int(value)
	_render()


func _on_SimulateButton_pressed():
	_simulate_ui.popup_centered()


func _on_NewDeckButton_pressed() -> void:
	self._deck_sequence = MahjongBase.new_tile_walls(true)
	_render()


func _on_OrderDeckButton_pressed() -> void:
	self._deck_sequence = MahjongBase.serialize(MahjongBase.deserialize(Faker.gen_ordered_deck()))
	_render()


func _on_VerifyButton_pressed():
	OS.clipboard = _deck_sequence
	assert(OS.shell_open("https://www.queji.tw/cardsmd5/") == 0)
