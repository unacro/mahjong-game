class_name Mahjong
extends Reference
# docstring 文档说明


################################################################
# Signals 信号
################################################################

################################################################
# Enums 枚举
################################################################
enum CALL { CHOW, PONG, KONG, WIN }  # 鸣牌: 吃 碰 杠 和
enum DORA { OUTER, INNER, RINSHAN, SEAFLOOR }  # 宝牌指示器 里宝 岭上 海底
enum HANDS {
	# Other special high-scoring hands
	COMMON_HAND = 11,  # 平和
	ALL_PONGS_KONGS = 31,  # 对对胡 三翻 ALL_IN_TRIPLETS
	CLEAN_HAND = 32,  # 混一色 三翻 MIXED_ONE_SUIT
	LITTLE_DRAGONS = 51,  # 小三元 五翻
	PURE_HAND = 61,  # 清一色 六翻 ALL_ONE_SUIT
	GREAT_DRAGONS = 81,  # 大三元 八翻
	WIN_BY_DOUBLE_KONG = 91,  # 杠上开花 九翻
	ALL_HONORS_TILES = 102,  # 字一色 十翻
	LITTLE_WINDS = 101,  # 小四喜 十翻
	# Limit Hands (Maximum number of fan agreed) 役满
	HEAVENLY_HAND = 1001,  # 天和
	EARTHLY_HAND = 1002,  # 地和
	SELF_TRIPLETS = 1003,  # 四暗刻
	ORPHANS = 1004,  # 清老头
	THIRTEEN_ORPHANS = 1005,  # 国士无双十三面(十三么)
	ALL_KONGS = 1006,  # 四杠子(十八罗汉)
	NINE_GATES_HAND = 1007,  # 九莲宝灯
	GREAT_WINDS = 1008,  # 大四喜
}
# 流局: 九种九牌 四风连打 四家立直 四杠散了
enum DRAWS { NINE_ORPHANS, QUADRA_WIND, QUADRA_RICHI, QUADRA_KONG }
enum MAHJONG {
	MAN_1A = 110,
	MAN_1B = 111,
	MAN_1C = 112,
	MAN_1D = 113,
	MAN_2A = 120,
	MAN_2B = 121,
	MAN_2C = 122,
	MAN_2D = 123,
	MAN_3A = 130,
	MAN_3B = 131,
	MAN_3C = 132,
	MAN_3D = 133,
	MAN_4A = 140,
	MAN_4B = 141,
	MAN_4C = 142,
	MAN_4D = 143,
	MAN_5A = 150,
	MAN_5B = 151,
	MAN_5C = 152,
	MAN_5D = 153,  # 赤五万
	MAN_6A = 160,
	MAN_6B = 161,
	MAN_6C = 162,
	MAN_6D = 163,
	MAN_7A = 170,
	MAN_7B = 171,
	MAN_7C = 172,
	MAN_7D = 173,
	MAN_8A = 180,
	MAN_8B = 181,
	MAN_8C = 182,
	MAN_8D = 183,
	MAN_9A = 190,
	MAN_9B = 191,
	MAN_9C = 192,
	MAN_9D = 193,
	PIN_1A = 210,
	PIN_1B = 211,
	PIN_1C = 212,
	PIN_1D = 213,
	PIN_2A = 220,
	PIN_2B = 221,
	PIN_2C = 222,
	PIN_2D = 223,
	PIN_3A = 230,
	PIN_3B = 231,
	PIN_3C = 232,
	PIN_3D = 233,
	PIN_4A = 240,
	PIN_4B = 241,
	PIN_4C = 242,
	PIN_4D = 243,
	PIN_5A = 250,
	PIN_5B = 251,
	PIN_5C = 252,
	PIN_5D = 253,  # 赤五饼
	PIN_6A = 260,
	PIN_6B = 261,
	PIN_6C = 262,
	PIN_6D = 263,
	PIN_7A = 270,
	PIN_7B = 271,
	PIN_7C = 272,
	PIN_7D = 273,
	PIN_8A = 280,
	PIN_8B = 281,
	PIN_8C = 282,
	PIN_8D = 283,
	PIN_9A = 290,
	PIN_9B = 291,
	PIN_9C = 292,
	PIN_9D = 293,
	SO_1A = 310,
	SO_1B = 311,
	SO_1C = 312,
	SO_1D = 313,
	SO_2A = 320,
	SO_2B = 321,
	SO_2C = 322,
	SO_2D = 323,
	SO_3A = 330,
	SO_3B = 331,
	SO_3C = 332,
	SO_3D = 333,
	SO_4A = 340,
	SO_4B = 341,
	SO_4C = 342,
	SO_4D = 343,
	SO_5A = 350,
	SO_5B = 351,
	SO_5C = 352,
	SO_5D = 353,  # 赤五索
	SO_6A = 360,
	SO_6B = 361,
	SO_6C = 362,
	SO_6D = 363,
	SO_7A = 370,
	SO_7B = 371,
	SO_7C = 372,
	SO_7D = 373,
	SO_8A = 380,
	SO_8B = 381,
	SO_8C = 382,
	SO_8D = 383,
	SO_9A = 390,
	SO_9B = 391,
	SO_9C = 392,
	SO_9D = 393,
	ZI_1A = 410,  # 东风
	ZI_1B = 411,
	ZI_1C = 412,
	ZI_1D = 413,
	ZI_2A = 420,  # 南风
	ZI_2B = 421,
	ZI_2C = 422,
	ZI_2D = 423,
	ZI_3A = 430,  # 西风
	ZI_3B = 431,
	ZI_3C = 432,
	ZI_3D = 433,
	ZI_4A = 440,  # 北风
	ZI_4B = 441,
	ZI_4C = 442,
	ZI_4D = 443,
	ZI_5A = 450,  # 白板
	ZI_5B = 451,
	ZI_5C = 452,
	ZI_5D = 453,
	ZI_6A = 460,  # 发财
	ZI_6B = 461,
	ZI_6C = 462,
	ZI_6D = 463,
	ZI_7A = 470,  # 红中
	ZI_7B = 471,
	ZI_7C = 472,
	ZI_7D = 473,
}

