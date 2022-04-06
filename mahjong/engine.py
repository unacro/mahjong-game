from functools import reduce
import logging
from utils import Utils
from const import Const

logger = Utils.Logger()


class MahjongEngine(object):

    class V1(object):
        """
        初代麻将引擎
        """

        @staticmethod
        def new_deck(enable_sequence: bool = False) -> list:
            new_deck = []
            for tile in Const.Mahjong:
                new_deck.append(tile)
            new_deck = Utils.shuffle(new_deck)
            if enable_sequence:
                return MahjongEngine.V1.serialize(new_deck)
            else:
                return new_deck

        @staticmethod
        def sort(tiles: list) -> list:

            def _quick_sort(array) -> None:
                if len(array) < 2:
                    return
                p = array[0]
                L = []
                E = []
                R = []
                while len(array) > 0:
                    if array[-1].value < p.value:
                        L.append(array.pop())
                    elif array[-1].value == p.value:
                        E.append(array.pop())
                    else:
                        R.append(array.pop())
                _quick_sort(L)
                _quick_sort(R)
                array.extend(L)
                array.extend(E)
                array.extend(R)

            _quick_sort(tiles)
            return tiles

        @staticmethod
        def translate(tile, humanize: bool = True) -> str:
            tile_code = ''
            if isinstance(tile, Const.Code):
                tile_code = tile.value
            elif isinstance(tile, str):
                tile_code = tile
            else:
                tile_name = None
                if isinstance(tile, Const.Mahjong):
                    tile_name = tile.name
                elif isinstance(tile, int):
                    tile_name = Const.Mahjong(tile).name[:-1]
                else:
                    raise (Exception(f'翻译牌面失败 输入参数的类型有误 {type(tile)}: {tile}'))
                tile_key = tile_name[:-1]
                if tile_name[-2:] == '5D' and tile_name[0] != 'Z':
                    tile_key = f'{tile_name[:-2]}0'
                tile_code = Const.Code[tile_key].value
            if humanize:
                return Const.Alias[Const.Code(tile_code).name].value
            else:
                return tile_code

        @staticmethod
        def humanize(tiles):

            def _loop_multi_array(parent):
                if not parent:
                    return None
                cache = None
                if isinstance(parent, list):
                    cache = list()
                elif isinstance(parent, set):
                    cache = set()
                elif isinstance(parent, dict):
                    cache = dict()
                if type(parent) in [list, set]:
                    for value in parent:
                        if type(value) in [list, set, dict]:
                            if isinstance(parent, list):
                                cache.append(_loop_multi_array(value))
                            elif isinstance(parent, set):
                                cache.add(_loop_multi_array(value))
                            elif isinstance(parent, dict):
                                cache[key] = _loop_multi_array(value)
                        else:
                            memo = MahjongEngine.V1.translate(value)
                            if isinstance(parent, list):
                                cache.append(memo)
                            elif isinstance(parent, set):
                                cache.add(memo)
                            elif isinstance(parent, dict):
                                cache[key] = memo
                elif isinstance(parent, dict):
                    for key, value in parent.items():
                        if type(value) in [list, set, dict]:
                            if isinstance(parent, list):
                                cache.append(_loop_multi_array(value))
                            elif isinstance(parent, set):
                                cache.add(_loop_multi_array(value))
                            elif isinstance(parent, dict):
                                cache[key] = _loop_multi_array(value)
                        else:
                            memo = MahjongEngine.V1.translate(value)
                            if isinstance(parent, list):
                                cache.append(memo)
                            elif isinstance(parent, set):
                                cache.add(memo)
                            elif isinstance(parent, dict):
                                cache[key] = memo
                elif type(parent) in [str, Const.Mahjong]:
                    cache = MahjongEngine.V1.translate(parent)
                else:
                    logger.fatal(f'不支持遍历的数据类型 {type(parent)} {parent}')
                return cache

            return _loop_multi_array(tiles)

        @staticmethod
        def index_of(tile):
            return Const.Index[Const.Code(
                MahjongEngine.V1.translate(tile, False)).name].value

        @staticmethod
        def serialize(tiles: list) -> str:
            tiles_sequence = []
            if isinstance(tiles[0], Const.Mahjong):
                for tile in tiles:
                    tile_key = tile.name[:-1]
                    if tile.name[-2:] == '5D' and tile.name[0] != 'Z':
                        tile_key = f'{tile.name[:-2]}0'
                    tiles_sequence.append(Const.Code[tile_key].value)
            elif isinstance(tiles[0], str):
                for tile in tiles:
                    tiles_sequence.append(tile)
            else:
                raise (Exception(
                    f'序列化牌序失败 输入参数的类型有误 {type(tiles[0])}: {tiles[0]}'))
            return ''.join(tiles_sequence)

        @staticmethod
        def deserialize(deck_sequence: str) -> list:
            temp = []
            for i in range(int(len(deck_sequence) / 2)):
                temp.append(Const.Code(deck_sequence[i * 2:i * 2 + 2]))
            deck = []
            count = [0 for _ in range(34)]
            suffix = ['A', 'B', 'C', 'D']
            for tile in temp:
                if tile.name[-1:] == '0':
                    deck.append(Const.Mahjong[f'{tile.name[:-1]}5D'])
                else:
                    deck.append(Const.Mahjong[
                        f'{tile.name}{suffix[count[Const.Index[tile.name]]]}'])
                count[Const.Index[tile.name]] += 1
            return deck

        @staticmethod
        def deal(deck_sequence: str, player: int = 0) -> list:
            """
            根据牌序发起始手牌
            """
            if len(deck_sequence) != 272:
                raise (Exception(f'牌组序列长度错误 {len(deck_sequence)}'))
            the_deck = MahjongEngine.V1.deserialize(deck_sequence)
            hand_tiles = []
            for i in range(3):
                hand_tiles.extend(the_deck[i * 16 + player * 4:i * 16 +
                                           player * 4 + 4])
            if player == 0:
                hand_tiles.extend(the_deck[48:50])
            else:
                hand_tiles.append(the_deck[player + 48])
            return hand_tiles

        @staticmethod
        def query(deck_sequence: str, keyword: str = '') -> list:
            """
            根据牌序查询宝牌
            """
            if len(deck_sequence) != 272:
                raise (Exception(f'牌组序列长度错误 {len(deck_sequence)}'))
            the_deck = MahjongEngine.V1.deserialize(deck_sequence)
            query_result = []
            if keyword == 'kong':  # 岭上牌
                for i in range(4):
                    query_result.append(the_deck[135 - i])
            elif keyword == 'hai_di':  # 可能的的海底牌
                for i in range(4):
                    query_result.append(the_deck[121 - i])
            elif keyword == 'li_bao':  # 里宝牌指示器 doraHaiUra
                for i in range(5):
                    query_result.append(the_deck[130 - i * 2])
            else:  # 宝牌指示器 doraHai
                for i in range(5):
                    query_result.append(the_deck[131 - i * 2])
            return query_result

        @staticmethod
        def near_tile(tile, offset: int = 1, allow_loop: bool = False) -> set:
            """
            查询相邻的牌
            """
            indicator = None
            if isinstance(tile, Const.Mahjong):
                indicator = tile
            elif isinstance(tile, str):
                indicator = MahjongEngine.V1.deserialize(tile.lower())[0]
            else:
                raise (Exception(f'计算下一张牌失败 输入参数的类型有误 {type(tile)}: {tile}'))
            suit, rank = int(indicator / 100), int(indicator / 10 % 10)
            new_rank = 0
            if suit < 4:  # 数字牌
                if not allow_loop:
                    if offset > 0:
                        offset = offset % (10 - rank)
                    elif offset < 0:
                        offset = offset % -rank
                new_rank = (rank + offset - 1) % 9 + 1
            else:  # 字牌
                if rank <= 4:  # 风牌
                    if not allow_loop:
                        offset = offset % (
                            5 - rank) if offset > 0 else offset % -rank
                    new_rank = (rank + offset - 1) % 4 + 1
                else:  # 三元牌
                    if not allow_loop:
                        offset = offset % (
                            8 - rank) if offset > 0 else offset % (4 - rank)
                    new_rank = (rank + offset - 5) % 3 + 5
            if new_rank == rank:
                return set()
            near = []
            for i in range(4):
                near.append(Const.Mahjong(suit * 100 + new_rank * 10 + i))
            return set(near)

        @staticmethod
        def map_tiles_count(tiles: list, style: str = 'default') -> list:
            tiles_count_map = [0 for _ in range(34)]
            for tile in tiles:
                tiles_count_map[MahjongEngine.V1.index_of(tile)] += 1
            if not style in ['long', 'short']:
                return tiles_count_map
            else:
                long_map = [0]
                for i in range(3):
                    long_map.extend(tiles_count_map[i * 9:i * 9 + 9])
                    long_map.append(0)
                long_map.extend(tiles_count_map[-7:])
                long_map.append(0)
                if style == 'short':
                    short_map = [0]
                    for count in long_map:
                        if count != 0 or short_map[-1:][0] != 0:
                            short_map.append(count)
                    return short_map
                return long_map

        @staticmethod
        def use_razor(sheep: list, no_eyes: bool = False) -> list:

            def _razor(wool: list) -> list:
                """
                剔除没有变数的面子
                """
                for i in range(3):  # 处理数字牌
                    for j in range(1, 10):
                        index = i * 10 + j

                        # 剔除孤立的刻子
                        if wool[index] >= 3:
                            if wool[index - 1] == 0:  # 0, 3
                                if wool[index + 1] == 0:  # 0, 3, 0
                                    wool[index] -= 3
                                elif wool[index + 1] >= 3:  # 0, 3, 3
                                    if wool[index + 2] == 0:  # 0, 3, 3, 0
                                        wool[index] -= 3
                                        wool[index + 1] -= 3
                                    elif wool[index +
                                              2] >= 3:  # 0, 3, 3, 3 一色三节高直接约掉
                                        wool[index] -= 3
                                        wool[index + 1] -= 3
                                        wool[index + 2] -= 3
                            elif wool[index + 1] == 0:
                                if min(wool[index - 2:index]) >= 3:
                                    # 3, 3, 3, 0 反向一色三节高
                                    wool[index - 2] -= 3
                                    wool[index - 1] -= 3
                                    wool[index] -= 3

                        # 剔除孤立的顺子
                        if wool[index] in [1, 4]:  # 判断存在单张
                            # 2/3可能是刻子/雀头 1/4必定含有顺子
                            # 否则就是完全孤立的单张 绝对和不了 直接排除掉
                            if wool[index - 1] == 0:  # 判断孤立
                                if min(wool[index:index + 3]) > 0:  # 判断存在顺子
                                    wool[index] -= 1
                                    wool[index + 1] -= 1
                                    wool[index + 2] -= 1
                                else:
                                    return []
                            elif wool[index - 2] + wool[index + 2] == 0:
                                if min(wool[index - 1:index + 2]) > 0:
                                    wool[index - 1] -= 1
                                    wool[index] -= 1
                                    wool[index + 1] -= 1
                                else:
                                    return []
                            elif wool[index + 1] == 0:
                                if min(wool[index - 2:index + 1]) > 0:
                                    wool[index - 2] -= 1
                                    wool[index - 1] -= 1
                                    wool[index] -= 1
                                else:
                                    return []

                for i in range(31, 38):  # 处理字牌
                    if wool[i] == 3:
                        wool[i] = 0
                    elif wool[i] in [1, 4]:  # 1为孤立单张 4张字牌还不暗杠留着下蛋呢
                        return []

                return wool

            def _bigger_razor(wool: list) -> list:
                for i in range(3):
                    for j in range(1, 10):
                        index = i * 10 + j
                        if wool[index] == 3:  # 孤立刻子
                            if wool[index - 1] == 0:
                                if wool[index + 1] in [1, 2]:  # 0, 3, 1/2
                                    wool[index] -= 3
                            elif wool[index + 1] == 0:
                                if wool[index - 1] in [1, 2]:  # 1/2, 3, 0
                                    wool[index] -= 3
                        elif wool[index] in [1, 2]:  # 孤立顺子
                            if wool[index - 1] == 0:
                                if min(wool[index:index +
                                            3]) > 0:  # 0, 1/2, >1, >1
                                    wool[index] -= 1
                                    wool[index + 1] -= 1
                                    wool[index + 2] -= 1
                                else:
                                    return []
                            elif wool[index + 1] == 0:  # >1, >1, 1/2, 0
                                if min(wool[index - 2:index + 1]) > 0:
                                    wool[index - 2] -= 1
                                    wool[index - 1] -= 1
                                    wool[index] -= 1
                                else:
                                    return []
                return wool

            count = -1
            while len(sheep) > 0:
                new_count = reduce(lambda x, y: x + y, sheep)
                if count == new_count:
                    break
                else:
                    count = new_count
                if no_eyes:  # 已经去掉雀头
                    sheep = _bigger_razor(sheep)
                else:
                    sheep = _razor(sheep)
            return sheep

        @staticmethod
        def can_win(hand_tiles: list, print_details: bool = False) -> bool:
            """
            判定是否和牌 V1
            """

            def _guess_pair(known: list, possibility: list) -> int:
                hand_map = known[:]
                for eyes in possibility:
                    answer = hand_map[:]  # 深拷贝 避免影响下一次尝试
                    answer[eyes] -= 2  # 去掉雀头
                    answer = MahjongEngine.V1.use_razor(answer)
                    answer = MahjongEngine.V1.use_razor(answer, True)
                    answer = MahjongEngine.V1.use_razor(answer)
                    if len(answer) == 0:  # 排除本次错误的假设
                        continue
                    elif max(answer) == 0:  # 没有剩余存疑的手牌
                        return eyes
                    else:
                        logger(f'猜测并去掉雀头 {eyes} 前 {hand_map[1:10]} 万子')
                        logger(f'猜测并去掉雀头 {eyes} 后 {answer[1:10]} 万子')
                        raise Exception(
                            f'假设雀头为 {eyes} 的可能性无法确定也无法排除 需要继续进一步猜测')
                return -1

            hand_count_map = None
            if len(hand_tiles) == 9:  # 输入的已经是数量映射数组了
                hand_count_map = [0]
                hand_count_map.extend(hand_tiles)
                hand_count_map.extend([0 for _ in range(29)])
            elif len(hand_tiles) % 3 != 2:
                raise Exception(f'V1 和牌判定 手牌数量错误 {len(hand_tiles)}')
            else:
                hand_count_map = MahjongEngine.V1.map_tiles_count(
                    hand_tiles, 'long')

            if hand_count_map.count(2) == 7:  # 七对子
                return True

            if hand_count_map.count(1) >= 12:  # 国士无双
                one_nine_count = 0
                for i in range(3):
                    if hand_count_map[i * 10 + 1] > 0:
                        one_nine_count += 1
                    if hand_count_map[i * 10 + 9] > 0:
                        one_nine_count += 1
                for i in range(31, 38):
                    if hand_count_map[i] > 0:
                        one_nine_count += 1
                if one_nine_count == 13:
                    return True
                elif one_nine_count >= 9:
                    logger(f'放到听牌判断里 九种九牌 允许流局 {hand_tiles}')
                else:
                    return False

            # logger(f'第一次简化前 {hand_count_map[1:10]} 万子')
            tils_map = MahjongEngine.V1.use_razor(hand_count_map)
            if len(tils_map) == 0:  # 简化过程中发现不可能和
                return False
            # logger(f'第一次简化后 {tils_map[1:10]} 万子')

            pairs = []  # 雀头(将牌)的可能性
            for i in range(3):
                for j in range(1, 10):
                    index = i * 10 + j
                    if tils_map[index] >= 2:
                        pairs.append(index)
            for i in range(31, 38):
                if tils_map[i] == 2:
                    pairs = [i]  # 字牌没有顺子 单吊的2张必定是雀头
            if len(pairs) == 0:
                return False
            else:
                unsolved = []
                for eyes in pairs:
                    answer = tils_map[:]  # 深拷贝 避免影响下一次尝试
                    answer[eyes] -= 2  # 去掉雀头
                    answer = MahjongEngine.V1.use_razor(answer)
                    if len(answer) == 0:  # 排除本次错误的假设
                        continue
                    elif max(answer) == 0:  # 没有剩余存疑的手牌
                        if print_details:
                            logger(f'算出雀头为 {eyes}万')
                        return True
                    else:
                        unsolved.append(eyes)
                if len(unsolved) > 0:
                    true_eyes = _guess_pair(tils_map, unsolved)
                    if true_eyes > 0:
                        if print_details:
                            logger(f'猜出雀头为 {true_eyes}万 {tils_map[1:10]}')
                        return True
                    else:
                        return False

            return False

        @staticmethod
        def is_ready(hand_tiles: list) -> bool:
            """
            TODO 判定是否听牌
            """
            if len(hand_tiles) % 3 != 1:
                raise Exception(f'V1 听牌判定 手牌数量错误 {len(hand_tiles)}')
                return False

            tils_map = MahjongEngine.V1.use_razor(
                MahjongEngine.V1.map_tiles_count(hand_tiles, 'long'))
            if len(tils_map) == 0:  # 简化过程中发现不可能和
                return False
            logger(f'简化后 {tils_map[1:10]} 万子')
            logger(f'简化后 {tils_map[11:20]} 饼子')
            logger(f'简化后 {tils_map[21:30]} 索子')
            logger(f'简化后 {tils_map[31:]} 字牌')

            return False

        @staticmethod
        def limit(hand: list) -> int:
            """
            TODO 判定役种限制
            """
            return 0

        @staticmethod
        def check_call(hand_tiles: list, ownerless_tile) -> tuple:
            flag = 0b0000
            highlight = {'chow': [], 'pong': [], 'kong': []}

            temp = hand_tiles[:]
            temp.append(ownerless_tile)
            first_win, second_win = MahjongEngine.V1.can_win(
                temp), MahjongEngine.V2.can_win(temp)
            if first_win != second_win:
                raise (Exception(f'交叉验证 和牌判断 算法时冲突'))
            if first_win or second_win:  # 和
                flag |= 0b11000

            hand = set(hand_tiles)

            this = set()
            suit, rank = int(ownerless_tile.value /
                             100), int(ownerless_tile.value / 10) % 10
            for i in range(4):
                this.add(Const.Mahjong(suit * 100 + rank * 10 + i))
            if len(hand & this) == 3:  # 杠
                flag |= 0b0100
                highlight['kong'] = list(hand & this)
            if len(hand & this) == 2:  # 碰
                flag |= 0b0010
                highlight['pong'] = list(hand & this)

            left = MahjongEngine.V1.near_tile(ownerless_tile, -2, False)
            prev = MahjongEngine.V1.near_tile(ownerless_tile, -1, False)
            next = MahjongEngine.V1.near_tile(ownerless_tile, 1, False)
            right = MahjongEngine.V1.near_tile(ownerless_tile, 2, False)
            if ownerless_tile < 400:  # 数字牌
                if len(hand & left) > 0 and len(hand & prev) > 0:  # 1, 1, _
                    flag |= 0b0001
                    highlight['chow'].append(
                        [list(hand & left)[0],
                         list(hand & prev)[0]])
                if len(hand & prev) > 0 and len(hand & next) > 0:  # 1, _, 1
                    flag |= 0b0001
                    highlight['chow'].append(
                        [list(hand & prev)[0],
                         list(hand & next)[0]])
                if len(hand & next) > 0 and len(hand & right) > 0:  # _, 1, 1
                    flag |= 0b0001
                    highlight['chow'].append(
                        [list(hand & next)[0],
                         list(hand & right)[0]])

            return flag, highlight

    class V2(V1):
        """
        第二代麻将引擎
        - 更新了和牌判定算法 (参考 http://hp.vector.co.jp/authors/VA046927/mjscore/mjalgorism.html)
        """

        @staticmethod
        def can_win(hand_tiles: list, print_details: bool = False) -> bool:
            """
            回轨法 Agari Backtrack バックトラック法
            """

            hand_count_map = None
            if len(hand_tiles) == 9:  # 输入的已经是数量映射数组了
                hand_count_map = hand_tiles[:]
                hand_count_map.extend([0 for _ in range(25)])
            elif len(hand_tiles) % 3 == 2:
                hand_count_map = MahjongEngine.V1.map_tiles_count(hand_tiles)
            else:
                raise Exception(f'V2 和牌判定 手牌数量错误 {len(hand_tiles)}')

            def fetch_kotsu(temp: list, kotsu: list) -> tuple:  # 取出刻子
                for i in range(len(temp)):
                    if temp[i] >= 3:
                        temp[i] -= 3
                        kotsu.append(i)
                return temp, kotsu

            def fetch_shuntsu(temp: list, shuntsu: list) -> tuple:  # 取出顺子
                for i in range(3):
                    j = 0
                    while j < 7:
                        index = i * 9 + j
                        if min(temp[index:index + 3]) >= 1:
                            temp[index] -= 1
                            temp[index + 1] -= 1
                            temp[index + 2] -= 1
                            shuntsu.append(index)
                        else:
                            j += 1
                return temp, shuntsu

            if hand_count_map.count(2) == 7:  # 七对子
                return True

            if hand_count_map.count(1) >= 12:  # 国士无双
                one_nine_count = 0
                for i in range(3):
                    if hand_count_map[i * 9] > 0:
                        one_nine_count += 1
                    if hand_count_map[i * 9 + 8] > 0:
                        one_nine_count += 1
                for i in range(27, 34):
                    if hand_count_map[i] > 0:
                        one_nine_count += 1
                if one_nine_count == 13:
                    return True
                elif one_nine_count >= 9:
                    logger(f'放到听牌判断里 九种九牌 允许流局 {hand_tiles}')
                else:
                    return False

            ret = []
            for i in range(len(hand_count_map)):
                for kotsu_first in range(2):  # 轮流 先刻子后顺子 先顺子后刻子
                    janto = None
                    kotsu = []
                    shuntsu = []
                    temp = hand_count_map[:]
                    if temp[i] >= 2:
                        temp[i] -= 2
                        janto = i
                        if kotsu_first == 0:
                            temp, kotsu = fetch_kotsu(temp, kotsu)
                            temp, shuntsu = fetch_shuntsu(temp, shuntsu)
                        else:
                            temp, shuntsu = fetch_shuntsu(temp, shuntsu)
                            temp, kotsu = fetch_kotsu(temp, kotsu)
                        if max(temp) == 0:
                            ret.append(janto)
                            ret.append(kotsu)
                            ret.append(shuntsu)
            if len(ret) > 0:
                if print_details:
                    logger(
                        f'雀头为 {ret[0]+1}  刻子有 {[(s+1,s+1,s+1) for s in ret[1]]}  顺子有 {[(s+1,s+2,s+3) for s in ret[2]]}'
                    )
                return True
            else:
                return False

    class AI(object):
        """
        简单的人机 AI
        """

        def __init__(self, controller) -> None:
            self.__Player = controller
            # TODO 协程 / 多线程

        def think(self) -> None:  # TODO 判断
            pass
