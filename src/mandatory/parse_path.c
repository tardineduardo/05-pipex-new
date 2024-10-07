/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parse_path.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:43:34 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/06 18:15:04 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static char	*parse_absolute_path(t_cmd *cmd, char *argv[])
{
	char	*path;
	char	**commands;

	commands = ft_split_space(argv[cmd->cmd_index]);
	if (!commands)
		return (NULL);
	path = ft_strdup(commands[0]);
	if (!path)
		return (NULL);
	ft_free_str_array(commands);
	return (path);
}

static char	*parse_relative_path(char *envp[], t_cmd *cmd)
{
	int		a;
	char	*pwd;
	char	*path;
	char	*ptr;

	a = 0;
	while (envp[a] != NULL)
	{
		pwd = ft_strnstr(envp[a++], "PWD=", 4);
		if (pwd)
		{
			pwd = ft_strdup(pwd + 4);
			break ;
		}
	}	
	if (!pwd)
		return (NULL);
	if (cmd->is_parent_directory)
	{
		ptr = ft_strrchr(pwd, '/');
		*ptr++ = '\0';
	}
	path = ft_concatenate(pwd, "/", cmd->cmd[0]);
	free(pwd);
	return (path);
}

static char	*ft_get_abs_env_path(char **path_split, char *path, char *cmd)
{
	int	i;

	i = 0;
	while (path_split[i] != NULL)
	{
		path = ft_concatenate(path_split[i], "/", cmd);
		if (path == NULL)
			return (NULL);
		if (access(path, F_OK) == 0)
			return (path);
		free(path);
		i++;
	}
	return (NULL);
}

static char	*parse_environment_path(char *envp[], char *cmd0)
{
	int		a;
	char	*path;
	char	**path_split;

	a = 0;
	while (envp[a] != NULL)
	{
		path = ft_strnstr(envp[a], "PATH=", 5);
		if (path)
		{
			path_split = ft_split_char((path + 5), ':');
			if (path_split == NULL)
				return (NULL);
			path = ft_get_abs_env_path(path_split, path, cmd0);
			ft_free_str_array(path_split);
			if (!path)
				return (NULL);
			return (path);
		}
		a++;
	}
	return (NULL);
}

char	*parse_path(char *envp[], t_cmd *cmd, char *argv[])
{
	if (!cmd->cmd)
		return (NULL);
	if (cmd->is_environment_path)
		return (parse_environment_path(envp, cmd->cmd[0]));
	else if (cmd->is_absolute_path)
		return (parse_absolute_path(cmd, argv));
	else if (cmd->is_current_directory || cmd->is_parent_directory)
		return (parse_relative_path(envp, cmd));
	return (NULL);
}
