#include <iostream>

#include "yaml-cpp/yaml.h"

#include "map.h"
#include "domain.h"
#include "sys.h"
#include "sequence.h"
#include "field.h"

using namespace std;

EXTERNCALL Map* start_from_map(Domain* d, char* label)
{
    string s(label);
    YAML::Node root = d->container->config;
    YAML::Node config = root[s];
    Map* map = 0;

    map = convert_node_to_map(config);
    return map;
};


EXTERNCALL void destroy_map(Map* map)
{
    if (map) {
        if (map->labels) {
            for (auto m = map->labels->begin(); m != map->labels->end(); ++m) {
                if (*m) {
                    delete[](*m);
                    *m = 0;
                }
            }
            delete map->labels;
            map->labels = 0;
        }
        if (map->nodes) {
            delete map->nodes;
            map->nodes = 0;
        }
        delete map;
        map = 0;
    };
};


Map* new_map()
{
    Map* map = new Map;
    map->labels = new vector<char*>;
    map->nodes = new vector<YAML::Node>;
    return map;
};


EXTERNCALL Map* get_map_from_field(Field* field)
{
    Map* map = 0;
    vector<char*>* labels = 0;
    vector<YAML::Node>* nodes = 0;
    string t = "";

    map = static_cast<Map*>(field->ptr);
    labels = map->labels;
    nodes = map->nodes;

    map = new_map();
    for (int i = 0; i < labels->size() ; i++)  {
         t = (*labels)[i];
         YAML::Node node = YAML::Clone((*nodes)[i]);
         map->labels->push_back(str_to_char(t));
         map->nodes->push_back(move(node));
         // map->nodes->push_back((*nodes)[i]);
    };
    return map;
};


EXTERNCALL int get_map_size(Map* map)
{
    return map->labels->size();
};


EXTERNCALL char* get_map_label(Map* map, int i)
{
    return map->labels->at(i);
};


EXTERNCALL Map* get_map_from_sequence(Sequence* sequence, int i)
{
    return sequence->at(i);
};


Map* convert_node_to_map(YAML::Node config)
{
    string t = "";
    Map* map = 0;

    if (config.IsSequence()) {
        throw invalid_argument("Cannot retrieve keys from a sequence.");
    }

    map = new_map();
    for (YAML::const_iterator it = config.begin(); it != config.end(); ++it) {
        t = it->first.as<string>();
        YAML::Node node = YAML::Clone(it->second.as<YAML::Node>());
        map->labels->push_back(str_to_char(t));
        map->nodes->push_back(move(node));
        // map->nodes->push_back(it->second.as<YAML::Node>());
    };
    return map;
};
