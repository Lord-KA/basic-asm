#include <stdio.h>
// typedef unsigned long long size_t;


void gprintf(char* text, ...);
void gwrite(const char* text, size_t len);
void gflush();

size_t gstrlen( char* s );

int main()
{  
    int a = 255, b = 12345, c = 999, d = 1923;

    
    gprintf("   255: %o\n 12345: %o\n   999: %o\n  1923: %o\n\n", a, b, c, d);
    
    // /*

    gprintf("I %s %x %d%%%c%o\n",
            "love", 3802, 100, 33, 299593);
    
    gprintf("Many args test:\n"
            "  1: %x\n"
            "  2: %x\n"
            "  3: %x\n"
            "  4: %x\n"
            "  5: %x\n"
            "  6: %x\n"
            "  7: %x\n"
            "  8: %x\n"
            "  9: %x\n"
            " 10: %x\n"
            " 11: %x\n"
            "365: %x\n",
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 365);
    // gprintf("This is an int: %d \n", a);
    // */
}

