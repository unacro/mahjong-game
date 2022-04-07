# Mahjong Game

<p align="center">
    <a href="https://github.com/time2beat/mahjong-game" target="_blank"><img src="https://img.shields.io/badge/time2beat-mahjong--game-blue?logo=github" alt="Github Repository" /></a>
    <a href="https://github.com/time2beat/mahjong-game/tags" target="_blank"><img src="https://img.shields.io/github/v/tag/time2beat/mahjong-game?label=Version" alt="Release Version" /></a>
    <img src="https://img.shields.io/github/pipenv/locked/python-version/time2beat/mahjong-game" alt="Python Version" />
    <img src="https://img.shields.io/github/languages/top/time2beat/mahjong-game?label=Python&logo=python&logoColor=fff" alt="Language Usage" />
</p>

Python 无框架手写日麻

```Bash
$ python start.py
```

[开发日志](https://ews.ink/game/mahjong-game-diy/)

## Todo List

### Feature 功能

- [x] 公平洗牌 序列化和反序列化牌序 与《雀姬》的 [md5 牌山验证](https://www.queji.tw/cardsmd5/) 兼容
- [x] 根据牌序查询 4 副手牌、宝牌指示器、里宝、岭上、海底
- [x] 发牌、摸牌、打牌
- [x] 自动排序手牌
- [x] 兼容赤宝牌的牌面计算
- [x] 鸣牌判定
- [x] 吃、碰、杠操作
- [x] 和牌判定
- [x] 听牌提示（硬遍历就完事了）
- [ ] 更新索引法和牌判定（用空间换时间）
- [x] 覆盖率还可以的单元测试
- [x] 弱智 AI 介入人机操作\
       ~~虽然人机只会摸什么打什么~~（现在优先打字牌，方便鸣牌），但是总算能玩了，不再是一个人打四家\
       ~~不过四家的鸣牌还是要玩家操作，还没想好怎么设计~~
- [x] AI 自动鸣牌（依然没有策略，能鸣就鸣）
- [x] 简单人机 AI 策略（草啊开始打不过电脑了，不限制役种人机无脑吃牌太猛了）
- [ ] 进阶人机 AI 策略
  1. 优先打闲风（不考虑大牌）
  2. 优先打绝张（绝张换听）
  3. 优先留刻子（保碰争杠）
  4. 优先打边张
  5. 优先留宝牌
- [ ] 优化 / 补充完善业务流程
  - [ ] 振听
  - [ ] 自风
  - [ ] 场风
  - [ ] 加杠 / 暗杠
  - [ ] 立直
  - [ ] 役种限定
  - [ ] 番种计算：翻数 / 符数
  - [ ] 输赢计分
  - [ ] 多局游戏（半庄东南）
- [x] 不考虑 UI，考虑 UI 我换 Godot 了

### Bug 修复

- [x] 存在重复的赤宝牌，排查后发现是因为反序列化函数 `deserialize()` 有一行少了缩进\
       ~~Python 万恶的缩进区分代码块~~ 写起来很爽，改起来很烦
