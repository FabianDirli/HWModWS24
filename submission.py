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

slog = None

def init_slog(path):
	global slog
	slog = open(path, "w")

def error(msg: str):
	print(f"{RED}Error: {msg}{RESET}")
	slog.write(f"Error: {msg}\n")
	exit(1)

def warning(msg: str):
	print(f"{YELLOW}Warning: {msg}{RESET}")
	slog.write(f"Warning: {msg}\n")

def message(msg: str):
	print(msg)
	slog.write(f"{msg}\n")

def usage():
	print(textwrap.dedent("""\
		HWMod Homework Submission Script

		./submission.py CHAPTER TASKS ...

		Usage examples:
		  * Submit the tasks 'alu' and 'sram' of chapter 1:
		    ./submission.py chapter1 alu sram
		  * Additional '/' charactars in the task names are ignored, so is the prefix
		    'CHAPTER/'. Hence, you can also run:
		    ./submission.py chapter1 chapter1/alu/ chapter1/sram/
		  * Submit all tasks of chapter 1:
		    ./submission.py chapter1 -a"""))
		#--------|---------|---------|---------|---------|---------|---------|---------|

def create_submission_archive(chapter: str, tasks: list[str]):
	chapter_dir = pathlib.Path(chapter).absolute()
	init_slog(f"{chapter_dir}/submission.log")

	chapter = chapter_dir.name

	if not pathlib.Path(f"{chapter_dir}/.tasks.json").exists():
		error(f"{chapter} is not a valid homework directory, .tasks.json does not exist")

	with open(f"{chapter_dir}/.tasks.json") as f:
		task_data = json.load(f)

	slog.write(f"tasks to submit: {tasks}\n")

	if len(tasks) == 1 and tasks[0] == "-a":
		tasks = task_data.keys()
	else:
		tasks = [x.strip("/").removeprefix(f"{chapter}/") for x in tasks]


	# check submitted tasks
	for task in tasks:
		if task not in task_data:
			error(f"There is no task named '{task}'. Valid tasks are {', '.join(task_data.keys())}")

		task_dir = pathlib.Path(f"{chapter_dir}/{task}")
		os.system(f"make clean -C {task_dir} > /dev/null")
		r = os.system(f"make compile -C {task_dir} > /dev/null")
		if r != 0:
			error(f"make compile for task '{task}' failed!")
		os.system(f"make clean -C {task_dir} > /dev/null")

		if pathlib.Path(f"{chapter_dir}/{task}/quartus").exists():
			os.system(f"make qclean -C {task_dir} > /dev/null")

		vhd_files = {}
		for path in task_dir.glob(f"**/*.vhd"):
			with open(path) as f:
				lines = len(list(f.readlines()))
			vhd_files[str(path.relative_to(chapter_dir))] = lines

		expected = set(vhd_files.keys())
		actual = set(task_data[task]["vhd"].keys())
		if expected != actual :
			if expected - actual != set():
				error(f"Found unexpected VHDL file(s) in directory of task '{task}': {expected - actual} -- Please note that you are not allowed to create new VHDL files or rename existing ones!")
			if actual - expected != set():
				error(f"Missing VHDL file(s) in directory of task '{task}': {actual - expected} -- Please note that you are not allowed to delete or rename VHDL files!")

		total_expected = sum(task_data[task]["vhd"].values())
		total_actual = sum(vhd_files.values())

		if not task_data[task]["disable_vhd_line_check"]:
			if total_expected - total_actual == 0:
				error(f"You don't have a solution for task '{task}'. If you think this is an error please contact the teaching staff!")
			if abs(total_expected-total_actual) < 5:
				warning(f"You want to submit task '{task}'. However, it seems that you don't have a solution for it! Is this a mistake?")

		new_files = task_data[task]["new_files"]
		for file in new_files:
			if not (task_dir / file).exists():
				error(f"file {task}/{file} does not exist!")

		for check in task_data[task]["checks"]:
			r = os.system(f"cd {task_dir} && {check['cmd']}")
			if r != 0:
				error(f"task '{task}' - {check['msg']} If you think this is an error please contact the teaching staff!")

	# create archive
	total_points = sum([int(task_data[x]["points"]) for x in tasks])

	message(f"You submitted {len(tasks)} tasks worth {total_points} points: {' '.join(tasks)}")
	if total_points < 3:
		error("You need to submit task worth at least 3 points!").py
	slog.close()
	os.system(f"cd {chapter_dir} && tar -czf submission_{chapter}.tar.gz {' '.join(tasks)} submission.log")
	print(f"Created submission archive: submission_{chapter}.tar.gz")
	print("Please DO NOT forget to upload it to TUWEL!")


def main():
	if len(sys.argv) < 3:
		usage()
		exit(1)

	d = sys.argv[1]
	if not pathlib.Path(d).exists():
		pritn(f"{d} does not exist!")
		exit(1)

	create_submission_archive(d, sys.argv[2:])

if __name__ == "__main__":
	main()
