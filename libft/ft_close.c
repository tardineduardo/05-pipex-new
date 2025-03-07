/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_strjoin.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: eduribei <eduribei@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/05/12 18:49:43 by eduribei          #+#    #+#             */
/*   Updated: 2024/05/20 15:37:46 by eduribei         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libft.h"

void	ft_close(int total, ...)
{
	va_list	args;
	int		fd;
	int		a;

	va_start(args, total);
	a = 0;
	while (a < total)
	{
		fd = va_arg(args, int);
		close(fd);
		a++;
	}
	va_end(args);
}
