#include <fcntl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

char	**ft_split_space(char *s);
void	ft_free_str_array(char **array_of_strings);


int	main(int argc, char *argv[], char *envp[])
{
	char	**cmd;
	char	**unin;

	cmd = ft_split_space(argv[2]);

	int infile = open(argv[1], O_RDONLY);
	int outfile = open(argv[3], O_WRONLY | O_CREAT | O_TRUNC, 0644);

	dup2(infile, STDIN_FILENO);
	dup2(outfile, STDOUT_FILENO);

	close(infile);
	close(outfile);

	int pid = fork();
	if (pid == 0)
	{
		execve("", unin, envp);
		printf("error");

	}
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	ft_free_str_array(cmd);
	wait(NULL);
}



void	ft_free_str_array(char **array_of_strings)
{
	int	a;

	if (!array_of_strings)
		return ;
	a = 0;
	while (array_of_strings[a])
	{
		free(array_of_strings[a]);
		a++;
	}
	free(array_of_strings);
}



static char	*ft_strchr(const char *str, int c)
{
	unsigned char	a;

	a = (unsigned char)c;
	while (*str != '\0' || a == '\0')
	{
		if (*str == a)
			return ((char *)str);
		str++;
	}
	return (NULL);
}




static size_t	c_substrs(char *s, char *set)
{
	size_t	count_substrs;
	int		in_substr;

	count_substrs = 0;
	in_substr = 0;
	while (*s != '\0')
	{
		if (!ft_strchr(set, *s) && !in_substr)
		{
			in_substr = 1;
			count_substrs++;
		}
		else if (ft_strchr(set, *s))
		{
			in_substr = 0;
		}
		s++;
	}
	return (count_substrs);
}

static void	ft_free_if_error(char **results, size_t r_index)
{
	size_t	a;

	a = 0;
	while (a < r_index)
	{
		free(results[a]);
		a++;
	}
	free(results);
}

static char	*ft_fill(char **results, char *start, size_t count, size_t r_index)
{
	results[r_index] = calloc((count + 1), sizeof(char));
	if (results[r_index] != NULL)
	{
		memmove((char *)results[r_index], (char *)start, count);
		results[r_index][count] = '\0';
		return (results[r_index]);
	}
	else
	{
		ft_free_if_error(results, r_index);
		return (NULL);
	}
}

static char	**ft_get_substrs(char *s, char *set, char **results)
{
	size_t	substr_len_c;
	size_t	r_index;
	char	*start;

	r_index = 0;
	while (*s != '\0')
	{
		if ((!ft_strchr(set, *s)) && (*s != '\0'))
		{
			start = s;
			substr_len_c = 0;
			while ((!ft_strchr(set, *s)) && (*s != '\0'))
			{
				substr_len_c++;
				s++;
			}
			if (ft_fill(results, start, substr_len_c, r_index))
				r_index++;
			else
				return (NULL);
		}
		else
			s++;
	}
	return (results);
}

char	**ft_split_space(char *s)
{
	char	**results;
	size_t	total_substrs;
	char	*set;

	set = " \t";
	total_substrs = c_substrs((char *)s, set);

	if (total_substrs == 0)
	{
		return (NULL);
	}	
	results = calloc((total_substrs + 1), sizeof(char *));
	if (results == NULL)
		return (NULL);
	results[total_substrs] = NULL;
	results = ft_get_substrs((char *)s, set, results);
	return (results);
}
