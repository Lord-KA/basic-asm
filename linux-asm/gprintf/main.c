#include <stdio.h>
// typedef unsigned long long size_t;


void gprintf ( char* text, ...);
void gwrite( const char* text, size_t len);
void gflush();

size_t gstrlen( char* s );

int main()
{
    char first[] = "Hello world";
    char second[] = "is with you, ";
    char third[] = "motherfucker!\n";
    char end[] = "- Fine.\n";
    // gwrite(first, gstrlen(first));
    // gflush();
    // gwrite(second, gstrlen(second));
    // gwrite(third, gstrlen(third));
    // gwrite(end, gstrlen(end));
    
    int a = 284, b = 123, c = 999, d = 1923;

    // gprintf("%s%d", first, a);
    gprintf("%s No. %d asfsd %s%d ad %d%d%s%s sdfj\n", first, a, second, b, c, d, third, end);
    // printf("%s No. %d asfsd %s%d ad %d%d%s%s sdfj\n", first, a, second, b, c, d, third, end);
    
    //gprintf("This is an int: %d \n", a);

    return 0;
}

