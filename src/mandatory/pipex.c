/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/30 17:33:29 by eduribei          #+#    #+#             */
/*   Updated: 2024/10/10 17:56:53 by eduribei         ###   ########.fr       */
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

/*
the files were already validated at the start of the program.
this function is only meant to protect open.
*/
static void	ft_protect_file_open(int in_fd, int out_fd, t_list *l, char *av[])
{
	int		ac;
	t_cmd	*cmd;

	cmd = (t_cmd *)(l->content);
	ac = cmd->ac;
	if (in_fd == -1)
		cmd->infile_is_valid = false;
	if (out_fd == -1)
		ft_lclr_err_node(&l, (void (*)(void *))ft_free_cmd, av[ac - 1], NULL);

}

static void	ft_fork_and_exec(t_list *l, char *envp[], int fd[])
{
	int		pid;
	t_cmd	*cmd;

	cmd = (t_cmd *)(l->content);
	pid = fork();
	if (pid == -1)
		ft_perror_exit("fork", errno);
	else if (pid == 0)
	{
		if (!cmd->path || access(cmd->path, X_OK) != 0)
		{
			close(fd[1]);
			ft_invalid_cmd(&l, (void (*)(void *))ft_free_cmd, cmd, 127);
		}
		if (!cmd->infile_is_valid)
		{
			//ft_lstclear(&l, (void (*)(void *))ft_free_cmd);
			close(fd[1]);
			exit (0);
		}
		execve(cmd->path, cmd->cmd, envp); // ATENCAO, PAROU DE DAR ERRO QUANDO USEI NULL EM ENVP
		if (!cmd->is_last)
			close(fd[0]);
		ft_lclr_err(&l, (void (*)(void *))ft_free_cmd, "execve", errno);
	}
	else
	{
		if (cmd->is_last)
			ft_close_two(STDIN_FILENO, STDOUT_FILENO);
	}
}

static void	ft_set_pipes_and_run_cmds(t_list *l, char *argv[], char *envp[])
{
	int		in_fd;
	int		out_fd;
	int		fd[2];
	t_cmd	*cmd;

	cmd = (t_cmd *)(l->content);
	if (!cmd->is_last )
		if (pipe(fd) == -1)
			ft_lclr_err_node(&l, (void (*)(void *))ft_free_cmd, "pipe", NULL);
	if (cmd->is_first || cmd->is_unique)
		in_fd = open(argv[1], O_RDONLY);
	else
		in_fd = cmd->prev_fd;
	if (cmd->is_first || cmd->is_mid)
		out_fd = fd[1];
	else
		out_fd = open(argv[(cmd->ac) - 1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
	ft_protect_file_open(in_fd, out_fd, l, argv);
	dup2(in_fd, STDIN_FILENO);
	dup2(out_fd, STDOUT_FILENO);
	ft_close_two(in_fd, out_fd);
	ft_fork_and_exec(l, envp, fd);
	if (cmd->is_first || cmd->is_mid)
		((t_cmd *)(l->next->content))->prev_fd = fd[0];
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
		ft_set_pipes_and_run_cmds(trav, argv, envp);
		trav = trav->next;
	}
	//ft_lstclear(&head, (void (*)(void *))ft_free_cmd);
	while (wait(&status) > 0)
		NULL;
	return (0);
}
