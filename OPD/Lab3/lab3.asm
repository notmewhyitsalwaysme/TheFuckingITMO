ORG 0x5d3

first: WORD $el1
cur_el: WORD 0x0000
num_el: WORD 0x0000
res: WORD 0x0000

start: LD #0x40
SWAB
ASL
ST res
LD #0x08
ST num_el; т.к. 8 эллементов массива
LD first
ST cur_el
el: LD (cur_el)+
BMI iter
BEQ iter
CMP res
BLT iter
ST res
iter: LOOP num_el
JUMP el
HLT


el1: WORD 0xFFF9 ; -7
el2: WORD 0x0004 ; 4
el3: WORD 0xFC26 ; -986
el4: WORD 0x0007 ; 7
el5: WORD 0x0000 ; 0
el6: WORD 0x0003 ; 3
el7: WORD 0x0006 ; 6
el8: WORD 0xFAA7 ; -89
