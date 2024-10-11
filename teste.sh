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
make

NO=00

################################################################################
################################################################################
################################################################################
# START ------------------------------------------------------------------------

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

# Run strace to identifiy issues
eval strace -f -o $TMP/${NO}_valgrind_trace.txt $PIPEX &> $TMP/${NO}_valgrind_trace.txt
if grep -q "EBADF" $TMP/${NO}_valgrind_trace.txt; then
	echo -e "${RED}[KO] Trace raises EBADF errors${COLOR_LIMITER}\t(run strace -f)"
else
    echo -e "${GREEN}[OK] No EBADF erros on strace${COLOR_LIMITER}"
fi
echo -e "your exit code:\t\t$(cat $TMP/${NO}_exit.txt)"
echo -e "expected exit code:\t$(cat $TMP/${NO}_exit_ref.txt)"
echo ""



################################################################################
################################################################################
################################################################################
# START ------------------------------------------------------------------------

((NO++))
echo ""
echo -e $YELLOW_BG"$NO. No input file"$COLOR_LIMITER
echo ""

PIPEX="$NAME no_file wc \"cat -e\" \"cat -e\" $TMP/${NO}_outfile.txt"
NORMAL="< no_file wc | cat -e | cat -e > $TMP/${NO}_outfile_ref.txt"

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

# Run strace to identifiy issues
eval strace -f -o $TMP/${NO}_valgrind_trace.txt $PIPEX &> $TMP/${NO}_valgrind_trace.txt
if grep -q "EBADF" $TMP/${NO}_valgrind_trace.txt; then
	echo -e "${RED}[KO] Trace raises EBADF errors${COLOR_LIMITER}\t(run strace -f)"
else
    echo -e "${GREEN}[OK] No EBADF erros on strace${COLOR_LIMITER}"
fi

echo -e "your exit code:\t\t$(cat $TMP/${NO}_exit.txt)"
echo -e "expected exit code:\t$(cat $TMP/${NO}_exit_ref.txt)"
echo ""


################################################################################
################################################################################
################################################################################
# START ------------------------------------------------------------------------

((NO++))
echo ""
echo -e $YELLOW_BG"$NO. No access for output file"$COLOR_LIMITER
echo ""

PIPEX="$NAME infile.txt wc \"cat -e\" no_read_perm.txt"
NORMAL="< infile.txt wc | cat -e > no_read_perm.txt"

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

# Run strace to identifiy issues
eval strace -f -o $TMP/${NO}_valgrind_trace.txt $PIPEX &> $TMP/${NO}_valgrind_trace.txt
if grep -q "EBADF" $TMP/${NO}_valgrind_trace.txt; then
	echo -e "${RED}[KO] Trace raises EBADF errors${COLOR_LIMITER}\t(run strace -f)"
else
    echo -e "${GREEN}[OK] No EBADF erros on strace${COLOR_LIMITER}"
fi

echo -e "your exit code:\t\t$(cat $TMP/${NO}_exit.txt)"
echo -e "expected exit code:\t$(cat $TMP/${NO}_exit_ref.txt)"
echo ""

################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################
################################################################################

# make bonus


# ((NO++))
# echo ""
# echo -e $YELLOW_BG"$NO. Success case"$COLOR_LIMITER
# echo ""

# PIPEX="$NAME infile.txt \"cat -e\" \"cat -e\" \"cat -e\" $TMP/${NO}_outfile.txt"
# NORMAL="< infile.txt cat -e | cat -e | cat -e > $TMP/${NO}_outfile_ref.txt"

# echo $YELLOW$PIPEX $COLOR_LIMITER 
# eval $PIPEX; echo $? > $TMP/${NO}_exit.txt
# echo $YELLOW$NORMAL $COLOR_LIMITER
# eval $NORMAL; echo $? > $TMP/${NO}_exit_ref.txt
# echo ""
# if diff $TMP/${NO}_outfile.txt $TMP/${NO}_outfile_ref.txt > /dev/null; then
#     echo -e $GREEN"[OK] out files match"$COLOR_LIMITER;
# else 
#     echo -e $RED"[KO] out files don't match"$COLOR_LIMITER; 
# fi

# # Run valgrind checking memory leaks
# eval valgrind --trace-children=yes --leak-check=summary $PIPEX &> $TMP/${NO}_valgrind_memory.txt
# if grep -q "Rerun with --leak-check=full to see details of leaked memory" $TMP/${NO}_valgrind_memory.txt; then
#     echo -e $RED"[KO] check memory leaks$COLOR_LIMITER\t\t(run valgrind --trace-children=yes)"
# else
#     echo -e $GREEN"[OK] no memory leaks"$COLOR_LIMITER
# fi

# # Run valgrind with pipe tracking
# eval valgrind --trace-children=yes --track-fds=yes $PIPEX &> $TMP/${NO}_valgrind_pipes.txt
# if awk '/Open file descriptor/ {getline; if ($0 !~ /<inherited from parent>/) {found=1}} END {exit found}' "$TMP/${NO}_valgrind_pipes.txt"; then
#     echo -e "${GREEN}[OK] all pipes are closed${COLOR_LIMITER}"
# else
#     echo -e "${RED}[KO] pipes were left open${COLOR_LIMITER}\t(run valgrind --track-fds=yes --trace-children=yes)${COLOR_LIMITER}"
# fi

# # Run strace to identifiy issues
# eval strace -f -o $TMP/${NO}_valgrind_trace.txt $PIPEX &> $TMP/${NO}_valgrind_trace.txt
# if grep -q "EBADF" $TMP/${NO}_valgrind_trace.txt; then
# 	echo -e "${RED}[KO] Trace raises EBADF errors${COLOR_LIMITER}\t(run strace -f)"
# else
#     echo -e "${GREEN}[OK] No EBADF erros on strace${COLOR_LIMITER}"
# fi

# echo -e "your exit code:\t\t$(cat $TMP/${NO}_exit.txt)"
# echo -e "expected exit code:\t$(cat $TMP/${NO}_exit_ref.txt)"

# echo ""