################################################################
# Constants 常量
################################################################
const MAHJONG_INDEX = {
	11: 0,
	12: 1,
	13: 2,
	14: 3,
	15: 4,
	16: 5,
	17: 6,
	18: 7,
	19: 8,
	21: 9,
	22: 10,
	23: 11,
	24: 12,
	25: 13,
	26: 14,
	27: 15,
	28: 16,
	29: 17,
	31: 18,
	32: 19,
	33: 20,
	34: 21,
	35: 22,
	36: 23,
	37: 24,
	38: 25,
	39: 26,
	41: 27,
	42: 28,
	43: 29,
	44: 30,
	45: 31,
	46: 32,
	47: 33,
}

################################################################
# Exported variables 导出变量
################################################################

################################################################
# Public variables 公共变量
################################################################

################################################################
# Private variables 私有变量
################################################################

################################################################
# Onready variables 自动初始化变量
################################################################


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


#func _ready():
#	pass


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################
static func ord_at(tile: int) -> String:
	var suit: Array = ["m", "p", "s", "z"]
	if tile % 100 == 53 and tile < 400:
		# warning-ignore:integer_division
		return "0" + suit[int(tile / 100) - 1]
	else:
		# warning-ignore:integer_division
		# warning-ignore:integer_division
		return str(int(tile / 10) % 10) + suit[int(tile / 100) - 1]


