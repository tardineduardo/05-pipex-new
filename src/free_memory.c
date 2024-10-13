/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free_memory.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:43:10 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/11 17:34:46 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	ft_free_cmd(void *content)
{
	t_cmd	*cmd;

	if (!content)
		return ;
	cmd = (t_cmd *)content;
	if (cmd->cmd)
		ft_free_str_array(cmd->cmd);
	if (cmd->path != NULL)
		free(cmd->path);
	if (cmd)
		free(cmd);
}

void	ft_clear_list_exit(t_list **head, char *err, int errnum, t_cmd *curr)
{
	t_list	*temp1;
	t_list	*temp2;

	if (head == NULL || *head == NULL)
	{
		perror(err);
		ft_free_cmd(curr);
		exit(errnum);
	}
	temp1 = *head;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		ft_free_cmd(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*head = NULL;
	perror(err);
	ft_free_cmd(curr);
	exit(errnum);
}

void	ft_exit_bad_lstcmd(t_list **head, char *err, int errnum, t_cmd *curr)
{
	t_list	*temp1;
	t_list	*temp2;

	ft_putstr_fd("pipex: ", STDERR_FILENO);
	ft_putstr_fd("\"", STDERR_FILENO);
	ft_putstr_fd(err, STDERR_FILENO);
	ft_putstr_fd("\": ", STDERR_FILENO);
	ft_putstr_fd("command not found\n", STDERR_FILENO);
	temp1 = *head;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		ft_free_cmd(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*head = NULL;
	ft_free_cmd(curr);
	exit(errnum);
}

void	ft_skip_cmd_exit(t_list **head, char *err, int errnum, int fd[])
{
	t_list	*temp1;
	t_list	*temp2;

	if (err)
	{
		ft_putstr_fd(err, STDERR_FILENO);
		ft_putstr_fd(": command not found\n", STDERR_FILENO);
	}
	temp1 = *head;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		ft_free_cmd(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*head = NULL;
	close(fd[0]);
	close(fd[1]);
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	exit(errnum);
}
