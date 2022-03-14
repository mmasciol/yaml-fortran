#include "field.h"
#include "map.h"
#include "sequence.h"


using namespace std;


EXTERNCALL Field* get_field(Map* v, char* label)
{
    string t = "";
    unsigned int i = 0;
    Field* field = new Field;
    field->n = -1;
    field->m = -1;

    for (i = 0; i < v->labels->size(); i++) {
        t = v->labels->at(i);
        if (t.compare(label) == 0) {
            cast_type(v->nodes->at(i), field);
        }
    };
    return field;
};


void
cast_type(YAML::Node node, Field* field)
{
    bool successful = false;

    field->type = (enum CTypesEnum)0;
    while (!successful) {
        try {
            switch (field->type) {
            case INT_2D: {
                to_int_2d(node, field);
                successful = true;
                break;
            }
            case DOUBLE_2D: {
                to_double_2d(node, field);
                successful = true;
                break;
            }
            case INT_1D: {
                to_int_1d(node, field);
                successful = true;
                break;
            }
            case DOUBLE_1D: {
                to_double_1d(node, field);
                successful = true;
                break;
            }
            case INT: {
                to_int(node, field);
                successful = true;
                break;
            }
            case DOUBLE: {
                to_double(node, field);
                successful = true;
                break;
            }
            case STRING: {
                to_string(node, field);
                successful = true;
                break;
            }
            case YAML_SEQUENCE: {
                to_sequence(node, field);
                successful = true;
                break;
            }
            case YAML_MAP: {
                to_map(node, field);
                successful = true;
                break;
            }
            case INVALID: {
                throw runtime_error("Invalid YAML conversion");
                break;
            }
            };
        }
        catch (const YAML::BadConversion & e) {
            field->type = (enum CTypesEnum)(field->type + 1);
        }
        catch (const invalid_argument & e) {
            field->type = (enum CTypesEnum)(field->type + 1);
        }
    };
    return;
};


EXTERNCALL void destroy_field(Field* field)
{
    switch (field->type) {
    case INT_2D: {
        delete_int_1d(field);
        break;
    }
    case DOUBLE_2D: {
        delete_double_1d(field);  // yes, this is right.
        break;
    }
    case INT_1D: {
        delete_int_1d(field);
        break;
    }
    case DOUBLE_1D: {
        delete_double_1d(field);
        break;
    }
    case INT: {
        delete_int(field);
        break;
    }
    case DOUBLE: {
        delete_double(field);
        break;
    }
    case STRING: {
        delete_string(field);
        break;
    }
    case YAML_SEQUENCE: {
        delete field;
        break;
    }
    case YAML_MAP: {
        delete_map(field);
        break;
    }
    case INVALID: {
        throw runtime_error("Invalid YAML conversion");
        break;
    }
    };
};


void to_int(YAML::Node node, Field* field)
{
    int p = -9999;
    p = node.as<int>();
    int* ret = 0;

    field->m = 1;
    field->n = 0;

    ret = new int;
    *ret = p;

    field->ptr = static_cast<void*>(ret);
    return;
};


void to_int_2d(YAML::Node node, Field* field)
{
    vector<vector<int>> p = {};
    p = node.as<vector<vector<int>>>();
    int* ret = 0;
    int i = 0;
    int j = 0;

    field->m = p.size();
    field->n = p.at(0).size();

    ret = new int[field->m * field->n];

    for (i = 0; i < field->m; i++) {
        for (j = 0; j < field->n; j++) {
            ret[i * field->n + j] = p.at(i).at(j);
        };
    };
    field->ptr = static_cast<void*>(ret);
    return;
};


void to_double_2d(YAML::Node node, Field* field)
{
    vector<vector<double>> p = {};
    p = node.as<vector<vector<double>>>();
    double* ret = 0;
    int i = 0;
    int j = 0;

    field->m = p.size();
    field->n = p.at(0).size();

    ret = new double[field->m * field->n];

    for (i = 0; i < field->m; i++) {
        for (j = 0; j < field->n; j++) {
            ret[i * field->n + j] = p.at(i).at(j);
        };
    };
    field->ptr = static_cast<void*>(ret);
    return;
};


void to_int_1d(YAML::Node node, Field* field)
{
    vector<int> p = {};
    p = node.as<vector<int>>();
    int* ret = 0;
    int i = 0;

    field->m = p.size();
    field->n = 0;

    ret = new int[field->m];
    for (i = 0; i < field->m; i++) {
        ret[i] = p.at(i);
    };
    field->ptr = static_cast<void*>(ret);
    return;
};


void to_double_1d(YAML::Node node, Field* field)
{
    vector<double> p = {};
    p = node.as<vector<double>>();
    double* ret = 0;
    int i = 0;

    field->m = p.size();
    field->n = 0;

    ret = new double[field->m];
    for (i = 0; i < field->m; i++) {
        ret[i] = p.at(i);
    };
    field->ptr = static_cast<void*>(ret);
    return;
};


void to_double(YAML::Node node, Field* field)
{
    double p = -999.9;
    p = node.as<double>();
    double* ret = 0;

    field->m = 1;
    field->n = 0;

    ret = new double;
    *ret = p;

    field->ptr = static_cast<void*>(ret);
    return;
};


void to_string(YAML::Node node, Field* field)
{
    string t = "";
    char* p = 0;

    t = node.as<string>();
    p = str_to_char(t);
    field->ptr = static_cast<void*>(p);
    field->n = t.size();
    return;
};


void to_sequence(YAML::Node node, Field* field)
{
    Sequence* seq = 0;
    Map* map = 0;

    seq = covert_node_to_sequence(node);
    field->ptr = static_cast<void*>(seq);
    return;
};


void to_map(YAML::Node node, Field* field)
{
    Map* map = 0;

    map = convert_node_to_map(node);
    field->ptr = static_cast<void*>(map);
    return;
};


void delete_map(Field* field)
{
    Sequence* sequence = 0;
    Map* map = 0;

    if (field->ptr) {
        if (field->type == YAML_SEQUENCE) {
            sequence = static_cast<Sequence*>(field->ptr);
            destroy_sequence(sequence);
        }
        else if (field->type == YAML_MAP) {
            map = static_cast<Map*>(field->ptr);
            destroy_map(map);
        }
    }
    delete field;
    field = 0;
    return;
};


void delete_int_1d(Field* field)
{
    int* pvec = static_cast<int*>(field->ptr);
    delete[] pvec;
    delete field;
    field = 0;
    return;
};


void delete_double_1d(Field* field)
{
    double* pvec = static_cast<double*>(field->ptr);
    delete[] pvec;
    delete field;
    field = 0;
    return;
};


void delete_double(Field* field)
{
    double* pvec = static_cast<double*>(field->ptr);
    delete pvec;
    delete field;
    field = 0;
    return;
};


void delete_int(Field* field)
{
    int* pvec = static_cast<int*>(field->ptr);
    delete pvec;
    delete field;
    field = 0;
    return;
};


void delete_string(Field* field)
{
    char* pvec = static_cast<char*>(field->ptr);
    delete[] pvec;
    delete field;
    field = 0;
    return;
};
