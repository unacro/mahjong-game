extends Node
# 单元测试


enum UNIT_TEST_ITEM { DEAL, CHECK_WIN }

export(int) var test_mode: int = UNIT_TEST_ITEM.DEAL

onready var _label = $Control/MarginContainer/CenterContainer/VBoxContainer/PlayerLabel
onready var _player_count = $Control/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/PlayerCount


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
		for i in range(7):
			for _j in range(4):
				sequence += "%dz" % i
		if enable_sequence:
			return sequence
		else:
			return Mahjong.deserialize(sequence)
	
	
	static func gen_kongs_deck() -> String:
		var sequence: String = ""
		var suit: Array = ["m", "p", "s", "z"]
		for i in range(1, 8):
			for j in range(4):
				for _k in range(4):
					sequence += "{0}{1}".format([i, suit[j]])
		for i in range(8, 10):
			for j in range(3):
				for _k in range(4):
					sequence += "{0}{1}".format([i, suit[j]])
		return sequence


func _ready() -> void:
	test_mode = UNIT_TEST_ITEM.CHECK_WIN
	_test_check_win()


func _unhandled_key_input(event):
	if event is InputEventKey:
		if test_mode == UNIT_TEST_ITEM.DEAL:
			if Input.is_action_just_pressed("ui_up"):
				_player_count.value += 1
			elif Input.is_action_just_pressed("ui_down"):
				_player_count.value -= 1


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if test_mode == UNIT_TEST_ITEM.DEAL:
			match event.button_index:
				BUTTON_WHEEL_UP:
					_player_count.value += 1
				BUTTON_WHEEL_DOWN:
					_player_count.value -= 1


func _test_deal(player_count: int = 4) -> void:
	var fake_sequence = Faker.gen_ordered_deck()
	var colors: Array = ["#d50000", "#ffd600", "#2962ff", "#00c853", "#aa00ff", "#ff6d00", "#00b8d4", "#c51162"]
	var shan_pai: Array = Mahjong.deal(fake_sequence, -1, player_count)
	_label.bbcode_text = "山牌({0})为: ".format([len(shan_pai)])
	for i in shan_pai:
		_label.bbcode_text += "[color=#aeea00]{0}[/color] ".format([i])
	_label.bbcode_text += "\n"
	for i in range(player_count):
		_label.bbcode_text += "玩家 {0} 的手牌为: ".format([i])
		var t: Array = Mahjong.deal(fake_sequence, i, player_count)
		for j in range(len(t)):
			_label.bbcode_text += "[color={0}]{1}[/color] ".format([colors[i], t[j]])
			if j % 4 == 3:
				_label.bbcode_text += "  "
		_label.bbcode_text += "\n"


func _test_check_win() -> void:
	_label.bbcode_text = "测试和牌判定\n"
	var sample_hands: Array = [
#		"1m2m3m9m9m9m1p2p3p9p9p9p1s9s",
#		"9p9p1s2s3s9s9s9s1z1z1z7z7z7z",
		"1m2m3m5m6m7m1p2p3p5p6p7p2z2z",  # 11101110111011102
		"1m1m1m2m3m4m6m7m8m1z1z1z2z2z",  # 311101110302
		"1m1m1m2m2m2m2m3m3m3m3m4m4m4m",  # 3443
		"1m3m5m7m9m1p3p5p7p9p1z2z3z4z",  # 101010101010101010101010101
		"1m3m5m7m9m1s3s5s7s9s1z2z3z4z",  # 101010101010101010101010101
	]
	for i in range(len(sample_hands)):
		var can_win: bool = Mahjong.check_win(sample_hands[i])
		_label.bbcode_text += "第{0}副手牌 {1} 是否能和牌=".format(
				[i, sample_hands[i]])
		if can_win:
			_label.bbcode_text += "[color=#00c853]{0}[/color]\n".format([can_win])
		else:
			_label.bbcode_text += "[color=#d50000]{0}[/color]\n".format([can_win])


func _gen_enum_script() -> void:
	var suits: Array = [null, "MAN", "PIN", "SO", "ZI"]
	var indexes: Array = ["A", "B", "C", "D"]
	var text: String = ""
	for s in range(1, 5):
		for i in range(1, 10):
			for j in range(4):
				text += "	" + suits[s] + "_" + str(i) + indexes[j]
				text += " = " + str(s * 100 + i * 10 + j) + ",\n"
	OS.clipboard = text


func _gen_const_script() -> void:
	var text: String = ""
	var count: int = 0
	for i in range(1, 5):
		for j in range(1, 10):
			text += "	{0}: {1},\n".format([i * 10 + j, count])
			count += 1
	OS.clipboard = text
	print("生成的常量脚本已复制到剪切板")


func _on_PlayerCount_value_changed(value):
	_test_deal(int(value))
