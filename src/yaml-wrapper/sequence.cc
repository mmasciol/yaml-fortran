#include <iostream>

#include "yaml-cpp/yaml.h"

#include "sequence.h"
#include "map.h"
#include "domain.h"

using namespace std;

EXTERNCALL int get_sequence_size(Sequence* sequence)
{
    return sequence->size();
};


EXTERNCALL void destroy_sequence(Sequence* sequence)
{
   Map* map = 0;
   if (sequence) {
        for (int i = 0; i < sequence->size(); i++) {
            map = static_cast<Map*>((*sequence)[i]);
            if (map!=0) {
                destroy_map(map);
            }
        }
        delete sequence;
        sequence = 0;
    };
};


EXTERNCALL Sequence* start_from_sequence(Domain* domain, char* label)
{
    string s(label);
    YAML::Node root = domain->container->config;
    YAML::Node config = root[s];
    Sequence* sequence = 0;

    sequence = covert_node_to_sequence(config);
    return sequence;
};


Sequence* covert_node_to_sequence(YAML::Node config)
{
    string t = "";
    Sequence* sequence = 0;
    Map* map = 0;

    if (!config.IsSequence()) {
        throw invalid_argument("Cannot retrieve keys from unknown item (possibly a map).");
    };

    sequence = new Sequence;
    for (YAML::const_iterator node = config.begin(); node != config.end(); ++node) {
        map = convert_node_to_map(*node);
        sequence->push_back(move(map));
    };
    return sequence;
};
