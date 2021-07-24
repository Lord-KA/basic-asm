typedef unsigned long long size_t;

/*
void gread ( const char* text, size_t len);
void gwrite( const char* text, size_t len);
void gflush();

size_t gstrlen( char* s );

int main()
{
    char first[28];
    // char second[] = "is with you, ";
    // char third[] = "motherfucker!\n";
    // char end[] = "- Fine.\n";
    gread(first, 28);
    gwrite(first, gstrlen(first));
    gflush();
    // gwrite(second, gstrlen(second));
    // gwrite(third, gstrlen(third));
    // gwrite(end, gstrlen(end));
    
    return 0;
}
*/
