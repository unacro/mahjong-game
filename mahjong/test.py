from utils import Utils
from const import Const
from engine import MahjongEngine

logger = Utils.Logger()


class MahjongEngineTest(object):
    """
    单元测试类
    """

    def __init__(self, version: int = 2) -> None:
        if version == 1:
            self.Engine = MahjongEngine.V1()
        else:
            self.Engine = MahjongEngine.V2()

    @Utils.record_elapsed
    def __unit_test(
        self,
        unit: str = 'default',
        echo_result: bool = False,
    ) -> bool:
        """
        测试用例
        """

        def print_result(result: list) -> None:
            for item in result:
                logger.test(item)

        if unit == 'translate':
            test_result = []
            for i in [233, 153, 252, 353, 411]:
                test_result.append(
                    f'{Const.Mahjong(i).name} => {self.Engine.translate(Const.Mahjong(i))}'
                )
            new_deck = self.Engine.new_deck(True)
            test_result.append(
                self.Engine.humanize([
                    self.Engine.deserialize(new_deck[:4]),
                    self.Engine.deserialize(new_deck[4:8]),
                    self.Engine.deserialize(new_deck[8:12]),
                    [[['1z'], ['2z', [[[['1s', [['0m']]]]]], '3z']],
                     ['6m', {
                         'test': '8m'
                     }], {'8p'}, [['7z'], ['2s', '3p']], '5s'],
                ]), )
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'humanize':
            new_deck = self.Engine.sort(self.Engine.new_deck())
            test_result = [self.Engine.humanize(new_deck)]
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'serialize':
            test_result = []
            new_deck = self.Engine.new_deck()
            deck_sequence = self.Engine.serialize(new_deck)
            reduced_deck = self.Engine.deserialize(deck_sequence)
            test_result.append(f'第一次结果 {len(deck_sequence)} {deck_sequence}')
            for _ in range(10):
                deck_sequence = self.Engine.serialize(reduced_deck)
                reduced_deck = self.Engine.deserialize(deck_sequence)
            test_result.append(f'重复十遍后 {len(deck_sequence)} {deck_sequence}')
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'deal':
            new_deck = self.Engine.new_deck(True)
            test_result = []
            test_result.append(
                f'最前8墩: {self.Engine.humanize(self.Engine.deserialize(new_deck[:32]))}'
            )
            test_result.append(
                f'庄家手牌: {self.Engine.humanize(self.Engine.deal(new_deck, 0))}')
            test_result.append(
                f'闲家手牌: {self.Engine.humanize(self.Engine.deal(new_deck, 1))}')
            test_result.append(
                f'闲家手牌: {self.Engine.humanize(self.Engine.deal(new_deck, 2))}')
            test_result.append(
                f'闲家手牌: {self.Engine.humanize(self.Engine.deal(new_deck, 3))}')
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'query':
            new_deck = self.Engine.new_deck(True)
            test_result = []
            test_result.append(
                f'最后9墩(海底+王牌): {self.Engine.humanize(self.Engine.deserialize(new_deck[236:]))}'
            )
            test_result.append(
                f'海底: {self.Engine.humanize(self.Engine.query(new_deck, "hai_di"))}'
            )
            test_result.append(
                f'里宝: {self.Engine.humanize(self.Engine.query(new_deck, "li_bao"))}'
            )
            test_result.append(
                f'宝牌: {self.Engine.humanize(self.Engine.query(new_deck, "bao"))}'
            )
            test_result.append(
                f'岭上: {self.Engine.humanize(self.Engine.query(new_deck, "kong"))}'
            )
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'near_tile':
            test_result = []
            enable_loop = False
            enable_loop = True
            tips1, tips2, tips3, tips4 = [], [], [], []
            suit = ['m', 'p', 's']
            for i in range(1):
                for j in [1, 2, 4, 5, 0, 6, 8, 9]:
                    tips1.append(
                        f'{self.Engine.humanize(str(j)+suit[i])} => {self.Engine.humanize(self.Engine.near_tile(str(j)+suit[i], 1, enable_loop))}'
                    )
            for i in range(1):
                for j in [1, 2, 4, 5, 0, 6, 8, 9]:
                    tips2.append(
                        f'{self.Engine.humanize(self.Engine.near_tile(str(j)+suit[i], -1, enable_loop))} <= {self.Engine.humanize(str(j)+suit[i])}'
                    )
            for i in range(1, 8):
                tips3.append(
                    f'{self.Engine.humanize(str(i)+"z")} => {self.Engine.humanize(self.Engine.near_tile(str(i)+"z", 1, enable_loop))}'
                )
            for i in range(1, 8):
                tips4.append(
                    f'{self.Engine.humanize(self.Engine.near_tile(str(i)+"z", -1, enable_loop))} <= {self.Engine.humanize(str(i)+"z")}'
                )
            tabs = ' ' * 4
            tips = [
                tabs.join(tips1),
                tabs.join(tips2),
                tabs.join(tips3),
                tabs.join(tips4),
            ]
            test_result.append('\n'.join(tips))
            test_result.append('随机抽查:')
            new_deck = self.Engine.new_deck()
            for tile in new_deck[:10]:
                the_next = self.Engine.near_tile(tile, 1, True)
                test_result.append(
                    f'{self.Engine.humanize(tile)} 的下一张是 {self.Engine.humanize(the_next)}'
                )
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'map_count':
            test_result = []
            rand_deck_code = MahjongEngine.V1.new_deck(True)
            random_hand = MahjongEngine.V1.sort(
                MahjongEngine.V1.deal(rand_deck_code, 1))
            visual_tiles = MahjongEngine.V1.humanize(random_hand)
            test_result.append(f'{visual_tiles} 随机生成的手牌')
            try:
                for map_style in ['default', 'long', 'short']:
                    map_result = MahjongEngine.V1.map_tiles_count(
                        random_hand, map_style)
                    restore_result = MahjongEngine.V1.restore_count_map(
                        map_result)
                    new_visual_tiles = MahjongEngine.V1.humanize(
                        restore_result)
                    tips = f'{new_visual_tiles} {len(restore_result)} 映射再还原 {map_style} 方式'
                    if new_visual_tiles != visual_tiles:
                        tips += ' (赤宝牌的标记在转换过程中丢失)'
                    test_result.append(tips)
            except Exception as e:
                logger.warn(f'{e} ← 这一条是符合预期的正常测试结果')
            finally:
                if echo_result:
                    print_result(test_result)
            return True

        elif unit == 'can_win':
            test_result = []
            new_deck = self.Engine.new_deck()
            sample_hand = [
                '7z7z',
                '4m5m5m0m6m2p2p2p5p0p6p7p8p5p',
                '2m2m2m6m7m8m3p4p4p4p2s3s4s3p',  #0 听 235
                '1m1m1m2m2m2m3m3m3m4m4m4m0m5m',  #1 一色三节高
                '1m1m1m2m2m2m2m3m3m3m3m4m4m4m',  #2 一色三节高 复合两暗杠
                '1m1m2m2m3m3m5m5m6m6m7m7m8m8m',  #3 七对子 复合二杯口
                '2m2m3m3m4m4m5m5m6m6m7m7m8m8m',  #4 大数邻
                '1m9m1p9p1s9s1z2z3z4z5z6z7z1m',  #5 国士无双
            ]
            for i in range(len(sample_hand)):
                hand = self.Engine.deserialize(sample_hand[i])
                win = self.Engine.can_win(hand)
                if win:
                    test_result.append(
                        f'测试用例 #{i} {self.Engine.humanize(hand)} 能否和牌: {win}')
                else:
                    raise (Exception(f'{self.Engine.humanize(hand)} 难道不能和牌?'))
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'all_can_win':
            test_result = []
            possibility = []

            for i1 in range(5):
                for i2 in range(5):
                    for i3 in range(5):
                        for i4 in range(15 - i1 - i2 - i3):
                            for i5 in range(15 - i1 - i2 - i3 - i4):
                                for i6 in range(15 - i1 - i2 - i3 - i4 - i5):
                                    for i7 in range(15 - i1 - i2 - i3 - i4 -
                                                    i5 - i6):
                                        for i8 in range(15 - i1 - i2 - i3 -
                                                        i4 - i5 - i6 - i7):
                                            i9 = 14 - i1 - i2 - i3 - i4 - i5 - i6 - i7 - i8
                                            if max([
                                                    i1, i2, i3, i4, i5, i6, i7,
                                                    i8, i9
                                            ]) <= 4 and min([
                                                    i1, i2, i3, i4, i5, i6, i7,
                                                    i8, i9
                                            ]) >= 0:
                                                possibility.append([
                                                    i1, i2, i3, i4, i5, i6, i7,
                                                    i8, i9
                                                ])
            hu_pai = {'yes': [], 'no': []}
            for item in possibility:  # 118800 种可能
                if self.Engine.can_win(item):
                    hu_pai['yes'].append(item)
                else:
                    hu_pai['no'].append(item)
            start = 9527
            for index, item in enumerate(hu_pai['yes'][start:start + 5]):
                test_result.append(
                    f'测试集 #{index + start} {item} 能否和牌: {self.Engine.can_win(item, True)}'
                )
            test_result.append(
                f'和牌牌型(不考虑役种,{len(hu_pai["yes"])}种) + 不能和牌牌型({len(hu_pai["no"])}种) = 所有清一色牌型({len(possibility)}种)'
            )
            # V1: 和牌牌型(不考虑役种,12804种) + 不能和牌牌型(105996种) = 所有清一色牌型(118800种)
            # V2: 和牌牌型(不考虑役种,13073种) + 不能和牌牌型(105727种) = 所有清一色牌型(118800种)
            if echo_result:
                print_result(test_result)
            return True

        elif unit == 'is_ready':
            test_result = []
            sample_hand = [
                '7z',
                '4m5m5m0m6m2p2p2p5p0p6p7p8p',
                '2m2m2m6m7m8m3p4p4p4p2s3s4s',  #0 听 235
            ]
            for i in range(len(sample_hand)):
                hand_tiles = self.Engine.deserialize(sample_hand[i])
                winning_tiles = self.Engine.is_ready(hand_tiles)
                if len(winning_tiles) > 0:
                    test_result.append(
                        f'测试用例 #{i} {self.Engine.humanize(hand_tiles)} 听牌 => {winning_tiles}'
                    )
                else:
                    raise (Exception(
                        f'{self.Engine.humanize(hand_tiles)} 难道不能听牌?'))
            if echo_result:
                print_result(test_result)
            return True

        return False

    @Utils.record_elapsed
    def unit_test(self) -> None:
        unit_list = [
            ('translate', False),
            ('humanize', False),
            ('serialize', False),
            ('deal', False),
            ('query', False),
            ('near_tile', False),
            ('map_count', False),
            ('can_win', False),
            ('all_can_win', True),
            ('is_ready', False),
        ]
        for index, item in enumerate(unit_list):
            logger.test(f'开始 {index+1}/{len(unit_list)} 单元测试 {item[0]}()')
            if not self.__unit_test(*item):
                raise (Exception(f'单元测试 {item} 未通过'))
            print()
        logger.test(f'所有单元测试通过')

    @Utils.record_elapsed
    def e2e_test(self) -> None:
        rand_deck_code = MahjongEngine.V1.new_deck(True)
        random_deck = MahjongEngine.V1.sort(
            MahjongEngine.V1.deal(rand_deck_code))

        class Player:

            def __init__(self):
                self.Hand = random_deck

        com = MahjongEngine.AI(Player())

        logger.debug(
            f'{MahjongEngine.V1.humanize(random_deck)} 初始随机手牌 {len(random_deck)}'
        )
        logger.test(
            f'AI 打出 {MahjongEngine.V1.humanize(random_deck[com.analyse()])}')
        logger.test(f'黑箱测试完成')


def test(engine_version: int = 1) -> None:
    TestEngine = MahjongEngineTest(engine_version)
    TestEngine.unit_test()
    print()
    TestEngine.e2e_test()


if __name__ == "__main__":
    test(2)
