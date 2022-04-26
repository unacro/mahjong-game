class_name MahjongFaker
extends MahjongBase
# mock 麻将数据


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
static func gen_random_meld(in_hand: bool = true):
	var the_tile: int = MahjongBase.TILE_VALUE.values()[randi() % 136]
	var kotsu: Array = [0, 1, 2, 3]
	kotsu.pop_at(kotsu.find(the_tile % 10))
	kotsu.shuffle()
	if in_hand:
		var hand_meld: Array = []
		if randi() % 2 == 0:  # shuntsu 顺子
			if the_tile > 400:
				the_tile = MahjongBase.TILE_VALUE.values()[randi() % 108]
			# warning-ignore:integer_division
			var suit: int = int(the_tile / 100)
			# warning-ignore:integer_division
			var rank: int = int(the_tile / 10) % 10
			if rank > 7:
				hand_meld.append(suit * 100 + (rank - 2) * 10)
				hand_meld.append(suit * 100 + (rank - 1) * 10)
			else:
				hand_meld.append(suit * 100 + (rank + 1) * 10)
				hand_meld.append(suit * 100 + (rank + 2) * 10)
		else:
			for i in range(2):
				# warning-ignore:integer_division
				hand_meld.append(int(the_tile / 10) * 10 + kotsu[i])
		hand_meld.append(the_tile)
		return hand_meld
	else:
		var meld_data: Dictionary = {
			"have": [],
			"pick": [the_tile],
			"mark": randi() % 3 + 1,
		}
		match randi() % 5 + 1:
			MahjongBase.CALL.CHOW:
				if the_tile > 400:
					the_tile = MahjongBase.TILE_VALUE.values()[randi() % 108]
					meld_data["pick"] = [the_tile]
				# warning-ignore:integer_division
				var suit: int = int(the_tile / 100)
				# warning-ignore:integer_division
				var rank: int = int(the_tile / 10) % 10
				match randi() % 3:
					1:  # _, 2, 3
						if rank < 8:
							meld_data["have"].append(suit * 100 + (rank + 1) * 10)
							meld_data["have"].append(suit * 100 + (rank + 2) * 10)
						else:
							meld_data["have"].append(suit * 100 + (rank - 2) * 10)
							meld_data["have"].append(suit * 100 + (rank - 1) * 10)
					2:  # 1, _, 3
						match rank:
							1:
								meld_data["have"].append(suit * 100 + (rank + 1) * 10)
								meld_data["have"].append(suit * 100 + (rank + 2) * 10)
							9:
								meld_data["have"].append(suit * 100 + (rank - 2) * 10)
								meld_data["have"].append(suit * 100 + (rank - 1) * 10)
							_:
								meld_data["have"].append(suit * 100 + (rank - 1) * 10)
								meld_data["have"].append(suit * 100 + (rank + 1) * 10)
					_:  # 1, 2, _
						if rank > 2:
							meld_data["have"].append(suit * 100 + (rank - 2) * 10)
							meld_data["have"].append(suit * 100 + (rank - 1) * 10)
						else:
							meld_data["have"].append(suit * 100 + (rank + 1) * 10)
							meld_data["have"].append(suit * 100 + (rank + 2) * 10)
			MahjongBase.CALL.PONG:
				for i in range(2):
					# warning-ignore:integer_division
					meld_data["have"].append(int(the_tile / 10) * 10 + kotsu[i])
			_:
				match randi() % 3:
					1:  # 生成加杠
						for i in range(2):
							# warning-ignore:integer_division
							meld_data["have"].append(int(the_tile / 10) * 10 + kotsu[i])
						# warning-ignore:integer_division
						meld_data["pick"].append(int(the_tile / 10) * 10 + kotsu[2])
					2:  # 生成大明杠
						for i in range(3):
							# warning-ignore:integer_division
							meld_data["have"].append(int(the_tile / 10) * 10 + kotsu[i])
					_:  # 生成暗杠
						for i in range(3):
							# warning-ignore:integer_division
							meld_data["have"].append(int(the_tile / 10) * 10 + kotsu[i])
						meld_data["have"].append(meld_data["pick"].pop_back())
		return meld_data


static func gen_random_hand(random_meld_count: int = -1):
	var result: Dictionary = {
		"hand": [],
		"meld": [],
	}
	while true:
		result = {
			"hand": [],
			"meld": [],
		}
		var temp: Array = []
		if random_meld_count >= 0 and random_meld_count <= 4:
			for _i in range(random_meld_count):
				result["meld"].append(gen_random_meld(false))
			for _i in range(4 - random_meld_count):
				result["hand"].append_array(gen_random_meld(true))
		else:
			for _i in range(4):
				if randi() % 3 == 0:
					result["meld"].append(gen_random_meld(false))
				else:
					result["hand"].append_array(gen_random_meld(true))
		var eye: int = MahjongBase.TILE_VALUE.values()[randi() % 136]
		result["hand"].append(eye)
		# warning-ignore:integer_division
		result["hand"].append(int(eye / 10) * 10 + ((eye % 10) + 1) % 4)
		temp = result["hand"].duplicate()
		for meld in result["meld"]:
			temp.append_array(meld["have"])
			temp.append_array(meld["pick"])
		temp = .deserialize(.serialize(temp))  # 直接使用父类方法(类似 super 的简写)
		var verified: bool = true
		for tile in temp:
			if tile % 10 > 3 or temp.count(tile) > 1:
				verified = false
				break
		if verified:
			break
	result["hand"].shuffle()
	var win_tile: int = result["hand"].pop_back()
	result["hand"].sort()
	result["hand"].append(win_tile)
	return result


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
