# 16-bit Posit Adder for FPGAs
VHDL implementation of a posit<16,2> adder targeting low-end FPGAs. The code is synthesized targeting an Intel Max-10 Series FPGA using Quartus Prime Lite Edition. Results show a maximum operating frequency of 22.54 MHz which is an 18% improvement over previous designs. Regarding area cost, it utilizes 587 LUTs, which is comparable to other implementations.

Along with the implementation we have also included an extensive testsuite of every entity. The full adder is tested with some corner values and an automatic python script which generates 1 million random test cases.
