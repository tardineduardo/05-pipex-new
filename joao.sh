#!/bin/bash

# This script is used to test the functionality of the program

# Environment variables
NAME=./pipex
TMP=./tests

# Colors Definition 
GREEN="\033[32;1m"
RED="\033[31;1m"
CYAN="\033[36;1;3;208m"
WHITE="\033[37;1;4m"
YELLOW_BG="\033[43;1;3;208m"
COLOR_LIMITER="\033[0m"

# Path and filenames for the test files
mkdir -p $TMP
ls --help > $TMP/infile.txt
touch $TMP/no_read_perm.txt
chmod -r $TMP/no_read_perm.txt

# Compile the program
make

TEST_NO=0

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Success case"$COLOR_LIMITER
$NAME $TMP/infile.txt "cat" "grep call" $TMP/outfile.txt; echo $? > $TMP/exit.txt
< $TMP/infile.txt cat | grep call > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Non-existent input file"$COLOR_LIMITER
$NAME non_existent_file "cat" "grep call" $TMP/outfile.txt; echo $? > $TMP/exit.txt
< non_existent_file cat | grep call > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Infile with no read permission"$COLOR_LIMITER
$NAME $TMP/no_read_perm.txt "cat" "grep call" $TMP/outfile.txt; echo $? > $TMP/exit.txt
< $TMP/no_read_perm.txt | grep call > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Non-existent cmd1"$COLOR_LIMITER
$NAME $TMP/infile.txt "non_existent_cmd1" "grep COLS" $TMP/outfile.txt; echo $? > $TMP/exit.txt
< $TMP/infile.txt non_existent_cmd1 | grep COLS > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Non-existent cmd2"$COLOR_LIMITER
$NAME $TMP/infile.txt "cat" "non_existent_cmd2" $TMP/outfile.txt > /dev/null 2>&1; echo $? > $TMP/exit.txt
< $TMP/infile.txt cat | "non_existent_cmd2" > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi

((TEST_NO++))
echo -e $YELLOW_BG"$TEST_NO. Invalid outfile"$COLOR_LIMITER
$NAME $TMP/infile.txt "cat" "echo hello" /etc/passwd; echo $? > $TMP/exit.txt
< $TMP/infile.txt cat | grep call > /etc/passwd; echo $? > $TMP/exit_ref.txt
if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
else 
	echo -e $RED"[KO]"$COLOR_LIMITER; 
fi