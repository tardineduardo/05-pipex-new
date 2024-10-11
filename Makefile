SRC =	src/pipex.c \
	src/parse_path.c \
	src/free_memory.c \
	src/fill_commands.c \
	src/inutils.c \

BONUS =	src/pipex_bonus.c \

OBJS = $(SRC:.c=.o)

CC = cc
RM = rm -f
CFLAGS = -Wall -Wextra -Werror

NAME = pipex

LIBFT_PATH = ./libft

LIBFT = $(LIBFT_PATH)/libft.a

all: $(NAME)

$(NAME): $(OBJS) $(LIBFT)
	cp $(LIBFT) $(NAME)
	ar rfc $(NAME) $(OBJS)

$(LIBFT):
	$(MAKE) -C $(LIBFT_PATH) all

%.o: %.c ft_printf.h
	$(CC) $(CFLAGS) -g -c $< -o $@

clean:
	$(RM) $(OBJS)
	$(MAKE) -C $(LIBFT_PATH) clean

fclean: clean
	$(MAKE) -C $(LIBFT_PATH) fclean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re
