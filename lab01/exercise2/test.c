#include <stdio.h>
#include <string.h> 
int main()
{
	char str[] = "This is a simmple string";
	char* pch;
	pch = strstr(str, "simple");
    puts(pch);
	puts(str);

	return 0;
}