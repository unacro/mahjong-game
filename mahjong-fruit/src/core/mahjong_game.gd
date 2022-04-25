class_name MahjongGame
extends Node
# Server 麻将游戏管理类
# 拥有整局游戏全部信息


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
var sequence_md5: String = ""
var kong_count: int = 0

################################################################
# Private variables 私有变量
################################################################
var _deck_sequence: String = ""
var _tiles_wall: Array = []
var _player_list: Array = []

################################################################
# Onready variables 自动初始化变量
################################################################


class Player:
	var hand: Array = []  # 手牌
	var gate: Array = []  # 副露区
	var input: Array = []  # 进张
	var output: Array = []  # 舍张
	
	func _init(tiles: Array) -> void:
		tiles.sort()
		hand = tiles
	
	func discard(tile: int) -> void:
		output.append(tile)
		hand.remove(hand.find(tile))
		hand.sort()
		print("[DEBUG] 打出=", tile, " 剩余", len(hand), "手牌=", hand)
	
	func draw(tile: int) -> void:
		input.append(tile)
		hand.append(tile)
		print("[DEBUG] 摸到=", tile, " 当前", len(hand), "手牌=", hand)


################################################################
# built-in virtual methods 内置的虚函数
################################################################
func _init():
	randomize()
	_deck_sequence = MahjongBase.new_tile_walls(true)
	sequence_md5 = _deck_sequence.md5_text()
	_tiles_wall = MahjongBase.deal_tiles(_deck_sequence, -1)
	for i in range(4):
		_player_list.append(Player.new(MahjongBase.deal_tiles(_deck_sequence, i)))


#func _ready():
#	pass


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################
static func next_player(index: int, offset: int = 1, count: int = 4) -> int:
	return (index + offset) % count


func get_player(player_index: int):
	return _player_list[player_index]


func get_dora(dora_type: int):
	return MahjongBase.get_dora(_deck_sequence, dora_type, kong_count)


func get_tiles_count() -> int:
	return len(_tiles_wall)


func get_discard_history() -> Array:
	# TODO 将进张/舍张记录移出 玩家类
	var history: Array = []
	for i in range(len(_player_list)):
		history.append(_player_list[i].output)
	return history


func get_melds_data() -> Array:
	# TODO 将副露信息移出 玩家类
	var melds_data: Array = []
	for i in range(len(_player_list)):
		melds_data.append(_player_list[i].gate)
	return melds_data


func deal(player_index: int) -> void:
	_player_list[player_index].draw(_tiles_wall.pop_front())


func temp_debug_deck():
	var temp: Array = [len(_tiles_wall)]
	temp.append_array(MahjongBase.get_debug_info(_deck_sequence, kong_count, temp[0]))
	return "本局山牌({0}): {1}\n本局王牌(14): {2}".format(temp)


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
