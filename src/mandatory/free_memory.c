/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free_memory.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:43:10 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/06 18:55:01 by eduribei         ###   ########.fr       */
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

void	ft_lclr_err_node(t_list **l, void (*del)(void*), char *e, t_cmd *curr)
{
	t_list	*temp1;
	t_list	*temp2;

	if (l == NULL || *l == NULL)
	{
		perror(e);
		ft_free_cmd(curr);
		exit(0);
	}
	temp1 = *l;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		(*del)(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*l = NULL;
	perror(e);
	ft_free_cmd(curr);
	exit(0);
}

void	ft_lclr_err(t_list **l, void (*del)(void*), char *e, int err)
{
	t_list	*temp1;
	t_list	*temp2;

	temp1 = *l;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		(*del)(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*l = NULL;
	ft_error_exit(e, err, 2);
}


void	ft_invalid_cmd(t_list **l, void (*del)(void*), t_cmd *cmd, int errnum)
{
	t_list	*temp1;
	t_list	*temp2;


	ft_putstr_fd("command not found: \"", 2);	
	ft_putstr_fd(cmd->av, 2);
	ft_putstr_fd("\"\n", 2);

	temp1 = *l;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		(*del)(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*l = NULL;

	exit(errnum);
}