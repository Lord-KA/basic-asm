typedef unsigned long long size_t;
void gwrite( const char* text, size_t len);

int main()
{
    gwrite("Hell ", 5);
    gwrite("is with you, motherfucker!", 26);
    return 0;
}
