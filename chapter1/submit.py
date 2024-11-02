#!/bin/env python3

import json
import os
import sys
import pathlib
import textwrap

RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
RESET = "\033[0m"

slog = open("submission.log", "w")

def error(msg: str):
	print(f"{RED}Error: {msg}{RESET}")
	exit(1)

def warning(msg: str):
	print(f"{YELLOW}Warning: {msg}{RESET}")
	slog.write(f"Warning: {msg}\n")

def message(msg: str):
	print(msg)
	slog.write(f"{msg}\n")

def usage():
	print(textwrap.dedent("""\
		HWMod Homework I Submission Script

		Usage examples:
		  * Submit the tasks 'alu' and 'sram':
		    ./submit.py alu sram
		  * Additional '/' charactars in the task names are ignored. Hence, you can
		    also run:
		    ./submit.py alu/ sram/
		  * Submit all tasks:
		    ./submit.py -a"""))
		#--------|---------|---------|---------|---------|---------|---------|---------|

def main():

	if len(sys.argv) == 1:
		usage()
		error("No arguments!")

	with open(".tasks.json") as f:
		task_data = json.load(f)

	slog.write(f"running: {sys.argv}\n")

	if len(sys.argv) == 2 and sys.argv[1] == "-a":
		tasks = task_data.keys()
	else:
		tasks = [x.strip("/") for x in sys.argv[1:]]


	# check submitted tasks
	for task in tasks:
		if task not in task_data:
			error(f"There is no task named '{task}'. Valid tasks are {', '.join(task_data.keys())}")
		os.system(f"make clean -C {task} > /dev/null")

		task_dir = pathlib.Path(task)
		vhd_files = {}
		for path in task_dir.glob(f"**/*.vhd"):
			with open(path) as f:
				lines = len(list(f.readlines()))
			vhd_files[str(path)] = lines

		expected = set(vhd_files.keys())
		actual = set(task_data[task]["vhd"].keys())
		if expected != actual :
			if expected - actual != set():
				error(f"Found unexpected VHDL file(s) in directory of task '{task}': {expected - actual} -- Please note that you are not allowed to create new VHDL files or rename existing ones!")
			if actual - expected != set():
				error(f"Missing VHDL file(s) in directory of task '{task}': {actual - expected} -- Please note that you are not allowed to delete or rename VHDL files!")

		total_expected = sum(task_data[task]["vhd"].values())
		total_actual = sum(vhd_files.values())

		if total_expected - total_actual == 0:
			error(f"You don't have a solution for task '{task}'. If you think this is an error please contact the teaching staff!")
		if abs(total_expected-total_actual) < 5:
			warning(f"You want to submit task '{task}'. However, it seems that you don't have a solution for it! Is this a mistake?")

	# create archive
	total_points = sum([int(task_data[x]["points"]) for x in tasks])

	message(f"You submitted {len(tasks)} tasks worth {total_points} points: {' '.join(tasks)}")
	if total_points < 3:
		error("You need to submit task worth at least 3 points!").py
	slog.close()
	os.system(f"tar -czf submission.tar.gz {' '.join(tasks)} submission.log")
	print("Created submission archive: submission.tar.gz")
	print("Please DO NOT forget to upload it to TUWEL!")


if __name__ == "__main__":
	main()
