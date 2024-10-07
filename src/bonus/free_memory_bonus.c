/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   free_memory_bonus.c                                :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:43:10 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/02 18:32:41 by eduribei         ###   ########.fr       */
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

	perror(e);
	if (e == NULL)
		e = "error parsing command (NULL)";
	temp1 = *l;
	while (temp1 != NULL)
	{
		temp2 = temp1->next;
		(*del)(temp1->content);
		free(temp1);
		temp1 = temp2;
	}
	*l = NULL;
	exit(err);
}
