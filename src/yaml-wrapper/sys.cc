#include "sys.h"

using namespace std;

char* str_to_char(string str)
{
    char* c = 0;
    int n = str.size();

    c = new char[n+1];
    copy(str.begin(), str.end(), c);
    c[n] = '\0';
    return c;
}
