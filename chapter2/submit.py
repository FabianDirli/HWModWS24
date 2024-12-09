#!/bin/env python3

import os
import sys
import textwrap
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from submission import create_submission_archive

def main():
	if len(sys.argv) < 2:
		print(textwrap.dedent("""\
		HWMod Homework II Submission Script

		Usage examples:
		  * Submit the tasks 'lfsr' and 'watch':
		    ./submit.py lfsr watch
		  * Additional '/' charactars in the task names are ignored. Hence, you can
		    also run:
		    ./submit.py lfsr/ watch/
		  * Submit all tasks:
		    ./submit.py -a"""))
		#--------|---------|---------|---------|---------|---------|---------|---------|
		exit(1)
	create_submission_archive(".", sys.argv[1:])

if __name__ == "__main__":
	main()
