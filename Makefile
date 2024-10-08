NAME = pipex

SRC_MAND = \
	src/mandatory/pipex.c \
	src/mandatory/parse_path.c \
	src/mandatory/free_memory.c \
	src/mandatory/fill_commands.c \

SRC_BONUS = \
	src/bonus/pipex_bonus.c \
	src/bonus/parse_path_bonus.c \
	src/bonus/free_memory_bonus.c \
	src/bonus/fill_commands_bonus.c \

OBJS_MAND = ${SRC_MAND:.c=.o}
OBJS_BONUS = ${SRC_BONUS:.c=.o}

CC = cc
RM = rm -f
CFLAGS = -g
#CFLAGS = -Wall -Wextra -Werror -g
INCLUDE_MAND = -I include/mandatory
INCLUDE_BONUS = -I include/bonus
MAKE = make -C
LIBFT_PATH = libft
LIBFT = -L ${LIBFT_PATH} -lft

.c.o:
	${CC} ${CFLAGS} ${INCLUDE_MAND} -c $< -o ${<:.c=.o}

src/bonus/%.o: src/bonus/%_bonus.c
	${CC} ${CFLAGS} ${INCLUDE_BONUS} -c $< -o $@

all: $(NAME)

$(NAME): ${OBJS_MAND}
	${MAKE} ${LIBFT_PATH} all
	${CC} ${OBJS_MAND} ${LIBFT} -o ${NAME}

bonus: ${OBJS_BONUS}
	${MAKE} ${LIBFT_PATH} all
	${CC} ${OBJS_BONUS} ${LIBFT} -o ${NAME}

clean:
	${MAKE} ${LIBFT_PATH} clean
	${RM} ${OBJS_MAND} ${OBJS_BONUS}

fclean: clean
	${MAKE} ${LIBFT_PATH} fclean
	${RM} ${NAME}

re: fclean all

# valgrind: all
# 	valgrind \
#     --leak-check=full \
#     --suppressions=suppression.supp \
#     --show-leak-kinds=all \
#     --trace-children=yes --track-fds=yes \
#     ./$(NAME)


.PHONY: all bonus clean fclean re