import random
import sys

random.seed(0)

n = 100

with open('posit_input.txt', 'w') as posit_input:
    for _ in range(n * 2):
        for _ in range(16):
            posit_input.write(str(random.randint(0, 1)))
        posit_input.write('\n')