static func serialize(tiles: Array) -> String:
	if typeof(tiles) != TYPE_ARRAY or len(tiles) < 1:
		return ""
	var tiles_sequence: String = ""
	match typeof(tiles[0]):
		TYPE_INT:
			for tile in tiles:
				tiles_sequence += ord_at(tile)
		TYPE_STRING:
			for tile in tiles:
				tiles_sequence += tile
		_:
			print("序列化牌序失败 输入参数的类型有误 ", typeof(tiles[0]), tiles[0])
	return tiles_sequence


static func deserialize(deck_sequence: String) -> Array:
	var deck: Array = []
	var suit: Dictionary = { "m": 100, "p": 200, "s": 300, "z": 400 }
	var count: Dictionary = {}
	# warning-ignore:integer_division
	for i in range(int(len(deck_sequence) / 2)):
		var tile = deck_sequence.substr(i * 2, 2)
		if tile.substr(0, 1) == "0":
			deck.append(suit[tile.substr(1, 1)] + 53)
		else:
			var index: int = suit[tile.substr(1, 1)] + int(
					tile.substr(0, 1)) * 10
			if not count.has(index):
				count[index] = 0
			else:
				count[index] += 1
			deck.append(index + count[index])
	return deck


static func new_deck(enable_sequence: bool = false):
	var new_deck: Array = []
	for tile in MAHJONG.values():
		new_deck.append(tile)
	new_deck.shuffle()
	if enable_sequence:
		return serialize(new_deck)
	else:
		return new_deck


static func deal(sequence: String, player: int = 0) -> Array:
	var deck: Array = deserialize(sequence)
	var hand: Array = []
	for i in range(3):
		hand.append_array(
				deck.slice(i * 16 + player * 4, i * 16 + player * 4 + 3))
	if player == 0:
		hand.append(deck[48])
		hand.append(deck[52])
	else:
		hand.append(deck[player + 48])
	hand.sort()
	return hand


static func get_dora(sequence: String, dora_type: int) -> Array:
	var deck: Array = deserialize(sequence)
	var dora: Array = []
	match dora_type:
		DORA.OUTER:
			dora = deck.slice(-13, -4, 2)
		DORA.INNER:
			dora = deck.slice(-14, -5, 2)
		DORA.RINSHAN:
			dora = deck.slice(-4, -1)
		DORA.SEAFLOOR:
			dora = deck.slice(-19, -15)
	dora.invert()
	return dora


static func check_win(tiles: Array) -> bool:
	if len(tiles) % 3 != 2:
		return false
	return false


static func check_call(hand: Array, tile: int) -> Dictionary:
	var options: Dictionary = {}
	# warning-ignore:integer_division
	var tile_value: int = int(tile / 10)
	var mark: Dictionary = {
		chow = [],
		pair = []
	}
	for hand_tile in hand:
		var t = int(hand_tile / 10)
		if hand_tile < 400:
			if t == tile_value - 2:
				mark.chow[0] = true
			if t == tile_value - 1:
				mark.chow[1] = true
			if t == tile_value + 1:
				mark.chow[2] = true
			if t == tile_value + 2:
				mark.chow[3] = true
		if t == tile_value:
			mark.pair.append(hand_tile)
			if len(mark.pair) == 3:
				options[CALL.KONG] = mark.pair.duplicate(true)
			elif len(mark.pair) == 2:
				options[CALL.PONG] = mark.pair.duplicate(true)
	options[CALL.PONG] = []
	if mark.chow[0] and mark.chow[1]:
		options[CALL.CHOW].append([mark.chow[0], mark.chow[1]])
	if mark.chow[1] and mark.chow[2]:
		options[CALL.CHOW].append([mark.chow[1], mark.chow[2]])
	if mark.chow[2] and mark.chow[3]:
		options[CALL.CHOW].append([mark.chow[2], mark.chow[3]])
	if len(options[CALL.PONG]) == 0:
		assert(options.erase(CALL.PONG))
	if check_win(hand):
		options[CALL.WIN] = true
	return options


################################################################
# Private methods 私有函数
################################################################
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


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
