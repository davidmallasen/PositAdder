import sys
import softposit as sp

posit_input = []
with open('posit_input.txt') as file:
    posit_input = file.readlines()

posit_output = []
with open('posit_output.txt') as file:
    posit_output = file.readlines()

assert len(posit_input) == len(posit_output) * 2

for i, out in enumerate(posit_output):
    in1 = posit_input(2 * i)
    in2 = posit_input(2 * i + 1)

    posin1 = sp.posit_2(x=16, bits=bin(int(in1, 2)))
    posin2 = sp.posit_2(x=16, bits=bin(int(in2, 2)))
    posout = sp.posit_2(x=16, bits=bin(int(out, 2)))

    psum = posin1 + posin2

    assert posout == psum, f"{in1}({posin1}) + {in2}({posin2}) returned {out}({posout}) and should be {psum.toBinary()}({psum})"
