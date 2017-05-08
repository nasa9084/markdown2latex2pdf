import json
import re
import sys
import yaml

def main():
    if len(sys.argv) != 3:
        print("usage: {} FILTER_NAME TEXT".format(sys.argv[0]))
        exit(1)
    filter_name = sys.argv[1]
    text = sys.argv[2]
    if re.search("\.y(a)?ml$", filter_name):
        f = yaml_filter(filter_name)
    elif re.search("\.json$", filter_name):
        f = json_filter(filter_name)
    text = filter(f, text)
    print(text)

def yaml_filter(fn):
    with open(fn, 'r') as f:
        yml = yaml.load(f)
    return yml

def json_filter(fn):
    with open(fn, 'r') as f:
        jsn = json.load(f)
    return jsn

def filter(f, text):
    for ft in f:
        if ft['type'] == 'sed':
            text = re.sub(ft['before'], ft['after'], text, flags=re.MULTILINE)
    return text

if __name__ == '__main__':
    main()
