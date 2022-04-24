extends Node
# 客户端数据中心


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
var game = null
var player_index: int = -1 setget set_player_index

################################################################
# Private variables 私有变量
################################################################
var _player_class = null

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _play_space = $PlaySpace


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	_play_space.connect("tile_discarded", self, "_on_tile_discarded")
	_play_space.connect("tile_called", self, "_on_tile_called")
	self.player_index = 0
	new_game()


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################
func new_game() -> void:
	game = MahjongGame.new()
	_play_space.known_dora = game.get_dora(Mahjong.DORA.OUTER)
	_player_class = game.get_player(player_index)
	_play_space.player_points = [ 25000, 25000, 25000, 25000 ]
	_play_space.hand_tiles = _player_class.hand
	_play_space.tiles_count = game.get_tiles_count()
	_render_others_hand()
	_render_melds()
	_render_discard_histroy()
	$DebugInfo/MD5.text = "MD5: " + game.sequence_md5
	$DebugConsole/Deck.bbcode_text = game.temp_debug_deck()
	$DebugConsole/WindowDialog/MarginContainer/GridContainer/KongTimes.value = 0


################################################################
# Private methods 私有函数
################################################################
func _render_others_hand() -> void:
	var other_hands: Array = []
	for i in range(1, 4):  # TODO 实际应该抹除具体手牌信息
		other_hands.append(game._player_list[game.next_player(player_index, i)].hand)
	_play_space.others_hands = other_hands


func _render_discard_histroy() -> void:
	var history: Array = game.get_discard_history()
	var temp: Array = []
	for i in range(len(history)):
		if i == player_index:
			break
		else:
			temp.append(history.pop_front())
	history.append_array(temp)
	_play_space.discard_history = history


func _render_melds() -> void:
	var melds_data: Array = game.get_melds_data()
	var temp: Array = []
	for i in range(len(melds_data)):
		if i == player_index:
			break
		else:
			temp.append(melds_data.pop_front())
	melds_data.append_array(temp)
	_play_space.melds_info = melds_data


################################################################
# Setter/Getter methods
################################################################
func set_player_index(seat: int) -> void:
	player_index = seat
	_play_space.player_seat = seat


################################################################
# Callback methods 回调函数
################################################################
func _on_tile_discarded(tile_value) -> void:
	_player_class.discard(tile_value)
	_play_space.hand_tiles = _player_class.hand
	_render_discard_histroy()


func _on_tile_called(data: Dictionary) -> void:
	match data["type"]:
		Mahjong.CALL.WIN:
			print("玩家%d 选择 和牌" % player_index)
		Mahjong.CALL.KONG:
			print("玩家%d 选择 杠" % player_index)
		Mahjong.CALL.PONG:
			print("玩家%d 选择 碰" % player_index)
		Mahjong.CALL.CHOW:
			print("玩家%d 选择 吃" % player_index)
		Mahjong.CALL.RICHI:
			print("玩家%d 选择 立直" % player_index)


func _on_MD5_pressed():
	OS.clipboard = game._deck_sequence
	assert(OS.shell_open("https://www.queji.tw/cardsmd5/#" + game._deck_sequence) == 0)


func _on_NewGame_pressed():
	new_game()


func _on_KongTimes_value_changed(value):
	game.kong_count = int(value)
	_play_space.known_dora = game.get_dora(Mahjong.DORA.OUTER)
	$DebugConsole/Deck.bbcode_text = game.temp_debug_deck()


func _on_PlayerIndex_item_selected(index):
	self.player_index = index
	_player_class = game.get_player(player_index)
	_play_space.hand_tiles = _player_class.hand
	_render_others_hand()
	_render_melds()
	_render_discard_histroy()


func _on_Draw_pressed():
	if len(_player_class.hand) < 14:
		game.deal(player_index)
		_play_space.hand_tiles = _player_class.hand
		$DebugConsole/Deck.bbcode_text = game.temp_debug_deck()
		_play_space.tiles_count = game.get_tiles_count()
	else:
		print("[DEBUG] 摸牌失败 手牌已经满了")


func _on_XRayButton_toggled(button_pressed):
	for i in range(3):
		_play_space._other_hand_ui[i].visible_tiles = button_pressed
