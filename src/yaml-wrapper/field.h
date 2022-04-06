#ifndef _FIELD_H
#define _FIELD_H

#include "yaml-cpp/yaml.h"

#include "sys.h"

struct Map;

enum CTypesEnum {
    INT_2D,
    DOUBLE_2D,
    INT_1D,
    DOUBLE_1D,
    INT,
    DOUBLE,
    STRING,
    YAML_SEQUENCE,
    YAML_MAP,
    INVALID
};


struct Field {
    void* ptr;
    int m;
    int n;
    enum CTypesEnum type;
};


void cast_type(YAML::Node node, Field* field);

void to_int(YAML::Node node, Field* field);
void to_double(YAML::Node node, Field* field);
void to_int_2d(YAML::Node node, Field* field);
void to_int_1d(YAML::Node node, Field* field);
void to_double_1d(YAML::Node node, Field* field);
void to_double_2d(YAML::Node node, Field* field);
void to_string(YAML::Node node, Field* field);
void to_map(YAML::Node node, Field* field);
void to_sequence(YAML::Node node, Field* field);

void delete_int(Field* field);
void delete_int_1d(Field* field);
void delete_double(Field* field);
void delete_double_1d(Field* field);
void delete_string(Field* field);
void delete_map(Field* field);

#pragma once
#ifdef __cplusplus
extern "C" {
#endif
    EXTERNCALL void destroy_field(Field* field);
    EXTERNCALL Field* get_field(Map* map, char* label);
#ifdef __cplusplus
}
#endif

#endif /* _FIELD_H */
