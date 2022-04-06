from enum import IntEnum, Enum, unique


class Const(object):

    @unique
    class Mahjong(IntEnum):
        MAN1A = 110
        MAN1B = 111
        MAN1C = 112
        MAN1D = 113
        MAN2A = 120
        MAN2B = 121
        MAN2C = 122
        MAN2D = 123
        MAN3A = 130
        MAN3B = 131
        MAN3C = 132
        MAN3D = 133
        MAN4A = 140
        MAN4B = 141
        MAN4C = 142
        MAN4D = 143
        MAN5A = 150
        MAN5B = 151
        MAN5C = 152
        MAN5D = 153  # 赤五万
        MAN6A = 160
        MAN6B = 161
        MAN6C = 162
        MAN6D = 163
        MAN7A = 170
        MAN7B = 171
        MAN7C = 172
        MAN7D = 173
        MAN8A = 180
        MAN8B = 181
        MAN8C = 182
        MAN8D = 183
        MAN9A = 190
        MAN9B = 191
        MAN9C = 192
        MAN9D = 193
        PIN1A = 210
        PIN1B = 211
        PIN1C = 212
        PIN1D = 213
        PIN2A = 220
        PIN2B = 221
        PIN2C = 222
        PIN2D = 223
        PIN3A = 230
        PIN3B = 231
        PIN3C = 232
        PIN3D = 233
        PIN4A = 240
        PIN4B = 241
        PIN4C = 242
        PIN4D = 243
        PIN5A = 250
        PIN5B = 251
        PIN5C = 252
        PIN5D = 253  # 赤五饼
        PIN6A = 260
        PIN6B = 261
        PIN6C = 262
        PIN6D = 263
        PIN7A = 270
        PIN7B = 271
        PIN7C = 272
        PIN7D = 273
        PIN8A = 280
        PIN8B = 281
        PIN8C = 282
        PIN8D = 283
        PIN9A = 290
        PIN9B = 291
        PIN9C = 292
        PIN9D = 293
        SO1A = 310
        SO1B = 311
        SO1C = 312
        SO1D = 313
        SO2A = 320
        SO2B = 321
        SO2C = 322
        SO2D = 323
        SO3A = 330
        SO3B = 331
        SO3C = 332
        SO3D = 333
        SO4A = 340
        SO4B = 341
        SO4C = 342
        SO4D = 343
        SO5A = 350
        SO5B = 351
        SO5C = 352
        SO5D = 353  # 赤五索
        SO6A = 360
        SO6B = 361
        SO6C = 362
        SO6D = 363
        SO7A = 370
        SO7B = 371
        SO7C = 372
        SO7D = 373
        SO8A = 380
        SO8B = 381
        SO8C = 382
        SO8D = 383
        SO9A = 390
        SO9B = 391
        SO9C = 392
        SO9D = 393
        ZI1A = 410
        ZI1B = 411
        ZI1C = 412
        ZI1D = 413
        ZI2A = 420
        ZI2B = 421
        ZI2C = 422
        ZI2D = 423
        ZI3A = 430
        ZI3B = 431
        ZI3C = 432
        ZI3D = 433
        ZI4A = 440
        ZI4B = 441
        ZI4C = 442
        ZI4D = 443
        ZI5A = 450
        ZI5B = 451
        ZI5C = 452
        ZI5D = 453
        ZI6A = 460
        ZI6B = 461
        ZI6C = 462
        ZI6D = 463
        ZI7A = 470
        ZI7B = 471
        ZI7C = 472
        ZI7D = 473

    class Index(IntEnum):
        MAN1 = 0
        MAN2 = 1
        MAN3 = 2
        MAN4 = 3
        MAN5 = 4
        MAN0 = 4  # 赤五万
        MAN6 = 5
        MAN7 = 6
        MAN8 = 7
        MAN9 = 8
        PIN1 = 9
        PIN2 = 10
        PIN3 = 11
        PIN4 = 12
        PIN5 = 13
        PIN0 = 13  # 赤五饼
        PIN6 = 14
        PIN7 = 15
        PIN8 = 16
        PIN9 = 17
        SO1 = 18
        SO2 = 19
        SO3 = 20
        SO4 = 21
        SO5 = 22
        SO0 = 22  # 赤五索
        SO6 = 23
        SO7 = 24
        SO8 = 25
        SO9 = 26
        ZI1 = 27
        ZI2 = 28
        ZI3 = 29
        ZI4 = 30
        ZI5 = 31
        ZI6 = 32
        ZI7 = 33

    @unique
    class Code(Enum):
        MAN1 = '1m'
        MAN2 = '2m'
        MAN3 = '3m'
        MAN4 = '4m'
        MAN5 = '5m'
        MAN0 = '0m'  # 赤五万
        MAN6 = '6m'
        MAN7 = '7m'
        MAN8 = '8m'
        MAN9 = '9m'
        PIN1 = '1p'
        PIN2 = '2p'
        PIN3 = '3p'
        PIN4 = '4p'
        PIN5 = '5p'
        PIN0 = '0p'  # 赤五饼
        PIN6 = '6p'
        PIN7 = '7p'
        PIN8 = '8p'
        PIN9 = '9p'
        SO1 = '1s'
        SO2 = '2s'
        SO3 = '3s'
        SO4 = '4s'
        SO5 = '5s'
        SO0 = '0s'  # 赤五索
        SO6 = '6s'
        SO7 = '7s'
        SO8 = '8s'
        SO9 = '9s'
        ZI1 = '1z'
        ZI2 = '2z'
        ZI3 = '3z'
        ZI4 = '4z'
        ZI5 = '5z'
        ZI6 = '6z'
        ZI7 = '7z'

    @unique
    class Alias(Enum):
        MAN1 = '一万'
        MAN2 = '二万'
        MAN3 = '三万'
        MAN4 = '四万'
        MAN5 = '五万'
        MAN0 = '赤五万'
        MAN6 = '六万'
        MAN7 = '七万'
        MAN8 = '八万'
        MAN9 = '九万'
        PIN1 = '一饼'
        PIN2 = '二饼'
        PIN3 = '三饼'
        PIN4 = '四饼'
        PIN5 = '五饼'
        PIN0 = '赤五饼'
        PIN6 = '六饼'
        PIN7 = '七饼'
        PIN8 = '八饼'
        PIN9 = '九饼'
        SO1 = '一索'
        SO2 = '二索'
        SO3 = '三索'
        SO4 = '四索'
        SO5 = '五索'
        SO0 = '赤五索'
        SO6 = '六索'
        SO7 = '七索'
        SO8 = '八索'
        SO9 = '九索'
        ZI1 = '东风'
        ZI2 = '南风'
        ZI3 = '西风'
        ZI4 = '北风'
        ZI5 = '白板'
        ZI6 = '发财'
        ZI7 = '红中'


