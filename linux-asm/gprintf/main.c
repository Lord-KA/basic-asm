typedef unsigned long long size_t;


void gprintf ( char* text, ...);
void gwrite( const char* text, size_t len);
void gflush();

size_t gstrlen( char* s );

int main()
{
    //char first[] = "Hello world!";
    // char second[] = "is with you, ";
    // char third[] = "motherfucker!\n";
    // char end[] = "- Fine.\n";
    // gwrite(first, gstrlen(first));
    // gflush();
    // gwrite(second, gstrlen(second));
    // gwrite(third, gstrlen(third));
    // gwrite(end, gstrlen(end));
    
    gprintf("abc");

    return 0;
}

