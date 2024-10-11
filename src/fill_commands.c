/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   fill_commands.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:42:41 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/11 17:34:56 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static void	init_cmd(t_cmd *cmd)
{
	cmd->path_is_environment = false;
	cmd->path_is_absolute = false;
	cmd->path_is_curr_dir = false;
	cmd->path_is_parent_dir = false;
	cmd->is_unique = false;
	cmd->is_first = false;
	cmd->is_mid = false;
	cmd->is_last = false;
	cmd->infile_invalid = false;
	cmd->cmd = NULL;
	cmd->path = NULL;
	cmd->av = NULL;
	cmd->ac = -1;
	cmd->cmd_index = -1;
	cmd->out_fd = -1;
	cmd->in_fd = -1;
	cmd->prev_fd = -1;
}

static void	ft_get_path_type_and_fix_cmd(t_cmd *cmd)
{
	char	*temp;
	char	*last_slash;

	if (!cmd->cmd || cmd->cmd[0][0] == 0)
		return ;
	if (ft_strnstr(cmd->cmd[0], "/", 1))
		cmd->path_is_absolute = true;
	else if (ft_strnstr(cmd->cmd[0], "./", 2))
		cmd->path_is_curr_dir = true;
	else if (ft_strnstr(cmd->cmd[0], "../", 3))
		cmd->path_is_parent_dir = true;
	else
	{
		cmd->path_is_environment = true;
		return ;
	}
	temp = cmd->cmd[0];
	last_slash = ft_strrchr(cmd->cmd[0], '/');
	cmd->cmd[0] = strdup(last_slash + 1);
	free(temp);
}

static void	ft_get_position(t_cmd *cmd, int argc, int cmd_index)
{
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

	cmd_index = 2;
	while (cmd_index < argc - 1)
	{
		cmd = malloc(sizeof(t_cmd));
		if (!cmd)
			ft_clear_list_exit(head, "malloc error", errno, cmd);
		init_cmd(cmd);
		ft_get_position(cmd, argc, cmd_index);
		cmd->ac = argc;
		cmd->av = argv[cmd_index];
		cmd->cmd_index = cmd_index;
		cmd->cmd = ft_split_space(argv[cmd_index]);
		ft_get_path_type_and_fix_cmd(cmd);
		cmd->path = parse_path(envp, cmd, argv);
		if (cmd->is_last && (!cmd->path || access(cmd->path, X_OK) != 0))
			ft_exit_bad_lstcmd(head, cmd->cmd[0], 127, cmd);
		ft_lstadd_back(head, ft_lstnew((void *)cmd));
		cmd_index++;
	}
}
