#ifndef _SYS_H
#define _SYS_H

#include <iostream>

#if defined(_MSC_VER)
#    define EXTERNCALL __declspec( dllexport )
#else
#    if defined(_MINGW)
#        define EXTERNCALL __declspec( dllexport )
#    else
#        define EXTERNCALL
#    endif
#endif


#ifndef BUILD_DEFS_H
#    define BUILD_DEFS_H
#    define BUILD_YEAR_CH0 (__DATE__[ 7])
#    define BUILD_YEAR_CH1 (__DATE__[ 8])
#    define BUILD_YEAR_CH2 (__DATE__[ 9])
#    define BUILD_YEAR_CH3 (__DATE__[10])
#    define BUILD_MONTH_IS_JAN (__DATE__[0] == 'J' && __DATE__[1] == 'a' && __DATE__[2] == 'n')
#    define BUILD_MONTH_IS_FEB (__DATE__[0] == 'F')
#    define BUILD_MONTH_IS_MAR (__DATE__[0] == 'M' && __DATE__[1] == 'a' && __DATE__[2] == 'r')
#    define BUILD_MONTH_IS_APR (__DATE__[0] == 'A' && __DATE__[1] == 'p')
#    define BUILD_MONTH_IS_MAY (__DATE__[0] == 'M' && __DATE__[1] == 'a' && __DATE__[2] == 'y')
#    define BUILD_MONTH_IS_JUN (__DATE__[0] == 'J' && __DATE__[1] == 'u' && __DATE__[2] == 'n')
#    define BUILD_MONTH_IS_JUL (__DATE__[0] == 'J' && __DATE__[1] == 'u' && __DATE__[2] == 'l')
#    define BUILD_MONTH_IS_AUG (__DATE__[0] == 'A' && __DATE__[1] == 'u')
#    define BUILD_MONTH_IS_SEP (__DATE__[0] == 'S')
#    define BUILD_MONTH_IS_OCT (__DATE__[0] == 'O')
#    define BUILD_MONTH_IS_NOV (__DATE__[0] == 'N')
#    define BUILD_MONTH_IS_DEC (__DATE__[0] == 'D')
#    define BUILD_MONTH_CH0 (__DATE__[ 0])
#    define BUILD_MONTH_CH1 (__DATE__[ 1])
#    define BUILD_MONTH_CH2 (__DATE__[ 2])
#    define BUILD_DAY_CH0 ((__DATE__[4] >= '0') ? (__DATE__[4]) : '0')
#    define BUILD_DAY_CH1 (__DATE__[ 5])
#endif


char* str_to_char(std::string str);

#endif /* _SYS_H */
