#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <dirent.h>
#include <time.h>
#include <utime.h>
#include "html.h"

#define MAXPATHLEN 256
#define usage() fprintf(stderr, "Usage: stek <directory> (no trailing slash!)\n")
#define TIMEOFFSET 60

int currtime;

int traversedir(char *);
bool ismd(char *, unsigned char);
int mdtohtml(FILE *, struct dirent *);

int main(int argc, char** argv)
{
	if(argc != 2){
		usage();
		return -1;
	}

	currtime = time(NULL);

	char path[MAXPATHLEN];
	strncpy(path, argv[1], MAXPATHLEN);

	path[strlen(path)] = '/';

	if(traversedir(path) != 0){
		perror("traversedir");
		return -1;
	}

	return 0;
}

/* Traverse files in dir 'path'. Ignores symlinks, pipes, devices, socks */
int traversedir(char path[MAXPATHLEN])
{
	DIR* dir;
	struct dirent *ent;

	if((dir = opendir(path)) == NULL){
		perror(path);
		return -1;
	}

	while((ent = readdir(dir)) != NULL){ /* NULL means end of directory */
		bool isdir = false;
		if(ent->d_type == DT_DIR)
			isdir = true;
		/* Some file systems do not have support for d_type, so we need to
		 * stat() the file to check if it is a directory. */
		else if(ent->d_type == DT_UNKNOWN){ 
			struct stat stbuf;
			stat(ent->d_name, &stbuf);
			isdir = S_ISDIR(stbuf.st_mode);
		}
		if(isdir)
			continue;

		if(ent->d_type == DT_REG && ismd(ent->d_name, ent->d_namlen)){
			/* TODO: Probably a better way to deal with concatenating directory
			 * names, it's very verbose right now. */
			FILE* f;
			char *dname = ent->d_name;
			char *concat = malloc(strlen(path) + strlen(dname) + 1);
			memcpy(concat, path, strlen(path));
			strcat(concat, dname);

			struct stat currfile;
			if (stat(concat, &currfile) < 0){
				perror("stat");
				return 1;
			}

			/* printf("when you ran stek: %d\n", currtime);
			printf("when %s was last modified: %ld\n", dname, currfile.st_atimespec.tv_sec); */

			/* Only converts files that have been modified within 1 minute
			 * of running stek. */
			if ((((currtime) - currfile.st_atimespec.tv_sec) < TIMEOFFSET) &&
					(f = fopen(concat, "r+"))){ 
				mdtohtml(f, ent);
				free(concat);
			}
			
			/* Skip file, it hasn't been touched within the last minute */
			else {
				free(concat);
				continue;
			}
		}
	}
	return 0;
}

bool ismd(char* name, unsigned char len)
{
	char *local = name;
	int nlen = strlen(".md") - 1;
	for(int i = 0; i < len - nlen; i++, local++){
		if(strncmp(".md", local, 3) == 0)
			return true;
		else continue;
	}
	return false;
}

int mdtohtml(FILE *f, struct dirent *ent)
{
	char buffer[MAXPATHLEN];
	/* Should I be using system() here? Is there a more lightweight function? */
	printf("Converting %s to .html file...\n", ent->d_name);
	snprintf(buffer, sizeof(buffer), "~/projects/steklo/convert.sh %s", ent->d_name);
	return system(buffer);
}
