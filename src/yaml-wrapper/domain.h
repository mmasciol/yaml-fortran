#ifndef _API_H
#define _API_H

#include "sys.h"


struct YAMLContainer {
    YAML::Node config;
};


struct Domain {
    /** Embeds a YAMLContainer pointer rather than the
     *  YAML::Node iteself to make it interoperatble with
     *  python and Fortran.
     */
    YAMLContainer* container;
    int status;
};


#pragma once
#ifdef __cplusplus
extern "C" {
#endif
    EXTERNCALL Domain* load_file(char* fpath);
    EXTERNCALL void destroy_domain(Domain* domain);
#ifdef __cplusplus
}
#endif


#endif /* _API_H */
