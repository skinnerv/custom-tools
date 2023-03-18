#!/usr/bin/bash
#
#This is a bash script ping sweep
#Inserting the first 3 octets of the IP address, the starting value of the last octets and the ending value of the last octets.
#
for i in $(seq $2 $3);do
        ip="$1.$i"
        #echo $ip
        if ping -c 1 $ip >/dev/null; then
                echo $ip
        fi
done
