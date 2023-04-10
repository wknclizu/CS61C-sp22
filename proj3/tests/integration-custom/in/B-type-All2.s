         addi s1, x0, 1
         addi s0, x0, -1
label5:  bne  x0, x0, label1
label6:  bgeu x0, s0, label8
label4:  bge  x0, s1, label5
         bne  x0, x0, label6
label3:  bne  s1, s1, label4
label10: bne  s0, s0, end
label2:  bge  x0, s1, label3
label9:  bge  s0, s1, label10
label1:  bne  x0, x0, label2
label8:  bgeu s1, s0, label9
         bne  s1, s1, label9
end:     addi s0, x0, 2
