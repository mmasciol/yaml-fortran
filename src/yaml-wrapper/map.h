#ifndef _MAP_H
#define _MAP_H


#include <vector>

#include "sys.h"
#include "sequence.h"

using namespace std;


struct Domain;
struct Field;
// struct Sequence;

struct Map {
    vector<char*>* labels;
    vector<YAML::Node>* nodes;
};


Map* new_map();
Map* convert_node_to_map(YAML::Node config);


#pragma once
#ifdef __cplusplus
extern "C" {
#endif
    EXTERNCALL Map* start_from_map(Domain* domain, char* label);
    EXTERNCALL Map* get_map_from_field(Field* field);
    EXTERNCALL Map* get_map_from_sequence(Sequence* sequence, int i);
    EXTERNCALL void destroy_map(Map* map);
    EXTERNCALL int get_map_size(Map* map);
    EXTERNCALL char* get_map_label(Map* map, int i);
#ifdef __cplusplus
}
#endif

#endif /* _MAP_H */
