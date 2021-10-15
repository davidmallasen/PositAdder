import random
import sys

random.seed(0)

n = 1000000

with open('posit_input.txt', 'w') as posit_input:
    # 0 + 0
    posit_input.write('0000000000000000\n')
    posit_input.write('0000000000000000\n')
    # 0 + inf
    posit_input.write('0000000000000000\n')
    posit_input.write('1000000000000000\n')
    # inf + 0
    posit_input.write('1000000000000000\n')
    posit_input.write('0000000000000000\n')
    # inf + inf
    posit_input.write('1000000000000000\n')
    posit_input.write('1000000000000000\n')
    # max_num + max_num
    posit_input.write('0111111111111111\n')
    posit_input.write('0111111111111111\n')
    # 1 + (-1)
    posit_input.write('0100000000000000\n')
    posit_input.write('1100000000000000\n')
    # (-1) + 1
    posit_input.write('1100000000000000\n')
    posit_input.write('0100000000000000\n')
    # min_num + min_num
    posit_input.write('1000000000000001\n')
    posit_input.write('1000000000000001\n')

    for _ in range(n * 2):
        for _ in range(16):
            posit_input.write(str(random.randint(0, 1)))
        posit_input.write('\n')
