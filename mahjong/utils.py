import time
from functools import wraps
import random
import hashlib


class Utils(object):

    @staticmethod
    def get_time() -> str:
        return time.strftime('%H:%M:%S', time.localtime())

    @staticmethod
    def record_elapsed(function):

        @wraps(function)
        def function_timer(*args, **kwargs):
            t0 = time.time()
            result = function(*args, **kwargs)
            t1 = time.time()
            print('Total time running {}(): {} seconds'.format(
                function.__name__, str(t1 - t0)))
            return result

        return function_timer

    @staticmethod
    def shuffle(array: list) -> list:
        """
        公平洗牌算法 Fisher-Yates Shuffle 取出法
        random 包的 shuffle() 就是这个算法
        """
        random.shuffle(array)
        return array
        if len(array) < 2:
            return array
        # 减少空间复杂度(不新建另一个数组)其实就是 Knuth-Durstenfeld Shuffle 倒序交换法
        # 参考: https://mp.weixin.qq.com/s?__biz=MzU4NTIxODYwMQ==&mid=2247484310&idx=1&sn=916f92afff6016256648cfb3c7fd83e7
        for i in reversed(range(1, len(array))):
            rand = randrange(i + 1)
            array[i], array[rand] = array[rand], array[i]
        return array

    @staticmethod
    def md5(text: str) -> str:
        return hashlib.md5(text.encode(encoding='UTF-8')).hexdigest()

    class Logger(object):

        @staticmethod
        def gen_logs(*args) -> str:
            if len(args) == 0:
                raise (
                    Exception(f'utils.py Utils.Logger.gen_logs() 打印日志时缺少参数'))
            args_text = []
            for argv in args:
                args_text.append(str(argv))
            logs = ' '.join(args)
            return logs

        @staticmethod
        def test(*args) -> None:
            print(f'{Utils.get_time()} [TEST]', *args)

        @staticmethod
        def debug(*args) -> None:
            print(f'{Utils.get_time()} [DEBUG]', *args)

        @staticmethod
        def info(*args) -> None:
            print(f'{Utils.get_time()} [INFO] {Utils.Logger.gen_logs(*args)}')

        @staticmethod
        def warn(*args) -> None:
            print(f'{Utils.get_time()} [WARN]', *args)

        @staticmethod
        def error(*args) -> None:
            print(f'{Utils.get_time()} [ERROR]', *args)
            exit(504)

        @staticmethod
        def fatal(*args) -> None:
            raise (Exception(*args))

        def __call__(self, *args):
            Utils.Logger.debug(*args)


@Utils.record_elapsed
def random_sort(n):
    return sorted([random.random() for _ in range(n)])


if __name__ == "__main__":
    random_sort(2000000)
