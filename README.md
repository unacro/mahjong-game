<h1 align="center">🀄 Mahjong Fruit 雀实</h1>

<p align="center">
    <a href="https://github.com/time2beat/mahjong-game/actions?query=workflow%3Agodot-ci-export" target="_blank"><img src="https://github.com/time2beat/mahjong-game/workflows/godot-ci-export/badge.svg" /></a>
    <a href="https://github.com/time2beat/mahjong-game" target="_blank"><img src="https://img.shields.io/badge/time2beat-mahjong--fruit-informational?logo=github" /></a>
    <a href="https://godotengine.org/" target="_blank"><img src="https://img.shields.io/github/languages/top/time2beat/mahjong-game?label=GDScript" /></a><br/>
    <a href="https://github.com/time2beat/mahjong-game/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/time2beat/mahjong-game?label=latest%20version" /></a>
    <a href="https://time2beat.github.io/mahjong-game/" target="_blank"><img src="https://img.shields.io/badge/Play-Online-success" /></a>
    <a href="https://discord.gg/tkvnz2YzW5" target="_blank"><img src="https://img.shields.io/discord/482578656229720084?label=Discord&logo=discord&logoColor=fff" /></a>
    <a href="https://ews.ink/game/mahjong-game-diy/" target="_blank"><img src="https://img.shields.io/badge/Blog-开发日志-informational?logo=hugo&logoColor=fff" /></a>
</p>

Godot 实现日麻游戏

## Todo List

### Feature 功能

- [x] 基本 UI 交互界面
- [x] 兼容赤宝牌的数据结构设计
- [x] 配牌生成 [md5 验证牌山](https://www.queji.tw/cardsmd5/)
- [x] 配牌预览 山牌 / 王牌
- [x] 手牌 / 宝牌 / 里宝 / 岭上 / 海底计算
- [x] 自动排序手牌
- [x] 发牌 / 打牌 / 摸牌
- [x] Esc 开启 debug 控制台功能
- [x] 鸣牌判定
- [ ] 鸣牌操作 只能吃上家
- [ ] 和牌判定 map_count
- [ ] 听牌提示
- [ ] 人机 AI
  - [ ] 能打牌
  - [ ] 能鸣牌
  - [ ] 会做牌
  - [ ] 进阶人机 AI 策略
    1. 优先打闲风（不考虑大牌）
    2. 优先打绝张（绝张换听）
    3. 优先留刻子（保碰争杠）
    4. 优先打边张
    5. 优先留宝牌
- [ ] 符数 翻数计算
- [ ] 役种判定 枚举 POINTS
- [ ] 流局判定 枚举
- [ ] 思考倒计时
- [ ] 优化 / 补充完善业务流程
  - [ ] 振听
  - [ ] 自风
  - [ ] 场风
  - [ ] 加杠 / 暗杠
  - [ ] 立直
  - [ ] 输赢计分
  - [ ] 多局游戏（半庄东南）
