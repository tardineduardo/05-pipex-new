/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:33:29 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/11 17:34:09 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

static void	ft_validate_args(int argc, char *argv[])
{
	int	in_err;
	int	out_err;
	int	out_fd;	

	in_err = 0;
	out_err = 0;
	if (argc < 4)
		ft_error_exit("Invalid number of arguments.\n", 1, STDERR_FILENO);
	if ((access(argv[1], F_OK) != 0) || (access(argv[1], R_OK) != 0))
	{
		ft_perror_extra(argv[0], argv[1]);
		in_err = errno;
	}
	out_fd = open(argv[argc - 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (out_fd == -1)
	{
		ft_perror_extra(argv[0], argv[argc - 1]);
		out_err = errno;
	}
	else
		close(out_fd);
	if (out_err)
		exit(out_err);
}

static void	ft_fork_and_exec(t_list *c_lst, char *envp[], int fd[])
{
	int		pid;
	t_cmd	*cmd;

	cmd = (t_cmd *)(c_lst->content);
	pid = fork();
	if (pid == -1)
		ft_clear_list_exit(&c_lst, "fork", errno, NULL);
	else if (pid == 0)
	{
		if (!cmd->path || access(cmd->path, X_OK) != 0)
			ft_skip_cmd_exit(&c_lst, cmd->cmd[0], 127, fd);
		else if (cmd->infile_invalid)
			ft_skip_cmd_exit(&c_lst, NULL, 0, fd);
		execve(cmd->path, cmd->cmd, envp);
		if (!cmd->is_last)
			close(fd[0]);
		ft_clear_list_exit(&c_lst, "execve", errno, NULL);
	}
	if (cmd->is_last || cmd->is_unique)
		ft_close_two(STDIN_FILENO, STDOUT_FILENO);
}

static int	ft_set_pipes_run_cmds(t_list *c_lst, char *argv[], char *envp[])
{
	int		in_fd;
	int		out_fd;
	int		fd[2];
	t_cmd	*cmd;

	cmd = (t_cmd *)(c_lst->content);
	if (!cmd->is_last && !cmd->is_unique)
		if (pipe(fd) == -1)
			ft_clear_list_exit(&c_lst, "pipe", errno, NULL);
	if (cmd->is_first || cmd->is_unique)
		in_fd = open(argv[1], O_RDONLY);
	else
		in_fd = cmd->prev_fd;
	if (cmd->is_first || cmd->is_mid)
		out_fd = fd[1];
	else
		out_fd = open(argv[(cmd->ac) - 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	if (ft_protect_fopen(in_fd, out_fd, c_lst, argv) == -1)
		return (ft_skip(&c_lst, fd));
	ft_dup2_and_close(in_fd, out_fd);
	ft_fork_and_exec(c_lst, envp, fd);
	if (cmd->is_first || cmd->is_mid)
		((t_cmd *)(c_lst->next->content))->prev_fd = fd[0];
	return (0);
}

int	main(int argc, char *argv[], char *envp[])
{
	t_list	*head;
	t_list	*trav;
	int		status;

	head = NULL;
	ft_validate_args(argc, argv);
	fill_commands(argc, argv, envp, &head);
	trav = head;
	while (trav != NULL)
	{
		ft_set_pipes_run_cmds(trav, argv, envp);
		trav = trav->next;
	}
	ft_lstclear(&head, (void (*)(void *))ft_free_cmd);
	while (wait(&status) > 0)
		NULL;
	return (0);
}
