#!/usr/bin/env python3
# ===
# python script to handle list of useful softwares.
# the softwares are listed in yaml files.
# this script parses and manipulates the list.
# ===


import sys
import yaml
from pathlib import Path


# TODO: create Softwares class to handle softwares info from yaml files.
softwares_obj = None
softwares_yml = ".softwares-m/softwares.yml"


# TODO: recursively parse and construct a valid softwares object.
def parse_sw_yml(sw_yml_path):
    with open(Path(sw_yml_path)) as f:
        softwares = yaml.load(f, Loader=yaml.FullLoader)
        print(softwares)


if __name__ == "__main__":
    parse_sw_yml(sys.argv[1])
    exit(0)
