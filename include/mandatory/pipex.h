/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/12 18:49:43 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/06 18:12:09 by eduribei         ###   ########.fr       */
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
# include "../../libft/libft.h"

typedef struct t_cmd
{
	int		ac;
	int		cmd_index;
	char	*av;
	int		pip_index;
	bool	is_unique;
	bool	is_mid;
	bool	is_first;
	bool	is_last;
	bool	is_environment_path;
	bool	is_absolute_path;
	bool	is_current_directory;
	bool	is_parent_directory;
	int		out_fd;
	int		in_fd;
	int		prev_fd;
	char	**cmd;
	char	*path;
}			t_cmd;

//fill_commands.c
void	fill_commands(int argc, char *argv[], char *envp[], t_list **head);

//parse_path.c
char	*parse_path(char *envp[], t_cmd *cmd, char *argv[]);

//free_memory.c
void	ft_free_cmd(void *content);
void	ft_lclr_err_node(t_list **l, void (*d)(void*), char *e, t_cmd *c);
void	ft_lclr_err(t_list **l, void (*d)(void*), char *e, int err);
void	ft_invalid_cmd(t_list **l, void (*del)(void*), t_cmd *cmd, int errnum);

#endif