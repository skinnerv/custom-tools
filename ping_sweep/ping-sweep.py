#!/usr/bin/python
from os import system
from sys import argv

#This is a python script ping sweep
#Inserting the first 3 octets of the IP address, the starting value of the last octets and the ending value of the last octets.
# example: 127.0.0 1 10

for i in range(int(argv[2]), int(argv[3]) + 1):
    ip = f"{argv[1]}.{i}"
    # print(ip)
    if system(f"ping -c 1 {ip}>/dev/null") == 0:
        print(f"{ip}")
