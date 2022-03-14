#include <cstring>
#include <iostream>
#include <stdexcept>
#include <vector>

#include "yaml-cpp/yaml.h"

#include "domain.h"


EXTERNCALL Domain* load_file(char* fpath)
{
    Domain* domain = new Domain;
    domain->container = new YAMLContainer;

    domain->container->config = YAML::LoadFile(fpath);
    domain->status = -9999;
    return domain;
};



EXTERNCALL void destroy_domain(Domain* domain)
{
    delete domain->container;
    delete domain;
    return;
};
