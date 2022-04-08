from utils import Utils
from engine import MahjongEngine

logger = Utils.Logger()


class MahjongGame(object):

    class Player(object):

        def __init__(self,
                     engine,
                     name: str = 'anonymous',
                     is_npc: bool = True,
                     enable_tips: bool = False) -> None:
            self.__Engine = engine
            self.__EnableTips = False
            self.Name = name
            self.Score = 25000  # 点数
            self.Hand = []  # 手牌
            self.Gate = []  # 门前 副露区
            self.Input = []  # 进张历史记录
            self.Output = []  # 舍张历史记录
            if is_npc:
                self.Master = MahjongEngine.AI(self)
            else:
                self.Master = None
                self.__EnableTips = enable_tips

        def deal_from(self, hand_tiles: list) -> None:
            if len(hand_tiles) in [13, 14]:
                self.Hand = self.__Engine.sort(hand_tiles)
            else:
                logger.fatal(f'给 [{self.Name}] 发牌时手牌数量错误 {len(hand_tiles)}')

        def draw(self, input_tile) -> None:
            self.Input.append(input_tile)  # 记录进张
            self.Hand.append(input_tile)

        def discard(self, hand_index: int = -1) -> str:
            if len(self.Hand) % 3 != 2:
                logger.fatal(
                    f'打出牌失败 手牌数量错误 {len(self.Hand)} {self.__Engine.humanize(self.Hand)}'
                )
            if self.Master == None:
                hand_text = []
                for i, tile in enumerate(self.Hand):
                    hand_text.append(f'{i+1}:{self.__Engine.humanize(tile)}')
                logger.info(f'[{self.Name}](玩家) 当前手牌\n{" ".join(hand_text)}')
                if self.__EnableTips:
                    winning_tiles = self.__Engine.is_ready(self.Hand)
                    if len(winning_tiles) > 0:
                        logger.info(f'Tips: 正在听 {" ".join(winning_tiles)}')
                    discard_tips = self.__Engine.lack_of(self.Hand)
                    if len(discard_tips) > 0:
                        logger.info(f'Tips: {"  ".join(discard_tips)}')
                logger.info(f'请输入要打第几张: 1 ~ {len(self.Hand)}')
                hand_index = len(self.Hand) - 1
                discard_index = input('>: ')
                if discard_index != '' and discard_index.isdigit():
                    discard_index = int(discard_index) - 1
                    if discard_index >= 0 and discard_index < len(self.Hand):
                        hand_index = discard_index
            else:
                hand_index = self.Master.decide(
                    'discard',
                    {'history': {
                        'right': [],
                        'front': [],
                        'left': [],
                    }})  # TODO 输入其他家的舍张以便分析
            self.Output.append(self.Hand.pop(hand_index))  # 记录舍张
            self.Hand = self.__Engine.sort(self.Hand)
            return self.Output[len(self.Output) - 1]

        def chow(self, here: list, there) -> None:
            """
            吃
            """
            choose_index = 0
            if len(here) > 1:
                if self.Master == None:
                    tips = []
                    for tip in here:
                        tips.append(f'{self.__Engine.humanize(tip)}')
                    logger.info(f'{" ".join(tips)}')
                    logger.info(f'请输入要吃第几组: 1 ~ {len(tips)}')
                    choose = input('>: ')
                    if choose != '' and choose.isdigit():
                        choose = int(choose) - 1
                    if choose >= 0 and choose < len(here):
                        choose_index = choose
                else:
                    choose_index = self.Master.decide('chow', {'tile': there})
            shuntsu = here[choose_index]
            for eat in shuntsu:
                self.Hand.remove(eat)
            shuntsu.append(there)
            self.Gate.append(shuntsu)
            logger.info(f'[{self.Name}] 吃 {self.__Engine.humanize(shuntsu)}')

        def pong(self, here: list, there) -> None:
            """
            碰
            """
            record = here[:]
            for tile in here:
                self.Hand.remove(tile)
            record.append(there)
            self.Gate.append(record)
            logger.info(f'[{self.Name}] 碰 {self.__Engine.humanize(record)}')

        def kong(self, here: list, there, tile) -> bool:
            """
            杠
            """
            record = here[:]
            for hand in here:
                self.Hand.remove(hand)
            record.append(there)
            self.Gate.append(record)
            logger.info(f'[{self.Name}] 杠 {self.__Engine.humanize(record)}')
            self.Hand.append(tile)  # 摸一张岭上牌
            if self.__Engine.can_win(self.Hand):
                return True
            else:
                return False

        def get_log(self, log_type: str = 'hand') -> str:
            log_text = []
            if log_type == 'gate':
                log_type = '副露'
                for meld in self.Gate:
                    meld_list = []
                    for tile in meld:
                        meld_list.append(f'{self.__Engine.humanize(tile)}')
                    log_text.append(f'[{" ".join(meld_list)}]')
            elif log_type == 'input':
                log_type = '进张'
                for tile in self.Input:
                    log_text.append(f'{self.__Engine.humanize(tile)}')
            elif log_type == 'output':
                log_type = '舍张'
                for tile in self.Output:
                    log_text.append(f'{self.__Engine.humanize(tile)}')
            else:
                log_type = '手牌'
                for tile in self.Hand:
                    log_text.append(f'{self.__Engine.humanize(tile)}')
                for meld in self.Gate:
                    meld_list = []
                    for tile in meld:
                        meld_list.append(f'{self.__Engine.humanize(tile)}')
                    log_text.append(f'<{" ".join(meld_list)}>')
            return ' '.join(log_text)

    def __init__(self) -> None:
        self.__Engine = MahjongEngine.V2()
        self.__Running = False
        self.__Players = []
        logger.info('游戏主程序初始化完毕')

    @classmethod
    def init(cls, deck_sequence: str = ''):
        game = cls()
        game.new(deck_sequence)
        return game

    @property
    def dora_hai(self) -> list:  # 宝牌指示器
        return self.query("bao")[:self.__KongCount + 1]

    @property
    def dora(self) -> list:  # 宝牌
        dora_list = []
        for dora_hai in self.dora_hai:
            dora_list.extend(self.__Engine.near_tile(dora_hai, 1, True))
        return list(set(dora_list))

    @property
    def deck_count(self) -> int:
        return len(self.__Deck)

    @property
    def new_tile(self) -> str:
        return self.__Deck[0] if self.deck_count > 0 else None

    @property
    def active_player(self):
        return self.__Players[self.__Playing]

    @property
    def winning(self) -> bool:
        """
        和牌判定
        """
        if self.__Engine.can_win(self.active_player.Hand):
            self.__Winner = self.active_player.Name
            return True
        return False

    def tr(self, tiles):
        return self.__Engine.humanize(tiles)

    def new(self, deck_sequence: str = '') -> None:
        self.__Running = True
        if len(deck_sequence) == 272:
            self.__DeckSequence = deck_sequence
        else:
            self.__DeckSequence = self.__Engine.new_deck(True)
        self.__Deck = []
        tiles = self.__Engine.deserialize(self.__DeckSequence[106:244])
        for tile in tiles:
            self.__Deck.append(tile)
        self.__Circle = 1  # 当前第几巡
        self.__Playing = 0  # 当前轮到的玩家
        self.__KongCount = 0  # 本场杠的数量
        self.__Winner = 'unknown'
        logger.info('一局新游戏准备完毕')
        logger.info(
            f'本局牌序 md5 为 {Utils.md5(self.__DeckSequence)} 可前往 https://www.queji.tw/cardsmd5/ 验证'
        )
        logger.debug(f'剧透本局牌序 \n{self.tr(self.__Deck)}')

    def join(self,
             player_name: str = 'default',
             is_npc: bool = True,
             enable_tips: bool = False) -> bool:
        if not self.__Running:
            logger.warn(f'玩家 [{player_name}] 加入游戏失败。游戏尚未准备好')
            return False
        if len(self.__Players) == 4:
            logger.warn(
                f'玩家 [{player_name}] 加入游戏失败。当前玩家 {len(self.__Players)}/4: 人数已满'
            )
            return False
        if player_name == 'default':
            player_name = ['东家', '南家', '西家', '北家'][len(self.__Players)]
        self.__Players.append(
            MahjongGame.Player(self.__Engine, player_name, is_npc,
                               enable_tips))
        player_list = []
        for player in self.__Players:
            player_list.append(f'[{player.Name}]')
        player_type = 'AI'
        if not is_npc:
            player_type = '玩家'
        logger.info(
            f'玩家 [{player_name}] ({player_type}) 加入游戏成功。当前玩家 {len(self.__Players)}/4: {"".join(player_list)}'
        )
        return True

    def query(self, keyword: str = '') -> list:
        return self.__Engine.query(self.__DeckSequence, keyword)

    def check_call(self, the_tile) -> bool:
        """
        鸣牌检测
        """
        task_queue = [[], [], [], []]
        for index, player in enumerate(self.__Players):
            if index != self.__Playing:
                flag, highlight = self.__Engine.check_call(
                    player.Hand, the_tile)
                if index != (self.__Playing + 1) % 4:  # 不是下家不能吃
                    flag &= 0b1110  # 重置吃的标记位
                if flag > 0:
                    buttons_text = ['吃', '碰', '杠', '和']
                    buttons = []
                    for p in range(4):
                        if flag & 1 << p > 0:
                            buttons.append(3 - p)
                    tips = []
                    for button in buttons:
                        tips.append(f'[{button}]{buttons_text[3 - button]}')
                    if player.Master == None:
                        logger.info(
                            f'[{player.Name}](玩家) 当前手牌\n{player.get_log()}')
                        logger.info('可以操作', ' '.join(tips))
                        pressed = input('>: ')
                        if pressed != '' and pressed.isdigit():
                            pressed = int(pressed)
                        if pressed in buttons:
                            task_queue[pressed].append((index, highlight))
                        elif pressed == -1:  # debug 手动强制检测和牌判定
                            logger.debug(
                                f'[{player.Name}] 手牌\n{player.get_log()} {self.__Engine.can_win(player.Hand)}'
                            )
                    else:
                        ai_call = player.Master.decide('call', {
                            'tile': the_tile,
                            'options': buttons,
                        })
                        task_queue[ai_call].append((index, highlight))
        for task, executors in enumerate(task_queue):
            if executors != []:
                for executor, highlight in executors:
                    active_player = self.__Players[executor]
                    self.__Playing = executor
                    if task == 0:
                        active_player.draw(the_tile)
                        if self.__Engine.can_win(active_player.Hand):  # 最后一次确定
                            self.__Winner = active_player.Name
                            return True
                        else:
                            logger.fatal(
                                f'代码写的什么玩意儿 居然让 {active_player.Name} 诈和了 {self.tr(active_player.Hand)}'
                            )
                    elif task == 1:
                        temp = self.query("kong")[self.__KongCount]  # 岭上牌
                        self.__KongCount += 1
                        self.__Deck.pop(self.deck_count - 1)  #  牌山依次推一张海底牌
                        if active_player.kong(highlight['kong'], the_tile,
                                              temp):
                            self.__Winner = active_player.Name
                            logger.info('杠上开花！')
                            return True
                    elif task == 2:
                        active_player.pong(highlight['pong'], the_tile)
                    elif task == 3:
                        active_player.chow(highlight['chow'], the_tile)
                discarded_tile = self.active_player.discard()
                logger.info(
                    f'[{self.active_player.Name}] 打出 <{self.tr(discarded_tile)}>    余牌 {self.deck_count} 张'
                )
                return False
        return False

    def draw(self) -> None:
        self.active_player.draw(self.__Deck.pop(0))

    def next_turn(self) -> int:
        self.__Playing = (self.__Playing + 1) % 4
        return self.__Playing

    def start(self) -> bool:
        if not self.__Running:
            logger.warn('新游戏启动失败。游戏尚未准备好')
            return False
        if len(self.__Players) != 4:
            logger.warn(f'游戏无法开始。玩家人数不够 {len(self.__Players)}/4')
            return False

        def game_loop() -> bool:
            if self.winning:  # 庄家和牌判定
                logger.info('天和！')
                return True
            discarded_tile = self.active_player.discard()  # 庄家打牌
            logger.info(
                f'[{self.active_player.Name}] 打出 <{self.tr(discarded_tile)}>    余牌 {self.deck_count} 张'
            )
            if self.check_call(discarded_tile):  # 鸣牌判定
                return True
            self.next_turn()  # 开始正常循环
            while self.deck_count > 0:
                self.draw()  # 摸牌
                if self.winning:  # 和牌判定天和
                    logger.info(
                        f'[{self.active_player.Name}] 自摸！{self.tr(self.active_player.Hand[len(self.active_player.Hand)-1])}！'
                    )
                    return True
                # TODO 听牌提示
                discarded_tile = self.active_player.discard()  # 打牌
                logger.info(
                    f'[{self.active_player.Name}] 打出 <{self.tr(discarded_tile)}>    余牌 {self.deck_count} 张'
                )
                if self.check_call(discarded_tile):  # 鸣牌判定
                    logger.info('和！')
                    return True
                self.next_turn()
            return False

        logger.info('游戏开始')
        for index, player in enumerate(self.__Players):
            player.deal_from(self.__Engine.deal(self.__DeckSequence, index))
        logger.info(f'目前已知的宝牌指示器为 {self.tr(self.dora_hai)}')
        logger(f'目前已知的宝牌为 {self.tr(self.dora)}')
        if game_loop():
            logger.info(f'本局游戏结束。赢家是 [{self.__Winner}]')
        else:
            logger.info(f'本局游戏结束。流局(牌山已空)')
        logger.info(f'本局牌序为 {self.__DeckSequence}\n')
        for player in self.__Players:
            winner = ''
            if self.__Winner == player.Name:
                winner = ' WIN!'
            logger.info(f'[{player.Name}]{winner}\n[手牌] {player.get_log()}')
            logger.debug(
                f'\n[进张] {player.get_log("input")}\n[舍张] {player.get_log("output")}\n'
            )


@Utils.record_elapsed
def main() -> None:
    Game = MahjongGame()
    Game.new()
    Game.join()
    Game.join('小南')
    Game.join()
    Game.join('小北')
    Game.join('观战者')
    Game.start()


if __name__ == "__main__":
    main()
