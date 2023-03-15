#!/usr/bin/python

import ipaddress
import os

"""Python ping sweep script for the target: 10.11.1.0/24"""
ipTarget = "10.11.1.0/24"
network = ipaddress.ip_network(ipTarget)

for n in network.hosts():
    if  os.system(f"ping -c 1 {n}>/dev/null") == 0:
        print(f"{n} UP")
    else:
        print(f"No response {n}")
print('Ping sweep done')
