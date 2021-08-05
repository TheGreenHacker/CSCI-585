#!/usr/local/bin/python3
import numpy as np
from math import cos, sin, pi

centerX = -118.28542956556906
centerY = 34.02067992031394
R = 8
r = 1
a = 4
N = 20000
nRevs = 16

f = open("spiro.txt", 'w')
f.write("[\n")

for t in np.arange(0.0, pi * nRevs, 0.1):
	x = ((R + r) * cos((r / R) * t) - a * cos((1 + r / R) * t)) / N + centerX
	y = ((R + r) * sin((r / R) * t) - a * sin((1 + r / R) * t)) / N + centerY

	f.write("{\n")
	f.write("\"loc\": " + "[" + str(x) + "," + str(y) + "]\n")
	f.write("},\n")

f.write("]\n")
f.close()