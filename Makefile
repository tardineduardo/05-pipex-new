SRC =	src/pipex.c
BONUS =	src/pipex_bonus.c
UTILS = src/parse_path.c \
	src/free_memory.c \
	src/fill_commands.c \
	src/inutils.c

OBJS_SRC = $(SRC:.c=.o) $(UTILS:.c=.o)
OBJS_BONUS = $(BONUS:.c=.o) $(UTILS:.c=.o)

CC = cc
RM = rm -f
CFLAGS = -Wall -Wextra -Werror

NAME = pipex
BONUS_NAME = pipex_bonus

LIBFT_PATH = ./libft
LIBFT = $(LIBFT_PATH)/libft.a

# Find all .c files in the libft directory and track their changes
LIBFT_SRC = $(wildcard $(LIBFT_PATH)/*.c)

all: $(NAME)

bonus: $(BONUS_NAME)

$(NAME): $(OBJS_SRC) $(LIBFT)
	$(CC) $(CFLAGS) $(OBJS_SRC) $(LIBFT) -o $(NAME)

$(BONUS_NAME): $(OBJS_BONUS) $(LIBFT)
	$(CC) $(CFLAGS) $(OBJS_BONUS) $(LIBFT) -o $(BONUS_NAME)

# Ensure libft.a is rebuilt if any of the .c files in libft/ change
$(LIBFT): $(LIBFT_SRC)
	$(MAKE) -C $(LIBFT_PATH) all

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	$(RM) $(OBJS_SRC) $(OBJS_BONUS)
	$(MAKE) -C $(LIBFT_PATH) clean

fclean: clean
	$(RM) $(NAME) $(BONUS_NAME)
	$(MAKE) -C $(LIBFT_PATH) fclean

re: fclean all

.PHONY: all clean fclean re bonus