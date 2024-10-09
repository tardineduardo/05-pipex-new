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
echo "teste do\neduardo\ntardin\n" > infile.txt
touch no_read_perm.txt
chmod -r no_read_perm.txt

# Compile the program
#make

NO=00

# START ---------------------------------------------------------------------------

((NO++))
echo ""
echo -e $YELLOW_BG"$NO. Success case"$COLOR_LIMITER
echo ""

PIPEX="$NAME infile.txt \"cat -e\" \"cat -e\" $TMP/${NO}_outfile.txt"
NORMAL="< infile.txt cat -e | cat -e > $TMP/${NO}_outfile_ref.txt"

echo $YELLOW$PIPEX $COLOR_LIMITER 
eval $PIPEX; echo $? > $TMP/${NO}_exit.txt
echo $YELLOW$NORMAL $COLOR_LIMITER
eval $NORMAL; echo $? > $TMP/${NO}_exit_ref.txt
echo ""
if diff $TMP/${NO}_outfile.txt $TMP/${NO}_outfile_ref.txt > /dev/null; then
    echo -e $GREEN"[OK] out files match"$COLOR_LIMITER;
else 
    echo -e $RED"[KO] out files don't match"$COLOR_LIMITER; 
fi

# Run valgrind checking memory leaks
eval valgrind --trace-children=yes --leak-check=summary $PIPEX &> $TMP/${NO}_valgrind_memory.txt
if grep -q "Rerun with --leak-check=full to see details of leaked memory" $TMP/${NO}_valgrind_memory.txt; then
    echo -e $RED"[KO] check memory leaks$COLOR_LIMITER\t\t(run valgrind --trace-children=yes)"
else
    echo -e $GREEN"[OK] no memory leaks"$COLOR_LIMITER
fi

# Run valgrind with pipe tracking
eval valgrind --trace-children=yes --track-fds=yes $PIPEX &> $TMP/${NO}_valgrind_pipes.txt
if awk '/Open file descriptor/ {getline; if ($0 !~ /<inherited from parent>/) {found=1}} END {exit found}' "$TMP/${NO}_valgrind_pipes.txt"; then
    echo -e "${GREEN}[OK] all pipes are closed${COLOR_LIMITER}"
else
    echo -e "${RED}[KO] pipes were left open${COLOR_LIMITER}\t(run valgrind --track-fds=yes --trace-children=yes)${COLOR_LIMITER}"
fi

echo ""

# START ---------------------------------------------------------------------------

((NO++))
echo ""
echo -e $YELLOW_BG"$NO. Success case"$COLOR_LIMITER
echo ""

PIPEX="$NAME infile.txt \"cat -e\" \"cat -e\" \"cat -e\" $TMP/${NO}_outfile.txt"
NORMAL="< infile.txt cat -e | cat -e | cat -e > $TMP/${NO}_outfile_ref.txt"

echo $YELLOW$PIPEX $COLOR_LIMITER 
eval $PIPEX; echo $? > $TMP/${NO}_exit.txt
echo $YELLOW$NORMAL $COLOR_LIMITER
eval $NORMAL; echo $? > $TMP/${NO}_exit_ref.txt
echo ""
if diff $TMP/${NO}_outfile.txt $TMP/${NO}_outfile_ref.txt > /dev/null; then
    echo -e $GREEN"[OK] out files match"$COLOR_LIMITER;
else 
    echo -e $RED"[KO] out files don't match"$COLOR_LIMITER; 
fi

# Run valgrind checking memory leaks
eval valgrind --trace-children=yes --leak-check=summary $PIPEX &> $TMP/${NO}_valgrind_memory.txt
if grep -q "Rerun with --leak-check=full to see details of leaked memory" $TMP/${NO}_valgrind_memory.txt; then
    echo -e $RED"[KO] check memory leaks$COLOR_LIMITER\t\t(run valgrind --trace-children=yes)"
else
    echo -e $GREEN"[OK] no memory leaks"$COLOR_LIMITER
fi

# Run valgrind with pipe tracking
eval valgrind --trace-children=yes --track-fds=yes $PIPEX &> $TMP/${NO}_valgrind_pipes.txt
if awk '/Open file descriptor/ {getline; if ($0 !~ /<inherited from parent>/) {found=1}} END {exit found}' "$TMP/${NO}_valgrind_pipes.txt"; then
    echo -e "${GREEN}[OK] all pipes are closed${COLOR_LIMITER}"
else
    echo -e "${RED}[KO] pipes were left open${COLOR_LIMITER}\t(run valgrind --track-fds=yes --trace-children=yes)${COLOR_LIMITER}"
fi



echo ""



# START ---------------------------------------------------------------------------

((NO++))
echo ""
echo -e $YELLOW_BG"$NO. No input file"$COLOR_LIMITER
echo ""

PIPEX="$NAME no_file \"cat -e\" \"cat -e\" \"cat -e\" $TMP/${NO}_outfile.txt"
NORMAL="< no_file cat -e | cat -e | cat -e > $TMP/${NO}_outfile_ref.txt"

echo $YELLOW$PIPEX $COLOR_LIMITER 
eval $PIPEX; echo $? > $TMP/${NO}_exit.txt
echo $YELLOW$NORMAL $COLOR_LIMITER
eval $NORMAL; echo $? > $TMP/${NO}_exit_ref.txt
echo ""
if diff $TMP/${NO}_outfile.txt $TMP/${NO}_outfile_ref.txt > /dev/null; then
    echo -e $GREEN"[OK] out files match"$COLOR_LIMITER;
else 
    echo -e $RED"[KO] out files don't match"$COLOR_LIMITER; 
fi

# Run valgrind checking memory leaks
eval valgrind --trace-children=yes --leak-check=summary $PIPEX &> $TMP/${NO}_valgrind_memory.txt
if grep -q "Rerun with --leak-check=full to see details of leaked memory" $TMP/${NO}_valgrind_memory.txt; then
    echo -e $RED"[KO] check memory leaks$COLOR_LIMITER\t\t(run valgrind --trace-children=yes)"
else
    echo -e $GREEN"[OK] no memory leaks"$COLOR_LIMITER
fi

# Run valgrind with pipe tracking
eval valgrind --trace-children=yes --track-fds=yes $PIPEX &> $TMP/${NO}_valgrind_pipes.txt
if awk '/Open file descriptor/ {getline; if ($0 !~ /<inherited from parent>/) {found=1}} END {exit found}' "$TMP/${NO}_valgrind_pipes.txt"; then
    echo -e "${GREEN}[OK] all pipes are closed${COLOR_LIMITER}"
else
    echo -e "${RED}[KO] pipes were left open${COLOR_LIMITER}\t(run valgrind --track-fds=yes --trace-children=yes)${COLOR_LIMITER}"
fi



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
chmod 0777 no_read_perm.txt
rm no_read_perm.txt
#rm tests -r