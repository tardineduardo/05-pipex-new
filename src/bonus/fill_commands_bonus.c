/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fill_commands_bonus.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:45:21 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/03 19:04:39 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../../include/bonus/pipex_bonus.h"

void	ft_get_path_type_and_fix_cmd(t_cmd *cmd)
{
	char	*temp;
	char	*last_slash;

	cmd->is_environment_path = false;
	cmd->is_absolute_path = false;
	cmd->is_current_directory = false;
	cmd->is_parent_directory = false;
	if (ft_strnstr(cmd->cmd[0], "/", 1))
		cmd->is_absolute_path = true;
	else if (ft_strnstr(cmd->cmd[0], "./", 2))
		cmd->is_current_directory = true;
	else if (ft_strnstr(cmd->cmd[0], "../", 3))
		cmd->is_parent_directory = true;
	else
	{
		cmd->is_environment_path = true;
		return ;
	}
	temp = cmd->cmd[0];
	last_slash = ft_strrchr(cmd->cmd[0], '/');
	cmd->cmd[0] = strdup(last_slash + 1);
	free(temp);
}

void	ft_get_position(t_cmd *cmd, int argc, int cmd_index)
{
	cmd->is_unique = false;
	cmd->is_first = false;
	cmd->is_mid = false;
	cmd->is_last = false;
	if (argc == 4)
		cmd->is_unique = true;
	else if (cmd_index == 2)
		cmd->is_first = true;
	else if (cmd_index == argc - 2)
		cmd->is_last = true;
	else
		cmd->is_mid = true;
}

void	fill_commands(int argc, char *argv[], char *envp[], t_list **head)
{
	int		cmd_index;
	t_cmd	*cmd;
	void	(*del)(void *);

	cmd_index = 2;
	del = (void (*)(void *))ft_free_cmd;
	while (cmd_index < argc - 1)
	{
		cmd = malloc(sizeof(t_cmd));
		if (!cmd)
			ft_lclr_err_node(head, del, "malloc error", cmd);
		ft_get_position(cmd, argc, cmd_index);
		cmd->ac = argc;
		cmd->cmd_index = cmd_index;
		cmd->pip_index = cmd_index - 2;
		cmd->cmd = ft_split_space(argv[cmd_index]);
		ft_get_path_type_and_fix_cmd(cmd);
		cmd->path = parse_path(envp, cmd, argv);
		ft_lstadd_back(head, ft_lstnew((void *)cmd));
		cmd_index++;
	}
}
