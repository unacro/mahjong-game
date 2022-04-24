extends Control
# 玩家 UI


################################################################
# Signals 信号
################################################################
signal tile_discarded(tile_value)
signal tile_called(called_data)

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
var known_dora: Array = [] setget set_known_dora
var player_seat: int = 0 setget set_player_seat
var player_points: Array = [ 25000, 25000, 25000, 25000 ] setget set_player_points
var tiles_count: int = -1 setget set_tiles_count
var discard_history: Array = [] setget set_discard_history
var hand_tiles: Array = [] setget set_hand_tiles
var others_hands: Array = [] setget set_others_hands
var melds_info: Array = [] setget set_melds_info
var the_tile: int = -1 setget set_the_tile

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################
onready var _dora_tiles = $CenterInfo/Panel/DoraTiles
onready var _seat_info = [
	$CenterInfo/Panel/SeatInfoContainer/SeatInfo/SelfSeat,
	$CenterInfo/Panel/SeatInfoContainer/SeatInfo/NextSeat,
	$CenterInfo/Panel/SeatInfoContainer/SeatInfo/FrontSeat,
	$CenterInfo/Panel/SeatInfoContainer/SeatInfo/PrevSeat,
]
onready var _debug_info = $CenterInfo/Panel/MarginContainer/DebugInfo/Label
onready var _output_history = [
	$SelfDiscard,
	$NextDiscard,
	$FrontDiscard,
	$PrevDiscard,
]
onready var _call_tile_buttons = [
	$CallTileButtons/HBoxContainer/Richi,
	$CallTileButtons/HBoxContainer/Chow,
	$CallTileButtons/HBoxContainer/Pong,
	$CallTileButtons/HBoxContainer/Kong,
	$CallTileButtons/HBoxContainer/Win,
]
onready var _hand_tile_ui = $HandTiles
onready var _other_hand_ui = [
	$NextHand,
	$FrontHand,
	$PrevtHand,
]
onready var _melds_region = [
	$SelfMelds,
	$NextMelds,
	$FrontMelds,
	$PrevMelds,
]
onready var _tiles_count_label = $CenterInfo/Panel/MarginContainer/MetaInfoHbox/MetaInfoVBox/RemainTileCount
onready var _se_player = {
	"discard": $SoundEffect/Discard,
	"chow": $SoundEffect/Chow,
	"pong": $SoundEffect/Pong,
	"kong": $SoundEffect/Kong,
	"richi": $SoundEffect/Richi,
	"win": $SoundEffect/Win,
	"tsumo": $SoundEffect/WinBySelf,
}


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready() -> void:
	_hand_tile_ui.connect("tile_clicked", self, "_on_tile_clicked")


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################
func _render_seat_info() -> void:
	var t: Array = [ "东家", "南家", "西家", "北家" ]
	_seat_info[0].text = "%s: %d" % [t[player_seat], player_points[player_seat]]
	for i in range(3):
		var index: int = MahjongGame.next_player(player_seat, i + 1)
		_seat_info[i + 1].text = "%s: %d" % [t[index], player_points[index]]


################################################################
# Setter/Getter methods
################################################################
func set_known_dora(tiles: Array) -> void:
	known_dora = tiles
	_dora_tiles.dora = tiles


func set_player_seat(seat: int) -> void:
	player_seat = seat
	_render_seat_info()


func set_player_points(points: Array) -> void:
	player_points = points
	_render_seat_info()


func set_tiles_count(count: int) -> void:
	_tiles_count_label.text = "余牌: %d" % count


func set_discard_history(history: Array) -> void:
	discard_history = history  # 需要已经排好座次顺序的舍张记录
	for i in range(4):
#		print("[DEBUG] 玩家", i, " 舍张 ",  _output_history[i].discarded_tiles, " => ", history[i])
		_output_history[i].discarded_tiles = history[i]


func set_hand_tiles(tiles: Array) -> void:
	hand_tiles = tiles
	_hand_tile_ui.hand_tiles = tiles


func set_others_hands(hands: Array) -> void:
	assert(len(hands) == 3)  # 暂不考虑三人麻将
	others_hands = hands
	for i in range(len(hands)):
		_other_hand_ui[i].hand_tiles = hands[i]


func set_melds_info(melds: Array) -> void:
	assert(len(melds) == 4)
	melds_info = melds
	for i in range(len(melds)):
		_melds_region[i].melds = melds[i]


func set_the_tile(tile: int) -> void:
	var options: Dictionary = Mahjong.check_call(hand_tiles, tile)
	if len(options) == 0:
		return
	print("[DEBUG]", options)
	if options.has(Mahjong.CALL.RICHI):
		_call_tile_buttons[Mahjong.CALL.RICHI].visible = true
	if options.has(Mahjong.CALL.CHOW):
		_call_tile_buttons[Mahjong.CALL.CHOW].visible = true
	if options.has(Mahjong.CALL.PONG):
		_call_tile_buttons[Mahjong.CALL.PONG].visible = true
	if options.has(Mahjong.CALL.KONG):
		_call_tile_buttons[Mahjong.CALL.KONG].visible = true
	if options.has(Mahjong.CALL.WIN):
		_call_tile_buttons[Mahjong.CALL.WIN].visible = true


################################################################
# Callback methods 回调函数
################################################################
func _on_tile_clicked(discarded_tile: int) -> void:
	var t: Array = [ "东家", "南家", "西家", "北家" ]
	_debug_info.text = "{0}打出 → 手牌[{1}]={2}".format([t[player_seat],
			hand_tiles.find(discarded_tile), discarded_tile])
	_se_player["discard"].play()
	emit_signal("tile_discarded", discarded_tile)


func _on_Richi_pressed():
	_se_player["richi"].play()
	emit_signal("tile_called", { "type": Mahjong.CALL.RICHI, "data": [] })


func _on_Chow_pressed() -> void:
	var data: Dictionary = {
		"type": Mahjong.CALL.CHOW,
		"data": [],
	}
	_se_player["chow"].play()
	emit_signal("tile_called", data)


func _on_Pong_pressed() -> void:
	_se_player["pong"].play()
	emit_signal("tile_called", {"type": Mahjong.CALL.PONG})


func _on_Kong_pressed() -> void:
	_se_player["kong"].play()
	emit_signal("tile_called", {"type": Mahjong.CALL.KONG})


func _on_Win_pressed() -> void:
	if randi() % 2:
		_se_player["win"].play()
	else:
		_se_player["tsumo"].play()
	emit_signal("tile_called", {"type": Mahjong.CALL.WIN})
