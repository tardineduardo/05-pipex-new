/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/12 18:49:43 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/11 17:26:53 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include <errno.h>
# include <stdbool.h>
# include <fcntl.h>
# include <stdarg.h>
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <sys/types.h>
# include <sys/wait.h>
# include <unistd.h>
# include "../libft/libft.h"

typedef struct t_cmd
{
	int		ac;
	int		cmd_index;
	char	*av;
	bool	is_unique;
	bool	is_mid;
	bool	is_first;
	bool	is_last;
	bool	path_is_environment;
	bool	path_is_absolute;
	bool	path_is_curr_dir;
	bool	path_is_parent_dir;
	bool	infile_invalid;
	int		out_fd;
	int		in_fd;
	int		prev_fd;
	char	**cmd;
	char	*path;
}			t_cmd;

/* fill_commands.c */
void	fill_commands(int argc, char *argv[], char *envp[], t_list **head);

/* parse_path.c */
char	*parse_path(char *envp[], t_cmd *cmd, char *argv[]);

/* free_memorty.c */
void	ft_free_cmd(void *content);
void	ft_clear_list_exit(t_list **c_lst, char *err, int errnum, t_cmd *c);
void	ft_skip_cmd_exit(t_list **c_lst, char *err, int errnum, int fd[]);
void	ft_exit_bad_lstcmd(t_list **c_lst, char *err, int errnum, t_cmd *curr);

/* inutils.c */
int		ft_protect_fopen(int in_fd, int out_fd, t_list *c_lst, char *av[]);
void	ft_dup2_and_close(int in_fd, int out_fd);
int		ft_skip(t_list **c_lst, int fd[]);

#endif