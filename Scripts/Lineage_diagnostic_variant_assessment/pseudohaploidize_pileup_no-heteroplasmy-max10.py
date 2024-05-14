import sys

import random

from collections import Counter

with open(sys.argv[1]) as FILE:

	for LINE in FILE:

		if LINE.startswith("#"):

			continue

		LINE = LINE.rstrip("\n")

		SPLINE = LINE.split("\t")

		REF = SPLINE[2]

		#skip sites with structural variants

		if bool([ele for ele in [">","<","+","*","[","]"] if(ele in SPLINE[4])]):

			continue

		# remove positional info
		SPLINE[4]=SPLINE[4].replace("^","").replace("$","").replace(".",",").upper()

		#filter out heterplasmic sites or those with depth 10 or more
		if len(Counter(SPLINE[4]).keys()) != 1 or len(SPLINE[4]) > 10:

			continue

		RANDBASE = SPLINE[4][random.randrange(0,len(SPLINE[4]))]

		if RANDBASE in [".",","]:

			BASE = REF

		else:

			BASE = RANDBASE.upper()

		print "\t".join([SPLINE[0],SPLINE[1],SPLINE[2],BASE])
