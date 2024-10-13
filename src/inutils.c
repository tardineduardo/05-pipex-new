/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   inutils.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/11 16:12:09 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/11 17:34:37 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

int	ft_protect_fopen(int in_fd, int out_fd, t_list *c_lst, char *av[])
{
	int		ac;
	t_cmd	*cmd;

	cmd = (t_cmd *)(c_lst->content);
	ac = cmd->ac;
	if (out_fd == -1)
		ft_clear_list_exit(&c_lst, av[ac - 1], errno, NULL); // AQUI TEM LEAK
	if (in_fd == -1)
	{		
		cmd->infile_invalid = true;
		return (-1);
	}
	return (0);
}

void	ft_dup2_and_close(int in_fd, int out_fd)
{
	dup2(in_fd, STDIN_FILENO);
	dup2(out_fd, STDOUT_FILENO);
	close(in_fd);
	close(out_fd);
}

int	ft_skip(t_list **c_lst, int fd[])
{
	close(fd[0]);
	close(fd[1]);
	((t_cmd *)((*c_lst)->next->content))->prev_fd = open("/dev/null", O_RDONLY);
	return (-1);
}
