#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

int main(int argc, char *argv[]) {
    pid_t pid;
    int status;
    char command_path[256];

    // Fork a child process
    pid = fork();

    if (pid == -1) {
        // Fork failed
        perror("fork");
        exit(1);
    } else if (pid == 0) {
        // Child process
        snprintf(command_path, sizeof(command_path), "/usr/bin/%s", argv[2]);

        char *args[] = {argv[2], argv[1], NULL};
        execve(command_path, args, NULL);

        // If execve returns, it must have failed
        perror("execve");
        exit(1);
    } else {
        // Parent process
        waitpid(pid, &status, 0);

        if (WIFEXITED(status)) {
            int exit_status = WEXITSTATUS(status);
            if (exit_status != 0) {
                printf("Command failed with exit code: %d\n", exit_status);
            }
        } else {
            printf("Child process did not terminate normally\n");
        }
    }

    return 0;
}