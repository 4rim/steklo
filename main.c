#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#define MAXPATHLEN 256

#define usage() fprintf(stderr, "Usage: stek <directory>\n")

void traversedir(char *);
bool ismd(char *, unsigned char);
int mdtohtml(FILE *, struct dirent *);

int main(int argc, char** argv)
{
	if(argc != 2){
		usage();
		return -1;
	}

	char path[MAXPATHLEN];
	strncpy(path, argv[1], MAXPATHLEN);

	traversedir(path);

	return 0;
}

/* Traverse files in dir 'path'. Ignores symlinks, pipes, devices, socks */
void traversedir(char path[MAXPATHLEN])
{
	DIR* dir;
	struct dirent *ent;

	if((dir = opendir(path)) == NULL){
		perror(path);
		return;
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
			/* TODO: Obviously have to edit a lot here (make another function
			 * to manipulate the files, run parse scripts or parse directly,
			 * etc. 
			 * Make it generalizable across different directories, recurse
			 * over directories, etc. Probably a better way to deal with
			 * concatenating directory names, it's very verbose right now. */
			/* printf("%s\n", ent->d_name); */
			FILE* f;
			char *dummydir = "./dummy/";
			char *dname = ent->d_name;
			char *concat = malloc(strlen(dummydir) + strlen(dname) + 1);
			memcpy(concat, dummydir, strlen(dummydir));
			strcat(concat, dname);
			if ((f = fopen(concat, "r+"))){
				mdtohtml(f, ent);
				free(concat);
			}
			else {
				perror("Could not return a file stream");
				return;
			}
		}
	}
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
	printf("Converting %s to .html file...\n", ent->d_name);
	/* Obviously WIP. Could parse here or call a shell script to parse? */
	return 0;
}
