class_name MahjongBase
extends Reference
# 麻将基础类


################################################################
# Signals 信号
################################################################

################################################################
# Enums 枚举
################################################################
enum MAP_METHOD { LONG, STANDARD, SHORT }
enum CALL { RICHI, CHOW, PONG, KONG, WIN }  # 鸣牌: 立直 吃 碰 杠 和
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
enum TILE_VALUE {
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
const TILE_INDEX = {
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
static func index_of(tile: int) -> int:
	# warning-ignore:integer_division
	var index = int(tile / 10)
	if tile % 100 == 53 and tile < 400:
		# warning-ignore:integer_division
		return int(tile / 100) + 34  # 赤宝牌
	elif TILE_INDEX.has(index):
		return TILE_INDEX[index]
	return 34


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


static func new_tile_walls(enable_sequence: bool = false):
	var new_deck: Array = []
	for tile in TILE_VALUE.values():
		new_deck.append(tile)
	new_deck.shuffle()
	if enable_sequence:
		return serialize(new_deck)
	else:
		return new_deck


# sequence 根据牌序发放手牌
# player_index 玩家序号非法则返回山牌序列
# player_count 兼容两家 / 三家 / 五家及以上等非常规玩家数量
# jump 允许庄家最后一张平跳
# stack_times 允许每家 7 张而不是 13 张
# stack_count 允许每次拿 1 墩而不是 2 墩
static func deal_tiles(sequence: String,
			player_index: int, player_count: int = 4,
			jump: bool = true, stack_times: int = 3, stack_count: int = 2,
			enable_debug: bool = false) -> Array:
	if player_count < 2:
		printerr("非法的玩家数量 %d" % player_count)
		return []
	var deck: Array = deserialize(sequence)
	if enable_debug:
		deck = []
		for i in range(1, 137):
			deck.append(i)
	var jump_distance: int = 4 if jump else 2
	if player_index >= 0 and player_index < player_count:
		var hand: Array = []
		for i in range(stack_times):
			hand.append_array(deck.slice(
					(i * player_count + player_index) * (stack_count * 2),
					(i * player_count + player_index + 1) * (stack_count * 2) - 1))
		if player_index == 0:
			hand.append(deck[player_count * stack_times * stack_count * 2 + player_index])
			hand.append(deck[player_count * stack_times * stack_count * 2 + jump_distance])
		elif player_index < jump_distance:
			hand.append(deck[player_count * stack_times * stack_count * 2 + player_index])
		else:
			hand.append(deck[player_count * stack_times * stack_count * 2 + player_index + 1])
		return hand  # 返回手牌
	else:
		var tile_walls: Array = []
		# warning-ignore:narrowing_conversion
		var temp = deck.slice(
				player_count * stack_times * stack_count * 2 + max(player_count, jump_distance) + 1,
				len(deck) - 15)  # 没有根据开杠数量计算海底牌 出去自行处理
		if player_count < jump_distance:
			tile_walls = deck.slice(
					player_count * stack_times * stack_count * 2 + player_count,
					player_count * stack_times * stack_count * 2 + jump_distance - 1)
			tile_walls.append_array(temp)
		else:
			tile_walls = temp
		return tile_walls  # 返回山牌


# 严格来说这个算法是错误的(与现实相悖)
# 比如牌山是 1 3 5 7
#            2 4 6 8 这样排列的
# 正向是 12345678 没问题, 但逆向应该是 78563412 才对
# 这里与雀魂的算法对齐, 逆向视为 87654321
static func get_dora(sequence: String, dora_type: int, kong_count: int = 0):
	var deck: Array = deserialize(sequence)
	var dora: Array = []
	match dora_type:
		DORA.OUTER:  # 宝牌指示器 杠宝牌指示器
			dora = deck.slice(-13, -4, 2)
			dora.invert()
			return dora.slice(0, kong_count)
		DORA.INNER:  # 里宝牌指示器 杠里宝牌指示器
			dora = deck.slice(-14, -5, 2)
			dora.invert()
			return dora.slice(0, kong_count)
		DORA.RINSHAN:  # 岭上牌
			dora = deck.slice(-4, -1)
			dora.invert()
			return dora[kong_count - 1]
		DORA.SEAFLOOR:  # 海底牌
			dora = deck.slice(-19, -15)
			dora.invert()
			return dora[kong_count]
	return null


static func can_win(tiles) -> bool:
	var hand: Array = []
	match typeof(tiles):
		TYPE_ARRAY:
			if len(tiles) % 3 == 2:
				hand = tiles.duplicate(true)
		TYPE_STRING:
			if len(tiles) % 6 == 4:
				hand = deserialize(tiles)
	if hand.empty():
		printerr("判断和牌失败 解析手牌数据时发生错误")
		return false
	
	print("[DEBUG] 手牌为=[%s]" % Utils.array_join(hand, " "))

	var map_res: Array = _map_tiles_to_count(hand)
#	print("[DEBUG] 映射为数量数组 ", Utils.array_join(_map_tiles_to_count(hand, MAP_METHOD.SHORT)))
	# warning-ignore:return_value_discarded
	_map_count_to_index(map_res)
	
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
	if can_win(hand):
		options[CALL.WIN] = true
	return options


static func get_debug_info(sequence: String, kong_count: int = 0,
			remain_count: int = 69, enable_tile_value: bool = false) -> Array:
	var full_tiles_wall: Array = deal_tiles(sequence, -1)
	var shan_pai: String = ""
	for i in range(len(full_tiles_wall)):
		var tile: String = ""
		if enable_tile_value:
			tile = "%d" % full_tiles_wall[i]
		else:
			tile = ord_at(full_tiles_wall[i])
		if i > 63:
			if i < 68 - kong_count:
				shan_pai += "%s " % tile
			elif i == 68 - kong_count:
				shan_pai += "[color=#2196f3][u]%s[/u][/color] " % tile
			else:
				shan_pai += "[color=#82b1ff][s]%s[/s][/color] " % tile
		elif i < len(full_tiles_wall) - remain_count:
			shan_pai += "[color=#9e9e9e][s]%s[/s][/color] " % tile
		elif i == len(full_tiles_wall) - remain_count:
			shan_pai += "[color=#00bcd4][u]%s[/u][/color] " % tile
		else:
			shan_pai += "%s " % tile
	var full_ace: Array = deserialize(sequence).slice(122, 136)
	var wang_pai: String = ""
	for i in range(len(full_ace)):
		var tile: String = ""
		if enable_tile_value:
			tile = "%d" % full_ace[i]
		else:
			tile = ord_at(full_ace[i])
		if i < 10:
			if i % 2 == 0:
				if i < 8 - kong_count * 2:
					wang_pai += "[color=#ea80fc]%s[/color] " % tile
				else:
					wang_pai += "[color=#9c27b0][u]%s[/u][/color] " % tile
			else:
				if i < 8 - kong_count * 2:
					wang_pai += "[color=#ffff8d]%s[/color] " % tile
				else:
					wang_pai += "[color=#ffeb3b][u]%s[/u][/color] " % tile
		else:
			if i < 13 - kong_count:
				wang_pai += "[color=#4caf50]%s[/color] " % tile
			elif i == 13 - kong_count:
				wang_pai += "[color=#4caf50][u]%s[/u][/color] " % tile
			else:
				wang_pai += "[color=#b9f6ca][s]%s[/s][/color] " % tile
	return [ shan_pai, wang_pai ]


################################################################
# Private methods 私有函数
################################################################
static func _map_count_to_index(count_map: Array, _pos: Array = []) -> int:
	var p: int = -1  # pointer 类似打字机撞针 指向当前操作的位数
	var res: int = 0
	#var pos_index: int = 0
	var last_gt_zero: bool = false # ひとつ前が0以外
	# 数牌
	for i in range(3):
		for j in range(9):
			if count_map[i * 9 + j] == 0:
				if last_gt_zero:
					res |= 0x1 << p  # 0b0001
					p += 1
					last_gt_zero = false
			else:
				last_gt_zero = true
				p += 1
				#pos_index += 1
				#pos[pos_index] = i * 9 + j
				match count_map[i * 9 + j]:
					2:
						res |= 0x3 << p  # 0b0011
						p += 2
					3:
						res |= 0xF << p  # 0b1111
						p += 4
					4:
						res |= 0x3F << p  # 0b0011_1111
						p += 6
		if last_gt_zero:
			last_gt_zero = false
			res |= 0x1 << p  # 0b0001
			p += 1
	# 字牌
	for i in range(27, 34):
		if count_map[i] > 0:
			p += 1
			#pos_index += 1
			#pos[pos_index] = i
			match count_map[i]:
				2:
					res |= 0x3 << p  # 0b0011
					p += 2
				3:
					res |= 0xF << p  # 0b1111
					p += 4
				4:
					res |= 0x3F << p  # 0b0011_1111
					p += 6
			res |= 0x1 << p  # 0b0001
			p += 1
	print("[DEBUG] 映射的索引为 0b%s" % Utils.dec_to_bin(res))
	return res


static func _map_tiles_to_count(tiles: Array,
		map_method: int = MAP_METHOD.STANDARD) -> Array:
	var standard_map: Array = []
	for _i in range(34):
		standard_map.append(0)
	for tile in tiles:
		standard_map[TILE_INDEX[int(tile / 10)]] += 1
	match map_method:
		MAP_METHOD.LONG:
			var long_map: Array = [0]
			for i in range(3):
				long_map.append_array(standard_map.slice(i * 9, i * 9 + 8))
				long_map.append(0)
			long_map.append_array(standard_map.slice(27, 33))
			long_map.append(0)
			return long_map  # length = 39
		MAP_METHOD.SHORT:
			var short_map: Array = []
			var last_append_is_zero: bool = true
			for i in range(27):
				if standard_map[i] > 0:
					if i % 9 == 0 and i > 0 and standard_map[i - 1] > 0:
						short_map.append(0)
					short_map.append(standard_map[i])
					last_append_is_zero = false
				elif not last_append_is_zero:
					short_map.append(0)
					last_append_is_zero = true
			var tail: int = short_map.pop_back()
			if tail > 0:
				short_map.append(tail)
			if standard_map.slice(27, 33).max() > 0:
				for i in range(27, 34):
					if standard_map[i] > 0:
						short_map.append_array([0, standard_map[i]])
			return short_map  # unsized
	return standard_map  # length = 34


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