def main(argv: int = 0) -> None:
    temp = []
    suit = ['MAN', 'PIN', 'SO', 'ZI']
    if argv == 1:
        index = ['A', 'B', 'C', 'D']
        for i in range(1, 4):
            for j in range(1, 10):
                for n in range(4):
                    temp.append(
                        f'        {suit[i-1]}{j}{index[n]} = {i * 100 + j * 10 + n}'
                    )
        for i in range(1, 8):
            for j in range(4):
                temp.append(f'        ZI{i}{index[j]} = {400 + i * 10 + j}')
        print('\n'.join(temp))
    elif argv == 2:
        count = 0
        temp = []
        for i in range(3):
            for j in range(1, 10):
                temp.append(f'        {suit[i]}{j} = {count}')
                count += 1
        for i in range(1, 8):
            temp.append(f'        ZI{i} = {count}')
            count += 1
        print('\n'.join(temp))
    elif argv == 3:
        suit2 = ['m', 'p', 's', 'z']
        for i in range(3):
            for j in range(10):
                temp.append(f'        {suit[i]}{j} = \'{j}{suit2[i]}\'')
        for i in range(1, 8):
            temp.append(f'        ZI{i} = \'{i}z\'')
        print('\n'.join(temp))
    elif argv == 4:
        hans = {
            'Suit': ['万', '饼', '索'],
            'Rank': ['赤五', '一', '二', '三', '四', '五', '六', '七', '八', '九'],
            'WindAndDragon': ['东风', '南风', '西风', '北风', '白板', '发财', '红中']
        }
        for i in range(3):
            for j in range(10):
                temp.append(
                    f'        {suit[i]}{j} = \'{hans["Rank"][j]}{hans["Suit"][i]}\''
                )
        for i in range(1, 8):
            temp.append(f'        ZI{i} = \'{hans["WindAndDragon"][i-1]}\'')
        print('\n'.join(temp))
    else:
        pai_5m = Const.Mahjong['MAN5A']
        pai_2p = Const.Mahjong(233)
        tips = [
            f'Mahjong.{pai_5m.name} = {pai_5m.value}',
            f'Mahjong.{pai_2p.name} = {pai_2p.value}',
        ]
        for pai in Const.Alias:
            tips.append(f'Alias.{pai.name} = {pai.value}')
        print('\n'.join(tips))


if __name__ == "__main__":
    main()
