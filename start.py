import sys
import os

sys.path.append(f'{os.path.split(os.path.realpath(sys.argv[0]))[0]}\\mahjong')

from game import MahjongGame


def main() -> None:
    Game = MahjongGame()
    Game.new()
    Game.join()
    Game.join('小南', False, True)
    Game.join('UUZ')
    Game.join('小北')
    Game.join('观战者')
    Game.start()


if __name__ == "__main__":
    main()
