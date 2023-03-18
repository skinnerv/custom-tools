#!/usr/bin/bash
#
#This is a bash script ping sweep multithread
#Inserting the first 3 octets of the IP address, the starting value of the last octets and the ending value of the last octets.
# example: 127.0.0 1 10
seq $2 $3 | xargs -I{} -P0 sh -c 'ip="$1.{}"; if ping -c 1 $ip >/dev/null; then echo $ip; fi' sh $1
