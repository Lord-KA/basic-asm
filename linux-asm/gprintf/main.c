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
    
    int a = 255, b = 12345, c = 999, d = 1923;

    
    gprintf("%o %o %o %o\n", a, b, c, d);
    
    // /*
    // gprintf("%s No. %d asfsd %s%d ad %d%d%s%s sdfj\n", first, a, second, b, c, d, third, end);
    //printf("%s No. %d asfsd %s%d ad %d%d%s%s sdfj\n", first, a, second, b, c, d, third, end);
    gprintf("I %s %x %d%%%c%o\n",
            "love", 3802, 100, 33, 299593);
    
    gprintf("Many args test:\n"
            "  1: %d\n"
            "  2: %d\n"
            "  3: %d\n"
            "  4: %d\n"
            "  5: %d\n"
            "  6: %d\n"
            "  7: %d\n"
            "  8: %d\n"
            "  9: %d\n"
            " 10: %d\n"
            " 11: %d\n"
            "365: %d\n",
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 365);
    // gprintf("This is an int: %d \n", a);
    // */
    return 0;
}

