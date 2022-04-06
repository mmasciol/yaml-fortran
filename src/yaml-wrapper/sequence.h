#ifndef _SEQUENCE_H
#define _SEQUENCE_H


#include <vector>

#include "sys.h"


using namespace std;


struct Map;
struct Domain;
typedef vector<Map*> Sequence;


Sequence* covert_node_to_sequence(YAML::Node config);

#pragma once
#ifdef __cplusplus
extern "C" {
#endif
    EXTERNCALL Sequence* start_from_sequence(Domain* domain, char* label);
    EXTERNCALL int get_sequence_size(Sequence* sequence);
    EXTERNCALL void destroy_sequence(Sequence* sequence);
#ifdef __cplusplus
}
#endif

#endif /* _SEQUENCE_H */
