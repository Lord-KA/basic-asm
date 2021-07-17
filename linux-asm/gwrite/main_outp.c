typedef unsigned long long size_t;
void gwrite( const char* text, size_t len);
size_t gstrlen( char* s );
void gflush();

// void __stack_chk_fail(void);

int main()
{
    char first[] = "- Hell ";
    char second[] = "is with you, ";
    char third[] = "motherfucker!\n";
    char end[] = "- Fine.\n";
    gwrite(first, gstrlen(first));
    gwrite(second, gstrlen(second));
    gwrite(third, gstrlen(third));
    gwrite(end, gstrlen(end));

    gflush();
    return 0;
}
