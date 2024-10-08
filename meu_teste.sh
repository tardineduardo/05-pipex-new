#!/bin/zsh

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
YELLOW="\033[33;1m"
COLOR_LIMITER="\033[0m"

# Path and filenames for the test files
mkdir -p $TMP
ls --help > infile.txt
touch no_read_perm.txt
chmod -r no_read_perm.txt



# Compile the program
make

TEST_NO=0

((TEST_NO++))
echo ""
echo -e $YELLOW_BG"$TEST_NO. Success case"$COLOR_LIMITER
echo ""
echo $YELLOW$NAME infile.txt wc \"cat -e\" outfile.txt$COLOR_LIMITER 
$NAME infile.txt wc "cat -e" outfile.txt; echo $? > $TMP/exit.txt
echo $YELLOW"< infile.txt wc | cat -e > outfile_ref.txt"$COLOR_LIMITER
< infile.txt wc | cat -e > outfile_ref.txt; echo $? > $TMP/exit_ref.txt
echo ""
if diff outfile.txt outfile_ref.txt > /dev/null; then
	echo -e $GREEN"[OK] files match"$COLOR_LIMITER;
else 
	echo -e $RED"[KO] files don't match"$COLOR_LIMITER; 
fi

# Run valgrind and save the output to valgrind_tmp.txt
valgrind --trace-children=yes --leak-check=summary $NAME infile.txt wc "cat -e" outfile.txt &> $TMP/valgrind_memory_tmp.txt
if grep -q "Rerun with --leak-check=full to see details of leaked memory" $TMP/valgrind_memory_tmp.txt; then
    echo -e $RED"[KO] check memory leaks$COLOR_LIMITER (run valgrind --trace-children=yes)"
else
    echo -e $GREEN"[OK] no memory leaks"$COLOR_LIMITER
fi
rm $TMP/valgrind_memory_tmp.txt

# Search for the specific PIPE LEAKS in valgrind's output
valgrind --trace-children=yes --track-fds=yes --leak-check=summary $NAME infile.txt wc "cat -e" outfile.txt &> $TMP/valgrind_pipes_tmp.txt
if grep "at 0x" $TMP/valgrind_pipes_tmp.txt; then
    echo -e $RED"[KO] pipes were left open $COLOR_LIMITER(run valgrind --track-fds=yes --trace-children=yes)"$COLOR_LIMITER
else
    echo -e $GREEN"[OK] all pipes are closed"$COLOR_LIMITER
fi
rm $TMP/valgrind_pipes_tmp.txt

echo $TMP/exit.txt
echo $TMP/exit_ref.txt

echo ""

# ((TEST_NO++))
# echo -e $YELLOW_BG"$TEST_NO. Non-existent input file"$COLOR_LIMITER
# $NAME non_existent_file "cat" "grep call" $TMP/outfile.txt; echo $? > $TMP/exit.txt
# < non_existent_file cat | grep call > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
# if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
# 	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
# else 
# 	echo -e $RED"[KO]"$COLOR_LIMITER; 
# fi

# ((TEST_NO++))
# echo -e $YELLOW_BG"$TEST_NO. Infile with no read permission"$COLOR_LIMITER
# $NAME $TMP/no_read_perm.txt "cat" "grep call" $TMP/outfile.txt; echo $? > $TMP/exit.txt
# < $TMP/no_read_perm.txt | grep call > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
# if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
# 	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
# else 
# 	echo -e $RED"[KO]"$COLOR_LIMITER; 
# fi

# ((TEST_NO++))
# echo -e $YELLOW_BG"$TEST_NO. Non-existent cmd1"$COLOR_LIMITER
# $NAME $TMP/infile.txt "non_existent_cmd1" "grep COLS" $TMP/outfile.txt; echo $? > $TMP/exit.txt
# < $TMP/infile.txt non_existent_cmd1 | grep COLS > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
# if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
# 	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
# else 
# 	echo -e $RED"[KO]"$COLOR_LIMITER; 
# fi

# ((TEST_NO++))
# echo -e $YELLOW_BG"$TEST_NO. Non-existent cmd2"$COLOR_LIMITER
# $NAME $TMP/infile.txt "cat" "non_existent_cmd2" $TMP/outfile.txt > /dev/null 2>&1; echo $? > $TMP/exit.txt
# < $TMP/infile.txt cat | "non_existent_cmd2" > $TMP/outfile_ref.txt; echo $? > $TMP/exit_ref.txt
# if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
# 	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
# else 
# 	echo -e $RED"[KO]"$COLOR_LIMITER; 
# fi

# ((TEST_NO++))
# echo -e $YELLOW_BG"$TEST_NO. Invalid outfile"$COLOR_LIMITER
# $NAME $TMP/infile.txt "cat" "echo hello" /etc/passwd; echo $? > $TMP/exit.txt
# < $TMP/infile.txt cat | grep call > /etc/passwd; echo $? > $TMP/exit_ref.txt
# if diff $TMP/outfile.txt $TMP/outfile_ref.txt && diff $TMP/exit.txt $TMP/exit_ref.txt; then 
# 	echo -e $GREEN"[OK]"$COLOR_LIMITER; 
# else 
# 	echo -e $RED"[KO]"$COLOR_LIMITER; 
# fi




rm infile.txt
rm outfile.txt
rm outfile_ref.txt
chmod 0777 no_read_perm.txt
rm no_read_perm.txt
rm tests -r