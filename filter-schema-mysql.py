#!/usr/bin/python

import sys
import re

lines=sys.__stdin__.readlines()
mark=[False for i in range(len(lines))]
for i in range(len(lines)):
	if re.search("KEY",lines[i]) and not re.search("PRIMARY KEY",lines[i]) and not re.search("FOREIGN_KEY",lines[i]):
		lines[i-1]=lines[i-1].rstrip(",\n")+'\n'
		#print lines[i-1],
		#print lines[i],
		#print
		mark[i]=True
lines2=[lines[i] for i in range(len(lines)) if not mark[i]]
sys.__stdout__.writelines(lines2)
