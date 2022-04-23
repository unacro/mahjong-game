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
	_deck_sequence = Mahjong.new_deck(true)
	sequence_md5 = _deck_sequence.md5_text()
	_tiles_wall = Mahjong.deal(_deck_sequence, -1)
	for i in range(4):
		_player_list.append(Player.new(Mahjong.deal(_deck_sequence, i)))


#func _ready():
#	pass


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################
func get_player(player_index: int):
	return _player_list[player_index]


func get_dora(dora_type: int):
	var dora: Array = Mahjong.get_dora(_deck_sequence, dora_type)
	match dora_type:
		Mahjong.DORA.OUTER:  # 宝牌指示器 杠宝牌指示器
			return dora.slice(0, kong_count)
		Mahjong.DORA.INNER:  # 里宝牌指示器 杠里宝牌指示器
			return dora.slice(0, kong_count)
		Mahjong.DORA.RINSHAN:  # 岭上牌
			return dora[kong_count - 1]
		Mahjong.DORA.SEAFLOOR:  # 海底牌
			return dora[kong_count]
	return null


func get_tiles_count() -> int:
	return len(_tiles_wall)


func deal(player_index: int) -> void:
	_player_list[player_index].draw(_tiles_wall.pop_front())


func temp_debug_deck():
	var deck: Array = Mahjong.deserialize(_deck_sequence)
	var full_tiles_wall: Array = Mahjong.deal(_deck_sequence, -1)
	var shan_pai: String = ""
	for i in range(len(full_tiles_wall)):
		if i > 63:
			if i < 68 - kong_count:
				shan_pai += "%d " % full_tiles_wall[i]
			elif i == 68 - kong_count:
				shan_pai += "[color=#2196f3][u]%d[/u][/color] " % full_tiles_wall[i]
			else:
				shan_pai += "[color=#82b1ff][s]%d[/s][/color] " % full_tiles_wall[i]
		elif i < len(full_tiles_wall) - len(_tiles_wall):
			shan_pai += "[color=#9e9e9e][s]%d[/s][/color] " % full_tiles_wall[i]
		elif i == len(full_tiles_wall) - len(_tiles_wall):
			shan_pai += "[color=#00bcd4][u]%d[/u][/color] " % full_tiles_wall[i]
		else:
			shan_pai += "%d " % full_tiles_wall[i]
	var full_ace: Array = deck.slice(122, 136)
	var wang_pai: String = ""
	for i in range(len(full_ace)):
		if i < 10:
			if i % 2 == 0:
				if i < 8 - kong_count * 2:
					wang_pai += "[color=#ff8a80]%d[/color] " % full_ace[i]
				else:
					wang_pai += "[color=#f44336][u]%d[/u][/color] " % full_ace[i]
			else:
				if i < 8 - kong_count * 2:
					wang_pai += "[color=#ffff8d]%d[/color] " % full_ace[i]
				else:
					wang_pai += "[color=#ffeb3b][u]%d[/u][/color] " % full_ace[i]
		else:
			if i < 13 - kong_count:
				wang_pai += "[color=#4caf50]%d[/color] " % full_ace[i]
			elif i == 13 - kong_count:
				wang_pai += "[color=#4caf50][u]%d[/u][/color] " % full_ace[i]
			else:
				wang_pai += "[color=#b9f6ca][s]%d[/s][/color] " % full_ace[i]
	return "本局山牌({0}): {1}\n本局王牌(14): {2}".format([
			len(_tiles_wall), shan_pai, wang_pai])
################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
