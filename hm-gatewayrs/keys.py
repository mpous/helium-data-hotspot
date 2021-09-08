#!/usr/bin/env python3

import json

public_key = None
while public_key is None:
    try:
        pk_file = open("/var/data/key_json", "r")
        data = json.load(pk_file)
        public_key = str(data["address"])
        onboard_key = str(data["address"])
        animal = str(data["name"])
    except FileNotFoundError:
        sleep(10)

keyfile = open("/var/data/public_keys", "w")
keyfile.write('''{{pubkey,"{}"}}.\n{{onboarding_key,"{}"}}.\n'''
              '''{{animal_name,"{}"}}.'''.format(public_key, onboard_key, animal))
keyfile.close()
