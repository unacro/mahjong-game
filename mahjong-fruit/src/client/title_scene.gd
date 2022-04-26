extends Control
# 标题界面脚本


################################################################
# Signals 信号
################################################################

################################################################
# Enums 枚举
################################################################

################################################################
# Constants 常量
################################################################
const GAME_SCENE = preload("res://src/server/game_host.tscn")
const DEBUG_SCENE = preload("res://src/client/local_game/debug/debug_algorithm.tscn")

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
onready var _version_label = $VersionLabel
onready var _dialog = $Dialog
onready var _alert_dialog = $Dialog/AcceptDialog
onready var _game_start_buttons = $GameStartButtons
onready var _local_game_buttons = $LocalGameButtons


################################################################
# built-in virtual methods 内置的虚函数
################################################################
#func _init():
#	pass


func _ready():
	_version_label.text = Global.VERSION
	_alert_dialog.rect_size = Vector2(480, 200)
	_alert_dialog.get_ok().text = "行吧"


#func _process(delta):
#	pass


################################################################
# Public methods 公共函数
################################################################


################################################################
# Private methods 私有函数
################################################################


################################################################
# Setter/Getter methods
################################################################


################################################################
# Callback methods 回调函数
################################################################
func _on_Online_pressed():
	_alert_dialog.dialog_text = "在线联机什么的，不存在的。"
	_dialog.visible = true
	_alert_dialog.popup_centered()


func _on_Coop_pressed():
	_alert_dialog.dialog_text = "局域网联机什么的，不存在的。"
	_dialog.visible = true
	_alert_dialog.popup_centered()


func _on_Local_pressed():
	_game_start_buttons.visible = false
	_local_game_buttons.visible = true


func _on_AcceptDialog_popup_hide():
	_dialog.visible = false


func _on_NewGame_pressed():
	SceneChanger.goto_scene(GAME_SCENE)


func _on_Exam_pressed():
	_alert_dialog.dialog_text = "我自己都没整明白呢，我还给你出题。"
	_dialog.visible = true
	_alert_dialog.popup_centered()


func _on_Debug_pressed():
	SceneChanger.goto_scene(DEBUG_SCENE)


func _on_Back_pressed():
	_local_game_buttons.visible = false
	_game_start_buttons.visible = true
