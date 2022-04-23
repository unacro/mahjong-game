extends Node
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

################################################################
# Onready variables 自动初始化变量
################################################################
onready var http_client = $HTTPRequest


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
func dec_to_bin(dec: int) -> String:
	var temp_stack: Array = []
	var bin_string: String = ""
	while dec > 0:
		temp_stack.append(dec % 2)
		# warning-ignore:integer_division
		dec = int(dec / 2)
	while len(temp_stack) > 0:
		bin_string += str(temp_stack.pop_back())
	return bin_string


func array_join(seq: Array, sep: String = "") -> String:
	var temp: String = ""
	for item in seq:
		temp += "{0}{1}".format([item, sep])
	return temp.trim_suffix(sep)


func init_array(target = 0, fill_with = null, deep: bool = false) -> Array:
	var arr: Array = []
	match typeof(target):
		TYPE_INT:
			for _i in range(target):
				arr.append(fill_with)
		TYPE_ARRAY:
			if deep:
				for i in range(len(target)):
					arr[i] = fill_with
			else:
				for i in range(len(target)):
					target[i] = fill_with
				arr = target
	return arr


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
